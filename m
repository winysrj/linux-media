Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud9.xs4all.net ([194.109.24.30]:56506 "EHLO
        lb3-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753269AbeBZOM5 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 26 Feb 2018 09:12:57 -0500
Subject: Re: [PATCH 1/2] usbtv: Use same decoder sequence as Windows driver
To: Hugo Grostabussiat <bonstra@bonstra.fr.eu.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org
References: <20180224182419.15670-1-bonstra@bonstra.fr.eu.org>
 <20180224182419.15670-2-bonstra@bonstra.fr.eu.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <de1f0031-be47-1c7b-265e-da32825f66b9@xs4all.nl>
Date: Mon, 26 Feb 2018 15:12:52 +0100
MIME-Version: 1.0
In-Reply-To: <20180224182419.15670-2-bonstra@bonstra.fr.eu.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hugo,

Thanks for this patch, but I am a bit hesitant to apply it. Did you test
that PAL and NTSC still work after this change?

Unless you've tested it then I'm inclined to just apply the second patch that
adds the SECAM sequence.

Regards,

	Hans

On 02/24/2018 07:24 PM, Hugo Grostabussiat wrote:
> Re-format the register {address, value} pairs so they follow the same
> order as the decoder configuration sequences in the Windows driver's .INF
> file.
> 
> For instance, for PAL, the "AVPAL" sequence in the .INF file is:
> 0x04,0x68,0xD3,0x72,0xA2,0xB0,0x15,0x01,0x2C,0x10,0x20,0x2e,0x08,0x02,
> 0x02,0x59,0x16,0x35,0x17,0x16,0x36
> 
> Signed-off-by: Hugo Grostabussiat <bonstra@bonstra.fr.eu.org>
> ---
>  drivers/media/usb/usbtv/usbtv-video.c | 26 +++++++++++++++++---------
>  1 file changed, 17 insertions(+), 9 deletions(-)
> 
> diff --git a/drivers/media/usb/usbtv/usbtv-video.c b/drivers/media/usb/usbtv/usbtv-video.c
> index 3668a04359e8..52d06b30fabb 100644
> --- a/drivers/media/usb/usbtv/usbtv-video.c
> +++ b/drivers/media/usb/usbtv/usbtv-video.c
> @@ -124,15 +124,26 @@ static int usbtv_select_input(struct usbtv *usbtv, int input)
>  static int usbtv_select_norm(struct usbtv *usbtv, v4l2_std_id norm)
>  {
>  	int ret;
> +	/* These are the series of register values used to configure the
> +	 * decoder for a specific standard.
> +	 * They are copied from the Settings\DecoderDefaults registry keys
> +	 * present in the Windows driver .INF file for each norm.
> +	 */
>  	static const u16 pal[][2] = {
> +		{ USBTV_BASE + 0x0003, 0x0004 },
>  		{ USBTV_BASE + 0x001a, 0x0068 },
> +		{ USBTV_BASE + 0x0100, 0x00d3 },
>  		{ USBTV_BASE + 0x010e, 0x0072 },
>  		{ USBTV_BASE + 0x010f, 0x00a2 },
>  		{ USBTV_BASE + 0x0112, 0x00b0 },
> +		{ USBTV_BASE + 0x0115, 0x0015 },
>  		{ USBTV_BASE + 0x0117, 0x0001 },
>  		{ USBTV_BASE + 0x0118, 0x002c },
>  		{ USBTV_BASE + 0x012d, 0x0010 },
>  		{ USBTV_BASE + 0x012f, 0x0020 },
> +		{ USBTV_BASE + 0x0220, 0x002e },
> +		{ USBTV_BASE + 0x0225, 0x0008 },
> +		{ USBTV_BASE + 0x024e, 0x0002 },
>  		{ USBTV_BASE + 0x024f, 0x0002 },
>  		{ USBTV_BASE + 0x0254, 0x0059 },
>  		{ USBTV_BASE + 0x025a, 0x0016 },
> @@ -143,14 +154,20 @@ static int usbtv_select_norm(struct usbtv *usbtv, v4l2_std_id norm)
>  	};
>  
>  	static const u16 ntsc[][2] = {
> +		{ USBTV_BASE + 0x0003, 0x0004 },
>  		{ USBTV_BASE + 0x001a, 0x0079 },
> +		{ USBTV_BASE + 0x0100, 0x00d3 },
>  		{ USBTV_BASE + 0x010e, 0x0068 },
>  		{ USBTV_BASE + 0x010f, 0x009c },
>  		{ USBTV_BASE + 0x0112, 0x00f0 },
> +		{ USBTV_BASE + 0x0115, 0x0015 },
>  		{ USBTV_BASE + 0x0117, 0x0000 },
>  		{ USBTV_BASE + 0x0118, 0x00fc },
>  		{ USBTV_BASE + 0x012d, 0x0004 },
>  		{ USBTV_BASE + 0x012f, 0x0008 },
> +		{ USBTV_BASE + 0x0220, 0x002e },
> +		{ USBTV_BASE + 0x0225, 0x0008 },
> +		{ USBTV_BASE + 0x024e, 0x0002 },
>  		{ USBTV_BASE + 0x024f, 0x0001 },
>  		{ USBTV_BASE + 0x0254, 0x005f },
>  		{ USBTV_BASE + 0x025a, 0x0012 },
> @@ -236,15 +253,6 @@ static int usbtv_setup_capture(struct usbtv *usbtv)
>  		{ USBTV_BASE + 0x0158, 0x001f },
>  		{ USBTV_BASE + 0x0159, 0x0006 },
>  		{ USBTV_BASE + 0x015d, 0x0000 },
> -
> -		{ USBTV_BASE + 0x0003, 0x0004 },
> -		{ USBTV_BASE + 0x0100, 0x00d3 },
> -		{ USBTV_BASE + 0x0115, 0x0015 },
> -		{ USBTV_BASE + 0x0220, 0x002e },
> -		{ USBTV_BASE + 0x0225, 0x0008 },
> -		{ USBTV_BASE + 0x024e, 0x0002 },
> -		{ USBTV_BASE + 0x024e, 0x0002 },
> -		{ USBTV_BASE + 0x024f, 0x0002 },
>  	};
>  
>  	ret = usbtv_set_regs(usbtv, setup, ARRAY_SIZE(setup));
> 
