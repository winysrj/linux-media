Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.187]:52436 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752539AbZHEUjK (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 5 Aug 2009 16:39:10 -0400
From: Pete Hildebrandt <send2ph@googlemail.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [patch] Added Support for STK7700D (DVB)
Date: Wed, 5 Aug 2009 22:39:07 +0200
Cc: Patrick Boettcher <pboettcher@kernellabs.com>
References: <200908042138.11938.send2ph@googlemail.com> <alpine.LRH.1.10.0908051650360.6890@pub1.ifh.de>
In-Reply-To: <alpine.LRH.1.10.0908051650360.6890@pub1.ifh.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200908052239.07581.send2ph@googlemail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Patrick,

Am Mittwoch 05 August 2009 schrieb Patrick Boettcher:
> Hi Pete,
>
> On Tue, 4 Aug 2009, Pete Hildebrandt wrote:
> > Hello,
> >
> > To this mail I attached two patch-files to add support for the STK7700D
> > USB-DVB-Device.
> >
> > lsusb identifies it as:
> > idVendor           0x1164 YUAN High-Tech Development Co., Ltd
> > idProduct          0x1efc
> > iProduct                2 STK7700D
> >
> > My two patches mainly just add the new product-ID.
> >
> > I have tested the modification with the 2.6.28 and the 2.6.30 kernel. The
> > patches are for the 2.6.30 kernel.
> >
> > The device is build into my laptop (Samsung R55-T5500) and works great
> > after applying the patches.
>
> OK, I applied the patch and send the pull request to Mauro.
>
> Can you please check whether everything went well (I needed to merge
> manually)?

I checked and everything went well.

> In the future please use the v4l-dvb repository to apply your changes.
> This has several advantages: e.g. it is much easier to merge the patches
> for me, and it is simpler for you to try things as you don't need to use
> the kernel-build-environment to test the stuff etc.

Thanks for the advise, I will keep that in mind for the future.

Thanks
Pete


