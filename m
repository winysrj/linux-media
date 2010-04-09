Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:1026 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751127Ab0DIEdS (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 9 Apr 2010 00:33:18 -0400
Message-ID: <4BBEAE08.5010908@redhat.com>
Date: Fri, 09 Apr 2010 01:33:12 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: "istvan_v@mailbox.hu" <istvan_v@mailbox.hu>
CC: linux-media@vger.kernel.org
Subject: Re: [PATCH] cx88: implement sharpness control
References: <4BADFC12.4030707@mailbox.hu>
In-Reply-To: <4BADFC12.4030707@mailbox.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

istvan_v@mailbox.hu wrote:
> This patch adds support for V4L2_CID_SHARPNESS by changing the luma peak
> filter and notch filter. It can be set in the range 0 to 9, with 0 being
> the original and default mode.
> One minor problem is that other code that sets the registers being used
> (for example when switching TV channels) could reset the control to the
> default. This could be avoided by making changes so that the bits used
> to implement this control are not overwritten.
> 
> Signed-off-by: Istvan Varga <istvanv@users.sourceforge.net>
> 
> +	case V4L2_CID_SHARPNESS:
> +		/* use 4xFsc or square pixel notch filter */
> +		cx_andor(MO_HTOTAL, 0x1800, (ctl->value & 1) << 11);
> +		/* 0b000, 0b100, 0b101, 0b110, or 0b111 */
> +		value = (ctl->value < 2 ? 0 : (((ctl->value + 6) & 0x0E) << 6));
> +		/* needs to be set for both fields */
> +		cx_andor(MO_FILTER_EVEN, mask, value);
> +		break;

You're not adjusting the sharpness. Instead, you're changing the vertical tap filter,
and just for the even frames, plus the notch filter.
Tricky, and you're probably affecting the sharpness, but on an indirect and non-linear
way, as you're adjusting different measures.

This doesn't seem right, at least on my eyes. If this is really needed, it would
be better to break it into two controls (one for the notch filter and another for the
vertical tap filter).

Also, the "side effect" is not good: if you're using those bits, your code should assure
that no other part of the driver will touch on the used bits, and that the device will
be initialized with the default standard.

-- 

Cheers,
Mauro
