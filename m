Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr12.xs4all.nl ([194.109.24.32]:1344 "EHLO
	smtp-vbr12.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754948AbaFPKGT (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 16 Jun 2014 06:06:19 -0400
Message-ID: <539EC188.4010601@xs4all.nl>
Date: Mon, 16 Jun 2014 12:06:00 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Devin Heitmueller <dheitmueller@kernellabs.com>,
	linux-media@vger.kernel.org
Subject: Re: [PATCH] Add patch to allow compilation on versions < 3.5 with
 CONFIG_OF
References: <1402587904-9321-1-git-send-email-dheitmueller@kernellabs.com>
In-Reply-To: <1402587904-9321-1-git-send-email-dheitmueller@kernellabs.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 06/12/2014 05:45 PM, Devin Heitmueller wrote:
> Support for Open Firmware was introduced in the V4L2 tree, but
> it depends on features only found in 3.5+.  Add a patch to disable
> the support for earlier kernels.
> 
> Tested on Ubuntu 10.04 with kernel 3.2.0-030200-generic (which has
> CONFIG_OF enabled by default).

Doesn't this produce compiler warnings since the static v4l2_of_parse_*
functions are now never called?

I would patch v4l2-core/Makefile instead to just never compile v4l2-of.o.

Regards,

	Hans

> 
> Signed-off-by: Devin Heitmueller <dheitmueller@kernellabs.com>
> ---
>  backports/backports.txt           |  1 +
>  backports/v3.4_openfirmware.patch | 13 +++++++++++++
>  2 files changed, 14 insertions(+)
>  create mode 100644 backports/v3.4_openfirmware.patch
> 
> diff --git a/backports/backports.txt b/backports/backports.txt
> index 281c263..08908e6 100644
> --- a/backports/backports.txt
> +++ b/backports/backports.txt
> @@ -43,6 +43,7 @@ add v3.6_i2c_add_mux_adapter.patch
>  
>  [3.4.255]
>  add v3.4_i2c_add_mux_adapter.patch
> +add v3.4_openfirmware.patch
>  
>  [3.2.255]
>  add v3.2_devnode_uses_mode_t.patch
> diff --git a/backports/v3.4_openfirmware.patch b/backports/v3.4_openfirmware.patch
> new file mode 100644
> index 0000000..f0a8d36
> --- /dev/null
> +++ b/backports/v3.4_openfirmware.patch
> @@ -0,0 +1,13 @@
> +--- a/drivers/media/v4l2-core/v4l2-of.c	2014-06-11 17:05:02.000000000 -0700
> ++++ b/drivers/media/v4l2-core/v4l2-of.c	2014-06-11 17:05:34.000000000 -0700
> +@@ -1,3 +1,5 @@
> ++/* Depends on symbols not present until kernel 3.5 */
> ++#if 0
> + /*
> +  * V4L2 OF binding parsing library
> +  *
> +@@ -142,3 +144,4 @@
> + 	return 0;
> + }
> + EXPORT_SYMBOL(v4l2_of_parse_endpoint);
> ++#endif
> 

