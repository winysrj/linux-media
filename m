Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp206.alice.it ([82.57.200.102]:50228 "EHLO smtp206.alice.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933761Ab2KZRMp (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 26 Nov 2012 12:12:45 -0500
Date: Mon, 26 Nov 2012 18:12:41 +0100
From: Antonio Ospite <ospite@studenti.unina.it>
To: Jean-Francois Moine <moinejf@free.fr>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Hans de Goede <hdegoede@redhat.com>
Subject: Re: [PATCH] gspca - ov534: Fix the light frequency filter
Message-Id: <20121126181241.d13631659092083fb9021aac@studenti.unina.it>
In-Reply-To: <20121126162318.228c249f@armhf>
References: <20121122124652.3a832e33@armhf>
	<20121123180909.021c55a8c3795329836c42b7@studenti.unina.it>
	<20121123191232.7ed9c546@armhf>
	<20121126140806.65a6aa2b310c774e4edd62c3@studenti.unina.it>
	<20121126162318.228c249f@armhf>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 26 Nov 2012 16:23:18 +0100
Jean-Francois Moine <moinejf@free.fr> wrote:

> On Mon, 26 Nov 2012 14:08:06 +0100
> Antonio Ospite <ospite@studenti.unina.it> wrote:
> 
> > For now I'd NAK the patch since it is a regression for users
> > with 50Hz power sources and it looks like it does not _always_ work for
> > 60Hz either.
> > 
> > Should I remove it from patchwork as well?
> > 
> > As I have the webcam and can perform actual tests I'll coordinate with
> > Fabian to have more details about why light frequency filter is not
> > working for him with the current code, it works fine for me at 640x480,
> > even if I can see that its effect is weaker at 320x240.
> 
> I wonder how it could work. Look at the actual code:
> 
> 	val = val ? 0x9e : 0x00;
> 	if (sd->sensor == SENSOR_OV767x) {
> 		sccb_reg_write(gspca_dev, 0x2a, 0x00);
> 		if (val)
> 			val = 0x9d;	/* insert dummy to 25fps for 50Hz */
> 	}
> 	sccb_reg_write(gspca_dev, 0x2b, val);
> 
> According to the ov7720/ov7221 documentation, the register 2b is:
> 
> 	2B EXHCL 00 RW Dummy Pixel Insert LSB
> 	               8 LSB for dummy pixel insert in horizontal direction
> 
> How could it act on the light frequency filter?

Warning: guess-work follows.

When the light filter (i.e. from the v4l2 POV) is ON, the frame rate is
actually lower than the one expected; that could be the effect of the
insertion of dummy pixels in the data processed by the sensor (the
streamed data keeps always the same size tho), maybe it is just a trick
but the fact is that the flickering goes away.

The weaker result at 320x240 could be due to the amount of dummy pixels
tailored for the higher resolution, IIRC the PS3 dumps were performed
only at 640x480.

BTW the documentation might also be wrong or inaccurate.

Regards,
   Antonio

-- 
Antonio Ospite
http://ao2.it

A: Because it messes up the order in which people normally read text.
   See http://en.wikipedia.org/wiki/Posting_style
Q: Why is top-posting such a bad thing?
