Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud3.xs4all.net ([194.109.24.22]:49440 "EHLO
	lb1-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754040AbbDWOTV (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 23 Apr 2015 10:19:21 -0400
Message-ID: <5538FF4B.1010304@xs4all.nl>
Date: Thu, 23 Apr 2015 16:18:51 +0200
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

Since promiscuous support has been dropped, this capability needs to be
dropped as well.

> +
> +struct cec_caps {
> +	__u32 available_log_addrs;
> +	__u32 capabilities;
> +	__u32 vendor_id;
> +	__u8  version;
> +	__u8  reserved[11];

I'd increase this to 31.

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

I'd increase this to 65 or so.

Regards,

	Hans

