Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud6.xs4all.net ([194.109.24.24]:40485 "EHLO
	lb1-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751062AbbECKle (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 3 May 2015 06:41:34 -0400
Message-ID: <5545FB4F.1060003@xs4all.nl>
Date: Sun, 03 May 2015 12:41:19 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Kamil Debski <k.debski@samsung.com>,
	dri-devel@lists.freedesktop.org, linux-media@vger.kernel.org
CC: m.szyprowski@samsung.com, mchehab@osg.samsung.com,
	kyungmin.park@samsung.com, thomas@tommie-lie.de, sean@mess.org,
	dmitry.torokhov@gmail.com, linux-input@vger.kernel.org,
	linux-samsung-soc@vger.kernel.org, lars@opdenkamp.eu,
	Hans Verkuil <hansverk@cisco.com>
Subject: Re: [PATCH v5 06/11] cec: add HDMI CEC framework
References: <1430301765-22202-1-git-send-email-k.debski@samsung.com> <1430301765-22202-7-git-send-email-k.debski@samsung.com>
In-Reply-To: <1430301765-22202-7-git-send-email-k.debski@samsung.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Kamil,

Here is my review:

On 04/29/2015 12:02 PM, Kamil Debski wrote:
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
> [k.debski@samsung.com: add sequence number handling]
> [k.debski@samsung.com: add passthrough mode]
> [k.debski@samsung.com: fix CEC defines, add missing CEC 2.0 commands]
> [k.debski@samsung.com: add DocBook documentation by Hans Verkuil, with
> minor additions]
> Signed-off-by: Kamil Debski <k.debski@samsung.com>
> ---
>  Documentation/cec.txt     |  396 +++++++++++++++
>  drivers/media/Kconfig     |    6 +
>  drivers/media/Makefile    |    2 +
>  drivers/media/cec.c       | 1200 +++++++++++++++++++++++++++++++++++++++++++++
>  include/media/cec.h       |  142 ++++++
>  include/uapi/linux/Kbuild |    1 +
>  include/uapi/linux/cec.h  |  337 +++++++++++++
>  7 files changed, 2084 insertions(+)
>  create mode 100644 Documentation/cec.txt
>  create mode 100644 drivers/media/cec.c
>  create mode 100644 include/media/cec.h
>  create mode 100644 include/uapi/linux/cec.h
> 
> diff --git a/Documentation/cec.txt b/Documentation/cec.txt
> new file mode 100644
> index 0000000..2b6c08a
> --- /dev/null
> +++ b/Documentation/cec.txt

<snip>

> +The following capabilities are defined:
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

CAP_PROMISCUOUS doesn't exist anymore, this can be removed.

Instead add the PASSTHROUGH capability.

Frankly, I wonder if this cec.txt document should document the userspace
API at all now that that is part of DocBook. I think it is better if it
only describes the kernel API and just refers to the DocBook for the
userspace parts.

CEC_G/S_PASSTHROUGH aren't described here as well, which only shows that
the userspace API should just be dropped.

<snip>

> diff --git a/include/uapi/linux/cec.h b/include/uapi/linux/cec.h

<snip>

> +/* The hardware has the possibility to work in the passthrough */

s/the passthrough/passthrough mode/

> +#define CEC_CAP_PASSTHROUGH	(1 << 6)

<snip>

> +#define CEC_G_EVENT		_IOWR('a', 9, struct cec_event)
> +/*
> +   Read and set the vendor ID of the CEC adapter.
> + */
> +#define CEC_G_VENDOR_ID		_IOR('a', 9, __u32)

9 -> 10, same for the following ioctls, all need to be increased by 1
since current G_EVENT and G_VENDOR_ID have the same ioctl number.

> +#define CEC_S_VENDOR_ID		_IOW('a', 10, __u32)
> +/*
> +   Enable/disable the passthrough mode
> + */
> +#define CEC_G_PASSTHROUGH	_IOR('a', 11, __u32)
> +#define CEC_S_PASSTHROUGH	_IOW('a', 12, __u32)
> +
> +#endif
> 

Regards,

	Hans
