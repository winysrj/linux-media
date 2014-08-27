Return-path: <linux-media-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:59484 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934415AbaH0OJw (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 27 Aug 2014 10:09:52 -0400
Date: Wed, 27 Aug 2014 10:09:44 -0400
From: Kyle McMartin <kyle@infradead.org>
To: Bimow Chen <Bimow.Chen@ite.com.tw>
Cc: linux-firmware@kernel.org, linux-media@vger.kernel.org,
	dwmw2@infradead.org
Subject: Re: linux-firmware: add firmware v3.25.0.0 for ITEtech IT9135 DVB-T
 USB driver
Message-ID: <20140827140944.GB15412@merlin.infradead.org>
References: <1408433867.5698.6.camel@ite-desktop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1408433867.5698.6.camel@ite-desktop>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Aug 19, 2014 at 03:37:47PM +0800, Bimow Chen wrote:
> Add two firmware files for ITEtech IT9135 Ax and Bx chip versions.

> >From c05fac0989dff376729609cd6baac2367929d990 Mon Sep 17 00:00:00 2001
> From: Bimow Chen <Bimow.Chen@ite.com.tw>
> Date: Tue, 19 Aug 2014 15:19:56 +0800
> Subject: [PATCH] Add firmware v3.25.0.0 for ITEtech IT9135 DVB-T USB driver
> 
> Signed-off-by: Bimow Chen <Bimow.Chen@ite.com.tw>
> ---
>  LICENCE.it913x       |   17 +++++++++++++++++
>  WHENCE               |    9 +++++++++
>  dvb-usb-it9135-01.fw |  Bin 0 -> 8128 bytes
>  dvb-usb-it9135-02.fw |  Bin 0 -> 5834 bytes
>  4 files changed, 26 insertions(+), 0 deletions(-)
>  create mode 100644 LICENCE.it913x
>  create mode 100644 dvb-usb-it9135-01.fw
>  create mode 100644 dvb-usb-it9135-02.fw
> 

Looks better, thanks, I've applied this.

regards, Kyle

> diff --git a/LICENCE.it913x b/LICENCE.it913x
> new file mode 100644
> index 0000000..3706c18
> --- /dev/null
> +++ b/LICENCE.it913x
> @@ -0,0 +1,17 @@
> +Copyright (c) 2014, ITE Tech. Inc.
> +
> +The firmware files "dvb-usb-it9135-01.fw" and "dvb-usb-it9135-02.fw" 
> +are for ITEtech it9135 Ax and Bx chip versions.
> +
> +Permission to use, copy, modify, and/or distribute this software for
> +any purpose with or without fee is hereby granted, provided that the 
> +above copyright notice and this permission notice appear in all copies.
> +
> +THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES 
> +WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF 
> +MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE 
> +FOR ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY 
> +DAMAGES WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, 
> +WHETHER IN AN ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, 
> +ARISING OUT OF OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS 
> +SOFTWARE.
> diff --git a/WHENCE b/WHENCE
> index bd65d8c..3d46b76 100644
> --- a/WHENCE
> +++ b/WHENCE
> @@ -2503,3 +2503,12 @@ File: intel/fw_sst_0f28.bin-48kHz_i2s_master
>  License: Redistributable. See LICENCE.fw_sst_0f28 for details
>  
>  --------------------------------------------------------------------------
> +
> +Driver: it9135 -- ITEtech IT913x DVB-T USB driver
> +
> +File: dvb-usb-it9135-01.fw
> +File: dvb-usb-it9135-02.fw
> +
> +Licence: Redistributable. See LICENCE.it913x for details
> +
> +--------------------------------------------------------------------------
