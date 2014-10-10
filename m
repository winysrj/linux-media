Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr7.xs4all.nl ([194.109.24.27]:3143 "EHLO
	smtp-vbr7.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751774AbaJJIye (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 10 Oct 2014 04:54:34 -0400
Message-ID: <54379EB1.7010201@xs4all.nl>
Date: Fri, 10 Oct 2014 10:54:09 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Jacek Anaszewski <j.anaszewski@samsung.com>,
	linux-media@vger.kernel.org
CC: kyungmin.park@samsung.com, s.nawrocki@samsung.com,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [PATCH/RFC 1/1] Add a libv4l plugin for Exynos4 camera
References: <1412757980-23570-1-git-send-email-j.anaszewski@samsung.com> <1412757980-23570-2-git-send-email-j.anaszewski@samsung.com>
In-Reply-To: <1412757980-23570-2-git-send-email-j.anaszewski@samsung.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Jacek,

I didn't do an in-depth review, but one thing caught my eye:

On 10/08/2014 10:46 AM, Jacek Anaszewski wrote:
> The plugin provides support for the media device on Exynos4 SoC.
> Added is also a media device configuration file parser.
> The media configuration file is used for conveying information
> about media device links that need to be established as well
> as V4L2 user control ioctls redirection to a particular
> sub-device.
>
> The plugin performs single plane <-> multi plane API conversion,
> video pipeline linking and takes care of automatic data format
> negotiation for the whole pipeline, after intercepting
> VIDIOC_S_FMT or VIDIOC_TRY_FMT ioctls.
>
> Signed-off-by: Jacek Anaszewski <j.anaszewski@samsung.com>
> Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
> Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
> Cc: Hans Verkuil <hans.verkuil@cisco.com>
> ---
>   configure.ac                                       |    1 +
>   lib/Makefile.am                                    |    5 +-
>   lib/libv4l-exynos4-camera/Makefile.am              |    7 +
>   .../libv4l-devconfig-parser.h                      |  145 ++
>   lib/libv4l-exynos4-camera/libv4l-exynos4-camera.c  | 2486 ++++++++++++++++++++
>   5 files changed, 2642 insertions(+), 2 deletions(-)
>   create mode 100644 lib/libv4l-exynos4-camera/Makefile.am
>   create mode 100644 lib/libv4l-exynos4-camera/libv4l-devconfig-parser.h
>   create mode 100644 lib/libv4l-exynos4-camera/libv4l-exynos4-camera.c
>

<snip>

> +static int is_control_supported(struct media_device *mdev,
> +			struct libv4l_media_ctrl_conf *ctrl_cfg)
> +{
> +	struct v4l2_query_ext_ctrl queryctrl;
> +	struct media_entity *entity;
> +
> +	entity = get_entity_by_name(mdev, ctrl_cfg->entity_name);
> +	if (entity == NULL)
> +		return 0;
> +
> +	/* Iterate through control ids */
> +
> +	queryctrl.id = V4L2_CID_BASE | V4L2_CTRL_FLAG_NEXT_CTRL;
> +
> +	while (!SYS_IOCTL(entity->fd, VIDIOC_QUERY_EXT_CTRL, &queryctrl)) {
> +		if (queryctrl.flags & V4L2_CTRL_FLAG_DISABLED)
> +			continue;
> +
> +		if (!strcmp((char *) queryctrl.name, ctrl_cfg->control_name)) {
> +			ctrl_cfg->cid = queryctrl.id &
> +					~V4L2_CTRL_FLAG_NEXT_CTRL;
> +			ctrl_cfg->entity = entity;
> +
> +			return 1;
> +		}
> +
> +		queryctrl.id = queryctrl.id | V4L2_CTRL_FLAG_NEXT_CTRL;
> +	}
> +
> +	queryctrl.id = V4L2_CID_BASE | V4L2_CTRL_FLAG_NEXT_COMPOUND;

Why not combine V4L2_CTRL_FLAG_NEXT_CTRL and V4L2_CTRL_FLAG_NEXT_COMPOUND?
That way you iterate over both 'normal' and compound controls. But do you
really want to look at compound controls? First of all, to my knowledge
the exynos driver doesn't use them and secondly compound controls typically
do not have simple values that can easily be parsed.

> +
> +	while (!SYS_IOCTL(entity->fd, VIDIOC_QUERY_EXT_CTRL, &queryctrl)) {
> +		if (queryctrl.flags & V4L2_CTRL_FLAG_DISABLED)
> +			continue;
> +
> +		if (!strcmp((char *) queryctrl.name, ctrl_cfg->control_name)) {
> +			ctrl_cfg->cid = queryctrl.id &
> +					~V4L2_CTRL_FLAG_NEXT_COMPOUND;
> +			ctrl_cfg->entity = entity;
> +
> +			return 1;
> +		}
> +
> +		queryctrl.id = queryctrl.id | V4L2_CTRL_FLAG_NEXT_COMPOUND;
> +	}
> +
> +	return 0;
> +}
> +
> +static int validate_control_config(struct media_device *mdev,
> +				struct libv4l_media_ctrl_conf *ctrl_cfg)
> +{
> +	if (mdev == NULL || ctrl_cfg == NULL)
> +		return -EINVAL;
> +
> +	while (ctrl_cfg) {
> +		if (!is_control_supported(mdev, ctrl_cfg)) {
> +			V4L2_EXYNOS4_ERR("Control %s is unsupported on %s.",
> +					 ctrl_cfg->control_name,
> +					 ctrl_cfg->entity_name);
> +			return -EINVAL;
> +		}
> +
> +		ctrl_cfg = ctrl_cfg->next;
> +	}
> +
> +	return 0;
> +}
> +
> +static int get_entity_by_fd(struct media_device *mdev, int fd,
> +				struct media_entity **entity)
> +{
> +	char node_name[32];
> +	int i, ret;
> +
> +	if (mdev == NULL || entity == NULL)
> +		return -EINVAL;
> +
> +	ret = get_node_by_fd(fd, node_name);
> +	if (ret < 0)
> +		return ret;
> +
> +	for (i = 0; i < mdev->num_entities; ++i) {
> +		if (strcmp(mdev->entities[i].node_name, node_name) == 0) {
> +			*entity = &mdev->entities[i];
> +			return 0;
> +		}
> +	}
> +
> +	return -EINVAL;
> +}
> +
> +static int get_pads_by_entity(struct media_entity *entity,
> +				struct media_pad_desc **pads,
> +				int *num_pads, unsigned int type)
> +{
> +	struct media_pad_desc *entity_pads;
> +	int cnt_pads, i;
> +
> +	if (entity == NULL || pads == NULL || num_pads == NULL)
> +		return -EINVAL;
> +
> +	entity_pads = malloc(sizeof(*entity_pads));
> +	cnt_pads = 0;
> +
> +	for (i = 0; i < entity->num_pads; ++i) {
> +		if (entity->pads[i].flags & type) {
> +			entity_pads = realloc(entity_pads, (i + 1) *
> +					      sizeof(*entity_pads));
> +			entity_pads[cnt_pads++] = entity->pads[i];
> +		}
> +	}
> +
> +	if (cnt_pads == 0)
> +		free(entity_pads);
> +
> +	*pads = entity_pads;
> +	*num_pads = cnt_pads;
> +
> +	return 0;
> +}
> +
> +static int get_src_entity_by_link(struct media_device *mdev,
> +					struct media_link_desc *link,
> +					struct media_entity **entity)
> +{
> +	int i;
> +
> +	if (mdev == NULL || link == NULL || entity == NULL)
> +		return -EINVAL;
> +
> +	for (i = 0; i < mdev->num_entities; ++i) {
> +		if (mdev->entities[i].id == link->source.entity) {
> +			*entity = &mdev->entities[i];
> +			return 0;
> +		}
> +	}
> +
> +	return -EINVAL;
> +}
> +
> +static int get_link_by_sink_pad(struct media_device *mdev,
> +				struct media_pad_desc *pad,
> +				struct media_link_desc **link)
> +{
> +	struct media_link_desc *cur_link = NULL;
> +	struct media_entity *entity;
> +	int i, j, ret;
> +
> +	if (mdev == NULL || pad == NULL || link == NULL)
> +		return -EINVAL;
> +
> +	ret = get_entity_by_pad(mdev, pad, &entity);
> +	if (ret < 0)
> +		return ret;
> +
> +	for (i = 0; i < mdev->num_entities; ++i) {
> +		for (j = 0; j < mdev->entities[i].num_links; ++j) {
> +			cur_link = &mdev->entities[i].links[j];
> +			if ((cur_link->flags & MEDIA_LNK_FL_ENABLED) &&
> +			    (cur_link->sink.entity == pad->entity) &&
> +			    (cur_link->sink.index == pad->index)) {
> +				*link = cur_link;
> +				return 0;
> +			}
> +		}
> +	}
> +
> +	return -EINVAL;
> +}
> +
> +static int get_link_by_source_pad(struct media_entity *entity,
> +					struct media_pad_desc *pad,
> +					struct media_link_desc **link)
> +{
> +	int i;
> +
> +	if (entity == NULL || pad == NULL || link == NULL)
> +		return -EINVAL;
> +
> +	for (i = 0; i < entity->num_links; ++i) {
> +		if ((entity->links[i].flags & MEDIA_LNK_FL_ENABLED) &&
> +		    (entity->links[i].source.index == pad->index)) {
> +			*link = &entity->links[i];
> +			return 0;
> +		}
> +	}
> +
> +	return -EINVAL;
> +}
> +
> +static int get_busy_pads_by_entity(struct media_device *mdev,
> +		       struct media_entity *entity,
> +		       struct media_pad_desc **busy_pads,
> +		       int *num_busy_pads,
> +		       unsigned int type)
> +{
> +	struct media_pad_desc *bpads, *pads;
> +	struct media_link_desc *link;
> +	int cnt_bpads = 0, num_pads, i, ret;
> +
> +	if (entity == NULL || busy_pads == NULL || num_busy_pads == NULL ||
> +	    (type == MEDIA_PAD_FL_SINK && mdev == NULL))
> +		return -EINVAL;
> +
> +	ret = get_pads_by_entity(entity, &pads, &num_pads, type);
> +	if (ret < 0)
> +		return -EINVAL;
> +
> +	if (num_pads == 0)
> +		goto done;
> +
> +	bpads = malloc(sizeof(*pads));
> +	if (bpads == NULL)
> +		goto error_ret;
> +
> +	for (i = 0; i < num_pads; ++i) {
> +		if (type == MEDIA_PAD_FL_SINK)
> +			ret = get_link_by_sink_pad(mdev, &pads[i], &link);
> +		else
> +			ret = get_link_by_source_pad(entity, &pads[i], &link);
> +		if (ret == 0) {
> +			bpads = realloc(bpads, (i + 1) *
> +						sizeof(*bpads));
> +			bpads[cnt_bpads++] = pads[i];
> +		}
> +	}
> +	if (num_pads > 0)
> +		free(pads);
> +
> +	if (cnt_bpads == 0)
> +		free(bpads);
> +
> +done:
> +	*busy_pads = bpads;
> +	*num_busy_pads = cnt_bpads;
> +
> +	return 0;
> +
> +error_ret:
> +	return -EINVAL;
> +}
> +
> +static int get_pad_by_index(struct media_pad_desc *pads, int num_pads,
> +				int index, struct media_pad_desc *out_pad)
> +
> +{
> +	int i;
> +
> +	if (pads == NULL || out_pad == NULL)
> +		return -EINVAL;
> +
> +	for (i = 0; i < num_pads; ++i) {
> +		if (pads[i].index == index) {
> +			*out_pad = pads[i];
> +			return 0;
> +		}
> +	}
> +
> +	return -EINVAL;
> +}
> +
> +static int discover_pipeline_by_fd(struct media_device *mdev, int fd)
> +{
> +	struct media_entity *entity, *pipe_head = NULL;
> +	struct media_pad_desc *sink_pads, sink_pad;
> +	struct media_link_desc *link;
> +	int num_sink_pads, prev_link_src_pad = -1, ret;
> +
> +	if (mdev == NULL)
> +		return -EINVAL;
> +
> +	/* get sink pipeline entity */
> +	ret = get_entity_by_fd(mdev, fd, &entity);
> +	if (ret < 0)
> +		return ret;
> +
> +	if (entity == NULL)
> +		return -EINVAL;
> +
> +	entity->fd = fd;
> +
> +	for (;;) {
> +		if (pipe_head == NULL) {
> +			pipe_head = entity;
> +		} else {
> +			entity->next = pipe_head;
> +			pipe_head = entity;
> +		}
> +
> +		entity->src_pad_id = prev_link_src_pad;
> +		ret = get_busy_pads_by_entity(mdev, entity,
> +					     &sink_pads,
> +					     &num_sink_pads,
> +					     MEDIA_PAD_FL_SINK);
> +		if (ret < 0)
> +			return ret;
> +
> +		/* check if pipeline source entity has been reached */
> +		if (num_sink_pads > 1) {
> +			/* Case for two parallel active links */
> +			ret = get_pad_by_index(sink_pads, num_sink_pads, 0,
> +							&sink_pad);
> +			if (ret < 0)
> +				return ret;
> +		} else if (num_sink_pads == 1) {
> +			sink_pad = sink_pads[0];
> +		} else {
> +			break;
> +		}
> +		if (num_sink_pads > 0)
> +			free(sink_pads);
> +
> +		ret = get_link_by_sink_pad(mdev, &sink_pad,
> +						   &link);
> +
> +		prev_link_src_pad = link->source.index;
> +		entity->sink_pad_id = link->sink.index;
> +
> +		ret = get_src_entity_by_link(mdev, link, &entity);
> +		if (ret || entity == NULL)
> +			return ret;
> +
> +	}
> +
> +	mdev->pipeline = pipe_head;
> +
> +	return 0;
> +}
> +
> +static int close_pipeline_subdevs(struct media_entity *pipeline)
> +{
> +	if (pipeline == NULL)
> +		return -EINVAL;
> +
> +	while (pipeline) {
> +		close(pipeline->fd);
> +		pipeline = pipeline->next;
> +		if (pipeline->next == NULL)
> +			break;
> +	}
> +
> +	return 0;
> +}
> +
> +static int open_pipeline_subdevs(struct media_entity *pipeline)
> +{
> +	struct media_entity *entity = pipeline;
> +
> +	if (pipeline == NULL)
> +		return -EINVAL;
> +
> +	while (entity) {
> +		entity->fd = open(entity->node_name, O_RDWR);
> +		if (entity->fd < 0) {
> +			V4L2_EXYNOS4_DBG("Could not open device %s",
> +			    entity->node_name);
> +			goto err_open_subdev;
> +		}
> +
> +		entity = entity->next;
> +		if (entity->next == NULL)
> +			break;
> +	}
> +
> +	return 0;
> +
> +err_open_subdev:
> +	while (pipeline) {
> +		if (pipeline == entity)
> +			break;
> +		close(pipeline->fd);
> +		pipeline = pipeline->next;
> +		if (pipeline->next == NULL)
> +			break;
> +	}
> +
> +	return -EINVAL;
> +}
> +
> +static int verify_format(struct v4l2_mbus_framefmt *fmt1,
> +				struct v4l2_mbus_framefmt *fmt2)
> +{
> +	if (fmt1 == NULL || fmt2 == NULL)
> +		return 0;
> +
> +	if (fmt1->width != fmt2->width) {
> +		V4L2_EXYNOS4_DBG("width mismatch")
> +		return 0;
> +	}
> +
> +	if (fmt1->height != fmt2->height) {
> +		V4L2_EXYNOS4_DBG("height mismatch")
> +		return 0;
> +	}
> +
> +	if (fmt1->code != fmt2->code) {
> +		V4L2_EXYNOS4_DBG("code mismatch")
> +		return 0;
> +	}
> +
> +	if (fmt1->field != fmt2->field) {
> +		V4L2_EXYNOS4_DBG("field mismatch")
> +		return 0;
> +	}
> +
> +	if (fmt1->colorspace != fmt2->colorspace) {
> +		V4L2_EXYNOS4_DBG("colorspace mismatch")
> +		return 0;
> +	}
> +
> +	return 1;
> +}
> +
> +static int get_format_name(__u32 pix_code, int *fmt_id)
> +{
> +	int i;
> +
> +	if (fmt_id == NULL)
> +		return -EINVAL;
> +
> +	for (i = 0; i < ARRAY_SIZE(mbus_codes); ++i) {
> +		if (mbus_codes[i].code == pix_code) {
> +			*fmt_id = i;
> +			return 0;
> +		}
> +	}
> +
> +	return -EINVAL;
> +}
> +
> +static int rgb_fmt(unsigned int pix_fmt)
> +{
> +	int i;
> +
> +	for (i = 0; i < ARRAY_SIZE(rgb_px_fmt); ++i) {
> +		if (rgb_px_fmt[i] == pix_fmt)
> +			return 1;
> +	}
> +
> +	return 0;
> +}
> +
> +static int yuv_fmt(unsigned int pix_fmt)
> +{
> +	int i;
> +
> +	for (i = 0; i < ARRAY_SIZE(yuv_px_fmt); ++i) {
> +		if (yuv_px_fmt[i] == pix_fmt)
> +			return 1;
> +	}
> +
> +	return 0;
> +}
> +
> +static int jpeg_fmt(unsigned int pix_fmt)
> +{
> +	int i;
> +
> +	for (i = 0; i < ARRAY_SIZE(jpeg_px_fmt); ++i) {
> +		if (jpeg_px_fmt[i] == pix_fmt)
> +			return 1;
> +	}
> +
> +	return 0;
> +}
> +
> +static int sensor_fmt(unsigned int pix_fmt)
> +{
> +	int i;
> +
> +	for (i = 0; i < ARRAY_SIZE(sensor_px_fmt); ++i) {
> +		if (sensor_px_fmt[i] == pix_fmt)
> +			return 1;
> +	}
> +
> +	return 0;
> +}
> +
> +static int select_mbus_codes_by_pix_fmt(unsigned int pix_fmt)
> +{
> +	int fmt_flags, i;
> +
> +	if (rgb_fmt(pix_fmt) || yuv_fmt(pix_fmt))
> +		fmt_flags = RGB_PX_FMT | YUV_PX_FMT;
> +	else if (jpeg_fmt(pix_fmt))
> +		fmt_flags = JPEG_PX_FMT;
> +	else if (sensor_fmt(pix_fmt))
> +		fmt_flags = SENSOR_PX_FMT;
> +	else
> +		return -EINVAL;
> +
> +	for (i = 0; i < ARRAY_SIZE(mbus_codes); ++i)
> +		mbus_codes[i].supported = !!(mbus_codes[i].compat_pix_fmts
> +					   & fmt_flags);
> +
> +	return 0;
> +}
> +
> +static int enumerate_subdev_mbus_codes(struct media_entity *entity,
> +			    int pad_id,
> +			    struct v4l2_subdev_mbus_code_enum **fmt_enum,
> +			    int *num_codes)
> +{
> +	struct v4l2_subdev_mbus_code_enum *temp_fmt_enum;
> +	int i, code_id, ret;
> +
> +	if (entity == NULL || fmt_enum == NULL || num_codes == NULL)
> +		return -EINVAL;
> +
> +	temp_fmt_enum = malloc(sizeof(*temp_fmt_enum));
> +
> +	for (i = 0;; ++i) {
> +		temp_fmt_enum = realloc(temp_fmt_enum, (i + 1) *
> +						sizeof(*temp_fmt_enum));
> +		if (temp_fmt_enum == NULL)
> +			goto err_enum_subdev;
> +
> +		memset(&temp_fmt_enum[i], 0, sizeof(*temp_fmt_enum));
> +		temp_fmt_enum[i].pad = pad_id;
> +		temp_fmt_enum[i].index = i;
> +
> +		ret = SYS_IOCTL(entity->fd,
> +			    VIDIOC_SUBDEV_ENUM_MBUS_CODE, &temp_fmt_enum[i]);
> +		if (ret < 0)
> +			break;
> +
> +		ret = get_format_name(temp_fmt_enum[i].code, &code_id);
> +		if (ret < 0)
> +			goto err_enum_subdev;
> +
> +		V4L2_EXYNOS4_DBG("name: %s, pad: %d, format: %s, fmt_id: %x",
> +		    entity->name,
> +		    temp_fmt_enum[i].pad,
> +		    mbus_codes[code_id].name, temp_fmt_enum[i].code);
> +	}
> +
> +	*fmt_enum = temp_fmt_enum;
> +	*num_codes = i + 1;
> +
> +	return 0;
> +
> +err_enum_subdev:
> +	free(temp_fmt_enum);
> +
> +	return -EINVAL;
> +}
> +
> +static int mark_unsupported_mbus_codes(
> +				struct v4l2_subdev_mbus_code_enum *subdev_codes,
> +				int num_subdev_codes)
> +{
> +	int i, j;
> +
> +	if (subdev_codes == NULL)
> +		return -EINVAL;
> +
> +	/*
> +	 * Mark mbus codes not present in the passed subdev_codes
> +	 * array as unsupported, to prevent them from being selected
> +	 * as the common mbus code for the whole pipeline.
> +	 */
> +	for (i = 0; i < ARRAY_SIZE(mbus_codes); ++i) {
> +		for (j = 0; j < num_subdev_codes; ++j) {
> +			if (mbus_codes[i].code == subdev_codes[j].code)
> +				break;
> +		}
> +		/* Don't take into account mbus codes once marked unsupported */
> +		if (mbus_codes[i].supported)
> +			mbus_codes[i].supported = (j != num_subdev_codes);
> +	}
> +
> +	return 0;
> +}
> +
> +static int negotiate_mbus_pix_code(struct media_device *mdev,
> +					unsigned int pix_fmt,
> +					struct mbus_code_meta_pkg *mbus_code)
> +{
> +	struct v4l2_subdev_mbus_code_enum *subdev_mbus_codes = NULL;
> +	struct media_entity *entity;
> +	int i, num_subdev_codes, ret;
> +
> +	if (mdev == NULL || mbus_code == NULL)
> +		return -EINVAL;
> +
> +	entity = mdev->pipeline;
> +
> +	ret = select_mbus_codes_by_pix_fmt(pix_fmt);
> +	if (ret < 0)
> +		goto err_neg_mbus_code;
> +
> +	while (entity) {
> +		ret = enumerate_subdev_mbus_codes(entity,
> +						  entity->src_pad_id,
> +						  &subdev_mbus_codes,
> +						  &num_subdev_codes);
> +		if (ret < 0)
> +			return ret;
> +
> +		ret = mark_unsupported_mbus_codes(subdev_mbus_codes,
> +						  num_subdev_codes);
> +		if (ret < 0)
> +			goto err_neg_mbus_code;
> +
> +		free(subdev_mbus_codes);
> +
> +		/* Negotiation should stop on FIMC-IS-ISP entity */
> +		if (strcmp(entity->name, EXYNOS4_FIMC_IS_ISP) == 0)
> +			break;
> +
> +		entity = entity->next;
> +		/*
> +		 * We should exit the loop if current entity
> +		 * is pipeline's sink, as it is not a subdev.
> +		 */
> +		if (entity->next == NULL)
> +			break;
> +	}
> +
> +	for (i = 0; i < ARRAY_SIZE(mbus_codes); ++i) {
> +		if (mbus_codes[i].supported) {
> +			*mbus_code = mbus_codes[i];
> +			return 0;
> +		}
> +	}
> +
> +	return -EINVAL;
> +
> +err_neg_mbus_code:
> +	free(subdev_mbus_codes);
> +
> +	return -EINVAL;
> +}
> +
> +static int has_pipeline_entity(struct media_entity *pipeline, char *entity)
> +{
> +	if (pipeline == NULL || entity == NULL)
> +		return -EINVAL;
> +
> +	while (pipeline) {
> +		if (!strcmp(pipeline->name, entity))
> +			return 1;
> +		pipeline = pipeline->next;
> +	}
> +
> +	return 0;
> +}
> +
> +static int adjust_format_to_fimc_is_isp(struct v4l2_mbus_framefmt *mbus_fmt)
> +{
> +	if (mbus_fmt == NULL)
> +		return -EINVAL;
> +
> +	mbus_fmt->width += 16;
> +	mbus_fmt->height += 12;
> +
> +	return 0;
> +}
> +
> +static int negotiate_pipeline_fmt(struct media_device *mdev,
> +		       struct v4l2_format *dev_fmt,
> +		       struct mbus_code_meta_pkg *mbus_code)
> +{
> +	struct media_entity *vid_pipe;
> +	struct v4l2_subdev_format subdev_fmt = { 0 };
> +	struct v4l2_mbus_framefmt mbus_fmt = { 0 }, common_fmt;
> +	int repeat_negotiation, cnt_negotiation = 0, ret;
> +
> +	if (mdev == NULL || dev_fmt == NULL || mbus_code == NULL)
> +		return -EINVAL;
> +
> +	ret = select_mbus_codes_by_pix_fmt(dev_fmt->fmt.pix_mp.pixelformat);
> +	if (ret < 0)
> +		return ret;
> +
> +	vid_pipe = mdev->pipeline;
> +
> +	mbus_fmt.width = dev_fmt->fmt.pix_mp.width;
> +	mbus_fmt.height = dev_fmt->fmt.pix_mp.height;
> +	mbus_fmt.field = dev_fmt->fmt.pix_mp.field;
> +	mbus_fmt.colorspace = dev_fmt->fmt.pix_mp.colorspace;
> +
> +	subdev_fmt.which = V4L2_SUBDEV_FORMAT_TRY;
> +
> +	if (has_pipeline_entity(vid_pipe, EXYNOS4_FIMC_IS_ISP)) {
> +		ret = adjust_format_to_fimc_is_isp(&mbus_fmt);
> +		if (ret < 0)
> +			return ret;
> +	}
> +
> +	subdev_fmt.format = mbus_fmt;
> +
> +	for (;;) {
> +		repeat_negotiation = 0;
> +		vid_pipe = mdev->pipeline;
> +
> +		subdev_fmt.pad = vid_pipe->src_pad_id;
> +
> +		ret = SYS_IOCTL(vid_pipe->fd, VIDIOC_SUBDEV_S_FMT,
> +			    &subdev_fmt);
> +		if (ret < 0)
> +			return ret;
> +
> +		common_fmt = subdev_fmt.format;
> +		vid_pipe->subdev_fmt = subdev_fmt;
> +
> +		vid_pipe = mdev->pipeline->next;
> +
> +		while (vid_pipe) {
> +			subdev_fmt.pad = vid_pipe->sink_pad_id;
> +
> +			/* Set format on the entity src pad */
> +			ret =
> +			    SYS_IOCTL(vid_pipe->fd, VIDIOC_SUBDEV_S_FMT,
> +				  &subdev_fmt);
> +			if (ret < 0)
> +				return ret;
> +
> +			if (!verify_format(&subdev_fmt.format, &common_fmt)) {
> +				repeat_negotiation = 1;
> +				break;
> +			}
> +
> +			vid_pipe->subdev_fmt = subdev_fmt;
> +
> +			/*
> +			 * Do not check format on FIMC.[n] source pad
> +			 * and stop negotiation.
> +			 */
> +			if (!strncmp(vid_pipe->name,
> +					EXYNOS4_FIMC_PREFIX,
> +					strlen(EXYNOS4_FIMC_PREFIX)))
> +				break;
> +
> +			subdev_fmt.pad = vid_pipe->src_pad_id;
> +
> +			/* Get format on the entity sink pad */
> +			ret =
> +			    SYS_IOCTL(vid_pipe->fd, VIDIOC_SUBDEV_G_FMT,
> +				  &subdev_fmt);
> +			if (ret < 0)
> +				return -EINVAL;
> +
> +			if (!strcmp(vid_pipe->name,
> +						EXYNOS4_FIMC_IS_ISP)) {
> +				common_fmt.code = subdev_fmt.format.code;
> +				common_fmt.colorspace =
> +						subdev_fmt.format.colorspace;
> +				common_fmt.width -= 16;
> +				common_fmt.height -= 12;
> +			}
> +			/* Bring back source pad id to the subdev format */
> +			subdev_fmt.pad = vid_pipe->sink_pad_id;
> +
> +			if (!verify_format(&subdev_fmt.format, &common_fmt)) {
> +				repeat_negotiation = 1;
> +				break;
> +			}
> +
> +			vid_pipe = vid_pipe->next;
> +			if (vid_pipe->next == NULL)
> +				break;
> +		}
> +
> +		if (!repeat_negotiation) {
> +			break;
> +		} else if (++cnt_negotiation > MAX_FMT_NEGO_NUM) {
> +			V4L2_EXYNOS4_DBG("Pipeline format negotiation failed!");
> +			return -EINVAL;
> +		}
> +	}
> +
> +	dev_fmt->fmt.pix_mp.width = subdev_fmt.format.width;
> +	dev_fmt->fmt.pix_mp.height = subdev_fmt.format.height;
> +	dev_fmt->fmt.pix_mp.field = subdev_fmt.format.field;
> +	dev_fmt->fmt.pix_mp.colorspace = subdev_fmt.format.colorspace;
> +
> +	return 0;
> +}
> +
> +static int try_set_subdev_fmt(struct media_device *mdev,
> +		   struct v4l2_format *dev_fmt,
> +		   struct mbus_code_meta_pkg *mbus_code)
> +{
> +	int ret;
> +
> +	if (mdev == NULL || dev_fmt == NULL || mbus_code == NULL)
> +		return -EINVAL;
> +
> +	ret = negotiate_mbus_pix_code(mdev,
> +				      dev_fmt->fmt.pix_mp.pixelformat,
> +				      mbus_code);
> +	if (ret < 0)
> +		return ret;
> +
> +	V4L2_EXYNOS4_DBG("Negotiated mbus code: %s", mbus_code->name);
> +
> +	ret = negotiate_pipeline_fmt(mdev, dev_fmt, mbus_code);
> +	if (ret < 0)
> +		return ret;
> +
> +	return 0;
> +}
> +
> +static int set_subdev_fmt(struct media_entity *pipeline,
> +				struct v4l2_format *dev_fmt,
> +				struct mbus_code_meta_pkg *mbus_code)
> +{
> +	struct v4l2_subdev_format subdev_fmt = { 0 };
> +	int ret;
> +
> +	if (pipeline == NULL || dev_fmt == NULL || mbus_code == NULL)
> +		return -EINVAL;
> +
> +	while (pipeline) {
> +		subdev_fmt = pipeline->subdev_fmt;
> +		subdev_fmt.which = V4L2_SUBDEV_FORMAT_ACTIVE;
> +		ret = SYS_IOCTL(pipeline->fd, VIDIOC_SUBDEV_S_FMT,
> +			    &subdev_fmt);
> +		if (ret < 0)
> +			return ret;
> +
> +		pipeline = pipeline->next;
> +		if (pipeline->next == NULL)
> +			break;
> +	}
> +
> +	/* seek for pipeline sink entity */
> +	while (pipeline->next)
> +		pipeline = pipeline->next;
> +
> +	ret = SYS_IOCTL(pipeline->fd, VIDIOC_S_FMT, dev_fmt);
> +	if (ret < 0)
> +		return ret;
> +
> +	return 0;
> +}
> +
> +static int convert_type(int type)
> +{
> +	switch (type) {
> +	case V4L2_BUF_TYPE_VIDEO_CAPTURE:
> +		return V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE;
> +	default:
> +		return type;
> +	}
> +}
> +
> +static int set_fmt_ioctl(struct exynos4_camera_plugin *plugin,
> +			 unsigned long int cmd,
> +			 struct v4l2_format *arg,
> +			 enum v4l2_subdev_format_whence set_mode)
> +{
> +	struct v4l2_format fmt = { 0 };
> +	struct v4l2_format *org = arg;
> +	struct mbus_code_meta_pkg mbus_code = { 0 };
> +	int ret;
> +
> +	if (plugin == NULL || arg == NULL)
> +		return -EINVAL;
> +
> +	fmt.type = convert_type(arg->type);
> +	if (fmt.type != arg->type) {
> +		fmt.fmt.pix_mp.width = org->fmt.pix.width;
> +		fmt.fmt.pix_mp.height = org->fmt.pix.height;
> +		fmt.fmt.pix_mp.pixelformat = org->fmt.pix.pixelformat;
> +		fmt.fmt.pix_mp.field = org->fmt.pix.field;
> +		fmt.fmt.pix_mp.colorspace = org->fmt.pix.colorspace;
> +		fmt.fmt.pix_mp.num_planes = 1;
> +		fmt.fmt.pix_mp.plane_fmt[0].bytesperline =
> +						org->fmt.pix.bytesperline;
> +		fmt.fmt.pix_mp.plane_fmt[0].sizeimage = org->fmt.pix.sizeimage;
> +	} else {
> +		fmt = *org;
> +	}
> +
> +	ret = try_set_subdev_fmt(&plugin->mdev, &fmt, &mbus_code);
> +	if (ret < 0)
> +		return ret;
> +
> +	if (set_mode == V4L2_SUBDEV_FORMAT_ACTIVE) {
> +		ret = set_subdev_fmt(plugin->mdev.pipeline, &fmt, &mbus_code);
> +		if (ret < 0)
> +			return ret;
> +	}
> +
> +	if (fmt.type != arg->type) {
> +		org->fmt.pix.width = fmt.fmt.pix_mp.width;
> +		org->fmt.pix.height = fmt.fmt.pix_mp.height;
> +		org->fmt.pix.pixelformat = fmt.fmt.pix_mp.pixelformat;
> +		org->fmt.pix.field = fmt.fmt.pix_mp.field;
> +		org->fmt.pix.colorspace = fmt.fmt.pix_mp.colorspace;
> +		org->fmt.pix.bytesperline =
> +				fmt.fmt.pix_mp.plane_fmt[0].bytesperline;
> +		org->fmt.pix.sizeimage = fmt.fmt.pix_mp.plane_fmt[0].sizeimage;
> +	} else {
> +		*org = fmt;
> +	}
> +
> +	return 0;
> +}
> +
> +static int get_fmt_ioctl(struct exynos4_camera_plugin *plugin,
> +			 unsigned long int cmd,
> +			 struct v4l2_format *arg)
> +{
> +	struct v4l2_format fmt = { 0 };
> +	struct v4l2_format *org = arg;
> +	int ret;
> +
> +	if (plugin == NULL || arg == NULL)
> +		return -EINVAL;
> +
> +	fmt.type = convert_type(arg->type);
> +
> +	if (fmt.type == arg->type)
> +		return SYS_IOCTL(plugin->vid_fd, cmd, arg);
> +
> +	ret = SYS_IOCTL(plugin->vid_fd, cmd, &fmt);
> +	if (ret < 0)
> +		return ret;
> +
> +	org->fmt.pix.width = fmt.fmt.pix_mp.width;
> +	org->fmt.pix.height = fmt.fmt.pix_mp.height;
> +	org->fmt.pix.pixelformat = fmt.fmt.pix_mp.pixelformat;
> +	org->fmt.pix.field = fmt.fmt.pix_mp.field;
> +	org->fmt.pix.colorspace = fmt.fmt.pix_mp.colorspace;
> +	org->fmt.pix.bytesperline = fmt.fmt.pix_mp.plane_fmt[0].bytesperline;
> +	org->fmt.pix.sizeimage = fmt.fmt.pix_mp.plane_fmt[0].sizeimage;
> +
> +	/*
> +	 * If the device doesn't support just one plane, there's
> +	 * nothing we can do, except return an error condition.
> +	 */
> +	if (fmt.fmt.pix_mp.num_planes > 1) {
> +		errno = -EINVAL;
> +		return -1;
> +	}
> +
> +	return ret;
> +}
> +
> +static int enum_fmt_ioctl(struct exynos4_camera_plugin *plugin,
> +			  unsigned long int cmd,
> +			  struct v4l2_fmtdesc *arg)
> +{
> +	struct v4l2_fmtdesc efmt = *arg;
> +	struct v4l2_fmtdesc *org = arg;
> +	int ret;
> +
> +	if (plugin == NULL || arg == NULL)
> +		return -EINVAL;
> +
> +	efmt.type = convert_type(arg->type);
> +
> +	if (efmt.type == arg->type)
> +		return SYS_IOCTL(plugin->vid_fd, cmd, arg);
> +
> +	ret = SYS_IOCTL(plugin->vid_fd, cmd, &efmt);
> +	if (ret < 0)
> +		return ret;
> +
> +	efmt.type = org->type;
> +	*org = efmt;
> +
> +	return ret;
> +}
> +
> +static int buf_ioctl(struct exynos4_camera_plugin *plugin,
> +		     unsigned long int cmd,
> +		     struct v4l2_buffer *arg)
> +{
> +	struct v4l2_buffer buf = *arg;
> +	struct v4l2_plane plane = { 0 };
> +	int ret;
> +
> +	buf.type = convert_type(arg->type);
> +
> +	if (buf.type == arg->type)
> +		return SYS_IOCTL(plugin->vid_fd, cmd, arg);
> +
> +	memcpy(&plane.m, &arg->m, sizeof(plane.m));
> +	plane.length = arg->length;
> +	plane.bytesused = arg->bytesused;
> +
> +	buf.m.planes = &plane;
> +	buf.length = 1;
> +
> +	ret = SYS_IOCTL(plugin->vid_fd, cmd, &buf);
> +
> +	arg->index = buf.index;
> +	arg->memory = buf.memory;
> +	arg->flags = buf.flags;
> +	arg->field = buf.field;
> +	arg->timestamp = buf.timestamp;
> +	arg->timecode = buf.timecode;
> +	arg->sequence = buf.sequence;
> +	arg->length = buf.m.planes[0].length;
> +	arg->m.offset = buf.m.planes[0].m.mem_offset;
> +	arg->bytesused = buf.m.planes[0].bytesused;
> +
> +	return ret;
> +}
> +
> +static int querycap_ioctl(struct exynos4_camera_plugin *plugin,
> +			  struct v4l2_capability *arg)
> +{
> +	int ret;
> +
> +	ret = SYS_IOCTL(plugin->vid_fd, VIDIOC_QUERYCAP, arg);
> +
> +	if (arg->capabilities & V4L2_CAP_VIDEO_CAPTURE_MPLANE)
> +		arg->capabilities |= V4L2_CAP_VIDEO_CAPTURE;

Check device_caps instead of capabilities. That way you can check
what this specific device supports. I hope that the exynos driver
sets device_caps. If not, that should be added.

If you want to make this generic you could do:

	__u32 caps = arg->capabilities;

	if (caps & V4L2_CAP_DEVICE_CAPS)
		caps = arg->device_caps;

> +
> +	return ret;
> +}
> +
> +static int ctrl_ioctl(struct exynos4_camera_plugin *plugin, int request,
> +			struct v4l2_control *arg)
> +{
> +	struct media_entity *pipeline = plugin->mdev.pipeline;
> +	struct v4l2_control ctrl = *arg, gctrl = *arg;
> +	struct v4l2_queryctrl queryctrl;
> +	struct media_entity *entity;
> +	int ret = 0;
> +
> +	if (pipeline == NULL)
> +		return -EINVAL;
> +
> +	/*
> +	 * The control has to be reset to the default value
> +	 * on all of the pipeline entities, prior setting a new
> +	 * value. This is required in cases when the contol config

Typo: contol -> control

> +	 * is changed between subsequent calls to VIDIOC_S_CTRL,
> +	 * to avoid the situation when a control is set on more
> +	 * than one sub-device.
> +	 */
> +	if (request == VIDIOC_S_CTRL) {
> +		while (pipeline) {
> +			queryctrl.id = (ctrl.id - 1) | V4L2_CTRL_FLAG_NEXT_CTRL;

Why add NEXT_CTRL? Just set queryctrl.id to ctrl.id.

> +
> +			ret = SYS_IOCTL(pipeline->fd, VIDIOC_QUERYCTRL,
> +								&queryctrl);
> +			if (ret < 0 || queryctrl.id != ctrl.id) {
> +				pipeline = pipeline->next;
> +				continue;
> +			}
> +
> +			ret = SYS_IOCTL(pipeline->fd, VIDIOC_G_CTRL, &gctrl);
> +			if (ret < 0)
> +				return -EINVAL;
> +
> +			if (gctrl.value != queryctrl.default_value) {
> +				gctrl.value = queryctrl.default_value;
> +				ret = SYS_IOCTL(pipeline->fd,
> +						VIDIOC_S_CTRL, &gctrl);
> +				if (ret < 0)
> +					return -EINVAL;
> +			}
> +
> +			pipeline = pipeline->next;
> +		}
> +	}
> +
> +	entity = get_entity_by_cid(plugin->config.controls, ctrl.id);
> +	if (entity) {
> +		ret = SYS_IOCTL(entity->fd, request, &ctrl);
> +		V4L2_EXYNOS4_DBG("Setting config control %x succeeded on %s\n",
> +				 ctrl.id,
> +				 entity->name);
> +		goto exit;
> +	}
> +
> +	V4L2_EXYNOS4_DBG("No config for control id %x\n", ctrl.id);
> +
> +	/* Walk the pipeline until the request succeeds */
> +	pipeline = plugin->mdev.pipeline;
> +
> +	while (pipeline) {
> +		ret = SYS_IOCTL(pipeline->fd, request, &ctrl);
> +		if (!ret) {
> +			V4L2_EXYNOS4_DBG("Setting control %x succeeded on %s\n",
> +					 ctrl.id,
> +					 pipeline->name);
> +			goto exit;
> +		}
> +
> +		pipeline = pipeline->next;
> +	}
> +
> +exit:
> +	*arg = ctrl;
> +	return ret;
> +}
> +
> +static void *
> +plugin_init(int fd)
> +{
> +	struct v4l2_capability cap;
> +	struct exynos4_camera_plugin plugin, *ret_plugin = NULL;
> +	char *media_entity_name;
> +	struct media_device *mdev = &plugin.mdev;
> +	int ret;
> +
> +	memset(&plugin, 0, sizeof(plugin));
> +
> +	memset(&cap, 0, sizeof(cap));
> +	ret = SYS_IOCTL(fd, VIDIOC_QUERYCAP, &cap);
> +	if (ret < 0) {
> +		V4L2_EXYNOS4_ERR("Failed to query video capabilities.");
> +		return NULL;
> +	}
> +
> +	/* Get media node for the device */
> +	ret = get_media_node(mdev, fd, &media_entity_name);
> +	if (ret < 0)
> +		return NULL;
> +
> +	/* Check if video entity is of capture type */
> +	if (!capture_entity(media_entity_name))
> +		return NULL;
> +
> +	ret = libv4l_media_conf_read(EXYNOS4_CAPTURE_CONF, &plugin.config);
> +	if (ret < 0)
> +		return NULL;
> +
> +	ret = setup_config_links(mdev, plugin.config.links);
> +	/* Release links as they will not be used anymore */
> +	libv4l_media_conf_release_links(plugin.config.links);
> +
> +	if (ret < 0) {
> +		V4L2_EXYNOS4_ERR("Video entities linking failed.");
> +		return NULL;
> +	}
> +
> +	/* refresh device topology data after linking */
> +	release_entities(mdev);
> +
> +	ret = get_device_topology(mdev);
> +
> +	/* close media device fd as it won't be longer required */
> +	close(mdev->media_fd);
> +
> +	if (ret < 0)
> +		goto err_get_dev_topology;
> +
> +	/* discover a pipeline for the capture device */
> +	ret = discover_pipeline_by_fd(mdev, fd);
> +	if (ret < 0)
> +		goto err_discover_pipeline;
> +
> +	ret = open_pipeline_subdevs(mdev->pipeline);
> +	if (ret < 0)
> +		goto err_discover_pipeline;
> +
> +
> +	if (plugin.config.controls) {
> +		ret = validate_control_config(mdev,
> +						plugin.config.controls);
> +		if (ret < 0)
> +			goto err_validate_controls;
> +	}
> +
> +	/* Allocate and initialize private data */
> +	ret_plugin = calloc(1, sizeof(*ret_plugin));
> +	if (!ret_plugin)
> +		goto err_validate_controls;
> +
> +	plugin.vid_fd = fd;
> +
> +	*ret_plugin = plugin;
> +	V4L2_EXYNOS4_DBG("Initialized exynos4-camera plugin.");
> +
> +	return ret_plugin;
> +
> +err_validate_controls:
> +	close_pipeline_subdevs(mdev->pipeline);
> +err_discover_pipeline:
> +	release_entities(mdev);
> +err_get_dev_topology:
> +	libv4l_media_conf_release_controls(plugin.config.controls);
> +	return NULL;
> +}
> +
> +static void plugin_close(void *dev_ops_priv)
> +{
> +	struct exynos4_camera_plugin *plugin;
> +	struct media_device *mdev;
> +
> +	if (dev_ops_priv == NULL)
> +		return;
> +
> +	plugin = (struct exynos4_camera_plugin *) dev_ops_priv;
> +	mdev = &plugin->mdev;
> +
> +	close_pipeline_subdevs(mdev->pipeline);
> +	release_entities(mdev);
> +	libv4l_media_conf_release_controls(plugin->config.controls);
> +
> +	free(plugin);
> +}
> +
> +static int plugin_ioctl(void *dev_ops_priv, int fd, unsigned long int cmd,
> +							void *arg)
> +{
> +	struct exynos4_camera_plugin *plugin = dev_ops_priv;
> +
> +	if (plugin == NULL || arg == NULL)
> +		return -EINVAL;
> +
> +	switch (cmd) {
> +	case VIDIOC_S_CTRL:
> +	case VIDIOC_G_CTRL:
> +		return ctrl_ioctl(plugin, VIDIOC_S_CTRL, arg);

Support for VIDIOC_S/G/TRY_EXT_CTRLS should be added.

> +	case VIDIOC_TRY_FMT:
> +		return set_fmt_ioctl(plugin, VIDIOC_S_FMT, arg,
> +				     V4L2_SUBDEV_FORMAT_TRY);
> +	case VIDIOC_S_FMT:
> +		return set_fmt_ioctl(plugin, VIDIOC_S_FMT, arg,
> +				     V4L2_SUBDEV_FORMAT_ACTIVE);
> +	case VIDIOC_G_FMT:
> +		return get_fmt_ioctl(plugin, VIDIOC_G_FMT, arg);
> +	case VIDIOC_ENUM_FMT:
> +		return enum_fmt_ioctl(plugin, VIDIOC_ENUM_FMT, arg);
> +	case VIDIOC_QUERYCAP:
> +		return querycap_ioctl(plugin, arg);
> +	case VIDIOC_QBUF:
> +	case VIDIOC_DQBUF:
> +	case VIDIOC_QUERYBUF:
> +	case VIDIOC_PREPARE_BUF:
> +		return buf_ioctl(plugin, cmd, arg);
> +	case VIDIOC_REQBUFS:
> +		return SIMPLE_CONVERT_IOCTL(fd, cmd, arg,
> +					    v4l2_requestbuffers);
> +	case VIDIOC_STREAMON:
> +	case VIDIOC_STREAMOFF:
> +		{
> +			int *arg_type = (int *) arg;
> +			int type;
> +
> +			type = convert_type(*arg_type);
> +
> +			if (type != V4L2_BUF_TYPE_VIDEO_CAPTURE &&
> +			    type != V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE) {
> +				V4L2_EXYNOS4_ERR("Invalid buffer type.");
> +				return -EINVAL;
> +			}
> +
> +			return SYS_IOCTL(fd, cmd, &type);
> +		}
> +
> +	default:
> +		return SYS_IOCTL(fd, cmd, arg);
> +	}
> +}
> +
> +PLUGIN_PUBLIC const struct libv4l_dev_ops libv4l2_plugin = {
> +	.init = &plugin_init,
> +	.close = &plugin_close,
> +	.ioctl = &plugin_ioctl,
> +};
>

A lot of this looks like it is exynos independent. I would move such code to
a separate source and make it easy to reuse elsewhere.

BTW, I'm very pleased to see someone finally starting to use the libv4l plugin
mechanism. That's great! Hopefully this can serve as a template for others.

Regards,

	Hans
