Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:39562 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752935AbbDGPvO (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 7 Apr 2015 11:51:14 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: Chris Whittenburg <whittenburg@gmail.com>,
	linux-media@vger.kernel.org
Subject: Re: OMAP3 ISP previewer Y10 to UYVY conversion
Date: Tue, 07 Apr 2015 18:51:39 +0300
Message-ID: <1885047.DP4uMGgtdr@avalon>
In-Reply-To: <20150325235820.GP18321@valkosipuli.retiisi.org.uk>
References: <CABcw_Okm1ZVob1s_JxZaRk_oFP2efh38qEyDeok4K2066dcMvQ@mail.gmail.com> <CABcw_O=Gv3xvnRU9LvVUaCKEEkLFFrhpqLZ9FZ89XRAp0_RR5Q@mail.gmail.com> <20150325235820.GP18321@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Chris,

On Thursday 26 March 2015 01:58:20 Sakari Ailus wrote:
> On Wed, Mar 25, 2015 at 09:12:56AM -0500, Chris Whittenburg wrote:
> > Hi Sakari,
> > 
> > Thanks for the reply.
> > 
> > On Tue, Mar 24, 2015 at 6:51 PM, Sakari Ailus <sakari.ailus@iki.fi> wrote:
> > > Do you know if the sensor has black level correction enabled? It appears
> > > to have one, but I'm not completely sure what it does there. I'd check
> > > that it is indeed enabled.
> > 
> > The ar0130cs does have black level correction enabled by default.
> > 
> > My thought is that since the 12-bit data from the CCDC looked ok, that
> > it was something outside the sensor itself.
> 
> I think I might have misunderstood your original mail. I thought the images
> from CCDC were bad.
> 
> > >> I've captured the 12-bit data from the CCDC, downconverted it to Y8,
> > >> and verified it looks ok, and is not washed out, so I'm suspecting the
> > >> isp previewer is doing something wrong in the simple Y10 to UYVY
> > >> conversion.
> > > 
> > > Not necessarily wrong, the black level correction might be enabled by
> > > default, with the default configuration which works for most sensors (64
> > > for 10-bit data, 16 for 8-bit etc.).
> > 
> > Ok, I will check this.  You are referring to the "Camera ISP VPBE
> > Preview Black Adjustment" which is controlled by PRV_BLKADJOFF
> > register?
> 
> I guess it wasn't. The value appears to be zero by default, which makes
> sense.
> 
> > I also found that there are contrast and brightness settings in the
> > previewer which can be adjusted.  I'm not changing them from defaults,
> > so I thought the "Y" values would just get truncated to 8 bits and
> > mapped into the UYVY without being significantly altered.
> > 
> > Would your thought be the black level is more likely the issue rather
> > than brightness/contrast?
> 
> I haven't used this part of the ISP, perhaps Laurent has.

Black level compensation is applied by the CCDC before writing raw frames to 
memory. If your raw frames are correct BLC is probably not to blame.

The default contrast is x1.0 and the default brightness is +0.0, so I don't 
think those should be blame either.

I suspect the RGB2RGB conversion matrix to be wrong. The default setting is 
supposed to handle fluorescent lighting. You could try setting the RGB2RGB 
matrix to the identity matrix and see if this helps. See 
http://git.ideasonboard.org/omap3-isp-live.git/blob/HEAD:/isp/controls.c#l184 
for sample code.

Another matrix that could be worth being reprogrammed is the RGB2YUV matrix, 
which also defaults to fluorescent lighting. Sample code to reprogram it is 
available in the same location.

-- 
Regards,

Laurent Pinchart

