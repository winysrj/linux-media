Return-path: <linux-media-owner@vger.kernel.org>
Received: from r0.smtpout1.alwaysdata.com ([176.31.58.0]:33222 "EHLO
        r0.smtpout1.alwaysdata.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752099AbdFNSUR (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 14 Jun 2017 14:20:17 -0400
Subject: Re: [PATCH] uvcvideo: Hardcoded CTRL_QUERY GET_LEN for a lying device
To: linux-media@vger.kernel.org
References: <20170604134119.16936-1-web+oss@zopieux.com>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>
From: Alexandre Macabies <web+oss@zopieux.com>
Message-ID: <3f058773-37f6-dd63-78a5-b6e9005313ab@zopieux.com>
Date: Wed, 14 Jun 2017 20:19:53 +0200
MIME-Version: 1.0
In-Reply-To: <20170604134119.16936-1-web+oss@zopieux.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 06/04/2017 03:41 PM, Alexandre Macabies wrote:
> Hello,

I forgot to Cc: the full list of maintainers for this patch. This follow-up
includes them. Sorry for the noise! My original email & patch is quoted below.

Best,
Alexandre

> This thread comes after two others[1][2] about a similar issue.
> 
> I own a USB video microscope[3] from Dino-Lite. Even if the constructor does
> not advertise it as being supported on Linux, it is mostly a "good citizen"
> camera: it registers as a standard USB video device and as such, it is properly
> recognized by uvcvideo.
> 
> This device is equipped with an integrated illuminator/lamp -- a set of LEDs.
> After some research (using a USB sniffer) I managed to identify the
> non-standard XU control used to switch this lamp on and off: one shall send
> either 80 01 f0 (off) or 80 01 f1 (on) to XU control unit 4 selector 3.
> 
> So at first I tried to send a raw ctrl_set using:
> 
>     $ uvcdynctrl -S 4:3 8001f0
>     [...]
>     query control size of : 1
>     [...]
>     ERROR: Unable to set the control value: Invalid argument. (Code: 3)
> 
> Indeed, the device reports this XU as being only 1 in length, but the payload
> has to be 3 bytes. So I assume there is a bug (or deliberate inaccuracy) in the
> GET_LEN reply from the device firmware. To overcome this issue, I compiled
> a patched version of uvcvideo in which uvc_query_ctrl[4] returns an hardcoded
> size of 3 for this specific device & UX control. I was finally able to switch
> the lamp on and off:
> 
>     $ uvcdynctrl -S 4:3 8001f0
>     [39252.854261] uvcvideo: Fixing USB a168:0870 UX control 4/3 len: 1 -> 3
>     [...]
>     query control size of : 3
>     [...]
>     set value of          : (LE)0x8001f0  (BE)0xf00180
>     [lamp goes off]
> 
> You can find the patch below. I abstracted it in the spirit of
> uvc_ctrl_fixup_xu_info[5] so we can add more entries to the table in the
> future. What do you think, would it be relevant to merge? AFAICT there is no
> API in uvcvideo or v4l for controlling this kind of illuminator/lamp features,
> so giving userland the ability to control the devices via XU by lying seems to
> be the only solution.
> 
> Best,
> 
> Alexandre
> 
> [1] "Dino-Lite uvc support", 2008, https://sourceforge.net/p/linux-uvc/mailman/message/29831153/
> [2] "switching light on device Dino-Lite Premier", 2013, https://sourceforge.net/p/linux-uvc/mailman/message/31219122/
> [3] https://www.dinolite.us/products/digital-microscopes/usb/basic/am4111t
> [4] http://elixir.free-electrons.com/linux/v4.11/source/drivers/media/usb/uvc/uvc_video.c#L72
> [5] http://elixir.free-electrons.com/linux/v4.11/source/drivers/media/usb/uvc/uvc_ctrl.c#L1593
> 
> Signed-off-by: Alexandre Macabies <web+oss@zopieux.com>
> 
> ---
>  drivers/media/usb/uvc/uvc_video.c | 37 +++++++++++++++++++++++++++++++++++++
>  1 file changed, 37 insertions(+)
> 
> diff --git a/drivers/media/usb/uvc/uvc_video.c b/drivers/media/usb/uvc/uvc_video.c
> index 07a6c833ef7b..839dc02b4f33 100644
> --- a/drivers/media/usb/uvc/uvc_video.c
> +++ b/drivers/media/usb/uvc/uvc_video.c
> @@ -69,6 +69,40 @@ static const char *uvc_query_name(__u8 query)
>  	}
>  }
>  
> +static void uvc_fixup_query_ctrl_len(const struct uvc_device *dev, __u8 unit,
> +	__u8 cs, void *data)
> +{
> +	struct uvc_ctrl_fixup {
> +		struct usb_device_id id;
> +		u8 unit;
> +		u8 selector;
> +		u16 len;
> +	};
> +
> +	static const struct uvc_ctrl_fixup fixups[] = {
> +		// Dino-Lite Premier (AM4111T)
> +		{ { USB_DEVICE(0xa168, 0x0870) }, 4, 3, 3 },
> +	};
> +
> +	unsigned int i;
> +
> +	for (i = 0; i < ARRAY_SIZE(fixups); ++i) {
> +		if (!usb_match_one_id(dev->intf, &fixups[i].id))
> +			continue;
> +
> +		if (!(fixups[i].unit == unit && fixups[i].selector == cs))
> +			continue;
> +
> +		uvc_trace(UVC_TRACE_CONTROL,
> +			  "Fixing USB %04x:%04x %u/%u GET_LEN: %u -> %u",
> +			  fixups[i].id.idVendor, fixups[i].id.idProduct,
> +			  unit, cs,
> +			  le16_to_cpup((__le16 *)data), fixups[i].len);
> +		*((__le16 *)data) = cpu_to_le16(fixups[i].len);
> +		break;
> +	}
> +}
> +
>  int uvc_query_ctrl(struct uvc_device *dev, __u8 query, __u8 unit,
>  			__u8 intfnum, __u8 cs, void *data, __u16 size)
>  {
> @@ -83,6 +117,9 @@ int uvc_query_ctrl(struct uvc_device *dev, __u8 query, __u8 unit,
>  		return -EIO;
>  	}
>  
> +	if (query == UVC_GET_LEN && size == 2)
> +		uvc_fixup_query_ctrl_len(dev, unit, cs, data);
> +
>  	return 0;
>  }
>  
> 
> -- 
> 2.13.0
> 
