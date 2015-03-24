Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:46343 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751842AbbCXXwW (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 24 Mar 2015 19:52:22 -0400
Date: Wed, 25 Mar 2015 01:51:48 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Chris Whittenburg <whittenburg@gmail.com>
Cc: linux-media@vger.kernel.org
Subject: Re: OMAP3 ISP previewer Y10 to UYVY conversion
Message-ID: <20150324235148.GC18321@valkosipuli.retiisi.org.uk>
References: <CABcw_Okm1ZVob1s_JxZaRk_oFP2efh38qEyDeok4K2066dcMvQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABcw_Okm1ZVob1s_JxZaRk_oFP2efh38qEyDeok4K2066dcMvQ@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Chris,

On Wed, Mar 18, 2015 at 02:56:36PM -0500, Chris Whittenburg wrote:
> We're working on a DM3730 platform running a 3.5.7 kernel, using the
> pipeline below to take a 12-bit monochrome sensor (Aptina AR0130) and
> convert it to UYVY format for use with the TI codecs.
> 
> In general, this works, but the images end up looking washed out.
> Running them thru a "normalize" function makes them look good again.
> Looking at the levels histogram in gimp, I seem to be missing the high
> end and low end values.

Do you know if the sensor has black level correction enabled? It appears to
have one, but I'm not completely sure what it does there. I'd check that it
is indeed enabled.

> I've captured the 12-bit data from the CCDC, downconverted it to Y8,
> and verified it looks ok, and is not washed out, so I'm suspecting the
> isp previewer is doing something wrong in the simple Y10 to UYVY
> conversion.

Not necessarily wrong, the black level correction might be enabled by
default, with the default configuration which works for most sensors (64 for
10-bit data, 16 for 8-bit etc.).

-- 
Regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
