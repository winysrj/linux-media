Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud6.xs4all.net ([194.109.24.28]:44827 "EHLO
	lb2-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751557AbbALLsT (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 12 Jan 2015 06:48:19 -0500
Message-ID: <54B3B475.5010405@xs4all.nl>
Date: Mon, 12 Jan 2015 12:48:05 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Kamil Debski <k.debski@samsung.com>,
	dri-devel@lists.freedesktop.org, linux-media@vger.kernel.org
CC: m.szyprowski@samsung.com, mchehab@osg.samsung.com,
	kyungmin.park@samsung.com, Hans Verkuil <hansverk@cisco.com>
Subject: Re: [RFC 1/6] cec: add new driver for cec support.
References: <1419345142-3364-1-git-send-email-k.debski@samsung.com> <1419345142-3364-2-git-send-email-k.debski@samsung.com>
In-Reply-To: <1419345142-3364-2-git-send-email-k.debski@samsung.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 12/23/2014 03:32 PM, Kamil Debski wrote:
> From: Hans Verkuil <hansverk@cisco.com>
> 
> Add the CEC framework.
> 
> Signed-off-by: Hans Verkuil <hansverk@cisco.com>
> [k.debski@samsung.com: Merged CEC Updates commit by Hans Verkuil]
> [k.debski@samsung.com: Merged Update author commit by Hans Verkuil]
> [k.debski@samsung.com: change kthread handling when setting logical
> address]
> [k.debski@samsung.com: code cleanup]
> Signed-off-by: Kamil Debski <k.debski@samsung.com>
> ---
>  cec-rfc.txt              |  319 ++++++++++++++
>  cec.txt                  |   40 ++
>  drivers/media/Kconfig    |    5 +
>  drivers/media/Makefile   |    2 +
>  drivers/media/cec.c      | 1048 ++++++++++++++++++++++++++++++++++++++++++++++
>  include/media/cec.h      |  129 ++++++
>  include/uapi/linux/cec.h |  222 ++++++++++
>  7 files changed, 1765 insertions(+)
>  create mode 100644 cec-rfc.txt
>  create mode 100644 cec.txt
>  create mode 100644 drivers/media/cec.c
>  create mode 100644 include/media/cec.h
>  create mode 100644 include/uapi/linux/cec.h
> 

...

> diff --git a/include/uapi/linux/cec.h b/include/uapi/linux/cec.h
> new file mode 100644
> index 0000000..a2c78d7
> --- /dev/null
> +++ b/include/uapi/linux/cec.h
> @@ -0,0 +1,222 @@
> +#ifndef _CEC_H
> +#define _CEC_H
> +
> +#include <linux/types.h>
> +
> +struct cec_msg {
> +	__u32 len;
> +	__u8  msg[16];
> +	__u32 status;
> +	/* If non-zero, then wait for a reply with this opcode.
> +	   If there was an error when sending the msg or FeatureAbort
> +	   was returned, then reply is set to 0.
> +	   If reply is non-zero upon return, then len/msg are set to
> +	   the received message.
> +	   If reply is zero upon return and status has the CEC_TX_STATUS_FEATURE_ABORT
> +	   bit set, then len/msg are set to the received feature abort message.
> +	   If reply is zero upon return and status has the CEC_TX_STATUS_REPLY_TIMEOUT
> +	   bit set, then no reply was seen at all.
> +	   This field is ignored with CEC_RECEIVE.
> +	   If reply is non-zero for CEC_TRANSMIT and the message is a broadcast,
> +	   then -EINVAL is returned.
> +	   if reply is non-zero, then timeout is set to 1000 (the required maximum
> +	   response time).
> +	 */
> +	__u8  reply;
> +	/* timeout (in ms) is used to timeout CEC_RECEIVE.
> +	   Set to 0 if you want to wait forever. */
> +	__u32 timeout;
> +	struct timespec ts;
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
> +// The maximum number of logical addresses one device can be assigned to.
> +// The CEC 2.0 spec allows for only 2 logical addresses at the moment. The
> +// Analog Devices CEC hardware supports 3. So let's go wild and go for 4.
> +#define CEC_MAX_LOG_ADDRS 4
> +
> +// "You are in a maze of twisty little defines, all alike"
> +// What were they thinking of when they came up with this mess...
> +
> +// The "Primary Device Type"
> +#define CEC_PRIM_DEVTYPE_TV		0
> +#define CEC_PRIM_DEVTYPE_RECORD		1
> +#define CEC_PRIM_DEVTYPE_TUNER		3
> +#define CEC_PRIM_DEVTYPE_PLAYBACK	4
> +#define CEC_PRIM_DEVTYPE_AUDIOSYSTEM	5
> +#define CEC_PRIM_DEVTYPE_SWITCH		6
> +#define CEC_PRIM_DEVTYPE_VIDEOPROC	7
> +
> +// The "All Device Types" flags (CEC 2.0)
> +#define CEC_FL_ALL_DEVTYPE_TV		(1 << 7)
> +#define CEC_FL_ALL_DEVTYPE_RECORD	(1 << 6)
> +#define CEC_FL_ALL_DEVTYPE_TUNER	(1 << 5)
> +#define CEC_FL_ALL_DEVTYPE_PLAYBACK	(1 << 4)
> +#define CEC_FL_ALL_DEVTYPE_AUDIOSYSTEM	(1 << 3)
> +#define CEC_FL_ALL_DEVTYPE_SWITCH	(1 << 2)
> +// And if you wondering what happened to VIDEOPROC devices: those should
> +// be mapped to a SWITCH.
> +
> +// The logical address types that the CEC device wants to claim
> +#define CEC_LOG_ADDR_TYPE_TV		0
> +#define CEC_LOG_ADDR_TYPE_RECORD	1
> +#define CEC_LOG_ADDR_TYPE_TUNER		2
> +#define CEC_LOG_ADDR_TYPE_PLAYBACK	3
> +#define CEC_LOG_ADDR_TYPE_AUDIOSYSTEM	4
> +#define CEC_LOG_ADDR_TYPE_SPECIFIC	5
> +#define CEC_LOG_ADDR_TYPE_UNREGISTERED	6
> +// Switches should use UNREGISTERED.
> +// Video processors should use SPECIFIC.
> +
> +// The CEC version
> +#define CEC_VERSION_1_4B		5
> +#define CEC_VERSION_2_0			6
> +
> +struct cec_event {
> +	__u32 event;
> +	struct timespec ts;
> +};
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
> +
> +struct cec_caps {
> +	__u32 available_log_addrs;
> +	__u32 capabilities;
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
> +};
> +
> +/* Commands */
> +
> +/* Standby Feature */
> +#define CEC_OP_STANDBY			0x36
> +
> +/* System Information Feature */
> +#define CEC_OP_CEC_VERSION		0x9e
> +#define CEC_OP_GET_CEC_VERSION		0x9f
> +#define CEC_OP_GIVE_PHYS_ADDR		0x83
> +#define CEC_OP_GET_MENU_LANG		0x91
> +#define CEC_OP_REPORT_PHYS_ADDR		0x84
> +#define CEC_OP_SET_MENU_LANG		0x32
> +
> +/* One Touch Play Feature */
> +#define CEC_OP_ACTIVE_SOURCE		0x82
> +#define CEC_OP_REQUEST_ACTIVE_SOURCE	0x85
> +#define CEC_OP_IMAGE_VIEW_ON		0x04
> +#define CEC_OP_TEXT_VIEW_ON		0x0d
> +
> +/* Vendor Specific Commands Feature */
> +#define CEC_OP_DEVICE_VENDOR_ID		0x87
> +#define CEC_OP_GIVE_DEVICE_VENDOR_ID	0x8c
> +#define CEC_OP_VENDOR_CMD		0x89
> +#define CEC_OP_VENDOR_CMD_WITH_ID	0xa0
> +#define CEC_OP_VENDOR_REMOTE_BTN_DOWN	0x8a
> +#define CEC_OP_VENDOR_REMOTE_BTN_UP	0x8b
> +
> +/* OSD Display Feature */
> +#define CEC_OP_SET_OSD_STRING		0x64
> +#define CEC_OP_GIVE_OSD_NAME		0x46
> +#define CEC_OP_SET_OSD_NAME		0x47
> +
> +/* Power Status Feature */
> +#define CEC_OP_GIVE_DEVICE_POWER_STATUS	0x8f
> +#define CEC_OP_REPORT_POWER_STATUS	0x90
> +
> +/* General Protocol Messages */
> +#define CEC_OP_FEATURE_ABORT		0x00
> +#define CEC_OP_ABORT			0xff
> +
> +/* Capability Discovery and Control Feature */
> +#define CEC_OP_CDC_MSG			0xf8
> +#define CDC_OP_HPD_SET_STATE		0x10
> +#define CDC_OP_HPD_REPORT_STATE		0x11

Obviously the full set of CEC commands should be defined here. While working on
this I only added the commands that I needed for testing (core commands), but
the final version of this header should have the full list.

Regards,

	Hans

> +
> +/* ioctls */
> +
> +#define CEC_EVENT_READY		1
> +#define CEC_EVENT_DISCONNECT	2
> +
> +/* issue a CEC command */
> +#define CEC_G_CAPS		_IOWR('a', 0, struct cec_caps)
> +#define CEC_TRANSMIT		_IOWR('a', 1, struct cec_msg)
> +#define CEC_RECEIVE		_IOWR('a', 2, struct cec_msg)
> +
> +/*
> +   Configure the CEC adapter. It sets the device type and which
> +   logical types it will try to claim. It will return which
> +   logical addresses it could actually claim.
> +   An error is returned if the adapter is disabled or if there
> +   is no physical address assigned.
> + */
> +
> +#define CEC_G_ADAP_LOG_ADDRS	_IOR('a', 3, struct cec_log_addrs)
> +#define CEC_S_ADAP_LOG_ADDRS	_IOWR('a', 4, struct cec_log_addrs)
> +
> +/*
> +   Enable/disable the adapter. The Set state ioctl may not
> +   be available if that is handled internally.
> + */
> +#define CEC_G_ADAP_STATE	_IOR('a', 5, __u32)
> +#define CEC_S_ADAP_STATE	_IOW('a', 6, __u32)
> +
> +/*
> +   phys_addr is either 0 (if this is the CEC root device)
> +   or a valid physical address obtained from the sink's EDID
> +   as read by this CEC device (if this is a source device)
> +   or a physical address obtained and modified from a sink
> +   EDID and used for a sink CEC device.
> +   If nothing is connected, then phys_addr is 0xffff.
> +   See HDMI 1.4b, section 8.7 (Physical Address).
> +
> +   The Set ioctl may not be available if that is handled
> +   internally.
> + */
> +#define CEC_G_ADAP_PHYS_ADDR	_IOR('a', 7, __u16)
> +#define CEC_S_ADAP_PHYS_ADDR	_IOW('a', 8, __u16)
> +
> +#define CEC_G_EVENT		_IOWR('a', 9, struct cec_event)
> +
> +#endif
> 

