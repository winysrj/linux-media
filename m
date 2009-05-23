Return-path: <linux-media-owner@vger.kernel.org>
Received: from dd17600.kasserver.com ([85.13.138.69]:37637 "EHLO
	dd17600.kasserver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751109AbZEWMyr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 23 May 2009 08:54:47 -0400
From: Gernot Pansy <gernot@pansy.at>
To: linux-media@vger.kernel.org
Subject: Re: Question about driver for Mantis
Date: Sat, 23 May 2009 14:36:57 +0200
References: <200905230810.39344.jarhuba2@poczta.onet.pl> <1a297b360905222341t4e66e2c6x95d339838db43139@mail.gmail.com>
In-Reply-To: <1a297b360905222341t4e66e2c6x95d339838db43139@mail.gmail.com>
Cc: Manu Abraham <abraham.manu@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200905231436.58072.gernot@pansy.at>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

hy,

On Saturday 23 May 2009 08:41:48 Manu Abraham wrote:
> On Sat, May 23, 2009 at 10:10 AM, Jaros³aw Huba <jarhuba2@poczta.onet.pl> 
wrote:
> > Hi.
> > Is driver for Mantis chipset are currently developed somewhere?
> > I'm owner of Azurewave AD SP400 CI (VP-1041) and I'm waiting for support
> > for this card for quite long time. Even partly working driver in mainline
> > kernel would be great (without remote, CI, S2 support, with some tuning
> > bugs). This question is mainly for Manu Abraham who developed this driver
> > some time ago.
>
> The latest development snapshot for the mantis based devices can be found
> here: http://jusst.de/hg/mantis-v4l
>
> Currently CI is unsupported, though very preliminary code support for
> it exists in it.
> S2 works, pretty much. Or do you have other results ?

will CI be supported and are you willing to finish development and merge it to 
mainline anytime?

i think i was one of the first SP400 owner but i had to sold my card for a Nova 
HD2 because the driver was not reliable (some i2c errors, slow tunning, 
sometimes tunning failed). And now i need a dvb-s2 card with ci working. so 
i'm searching again for a new card. their seems to be only the tt-3200 out, 
which seems to work - no newer card. 

regards,
gernot

>
> Regards,
> Manu
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

