Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud2.xs4all.net ([194.109.24.29]:33931 "EHLO
	lb3-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751252AbbD0JOB (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 27 Apr 2015 05:14:01 -0400
Message-ID: <553DFDD1.9050803@xs4all.nl>
Date: Mon, 27 Apr 2015 11:13:53 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Kamil Debski <k.debski@samsung.com>,
	dri-devel@lists.freedesktop.org, linux-media@vger.kernel.org
CC: m.szyprowski@samsung.com, mchehab@osg.samsung.com,
	kyungmin.park@samsung.com, thomas@tommie-lie.de, sean@mess.org,
	dmitry.torokhov@gmail.com, linux-input@vger.kernel.org,
	linux-samsung-soc@vger.kernel.org,
	Hans Verkuil <hansverk@cisco.com>
Subject: Re: [PATCH v4 06/10] cec: add HDMI CEC framework
References: <1429794192-20541-1-git-send-email-k.debski@samsung.com> <1429794192-20541-7-git-send-email-k.debski@samsung.com>
In-Reply-To: <1429794192-20541-7-git-send-email-k.debski@samsung.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Kamil,

I've added some missing HDMI 2.0 commands:

On 04/23/2015 03:03 PM, Kamil Debski wrote:
> From: Hans Verkuil <hansverk@cisco.com>
> 
> The added HDMI CEC framework provides a generic kernel interface for
> HDMI CEC devices.
> 
> Signed-off-by: Hans Verkuil <hansverk@cisco.com>
> [k.debski@samsung.com: Merged CEC Updates commit by Hans Verkuil]
> [k.debski@samsung.com: Merged Update author commit by Hans Verkuil]
> [k.debski@samsung.com: change kthread handling when setting logical
> address]
> [k.debski@samsung.com: code cleanup and fixes]
> [k.debski@samsung.com: add missing CEC commands to match spec]
> [k.debski@samsung.com: add RC framework support]
> [k.debski@samsung.com: move and edit documentation]
> [k.debski@samsung.com: add vendor id reporting]
> [k.debski@samsung.com: add possibility to clear assigned logical
> addresses]
> [k.debski@samsung.com: documentation fixes, clenaup and expansion]
> [k.debski@samsung.com: reorder of API structs and add reserved fields]
> [k.debski@samsung.com: fix handling of events and fix 32/64bit timespec
> problem]
> [k.debski@samsung.com: add cec.h to include/uapi/linux/Kbuild]
> Signed-off-by: Kamil Debski <k.debski@samsung.com>
> ---
>  Documentation/cec.txt     |  396 ++++++++++++++++
>  drivers/media/Kconfig     |    6 +
>  drivers/media/Makefile    |    2 +
>  drivers/media/cec.c       | 1161 +++++++++++++++++++++++++++++++++++++++++++++
>  include/media/cec.h       |  140 ++++++
>  include/uapi/linux/Kbuild |    1 +
>  include/uapi/linux/cec.h  |  303 ++++++++++++
>  7 files changed, 2009 insertions(+)
>  create mode 100644 Documentation/cec.txt
>  create mode 100644 drivers/media/cec.c
>  create mode 100644 include/media/cec.h
>  create mode 100644 include/uapi/linux/cec.h
> 
> diff --git a/include/uapi/linux/cec.h b/include/uapi/linux/cec.h
> new file mode 100644
> index 0000000..bb6d66c
> --- /dev/null
> +++ b/include/uapi/linux/cec.h
> @@ -0,0 +1,303 @@
> +#ifndef _CEC_H
> +#define _CEC_H
> +
> +#include <linux/types.h>
> +
> +struct cec_time {
> +	__u64 sec;
> +	__u64 nsec;
> +};
> +
> +struct cec_msg {
> +	struct cec_time ts;
> +	__u32 len;
> +	__u32 status;
> +	__u32 timeout;
> +	/* timeout (in ms) is used to timeout CEC_RECEIVE.
> +	   Set to 0 if you want to wait forever. */
> +	__u8  msg[16];
> +	__u8  reply;
> +	/* If non-zero, then wait for a reply with this opcode.
> +	   If there was an error when sending the msg or FeatureAbort
> +	   was returned, then reply is set to 0.
> +	   If reply is non-zero upon return, then len/msg are set to
> +	   the received message.
> +	   If reply is zero upon return and status has the
> +	   CEC_TX_STATUS_FEATURE_ABORT bit set, then len/msg are set to the
> +	   received feature abort message.
> +	   If reply is zero upon return and status has the
> +	   CEC_TX_STATUS_REPLY_TIMEOUT
> +	   bit set, then no reply was seen at all.
> +	   This field is ignored with CEC_RECEIVE.
> +	   If reply is non-zero for CEC_TRANSMIT and the message is a broadcast,
> +	   then -EINVAL is returned.
> +	   if reply is non-zero, then timeout is set to 1000 (the required
> +	   maximum response time).
> +	 */
> +	__u8 reserved[31];
> +};
> +
> +static inline __u8 cec_msg_initiator(const struct cec_msg *msg)
> +{
> +	return msg->msg[0] >> 4;
> +}
> +
> +static inline __u8 cec_msg_destination(const struct cec_msg *msg)
> +{
> +	return msg->msg[0] & 0xf;
> +}
> +
> +static inline bool cec_msg_is_broadcast(const struct cec_msg *msg)
> +{
> +	return (msg->msg[0] & 0xf) == 0xf;
> +}
> +
> +/* cec status field */
> +#define CEC_TX_STATUS_OK            (0)
> +#define CEC_TX_STATUS_ARB_LOST      (1 << 0)
> +#define CEC_TX_STATUS_RETRY_TIMEOUT (1 << 1)
> +#define CEC_TX_STATUS_FEATURE_ABORT (1 << 2)
> +#define CEC_TX_STATUS_REPLY_TIMEOUT (1 << 3)
> +#define CEC_RX_STATUS_READY         (0)
> +
> +#define CEC_LOG_ADDR_INVALID 0xff
> +
> +/* The maximum number of logical addresses one device can be assigned to.
> + * The CEC 2.0 spec allows for only 2 logical addresses at the moment. The
> + * Analog Devices CEC hardware supports 3. So let's go wild and go for 4. */
> +#define CEC_MAX_LOG_ADDRS 4
> +
> +/* The "Primary Device Type" */
> +#define CEC_PRIM_DEVTYPE_TV		0
> +#define CEC_PRIM_DEVTYPE_RECORD		1
> +#define CEC_PRIM_DEVTYPE_TUNER		3
> +#define CEC_PRIM_DEVTYPE_PLAYBACK	4
> +#define CEC_PRIM_DEVTYPE_AUDIOSYSTEM	5
> +#define CEC_PRIM_DEVTYPE_SWITCH		6
> +#define CEC_PRIM_DEVTYPE_VIDEOPROC	7
> +
> +/* The "All Device Types" flags (CEC 2.0) */
> +#define CEC_FL_ALL_DEVTYPE_TV		(1 << 7)
> +#define CEC_FL_ALL_DEVTYPE_RECORD	(1 << 6)
> +#define CEC_FL_ALL_DEVTYPE_TUNER	(1 << 5)
> +#define CEC_FL_ALL_DEVTYPE_PLAYBACK	(1 << 4)
> +#define CEC_FL_ALL_DEVTYPE_AUDIOSYSTEM	(1 << 3)
> +#define CEC_FL_ALL_DEVTYPE_SWITCH	(1 << 2)
> +/* And if you wondering what happened to VIDEOPROC devices: those should
> + * be mapped to a SWITCH. */
> +
> +/* The logical address types that the CEC device wants to claim */
> +#define CEC_LOG_ADDR_TYPE_TV		0
> +#define CEC_LOG_ADDR_TYPE_RECORD	1
> +#define CEC_LOG_ADDR_TYPE_TUNER		2
> +#define CEC_LOG_ADDR_TYPE_PLAYBACK	3
> +#define CEC_LOG_ADDR_TYPE_AUDIOSYSTEM	4
> +#define CEC_LOG_ADDR_TYPE_SPECIFIC	5
> +#define CEC_LOG_ADDR_TYPE_UNREGISTERED	6
> +/* Switches should use UNREGISTERED.
> + * Video processors should use SPECIFIC. */
> +
> +/* The CEC version */
> +#define CEC_VERSION_1_4B		5
> +#define CEC_VERSION_2_0			6
> +
> +struct cec_event {
> +	struct cec_time ts;
> +	__u32 event;
> +	__u8 reserved[4];
> +};
> +
> +/* The CEC state */
> +#define CEC_STATE_DISABLED		0
> +#define CEC_STATE_ENABLED		1
> +
> +/* Userspace has to configure the adapter state (enable/disable) */
> +#define CEC_CAP_STATE		(1 << 0)
> +/* Userspace has to configure the physical address */
> +#define CEC_CAP_PHYS_ADDR	(1 << 1)
> +/* Userspace has to configure the logical addresses */
> +#define CEC_CAP_LOG_ADDRS	(1 << 2)
> +/* Userspace can transmit messages */
> +#define CEC_CAP_TRANSMIT	(1 << 3)
> +/* Userspace can receive messages */
> +#define CEC_CAP_RECEIVE		(1 << 4)
> +/* Userspace has to configure the vendor id */
> +#define CEC_CAP_VENDOR_ID	(1 << 5)
> +/* The hardware has the possibility to work in the promiscuous mode */
> +#define CEC_CAP_PROMISCUOUS	(1 << 6)
> +
> +struct cec_caps {
> +	__u32 available_log_addrs;
> +	__u32 capabilities;
> +	__u32 vendor_id;
> +	__u8  version;
> +	__u8  reserved[11];
> +};
> +
> +struct cec_log_addrs {
> +	__u8 cec_version;
> +	__u8 num_log_addrs;
> +	__u8 primary_device_type[CEC_MAX_LOG_ADDRS];
> +	__u8 log_addr_type[CEC_MAX_LOG_ADDRS];
> +	__u8 log_addr[CEC_MAX_LOG_ADDRS];
> +
> +	/* CEC 2.0 */
> +	__u8 all_device_types;
> +	__u8 features[CEC_MAX_LOG_ADDRS][12];
> +
> +	__u8 reserved[9];
> +};
> +
> +/* Commands */
> +
> +/* One Touch Play Feature */
> +#define CEC_OP_ACTIVE_SOURCE			0x82
> +#define CEC_OP_IMAGE_VIEW_ON			0x04
> +#define CEC_OP_TEXT_VIEW_ON			0x0d
> +
> +/* Routing Control Feature */
> +#define CEC_OP_ACTIVE_SOURCE			0x82
> +#define CEC_OP_INACTIVE_SOURCE			0x9d
> +#define CEC_OP_REQUEST_ACTIVE_SOURCE		0x85
> +#define CEC_OP_ROUTING_CHANGE			0x80
> +#define CEC_OP_ROUTING_INFORMATION		0x81
> +#define CEC_OP_SET_STREAM_PATH			0x86
> +
> +/* Standby Feature */
> +#define CEC_OP_STANDBY				0x36
> +
> +/* One Touch Record Feature */
> +#define CEC_OP_RECORD_OFF			0x0b
> +#define CEC_OP_RECORD_ON			0x09
> +#define CEC_OP_RECORD_STATUS			0x0a
> +#define CEC_OP_RECORD_TV_SCREEN			0x0f
> +
> +/* Timer Programming Feature */
> +#define CEC_OP_CLEAR_ANALOGUE_TIMER		0x33
> +#define CEC_OP_CLEAR_DIGITAL_TIMER		0x99
> +#define CEC_OP_CLEAR_EXT_TIMER			0xa1
> +#define CEC_OP_SET_ANALOGUE_TIMER		0x34
> +#define CEC_OP_SET_DIGITAL_TIMER		0x97
> +#define CEC_OP_SET_EXT_TIMER			0xa2
> +#define CEC_OP_SET_EXT_PROGRAM_TIMER		0x67
> +#define CEC_OP_TIMER_CLEARED_STATUS		0x43
> +#define CEC_OP_TIMER_STATUS			0x35
> +
> +/* System Information Feature */
> +#define CEC_OP_CEC_VERSION			0x9e
> +#define CEC_OP_GET_CEC_VERSION			0x9f
> +#define CEC_OP_GIVE_PHYSICAL_ADDR		0x83
> +#define CEC_OP_GET_MENU_LANGUAGE		0x91
> +#define CEC_OP_REPORT_PHYSICAL_ADDR		0x84
> +#define CEC_OP_SET_MENU_LANGUAGE		0x32

#define CEC_OP_REPORT_FEATURES			0xa6	/* HDMI 2.0 */
#define CEC_OP_GIVE_FEATURES			0xa5	/* HDMI 2.0 */

> +
> +/* Deck Control Feature */
> +#define CEC_OP_DECK_CONTROL			0x42
> +#define CEC_OP_DECK_STATUS			0x1b
> +#define CEC_OP_GIVE_DECK_STATUS			0x1a
> +#define CEC_OP_PLAY				0x41
> +
> +/* Tuner Control Feature */
> +#define CEC_OP_GIVE_TUNER_DEVICE_STATUS		0x08
> +#define CEC_OP_SELECT_ANALOGUE_SERVICE		0x92
> +#define CEC_OP_SELECT_DIGITAL_SERVICE		0x93
> +#define CEC_OP_TUNER_DEVICE_STATUS		0x07
> +#define CEC_OP_TUNER_STEP_DECREMENT		0x06
> +#define CEC_OP_TUNER_STEP_INCREMENT		0x05
> +
> +/* Vendor Specific Commands Feature */
> +#define CEC_OP_CEC_VERSION			0x9e
> +#define CEC_OP_DEVICE_VENDOR_ID			0x87
> +#define CEC_OP_GET_CEC_VERSION			0x9f
> +#define CEC_OP_GIVE_DEVICE_VENDOR_ID		0x8c
> +#define CEC_OP_VENDOR_COMMAND			0x89
> +#define CEC_OP_VENDOR_COMMAND_WITH_ID		0xa0
> +#define CEC_OP_VENDOR_REMOTE_BUTTON_DOWN	0x8a
> +#define CEC_OP_VENDOR_REMOTE_BUTTON_UP		0x8b
> +
> +/* OSD Display Feature */
> +#define CEC_OP_SET_OSD_STRING			0x64
> +
> +/* Device OSD Transfer Feature */
> +#define CEC_OP_GIVE_OSD_NAME			0x46
> +#define CEC_OP_SET_OSD_NAME			0x47
> +
> +/* Device Menu Control Feature */
> +#define CEC_OP_MENU_REQUEST			0x8d
> +#define CEC_OP_MENU_STATUS			0x8e
> +#define CEC_OP_USER_CONTROL_PRESSED		0x44
> +#define CEC_OP_USER_CONTROL_RELEASED		0x45
> +
> +/* Power Status Feature */
> +#define CEC_OP_GIVE_DEVICE_POWER_STATUS		0x8f
> +#define CEC_OP_REPORT_POWER_STATUS		0x90
> +#define CEC_OP_FEATURE_ABORT			0x00
> +#define CEC_OP_ABORT				0xff
> +
> +/* System Audio Control Feature */
> +#define CEC_OP_GIVE_AUDIO_STATUS		0x71
> +#define CEC_OP_GIVE_SYSTEM_AUDIO_MODE_STATUS	0x7d
> +#define CEC_OP_REPORT_AUDIO_STATUS		0x7a
> +#define CEC_OP_SET_SYSTEM_AUDIO_MODE		0x72
> +#define CEC_OP_SYSTEM_AUDIO_MODE_REQUEST	0x70
> +#define CEC_OP_SYSTEM_AUDIO_MODE_STATUS		0x7e
> +
> +/* Audio Rate Control Feature */
> +#define CEC_OP_SET_AUDIO_RATE			0x9a
> +

/* Audio Return Channel Control Feature */

#define CEC_OP_INITIATE_ARC			0xc0
#define CEC_OP_REPORT_ARC_INITIATED		0xc1
#define CEC_OP_REPORT_ARC_TERMINATED		0xc2
#define CEC_OP_REQUEST_ARC_INITIATION		0xc3
#define CEC_OP_REQUEST_ARC_TERMINATION		0xc4
#define CEC_OP_TERMINATE_ARC			0xc5

/* Dynamic Audio Lipsync Feature, HDMI 2.0 */

#define CEC_OP_REQUEST_CURRENT_LATENCY		0xa7
#define CEC_OP_REPORT_CURRENT_LATENCY		0xa8

/* Capability Discovery and Control Feature */

#define CEC_OP_CDC_MESSAGE			0xf8

Regards,

	Hans
