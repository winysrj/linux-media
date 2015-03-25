Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:56925 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751185AbbCYX6y (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 25 Mar 2015 19:58:54 -0400
Date: Thu, 26 Mar 2015 01:58:20 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Chris Whittenburg <whittenburg@gmail.com>
Cc: linux-media@vger.kernel.org, laurent.pinchart@ideasonboard.com
Subject: Re: OMAP3 ISP previewer Y10 to UYVY conversion
Message-ID: <20150325235820.GP18321@valkosipuli.retiisi.org.uk>
References: <CABcw_Okm1ZVob1s_JxZaRk_oFP2efh38qEyDeok4K2066dcMvQ@mail.gmail.com>
 <20150324235148.GC18321@valkosipuli.retiisi.org.uk>
 <CABcw_O=Gv3xvnRU9LvVUaCKEEkLFFrhpqLZ9FZ89XRAp0_RR5Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABcw_O=Gv3xvnRU9LvVUaCKEEkLFFrhpqLZ9FZ89XRAp0_RR5Q@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Chris,

On Wed, Mar 25, 2015 at 09:12:56AM -0500, Chris Whittenburg wrote:
> Hi Sakari,
> 
> Thanks for the reply.
> 
> On Tue, Mar 24, 2015 at 6:51 PM, Sakari Ailus <sakari.ailus@iki.fi> wrote:
> > Do you know if the sensor has black level correction enabled? It appears to
> > have one, but I'm not completely sure what it does there. I'd check that it
> > is indeed enabled.
> 
> The ar0130cs does have black level correction enabled by default.
> 
> My thought is that since the 12-bit data from the CCDC looked ok, that
> it was something outside the sensor itself.

I think I might have misunderstood your original mail. I thought the images
from CCDC were bad.

> >> I've captured the 12-bit data from the CCDC, downconverted it to Y8,
> >> and verified it looks ok, and is not washed out, so I'm suspecting the
> >> isp previewer is doing something wrong in the simple Y10 to UYVY
> >> conversion.
> >
> > Not necessarily wrong, the black level correction might be enabled by
> > default, with the default configuration which works for most sensors (64 for
> > 10-bit data, 16 for 8-bit etc.).
> 
> Ok, I will check this.  You are referring to the "Camera ISP VPBE
> Preview Black Adjustment" which is controlled by PRV_BLKADJOFF
> register?

I guess it wasn't. The value appears to be zero by default, which makes
sense.

> I also found that there are contrast and brightness settings in the
> previewer which can be adjusted.  I'm not changing them from defaults,
> so I thought the "Y" values would just get truncated to 8 bits and
> mapped into the UYVY without being significantly altered.
> 
> Would your thought be the black level is more likely the issue rather
> than brightness/contrast?

I haven't used this part of the ISP, perhaps Laurent has.

-- 
Regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
