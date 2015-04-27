Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud2.xs4all.net ([194.109.24.29]:34095 "EHLO
	lb3-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932381AbbD0KE4 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 27 Apr 2015 06:04:56 -0400
Message-ID: <553E09C1.9060605@xs4all.nl>
Date: Mon, 27 Apr 2015 12:04:49 +0200
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
> diff --git a/Documentation/cec.txt b/Documentation/cec.txt
> new file mode 100644
> index 0000000..2b6c08a
> --- /dev/null
> +++ b/Documentation/cec.txt
> @@ -0,0 +1,396 @@
> +- CEC_G_ADAP_LOG_ADDRS and CEC_S_ADAP_LOG_ADDRS
> +
> +These ioctl are used to configure the logical addresses of the CEC adapter.
> +
> +#define CEC_G_ADAP_LOG_ADDRS	_IOR('a', 3, struct cec_log_addrs)
> +#define CEC_S_ADAP_LOG_ADDRS	_IOWR('a', 4, struct cec_log_addrs)
> +
> +The struct cec_log_addrs is following:
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
> +The cec_version determines which CEC version should be used.
> +
> +/* The CEC version */
> +#define CEC_VERSION_1_4B		5
> +#define CEC_VERSION_2_0			6
> +
> +It will try to claim num_log_addrs devices. The log_addr_type array has
> +the logical address type that needs to be claimed for that device, and
> +the log_addr array will receive the actual logical address that was
> +claimed for that device or 0xff if no address could be claimed.
> +
> +The primary_device_type contains the primary device for each logical
> +address.
> +
> +For CEC 2.0 devices fill in the all_device_types parameter to use with the
> +Report Features command, and fill in the 'features' which contains the
> +remaining parameters (RC Profile and Device Features) to use in Report
> +Features.
> +
> +An error is returned if the adapter is disabled or if there
> +is no physical address assigned or if the cec_version is unknown.
> +
> +If no logical address of one or more of the given types could be claimed,
> +then log_addr will be set to CEC_LOG_ADDR_INVALID.

This does not appear to be the case looking at the cec_config_log_addrs function.
I don't see it being set to INVALID if it couldn't be claimed. I think that is
missing in the cec_config_log_addrs function.

Regards,

	Hans

