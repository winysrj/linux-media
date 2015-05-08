Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud2.xs4all.net ([194.109.24.21]:57696 "EHLO
	lb1-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753455AbbEHLab (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 8 May 2015 07:30:31 -0400
Message-ID: <554C9E45.7090800@xs4all.nl>
Date: Fri, 08 May 2015 13:30:13 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Kamil Debski <k.debski@samsung.com>,
	dri-devel@lists.freedesktop.org, linux-media@vger.kernel.org
CC: m.szyprowski@samsung.com, mchehab@osg.samsung.com,
	kyungmin.park@samsung.com, thomas@tommie-lie.de, sean@mess.org,
	dmitry.torokhov@gmail.com, linux-input@vger.kernel.org,
	linux-samsung-soc@vger.kernel.org, lars@opdenkamp.eu,
	Hans Verkuil <hansverk@cisco.com>
Subject: Re: [PATCH v6 06/11] cec: add HDMI CEC framework
References: <1430760785-1169-1-git-send-email-k.debski@samsung.com> <1430760785-1169-7-git-send-email-k.debski@samsung.com>
In-Reply-To: <1430760785-1169-7-git-send-email-k.debski@samsung.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Kamil,

Just two tiny issues, and after that you can add my:

Reviewed-by: Hans Verkuil <hans.verkuil@ciso.com>

to this.

On 05/04/2015 07:32 PM, Kamil Debski wrote:
> diff --git a/include/uapi/linux/cec.h b/include/uapi/linux/cec.h
> new file mode 100644
> index 0000000..67b0049
> --- /dev/null
> +++ b/include/uapi/linux/cec.h
> @@ -0,0 +1,332 @@
> +#ifndef _CEC_H
> +#define _CEC_H
> +
> +#include <linux/types.h>
> +
> +struct cec_msg {
> +	__u64 ts;
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
> +	__u32 sequence;
> +	/* The framework assigns a sequence number to messages that are sent.
> +	 * This can be used to track replies to previously sent messages.
> +	 */
> +	__u8 reserved[35];
> +};

It is confusing in struct cec_msg that the comments come *after* the field
they belong to instead of just before. Can you change this?

> +
> +#define CEC_G_EVENT		_IOWR('a', 9, struct cec_event)

This can be __IOR since we never write anything.

> +/*
> +   Read and set the vendor ID of the CEC adapter.
> + */
> +#define CEC_G_VENDOR_ID		_IOR('a', 10, __u32)
> +#define CEC_S_VENDOR_ID		_IOW('a', 11, __u32)
> +/*
> +   Enable/disable the passthrough mode
> + */
> +#define CEC_G_PASSTHROUGH	_IOR('a', 12, __u32)
> +#define CEC_S_PASSTHROUGH	_IOW('a', 13, __u32)
> +
> +#endif
> 

Regards,

	Hans
