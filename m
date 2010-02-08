Return-path: <linux-media-owner@vger.kernel.org>
Received: from cavuit02.kulnet.kuleuven.be ([134.58.240.44]:35018 "EHLO
	cavuit02.kulnet.kuleuven.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753791Ab0BHRIL (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 8 Feb 2010 12:08:11 -0500
Received: from smtps01.kuleuven.be (smtpshost01.kulnet.kuleuven.be [134.58.240.74])
	by cavuit02.kulnet.kuleuven.be (Postfix) with ESMTP id 3524F51C00B
	for <linux-media@vger.kernel.org>; Mon,  8 Feb 2010 18:07:05 +0100 (CET)
Received: from hydrogen.esat.kuleuven.be (hydrogen.esat.kuleuven.be [134.58.56.153])
	by smtps01.kuleuven.be (Postfix) with ESMTP id D8CE531E702
	for <linux-media@vger.kernel.org>; Mon,  8 Feb 2010 18:07:04 +0100 (CET)
Received: from matar.esat.kuleuven.be (matar.esat.kuleuven.be [10.33.133.74])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by hydrogen.esat.kuleuven.be (Postfix) with ESMTP id D8B3D48002
	for <linux-media@vger.kernel.org>; Mon,  8 Feb 2010 18:07:04 +0100 (CET)
From: Markus Moll <markus.moll@esat.kuleuven.be>
To: linux-media@vger.kernel.org
Subject: Re: Terratec H5 / Micronas
Date: Mon, 8 Feb 2010 18:07:03 +0100
References: <201002081656.41640.markus.moll@esat.kuleuven.be> <d9def9db1002080849u123ae2d2r24f31276d1d46ff@mail.gmail.com>
In-Reply-To: <d9def9db1002080849u123ae2d2r24f31276d1d46ff@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201002081807.04624.markus.moll@esat.kuleuven.be>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi

On Monday 08 February 2010 17:49:29 Markus Rechberger wrote:
> To write a driver with good quality it takes alot more than just 50
> hours, it took us
> around 1 year to have a certain quality now.
> We now support Linux, FreeBSD and MacOSX with the same driver as well as
> embedded ARM devices with bugged compilers.
> Just having it work will result in alot signal problems with some
> cable providers.
> The Micronas drivers are probably the most complex drivers this entire
> project has ever
> seen.

Thank you for your quick reply. Well, that sounds pretty bad indeed. On the 
other hand, my goal is not to write a perfect driver, but start writing and 
see where that leads me. I might very well give up after a few unsuccessful 
attempts.

> > My question is, did the Micronas legal department intervene because the
> > linux driver built on top of their reference implementation and they
> > weren't willing to gpl that, or did they also oppose on using the
> > data-sheets? If it was only the reference driver, wouldn't it be
> > whorthwhile trying to again get the data sheets and build a driver based
> > solely on these? I couldn't find any post that would clarify this.
> 
> it's an official statement, that they do not want to have their driver
> opensourced.

Yes, I understood that. The question was, does that also apply to writing a 
driver based only on the data sheets, without ever even looking at their 
reference driver code?

> > However, I'm in no way an expert in v4l driver writing, so I
> > don't know where this will lead to or if I'm going to brick the device on
> > the very first occasion ;-) (btw: how easy is that, generally?)
> 
> it's the most difficult device.

Ah, let me clarify that. I wasn't asking how easy it is to write a driver, but 
actually quite the opposite: how easy is it to damage the typical dvb-t tuner 
by (accidentally) writing garbage to some registers?

> In case you're looking for something that works with Linux better
> return it asap, or sell it

Thanks. I did consider that. But I have already accepted that the device isn't 
working and isn't going to work in the not so remote future. I was wondering 
if I could at least try to establish some communication with the device. Even 
if that won't result in a working driver, I might learn something. Best case: 
other people pick up some work and we get a working driver, maybe in 5 or 10 
years ;-)

Markus (M)
