Return-path: <linux-media-owner@vger.kernel.org>
Received: from nm15.bullet.mail.ne1.yahoo.com ([98.138.90.78]:44543 "HELO
	nm15.bullet.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751495Ab1GUKnP convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 21 Jul 2011 06:43:15 -0400
Message-ID: <1311244993.60601.YahooMailClassic@web121810.mail.ne1.yahoo.com>
Date: Thu, 21 Jul 2011 03:43:13 -0700 (PDT)
From: Luiz Ramos <lramos.prof@yahoo.com.br>
Subject: Re: [PATCH] Fix wrong register mask in gspca/sonixj.c
To: Jean-Francois Moine <moinejf@free.fr>
Cc: linux-media@vger.kernel.org
In-Reply-To: <20110720131212.13a9f8d2@tele>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

The package version 2.13.3 was compiled, and there are some results:

  - at 640x480: it works as before (10 fps, good image)
  - at 320x240 and 160x120: it does not work (no frames when using qv4l2)

Now my doubts. Unless I misunderstood something, it seems these are the our assumptions regarding reg01 and reg17:

  - reg01 bit 6 is set when bridge runs at 48 MHz; if reset, 24 MHz
  - reg17 bits 0..4 is a mask for dividing a sensor clock of 48 MHz, so
    - if reg17 = x | 01 then clock = 48 MHz
    - if reg17 = x | 02 then clock = 24 MHz
    - if reg17 = x | 04 then clock = 12 MHz

Putting some printk at the code version 2.13.3, the values of these registers at the last command are:

  - at 640x480 ........... reg01 = 0x66  reg17 = 0x64
  - at 320x240/160x120 ... reg01 = 0x26  reg17 = 0x61

So, at 640x480 the bridge would be running at 48 MHz and the sensor at 12 MHz. At lower resolutions the bridge would be running at 24 MHz and the sensor at 48 MHz. It seems that this is not what we'd like to do.

I made some experiences, and noticed that:

  - making reg17 = 0x62 (sensor clock at 24 MHz) and reg01 = 0x26
    (bridge clock at 24 MHz) at 320x240 and lower makes it work again.
    I think this reaches the goal of having both clocks at 24 MHz, but
    at 10 fps

  - making reg17 = 0x61 (sensor at 48 MHz) and reg01 = 0x66 (bridge
    at 48 MHz) at 640x480 gives me back a "No frame". A side question:
    would it be associated to the speed limit of USB 1.1 or whatever?

There are more experiences to be done, and as there are more conclusions, I'll post them here. But again, to make the code work it's sufficient to change the reg17 or'ing at line 2537 from 0x01 to 0x02, making the sensor run at 24 MHz for resolutions 320x240 and 160x120.

For now, it seems to exist a trade-off between sensor clock and exposure, meaning that if you'd like to run at 20 fps, you'd have to use higher clock rates and the images require higher levels of light. Or running at 10 fps gives the ability to capture images in darker places. Does this makes sense? If so, one nice feature for such cameras would be controlling the exposure level by the user interface (ioctl), which in effect puts that decision in the user's hands.

Thanks,

Luiz Ramos



--- Em qua, 20/7/11, Jean-Francois Moine <moinejf@free.fr> escreveu:

> De: Jean-Francois Moine <moinejf@free.fr>
> Assunto: Re: [PATCH] Fix wrong register mask in gspca/sonixj.c
> Para: "Luiz Ramos" <lramos.prof@yahoo.com.br>
> Cc: linux-media@vger.kernel.org
> Data: Quarta-feira, 20 de Julho de 2011, 8:12
> On Mon, 18 Jul 2011 18:39:14 -0700
> (PDT)
> Luiz Ramos <lramos.prof@yahoo.com.br>
> wrote:
>     [snip]
> > I noticed that in 640x480 the device worked fine, but
> in 320x240 and
> > 160x120 it didn't (I mean: the image is dark). Or'ing
> reg17 with 0x04
> > in line 2535 (as it's currently done for VGA) is
> sufficient to make
> > the webcam work again. The change could be like that:
>     [snip]
> > However, the frame rates get limited to 10 fps.
> Without that change,
> > and in 320x240 and 160x120, they reach 20 fps (of
> darkness).
> > 
> > I can't see what or'ing that register means, and
> what's the
> > relationship between this and the webcam darkness. It
> seems that
> > these bits control some kind of clock; this can be
> read in the
> > program comments. One other argument in favour of this
> assumption is
> > the fact that the frame rate changes accordingly to
> the value of
> > these bits. But I can't see how this relates to
> exposure.
> > 
> > For my purposes, I'll stay with that change; it's
> sufficient for my
> > purposes. If you know what I did, please advise me.
> :-)
> 
> Hi Luiz,
> 
> You changed the sensor clock from 24MHz to 12MHz.
> 
> The clocks of the sensor and the bridge may have different
> values.
> In 640x480, the bridge clock is 48MHz (reg01) and the
> sensor clock is
> 12MHz (reg17: clock / 4). Previously, in 320x240, the
> bridge clock was
> 48MHz and the sensor clock 24 MHz (reg17: clock / 2).
> 
> I think that the sensor clock must stay the same for a same
> frame rate.
> So, what about changing the bridge clock only, i.e. bridge
> clock 24MHZ
> (reg01) and sensor clock 24MHz (reg17: clock / 1)?
> 
> That's what I coded in the last gspca test version (2.13.3)
> which is
> available in my web site (see below). May you try it?
> 
> Best regards.
> 
> -- 
> Ken ar c'hentañ    |   
>       ** Breizh ha Linux atav! **
> Jef       
> |        http://moinejf.free.fr/
> --
> To unsubscribe from this list: send the line "unsubscribe
> linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
