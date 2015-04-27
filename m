Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud2.xs4all.net ([194.109.24.25]:42912 "EHLO
	lb2-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751252AbbD0KZR (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 27 Apr 2015 06:25:17 -0400
Message-ID: <553E0E86.4080002@xs4all.nl>
Date: Mon, 27 Apr 2015 12:25:10 +0200
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

> +	case CEC_S_ADAP_LOG_ADDRS: {
> +		struct cec_log_addrs log_addrs;
> +
> +		if (!(adap->capabilities & CEC_CAP_LOG_ADDRS))
> +			return -ENOTTY;
> +		if (copy_from_user(&log_addrs, parg, sizeof(log_addrs)))
> +			return -EFAULT;
> +		err = cec_claim_log_addrs(adap, &log_addrs, true);

Currently CEC_S_ADAP_LOG_ADDRS is always blocking, but since we have CEC_EVENT_READY
I think it makes sense to just return in non-blocking mode and have cec_claim_log_addrs
generate CEC_EVENT_READY when done. Userspace can then call G_ADAP_LOG_ADDRS to discover
the result.

What do you think?

Regards,

	Hans

> +		if (err)
> +			return err;
> +
> +		if (copy_to_user(parg, &log_addrs, sizeof(log_addrs)))
> +			return -EFAULT;
> +		break;
> +	}

