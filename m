Return-path: <linux-media-owner@vger.kernel.org>
Received: from ams-iport-2.cisco.com ([144.254.224.141]:32166 "EHLO
	ams-iport-2.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757961Ab2IRKxz (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 18 Sep 2012 06:53:55 -0400
From: Hans Verkuil <hans.verkuil@cisco.com>
To: linux-media@vger.kernel.org
Cc: Prabhakar Lad <prabhakar.csengg@gmail.com>,
	DLOS <davinci-linux-open-source@linux.davincidsp.com>
Subject: [RFCv1 PATCH 09/11] vpif_capture: separate subdev from input.
Date: Tue, 18 Sep 2012 12:53:11 +0200
Message-Id: <04e3edc8e894b5468c613016222c1514eb836f93.1347965140.git.hans.verkuil@cisco.com>
In-Reply-To: <1347965593-16746-1-git-send-email-hans.verkuil@cisco.com>
References: <1347965593-16746-1-git-send-email-hans.verkuil@cisco.com>
In-Reply-To: <bd383d11cd06a8f66571cf1dccb42fd89760ecdb.1347965140.git.hans.verkuil@cisco.com>
References: <bd383d11cd06a8f66571cf1dccb42fd89760ecdb.1347965140.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

vpif_capture relied on a 1-1 mapping of input and subdev. This is not
necessarily the case. Separate the two. So there is a list of subdevs
and a list of inputs. Each input refers to a subdev and has routing
information. An input does not have to have a subdev.

The initial input for each channel is set to the fist input.

Currently missing is support for associating multiple subdevs with
an input.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/video/davinci/vpif_capture.c |  239 +++++++++++++---------------
 drivers/media/video/davinci/vpif_capture.h |    6 +-
 2 files changed, 113 insertions(+), 132 deletions(-)

diff --git a/drivers/media/video/davinci/vpif_capture.c b/drivers/media/video/davinci/vpif_capture.c
index 0d67443..5266167 100644
--- a/drivers/media/video/davinci/vpif_capture.c
+++ b/drivers/media/video/davinci/vpif_capture.c
@@ -856,13 +856,11 @@ static unsigned int vpif_poll(struct file *filep, poll_table * wait)
  */
 static int vpif_open(struct file *filep)
 {
-	struct vpif_capture_config *config = vpif_dev->platform_data;
 	struct video_device *vdev = video_devdata(filep);
 	struct common_obj *common;
 	struct video_obj *vid_ch;
 	struct channel_obj *ch;
 	struct vpif_fh *fh;
-	int i;
 
 	vpif_dbg(2, debug, "vpif_open\n");
 
@@ -871,24 +869,6 @@ static int vpif_open(struct file *filep)
 	vid_ch = &ch->video;
 	common = &ch->common[VPIF_VIDEO_INDEX];
 
-	if (NULL == ch->curr_subdev_info) {
-		/**
-		 * search through the sub device to see a registered
-		 * sub device and make it as current sub device
-		 */
-		for (i = 0; i < config->subdev_count; i++) {
-			if (vpif_obj.sd[i]) {
-				/* the sub device is registered */
-				ch->curr_subdev_info = &config->subdev_info[i];
-				break;
-			}
-		}
-		if (i == config->subdev_count) {
-			vpif_err("No sub device registered\n");
-			return -ENOENT;
-		}
-	}
-
 	/* Allocate memory for the file handle object */
 	fh = kzalloc(sizeof(struct vpif_fh), GFP_KERNEL);
 	if (NULL == fh) {
@@ -1159,10 +1139,9 @@ static int vpif_streamon(struct file *file, void *priv,
 		return ret;
 
 	/* Enable streamon on the sub device */
-	ret = v4l2_subdev_call(vpif_obj.sd[ch->curr_sd_index], video,
-				s_stream, 1);
+	ret = v4l2_subdev_call(ch->sd, video, s_stream, 1);
 
-	if (ret && (ret != -ENOIOCTLCMD)) {
+	if (ret && ret != -ENOIOCTLCMD && ret != -ENODEV) {
 		vpif_dbg(1, debug, "stream on failed in subdev\n");
 		return ret;
 	}
@@ -1222,73 +1201,105 @@ static int vpif_streamoff(struct file *file, void *priv,
 
 	common->started = 0;
 
-	ret = v4l2_subdev_call(vpif_obj.sd[ch->curr_sd_index], video,
-				s_stream, 0);
+	ret = v4l2_subdev_call(ch->sd, video, s_stream, 0);
 
-	if (ret && (ret != -ENOIOCTLCMD))
+	if (ret && ret != -ENOIOCTLCMD && ret != -ENODEV)
 		vpif_dbg(1, debug, "stream off failed in subdev\n");
 
 	return vb2_streamoff(&common->buffer_queue, buftype);
 }
 
 /**
- * vpif_map_sub_device_to_input() - Maps sub device to input
- * @ch - ptr to channel
- * @config - ptr to capture configuration
+ * vpif_input_to_subdev() - Maps input to sub device
+ * @vpif_cfg - global config ptr
+ * @chan_cfg - channel config ptr
  * @input_index - Given input index from application
- * @sub_device_index - index into sd table
  *
  * lookup the sub device information for a given input index.
  * we report all the inputs to application. inputs table also
  * has sub device name for the each input
  */
-static struct vpif_subdev_info *vpif_map_sub_device_to_input(
-				struct channel_obj *ch,
-				struct vpif_capture_config *vpif_cfg,
-				int input_index,
-				int *sub_device_index)
+static int vpif_input_to_subdev(
+		struct vpif_capture_config *vpif_cfg,
+		struct vpif_capture_chan_config *chan_cfg,
+		int input_index)
 {
-	struct vpif_capture_chan_config *chan_cfg;
-	struct vpif_subdev_info *subdev_info = NULL;
-	const char *subdev_name = NULL;
+	struct vpif_subdev_info *subdev_info;
+	const char *subdev_name;
 	int i;
 
-	vpif_dbg(2, debug, "vpif_map_sub_device_to_input\n");
-
-	chan_cfg = &vpif_cfg->chan_config[ch->channel_id];
+	vpif_dbg(2, debug, "vpif_input_to_subdev\n");
 
-	/**
-	 * search through the inputs to find the sub device supporting
-	 * the input
-	 */
-	for (i = 0; i < chan_cfg->input_count; i++) {
-		/* For each sub device, loop through input */
-		if (i == input_index) {
-			subdev_name = chan_cfg->inputs[i].subdev_name;
-			break;
-		}
-	}
-
-	/* if reached maximum. return null */
-	if (i == chan_cfg->input_count || (NULL == subdev_name))
-		return subdev_info;
+	subdev_name = chan_cfg->inputs[input_index].subdev_name;
+	if (subdev_name == NULL)
+		return -1;
 
 	/* loop through the sub device list to get the sub device info */
 	for (i = 0; i < vpif_cfg->subdev_count; i++) {
 		subdev_info = &vpif_cfg->subdev_info[i];
 		if (!strcmp(subdev_info->name, subdev_name))
-			break;
+			return i;
+	}
+	return -1;
+}
+
+/**
+ * vpif_set_input() - Select an input
+ * @vpif_cfg - global config ptr
+ * @ch - channel
+ * @_index - Given input index from application
+ *
+ * Select the given input.
+ */
+static int vpif_set_input(
+		struct vpif_capture_config *vpif_cfg,
+		struct channel_obj *ch,
+		int index)
+{
+	struct vpif_capture_chan_config *chan_cfg = 
+			&vpif_cfg->chan_config[ch->channel_id];
+	struct vpif_subdev_info *subdev_info = NULL;
+	struct v4l2_subdev *sd = NULL;
+	u32 input = 0, output = 0;
+	int sd_index;
+	int ret;
+
+	sd_index = vpif_input_to_subdev(vpif_cfg, chan_cfg, index);
+	if (sd_index >= 0) {
+		sd = vpif_obj.sd[sd_index];
+		subdev_info = &vpif_cfg->subdev_info[sd_index];
 	}
 
-	if (i == vpif_cfg->subdev_count)
-		return subdev_info;
+	/* first setup input path from sub device to vpif */
+	if (sd && vpif_cfg->setup_input_path) {
+		ret = vpif_cfg->setup_input_path(ch->channel_id,
+				       subdev_info->name);
+		if (ret < 0) {
+			vpif_dbg(1, debug, "couldn't setup input path for the"
+				" sub device %s, for input index %d\n",
+				subdev_info->name, index);
+			return ret;
+		}
+	}
 
-	/* check if the sub device is registered */
-	if (NULL == vpif_obj.sd[i])
-		return NULL;
+	if (sd) {
+		input = chan_cfg->inputs[index].input_route;
+		output = chan_cfg->inputs[index].output_route;
+		ret = v4l2_subdev_call(sd, video, s_routing,
+				input, output, 0);
+		if (ret < 0 && ret != -ENOIOCTLCMD) {
+			vpif_dbg(1, debug, "Failed to set input\n");
+			return ret;
+		}
+	}
+	ch->input_idx = index;
+	ch->sd = sd;
+	/* copy interface parameters to vpif */
+	ch->vpifparams.iface = subdev_info->vpif_if;
 
-	*sub_device_index = i;
-	return subdev_info;
+	/* update tvnorms from the sub device input info */
+	ch->video_dev->tvnorms = chan_cfg->inputs[index].input.std;
+	return 0;
 }
 
 /**
@@ -1308,12 +1319,16 @@ static int vpif_querystd(struct file *file, void *priv, v4l2_std_id *std_id)
 	vpif_dbg(2, debug, "vpif_querystd\n");
 
 	/* Call querystd function of decoder device */
-	ret = v4l2_subdev_call(vpif_obj.sd[ch->curr_sd_index], video,
-				querystd, std_id);
-	if (ret < 0)
-		vpif_dbg(1, debug, "Failed to set standard for sub devices\n");
+	ret = v4l2_subdev_call(ch->sd, video, querystd, std_id);
 
-	return ret;
+	if (ret == -ENOIOCTLCMD || ret == -ENODEV)
+		return -ENODATA;
+	if (ret) {
+		vpif_dbg(1, debug, "Failed to query standard for sub devices\n");
+		return ret;
+	}
+
+	return 0;
 }
 
 /**
@@ -1381,11 +1396,12 @@ static int vpif_s_std(struct file *file, void *priv, v4l2_std_id *std_id)
 	vpif_config_format(ch);
 
 	/* set standard in the sub device */
-	ret = v4l2_subdev_call(vpif_obj.sd[ch->curr_sd_index], core,
-				s_std, *std_id);
-	if (ret < 0)
+	ret = v4l2_subdev_call(ch->sd, core, s_std, *std_id);
+	if (ret && ret != -ENOIOCTLCMD && ret != -ENODEV) {
 		vpif_dbg(1, debug, "Failed to set standard for sub devices\n");
-	return ret;
+		return ret;
+	}
+	return 0;
 }
 
 /**
@@ -1443,9 +1459,7 @@ static int vpif_s_input(struct file *file, void *priv, unsigned int index)
 	struct vpif_fh *fh = priv;
 	struct channel_obj *ch = fh->channel;
 	struct common_obj *common = &ch->common[VPIF_VIDEO_INDEX];
-	struct vpif_subdev_info *subdev_info;
-	int ret = 0, sd_index = 0;
-	u32 input = 0, output = 0;
+	int ret;
 
 	chan_cfg = &config->chan_config[ch->channel_id];
 
@@ -1470,43 +1484,7 @@ static int vpif_s_input(struct file *file, void *priv, unsigned int index)
 		return ret;
 
 	fh->initialized = 1;
-	subdev_info = vpif_map_sub_device_to_input(ch, config, index,
-						   &sd_index);
-	if (NULL == subdev_info) {
-		vpif_dbg(1, debug,
-			"couldn't lookup sub device for the input index\n");
-		return -EINVAL;
-	}
-
-	/* first setup input path from sub device to vpif */
-	if (config->setup_input_path) {
-		ret = config->setup_input_path(ch->channel_id,
-					       subdev_info->name);
-		if (ret < 0) {
-			vpif_dbg(1, debug, "couldn't setup input path for the"
-				" sub device %s, for input index %d\n",
-				subdev_info->name, index);
-			return ret;
-		}
-	}
-
-	input = chan_cfg->inputs[index].input_route;
-	output = chan_cfg->inputs[index].output_route;
-	ret = v4l2_subdev_call(vpif_obj.sd[sd_index], video, s_routing,
-			input, output, 0);
-	if (ret < 0 && ret != -ENOIOCTLCMD) {
-		vpif_dbg(1, debug, "Failed to set input\n");
-		return ret;
-	}
-	ch->input_idx = index;
-	ch->curr_subdev_info = subdev_info;
-	ch->curr_sd_index = sd_index;
-	/* copy interface parameters to vpif */
-	ch->vpifparams.iface = subdev_info->vpif_if;
-
-	/* update tvnorms from the sub device input info */
-	ch->video_dev->tvnorms = chan_cfg->inputs[index].input.std;
-	return 0;
+	return vpif_set_input(config, ch, index);
 }
 
 /**
@@ -1711,9 +1689,12 @@ static int vpif_enum_dv_timings(struct file *file, void *priv,
 {
 	struct vpif_fh *fh = priv;
 	struct channel_obj *ch = fh->channel;
+	int ret;
 
-	return v4l2_subdev_call(vpif_obj.sd[ch->curr_sd_index],
-			video, enum_dv_timings, timings);
+	ret = v4l2_subdev_call(ch->sd, video, enum_dv_timings, timings);
+	if (ret == -ENOIOCTLCMD && ret == -ENODEV)
+		return -EINVAL;
+	return ret;
 }
 
 /**
@@ -1727,9 +1708,12 @@ static int vpif_query_dv_timings(struct file *file, void *priv,
 {
 	struct vpif_fh *fh = priv;
 	struct channel_obj *ch = fh->channel;
+	int ret;
 
-	return v4l2_subdev_call(vpif_obj.sd[ch->curr_sd_index],
-		       video, query_dv_timings, timings);
+	ret = v4l2_subdev_call(ch->sd, video, query_dv_timings, timings);
+	if (ret == -ENOIOCTLCMD && ret == -ENODEV)
+		return -ENODATA;
+	return ret;
 }
 
 /**
@@ -1755,13 +1739,9 @@ static int vpif_s_dv_timings(struct file *file, void *priv,
 	}
 
 	/* Configure subdevice timings, if any */
-	ret = v4l2_subdev_call(vpif_obj.sd[ch->curr_sd_index],
-			video, s_dv_timings, timings);
-	if (ret == -ENOIOCTLCMD) {
-		vpif_dbg(2, debug, "Custom DV timings not supported by "
-				"subdevice\n");
-		return -EINVAL;
-	}
+	ret = v4l2_subdev_call(ch->sd, video, s_dv_timings, timings);
+	if (ret == -ENOIOCTLCMD || ret == -ENODEV)
+		ret = 0;
 	if (ret < 0) {
 		vpif_dbg(2, debug, "Error setting custom DV timings\n");
 		return ret;
@@ -1886,8 +1866,7 @@ static int vpif_dbg_g_register(struct file *file, void *priv,
 	struct vpif_fh *fh = priv;
 	struct channel_obj *ch = fh->channel;
 
-	return v4l2_subdev_call(vpif_obj.sd[ch->curr_sd_index], core,
-			g_register, reg);
+	return v4l2_subdev_call(ch->sd, core, g_register, reg);
 }
 
 /*
@@ -1904,8 +1883,7 @@ static int vpif_dbg_s_register(struct file *file, void *priv,
 	struct vpif_fh *fh = priv;
 	struct channel_obj *ch = fh->channel;
 
-	return v4l2_subdev_call(vpif_obj.sd[ch->curr_sd_index], core,
-			s_register, reg);
+	return v4l2_subdev_call(ch->sd, core, s_register, reg);
 }
 #endif
 
@@ -2164,6 +2142,11 @@ static __init int vpif_probe(struct platform_device *pdev)
 		/* Initialize prio member of channel object */
 		v4l2_prio_init(&ch->prio);
 		video_set_drvdata(ch->video_dev, ch);
+
+		/* select input 0 */
+		err = vpif_set_input(config, ch, 0);
+		if (err)
+			goto probe_out;
 		
 		err = video_register_device(ch->video_dev,
 					    VFL_TYPE_GRABBER, (j ? 1 : 0));
diff --git a/drivers/media/video/davinci/vpif_capture.h b/drivers/media/video/davinci/vpif_capture.h
index cf954f8..ed7af8d 100644
--- a/drivers/media/video/davinci/vpif_capture.h
+++ b/drivers/media/video/davinci/vpif_capture.h
@@ -118,12 +118,10 @@ struct channel_obj {
 	u8 initialized;
 	/* Identifies channel */
 	enum vpif_channel_id channel_id;
-	/* index into sd table */
-	int curr_sd_index;
 	/* Current input */
 	u32 input_idx;
-	/* ptr to current sub device information */
-	struct vpif_subdev_info *curr_subdev_info;
+	/* subdev corresponding to the current input, may be NULL */
+	struct v4l2_subdev *sd;
 	/* vpif configuration params */
 	struct vpif_params vpifparams;
 	/* common object array */
-- 
1.7.10.4

