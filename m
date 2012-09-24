Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:44270 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755454Ab2IXOPl (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 24 Sep 2012 10:15:41 -0400
Message-ID: <50606B5E.8030002@redhat.com>
Date: Mon, 24 Sep 2012 16:17:02 +0200
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: =?UTF-8?B?RnJhbmsgU2Now6RmZXI=?= <fschaefer.oss@googlemail.com>
CC: linux-media@vger.kernel.org
Subject: Re: [PATCH 1/4] gspca_pac7302: correct register documentation
References: <1348406983-3451-1-git-send-email-fschaefer.oss@googlemail.com>
In-Reply-To: <1348406983-3451-1-git-send-email-fschaefer.oss@googlemail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On 09/23/2012 03:29 PM, Frank Schäfer wrote:
> R,G,B balance registers are 0x01-0x03 instead of 0x02-0x04,
> which lead to the wrong conclusion that values are inverted.
> Exposure is controlled via page 3 registers and this is already documented.
> Also fix a whitespace issue.
>
> Signed-off-by: Frank Schäfer <fschaefer.oss@googlemail.com>

Thanks, as discussed I've added the first 2 patches to my media tree and
they will be included in my next pull-req to Mauro.

Regards,

Hans



> ---
>   drivers/media/usb/gspca/pac7302.c |   11 +++++------
>   1 files changed, 5 insertions(+), 6 deletions(-)
>
> diff --git a/drivers/media/usb/gspca/pac7302.c b/drivers/media/usb/gspca/pac7302.c
> index 2d5c6d83..4894ac1 100644
> --- a/drivers/media/usb/gspca/pac7302.c
> +++ b/drivers/media/usb/gspca/pac7302.c
> @@ -29,14 +29,13 @@
>    * Register page 0:
>    *
>    * Address	Description
> - * 0x02		Red balance control
> - * 0x03		Green balance control
> - * 0x04 	Blue balance control
> - *		     Valus are inverted (0=max, 255=min).
> + * 0x01		Red balance control
> + * 0x02		Green balance control
> + * 0x03		Blue balance control
>    *		     The Windows driver uses a quadratic approach to map
>    *		     the settable values (0-200) on register values:
> - *		     min=0x80, default=0x40, max=0x20
> - * 0x0f-0x20	Colors, saturation and exposure control
> + *		     min=0x20, default=0x40, max=0x80
> + * 0x0f-0x20	Color and saturation control
>    * 0xa2-0xab	Brightness, contrast and gamma control
>    * 0xb6		Sharpness control (bits 0-4)
>    *
>
