Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-px0-f182.google.com ([209.85.216.182]:34143 "EHLO
	mail-px0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754830Ab0BBHIR (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 2 Feb 2010 02:08:17 -0500
Received: by mail-px0-f182.google.com with SMTP id 12so5432630pxi.33
        for <linux-media@vger.kernel.org>; Mon, 01 Feb 2010 23:08:16 -0800 (PST)
From: Huang Shijie <shijie8@gmail.com>
To: mchehab@redhat.com
Cc: linux-media@vger.kernel.org, zyziii@telegent.com, tiwai@suse.de,
	Huang Shijie <shijie8@gmail.com>
Subject: [PATCH v2 01/10] add header files for tlg2300
Date: Tue,  2 Feb 2010 15:07:47 +0800
Message-Id: <1265094475-13059-2-git-send-email-shijie8@gmail.com>
In-Reply-To: <1265094475-13059-1-git-send-email-shijie8@gmail.com>
References: <1265094475-13059-1-git-send-email-shijie8@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

pd-common.h contains the common data structures, while
vendorcmds.h contains the vendor commands for firmware.

Signed-off-by: Huang Shijie <shijie8@gmail.com>
---
 drivers/media/video/tlg2300/pd-common.h  |  280 ++++++++++++++++++++++++++++++
 drivers/media/video/tlg2300/vendorcmds.h |  243 ++++++++++++++++++++++++++
 2 files changed, 523 insertions(+), 0 deletions(-)
 create mode 100644 drivers/media/video/tlg2300/pd-common.h
 create mode 100644 drivers/media/video/tlg2300/vendorcmds.h

diff --git a/drivers/media/video/tlg2300/pd-common.h b/drivers/media/video/tlg2300/pd-common.h
new file mode 100644
index 0000000..619fd00
--- /dev/null
+++ b/drivers/media/video/tlg2300/pd-common.h
@@ -0,0 +1,280 @@
+#ifndef PD_COMMON_H
+#define PD_COMMON_H
+
+#include <linux/version.h>
+#include <linux/fs.h>
+#include <linux/wait.h>
+#include <linux/list.h>
+#include <linux/videodev2.h>
+#include <linux/semaphore.h>
+#include <linux/usb.h>
+#include <linux/poll.h>
+#include <media/videobuf-vmalloc.h>
+#include <media/v4l2-device.h>
+
+#include "dvb_frontend.h"
+#include "dvbdev.h"
+#include "dvb_demux.h"
+#include "dmxdev.h"
+
+#define SBUF_NUM	8
+#define MAX_BUFFER_NUM	6
+#define PK_PER_URB	32
+#define ISO_PKT_SIZE	3072
+
+#define POSEIDON_STATE_NONE		(0x0000)
+#define POSEIDON_STATE_ANALOG		(0x0001)
+#define POSEIDON_STATE_FM		(0x0002)
+#define POSEIDON_STATE_DVBT		(0x0004)
+#define POSEIDON_STATE_VBI		(0x0008)
+#define POSEIDON_STATE_DISCONNECT	(0x0080)
+
+#define PM_SUSPEND_DELAY	3
+
+#define V4L_PAL_VBI_LINES	18
+#define V4L_NTSC_VBI_LINES	12
+#define V4L_PAL_VBI_FRAMESIZE	(V4L_PAL_VBI_LINES * 1440 * 2)
+#define V4L_NTSC_VBI_FRAMESIZE	(V4L_NTSC_VBI_LINES * 1440 * 2)
+
+#define TUNER_FREQ_MIN		(45000000)
+#define TUNER_FREQ_MAX		(862000000)
+
+struct vbi_data {
+	struct video_device	*v_dev;
+	struct video_data	*video;
+	struct front_face	*front;
+
+	unsigned int		copied;
+	unsigned int		vbi_size; /* the whole size of two fields */
+	int 			users;
+};
+
+/*
+ * This is the running context of the video, it is useful for
+ * resume()
+ */
+struct running_context {
+	u32		freq;		/* VIDIOC_S_FREQUENCY */
+	int		audio_idx;	/* VIDIOC_S_TUNER    */
+	v4l2_std_id	tvnormid;	/* VIDIOC_S_STD     */
+	int		sig_index;	/* VIDIOC_S_INPUT  */
+	struct v4l2_pix_format pix;	/* VIDIOC_S_FMT   */
+};
+
+struct video_data {
+	/* v4l2 video device */
+	struct video_device	*v_dev;
+
+	/* the working context */
+	struct running_context	context;
+
+	/* for data copy */
+	int		field_count;
+
+	char		*dst;
+	int		lines_copied;
+	int		prev_left;
+
+	int		lines_per_field;
+	int		lines_size;
+
+	/* for communication */
+	u8			endpoint_addr;
+	struct urb 		*urb_array[SBUF_NUM];
+	struct vbi_data		*vbi;
+	struct poseidon 	*pd;
+	struct front_face	*front;
+
+	int			is_streaming;
+	int			users;
+
+	/* for bubble handler */
+	struct work_struct	bubble_work;
+};
+
+enum pcm_stream_state {
+	STREAM_OFF,
+	STREAM_ON,
+	STREAM_SUSPEND,
+};
+
+#define AUDIO_BUFS (3)
+#define CAPTURE_STREAM_EN 1
+struct poseidon_audio {
+	struct urb		*urb_array[AUDIO_BUFS];
+	unsigned int 		copied_position;
+	struct snd_pcm_substream   *capture_pcm_substream;
+
+	unsigned int 		rcv_position;
+	struct	snd_card	*card;
+	int 			card_close;
+
+	int 			users;
+	int			pm_state;
+	enum pcm_stream_state 	capture_stream;
+};
+
+struct radio_data {
+	__u32		fm_freq;
+	int		users;
+	unsigned int	is_radio_streaming;
+	struct video_device *fm_dev;
+};
+
+#define DVB_SBUF_NUM		4
+#define DVB_URB_BUF_SIZE	0x2000
+struct pd_dvb_adapter {
+	struct dvb_adapter	dvb_adap;
+	struct dvb_frontend	dvb_fe;
+	struct dmxdev		dmxdev;
+	struct dvb_demux	demux;
+
+	atomic_t		users;
+	atomic_t		active_feed;
+
+	/* data transfer */
+	s32			is_streaming;
+	struct urb		*urb_array[DVB_SBUF_NUM];
+	struct poseidon		*pd_device;
+	u8			ep_addr;
+	u8			reserved[3];
+
+	/* data for power resume*/
+	struct dvb_frontend_parameters fe_param;
+
+	/* for channel scanning */
+	int		prev_freq;
+	int		bandwidth;
+	unsigned long	last_jiffies;
+};
+
+struct front_face {
+	/* use this field to distinguish VIDEO and VBI */
+	enum v4l2_buf_type	type;
+
+	/* for host */
+	struct videobuf_queue	q;
+
+	/* the bridge for host and device */
+	struct videobuf_buffer	*curr_frame;
+
+	/* for device */
+	spinlock_t		queue_lock;
+	struct list_head	active;
+	struct poseidon		*pd;
+};
+
+struct poseidon {
+	struct list_head	device_list;
+
+	struct mutex		lock;
+	struct kref		kref;
+
+	/* for V4L2 */
+	struct v4l2_device	v4l2_dev;
+
+	/* hardware info */
+	struct usb_device	*udev;
+	struct usb_interface	*interface;
+	int 			cur_transfer_mode;
+
+	struct video_data	video_data;	/* video */
+	struct vbi_data		vbi_data;	/* vbi	 */
+	struct poseidon_audio	audio;		/* audio (alsa) */
+	struct radio_data	radio_data;	/* FM	 */
+	struct pd_dvb_adapter	dvb_data;	/* DVB	 */
+
+	u32			state;
+	int			country_code;
+	struct file		*file_for_stream; /* the active stream*/
+
+#ifdef CONFIG_PM
+	int (*pm_suspend)(struct poseidon *);
+	int (*pm_resume)(struct poseidon *);
+	pm_message_t		msg;
+
+	struct work_struct	pm_work;
+	u8			portnum;
+#endif
+};
+
+struct poseidon_format {
+	char 	*name;
+	int	fourcc;		 /* video4linux 2	  */
+	int	depth;		 /* bit/pixel		  */
+	int	flags;
+};
+
+struct poseidon_tvnorm {
+	v4l2_std_id	v4l2_id;
+	char		name[12];
+	u32		tlg_tvnorm;
+};
+
+/* video */
+int pd_video_init(struct poseidon *);
+void pd_video_exit(struct poseidon *);
+int stop_all_video_stream(struct poseidon *);
+
+/* alsa audio */
+int poseidon_audio_init(struct poseidon *);
+int poseidon_audio_free(struct poseidon *);
+#ifdef CONFIG_PM
+int pm_alsa_suspend(struct poseidon *);
+int pm_alsa_resume(struct poseidon *);
+#endif
+
+/* dvb */
+int pd_dvb_usb_device_init(struct poseidon *);
+void pd_dvb_usb_device_exit(struct poseidon *);
+void pd_dvb_usb_device_cleanup(struct poseidon *);
+int pd_dvb_get_adapter_num(struct pd_dvb_adapter *);
+void dvb_stop_streaming(struct pd_dvb_adapter *);
+
+/* FM */
+int poseidon_fm_init(struct poseidon *);
+int poseidon_fm_exit(struct poseidon *);
+struct video_device *vdev_init(struct poseidon *, struct video_device *);
+
+/* vendor command ops */
+int send_set_req(struct poseidon*, u8, s32, s32*);
+int send_get_req(struct poseidon*, u8, s32, void*, s32*, s32);
+s32 set_tuner_mode(struct poseidon*, unsigned char);
+enum tlg__analog_audio_standard get_audio_std(s32, s32);
+
+/* bulk urb alloc/free */
+int alloc_bulk_urbs_generic(struct urb **urb_array, int num,
+			struct usb_device *udev, u8 ep_addr,
+			int buf_size, gfp_t gfp_flags,
+			usb_complete_t complete_fn, void *context);
+void free_all_urb_generic(struct urb **urb_array, int num);
+
+/* misc */
+void poseidon_delete(struct kref *kref);
+void destroy_video_device(struct video_device **v_dev);
+extern int country_code;
+extern int debug_mode;
+void set_debug_mode(struct video_device *vfd, int debug_mode);
+
+#define in_hibernation(pd) (pd->msg.event == PM_EVENT_FREEZE)
+#define get_pm_count(p) (atomic_read(&(p)->interface->pm_usage_cnt))
+
+#define log(a, ...) printk(KERN_DEBUG "\t[ %s : %.3d ] "a"\n", \
+				__func__, __LINE__,  ## __VA_ARGS__)
+
+/* for power management */
+#define logpm(pd) do {\
+			if (debug_mode & 0x10)\
+				log();\
+		} while (0)
+
+#define logs(f) do { \
+			if ((debug_mode & 0x4) && \
+				(f)->type == V4L2_BUF_TYPE_VBI_CAPTURE) \
+					log("type : VBI");\
+								\
+			if ((debug_mode & 0x8) && \
+				(f)->type == V4L2_BUF_TYPE_VIDEO_CAPTURE) \
+					log("type : VIDEO");\
+		} while (0)
+#endif
diff --git a/drivers/media/video/tlg2300/vendorcmds.h b/drivers/media/video/tlg2300/vendorcmds.h
new file mode 100644
index 0000000..ba6f4ae
--- /dev/null
+++ b/drivers/media/video/tlg2300/vendorcmds.h
@@ -0,0 +1,243 @@
+#ifndef VENDOR_CMD_H_
+#define VENDOR_CMD_H_
+
+#define BULK_ALTERNATE_IFACE		(2)
+#define ISO_3K_BULK_ALTERNATE_IFACE     (1)
+#define REQ_SET_CMD			(0X00)
+#define REQ_GET_CMD			(0X80)
+
+enum tlg__analog_audio_standard {
+	TLG_TUNE_ASTD_NONE	= 0x00000000,
+	TLG_TUNE_ASTD_A2	= 0x00000001,
+	TLG_TUNE_ASTD_NICAM	= 0x00000002,
+	TLG_TUNE_ASTD_EIAJ	= 0x00000004,
+	TLG_TUNE_ASTD_BTSC	= 0x00000008,
+	TLG_TUNE_ASTD_FM_US	= 0x00000010,
+	TLG_TUNE_ASTD_FM_EUR	= 0x00000020,
+	TLG_TUNE_ASTD_ALL	= 0x0000003f
+};
+
+/*
+ * identifiers for Custom Parameter messages.
+ * @typedef cmd_custom_param_id_t
+ */
+enum cmd_custom_param_id {
+	CUST_PARM_ID_NONE		= 0x00,
+	CUST_PARM_ID_BRIGHTNESS_CTRL	= 0x01,
+	CUST_PARM_ID_CONTRAST_CTRL	= 0x02,
+	CUST_PARM_ID_HUE_CTRL		= 0x03,
+	CUST_PARM_ID_SATURATION_CTRL	  = 0x04,
+	CUST_PARM_ID_AUDIO_SNR_THRESHOLD  = 0x10,
+	CUST_PARM_ID_AUDIO_AGC_THRESHOLD  = 0x11,
+	CUST_PARM_ID_MAX
+};
+
+struct  tuner_custom_parameter_s {
+	uint16_t	param_id;	 /*  Parameter identifier  */
+	uint16_t	param_value;	 /*  Parameter value	   */
+};
+
+struct  tuner_ber_rate_s {
+	uint32_t	ber_rate;  /*  BER sample rate in seconds   */
+};
+
+struct tuner_atv_sig_stat_s {
+	uint32_t	sig_present;
+	uint32_t	sig_locked;
+	uint32_t	sig_lock_busy;
+	uint32_t	sig_strength;	   /*  milliDb	  */
+	uint32_t	tv_audio_chan;	  /*  mono/stereo/sap*/
+	uint32_t 	mvision_stat;	   /*  macrovision status */
+};
+
+struct tuner_dtv_sig_stat_s {
+	uint32_t sig_present;   /*  Boolean*/
+	uint32_t sig_locked;	/*  Boolean */
+	uint32_t sig_lock_busy; /*  Boolean	(Can this time-out?) */
+	uint32_t sig_strength;  /*  milliDb*/
+};
+
+struct tuner_fm_sig_stat_s {
+	uint32_t sig_present;	/* Boolean*/
+	uint32_t sig_locked;	 /* Boolean */
+	uint32_t sig_lock_busy;  /* Boolean */
+	uint32_t sig_stereo_mono;/* TBD*/
+	uint32_t sig_strength;   /* milliDb*/
+};
+
+enum _tag_tlg_tune_srv_cmd {
+	TLG_TUNE_PLAY_SVC_START = 1,
+	TLG_TUNE_PLAY_SVC_STOP
+};
+
+enum  _tag_tune_atv_audio_mode_caps {
+	TLG_TUNE_TVAUDIO_MODE_MONO	= 0x00000001,
+	TLG_TUNE_TVAUDIO_MODE_STEREO	= 0x00000002,
+	TLG_TUNE_TVAUDIO_MODE_LANG_A	= 0x00000010,/* Primary language*/
+	TLG_TUNE_TVAUDIO_MODE_LANG_B	= 0x00000020,/* 2nd avail language*/
+	TLG_TUNE_TVAUDIO_MODE_LANG_C	= 0x00000040
+};
+
+
+enum   _tag_tuner_atv_audio_rates {
+	ATV_AUDIO_RATE_NONE	= 0x00,/* Audio not supported*/
+	ATV_AUDIO_RATE_32K	= 0x01,/* Audio rate = 32 KHz*/
+	ATV_AUDIO_RATE_48K	= 0x02, /* Audio rate = 48 KHz*/
+	ATV_AUDIO_RATE_31_25K	= 0x04 /* Audio rate = 31.25KHz */
+};
+
+enum  _tag_tune_atv_vid_res_caps {
+	TLG_TUNE_VID_RES_NONE	= 0x00000000,
+	TLG_TUNE_VID_RES_720	= 0x00000001,
+	TLG_TUNE_VID_RES_704	= 0x00000002,
+	TLG_TUNE_VID_RES_360	= 0x00000004
+};
+
+enum _tag_tuner_analog_video_format {
+	TLG_TUNER_VID_FORMAT_YUV	= 0x00000001,
+	TLG_TUNER_VID_FORMAT_YCRCB	= 0x00000002,
+	TLG_TUNER_VID_FORMAT_RGB_565	= 0x00000004,
+};
+
+enum  tlg_ext_audio_support {
+	TLG_EXT_AUDIO_NONE 	= 0x00,/*  No external audio input supported */
+	TLG_EXT_AUDIO_LR	= 0x01/*  LR external audio inputs supported*/
+};
+
+enum {
+	TLG_MODE_NONE			= 0x00, /* No Mode specified*/
+	TLG_MODE_ANALOG_TV		= 0x01, /* Analog Television mode*/
+	TLG_MODE_ANALOG_TV_UNCOMP	= 0x01, /* Analog Television mode*/
+	TLG_MODE_ANALOG_TV_COMP  	= 0x02, /* Analog TV mode (compressed)*/
+	TLG_MODE_FM_RADIO		= 0x04, /* FM Radio mode*/
+	TLG_MODE_DVB_T			= 0x08, /* Digital TV (DVB-T)*/
+};
+
+enum  tlg_signal_sources_t {
+	TLG_SIG_SRC_NONE	= 0x00,/* Signal source not specified */
+	TLG_SIG_SRC_ANTENNA	= 0x01,/* Signal src is: Antenna */
+	TLG_SIG_SRC_CABLE	= 0x02,/* Signal src is: Coax Cable*/
+	TLG_SIG_SRC_SVIDEO	= 0x04,/* Signal src is: S_VIDEO   */
+	TLG_SIG_SRC_COMPOSITE   = 0x08 /* Signal src is: Composite Video */
+};
+
+enum tuner_analog_video_standard {
+	TLG_TUNE_VSTD_NONE	= 0x00000000,
+	TLG_TUNE_VSTD_NTSC_M	= 0x00000001,
+	TLG_TUNE_VSTD_NTSC_M_J	= 0x00000002,/* Japan   */
+	TLG_TUNE_VSTD_PAL_B	= 0x00000010,
+	TLG_TUNE_VSTD_PAL_D	= 0x00000020,
+	TLG_TUNE_VSTD_PAL_G	= 0x00000040,
+	TLG_TUNE_VSTD_PAL_H	= 0x00000080,
+	TLG_TUNE_VSTD_PAL_I	= 0x00000100,
+	TLG_TUNE_VSTD_PAL_M	= 0x00000200,
+	TLG_TUNE_VSTD_PAL_N	= 0x00000400,
+	TLG_TUNE_VSTD_SECAM_B	= 0x00001000,
+	TLG_TUNE_VSTD_SECAM_D	= 0x00002000,
+	TLG_TUNE_VSTD_SECAM_G	= 0x00004000,
+	TLG_TUNE_VSTD_SECAM_H	= 0x00008000,
+	TLG_TUNE_VSTD_SECAM_K	= 0x00010000,
+	TLG_TUNE_VSTD_SECAM_K1	= 0x00020000,
+	TLG_TUNE_VSTD_SECAM_L	= 0x00040000,
+	TLG_TUNE_VSTD_SECAM_L1	= 0x00080000,
+	TLG_TUNE_VSTD_PAL_N_COMBO = 0x00100000
+};
+
+enum tlg_mode_caps {
+	TLG_MODE_CAPS_NONE		= 0x00,  /*  No Mode specified	*/
+	TLG_MODE_CAPS_ANALOG_TV_UNCOMP  = 0x01,  /*  Analog TV mode     */
+	TLG_MODE_CAPS_ANALOG_TV_COMP	= 0x02,  /*  Analog TV (compressed)*/
+	TLG_MODE_CAPS_FM_RADIO		= 0x04,  /*  FM Radio mode	*/
+	TLG_MODE_CAPS_DVB_T		= 0x08,  /*  Digital TV (DVB-T)	*/
+};
+
+enum poseidon_vendor_cmds {
+	LAST_CMD_STAT		= 0x00,
+	GET_CHIP_ID		= 0x01,
+	GET_FW_ID		= 0x02,
+	PRODUCT_CAPS		= 0x03,
+
+	TUNE_MODE_CAP_ATV	= 0x10,
+	TUNE_MODE_CAP_ATVCOMP	= 0X10,
+	TUNE_MODE_CAP_DVBT	= 0x10,
+	TUNE_MODE_CAP_FM	= 0x10,
+	TUNE_MODE_SELECT	= 0x11,
+	TUNE_FREQ_SELECT	= 0x12,
+	SGNL_SRC_SEL		= 0x13,
+
+	VIDEO_STD_SEL		= 0x14,
+	VIDEO_STREAM_FMT_SEL	= 0x15,
+	VIDEO_ROSOLU_AVAIL	= 0x16,
+	VIDEO_ROSOLU_SEL	= 0x17,
+	VIDEO_CONT_PROTECT	= 0x20,
+
+	VCR_TIMING_MODSEL	= 0x21,
+	EXT_AUDIO_CAP		= 0x22,
+	EXT_AUDIO_SEL		= 0x23,
+	TEST_PATTERN_SEL	= 0x24,
+	VBI_DATA_SEL		= 0x25,
+	AUDIO_SAMPLE_RATE_CAP   = 0x28,
+	AUDIO_SAMPLE_RATE_SEL   = 0x29,
+	TUNER_AUD_MODE		= 0x2a,
+	TUNER_AUD_MODE_AVAIL	= 0x2b,
+	TUNER_AUD_ANA_STD	= 0x2c,
+	TUNER_CUSTOM_PARAMETER	= 0x2f,
+
+	DVBT_TUNE_MODE_SEL	= 0x30,
+	DVBT_BANDW_CAP		= 0x31,
+	DVBT_BANDW_SEL		= 0x32,
+	DVBT_GUARD_INTERV_CAP   = 0x33,
+	DVBT_GUARD_INTERV_SEL   = 0x34,
+	DVBT_MODULATION_CAP	= 0x35,
+	DVBT_MODULATION_SEL	= 0x36,
+	DVBT_INNER_FEC_RATE_CAP = 0x37,
+	DVBT_INNER_FEC_RATE_SEL = 0x38,
+	DVBT_TRANS_MODE_CAP	= 0x39,
+	DVBT_TRANS_MODE_SEL	= 0x3a,
+	DVBT_SEARCH_RANG	= 0x3c,
+
+	TUNER_SETUP_ANALOG	= 0x40,
+	TUNER_SETUP_DIGITAL	= 0x41,
+	TUNER_SETUP_FM_RADIO	= 0x42,
+	TAKE_REQUEST		= 0x43, /* Take effect of the command */
+	PLAY_SERVICE		= 0x44, /* Play start or Play stop */
+	TUNER_STATUS		= 0x45,
+	TUNE_PROP_DVBT		= 0x46,
+	ERR_RATE_STATS		= 0x47,
+	TUNER_BER_RATE		= 0x48,
+
+	SCAN_CAPS		= 0x50,
+	SCAN_SETUP		= 0x51,
+	SCAN_SERVICE		= 0x52,
+	SCAN_STATS		= 0x53,
+
+	PID_SET			= 0x58,
+	PID_UNSET		= 0x59,
+	PID_LIST		= 0x5a,
+
+	IRD_CAP			= 0x60,
+	IRD_MODE_SEL		= 0x61,
+	IRD_SETUP		= 0x62,
+
+	PTM_MODE_CAP		= 0x70,
+	PTM_MODE_SEL		= 0x71,
+	PTM_SERVICE		= 0x72,
+	TUNER_REG_SCRIPT	= 0x73,
+	CMD_CHIP_RST		= 0x74,
+};
+
+enum tlg_bw {
+	TLG_BW_5 = 5,
+	TLG_BW_6 = 6,
+	TLG_BW_7 = 7,
+	TLG_BW_8 = 8,
+	TLG_BW_12 = 12,
+	TLG_BW_15 = 15
+};
+
+struct cmd_firmware_vers_s {
+	uint8_t	 fw_rev_major;
+	uint8_t	 fw_rev_minor;
+	uint16_t fw_patch;
+};
+#endif /* VENDOR_CMD_H_ */
-- 
1.6.5.2

