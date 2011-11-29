Return-path: <linux-media-owner@vger.kernel.org>
Received: from fmmailgate05.web.de ([217.72.192.243]:64467 "EHLO
	fmmailgate05.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754876Ab1K2MNo (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 29 Nov 2011 07:13:44 -0500
Received: from moweb002.kundenserver.de (moweb002.kundenserver.de [172.19.20.108])
	by fmmailgate05.web.de (Postfix) with ESMTP id 3FF3E67AA952
	for <linux-media@vger.kernel.org>; Tue, 29 Nov 2011 13:04:59 +0100 (CET)
From: Jens Erdmann <Jens.Erdmann@web.de>
To: Andreas Oberritter <obi@linuxtv.org>, linux-media@vger.kernel.org
Subject: Re: [PATCH] em28xx: Add Terratec Cinergy HTC Stick
Date: Tue, 29 Nov 2011 13:04:57 +0100
References: <11607963.5467764.1322494881126.JavaMail.fmail@mwmweb051> <4ED3BD7F.1020406@linuxtv.org>
In-Reply-To: <4ED3BD7F.1020406@linuxtv.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-ID: <0MQf77-1RNtkl3pe9-00U2UK@smtp.web.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Andreas,

On Monday, November 28, 2011 05:57:35 PM you wrote:
> Hello Jens,
> 
> On 28.11.2011 16:41, Jens Erdmann wrote:
> > Hi folks,
> > 
> > just a few quetstions:
> > 1. Why is the device named EM2884_BOARD_CINERGY_HTC_STICK and not
> > 
> >     EM2884_BOARD_TERRATEC_HTC_STICK like all the other devices from that
> >     vendor? Looks inconsistent to me.
> 
> that's because it's the product name. Even though TERRATEC is the
> vendor, the TERRATEC series of devices is different from the Cinergy
> series (mostly due to software bundles, IMHO). See their homepage for
> details.
> 
> So, TERRATEC_HTC_STICK would be wrong. You could change it to
> TERRATEC_CINERGY_HTC_STICK, if it's important to you. However, following
> the same logic, the TERRATEC H5 should then be called
> TERRATEC_TERRATEC_H5, which seems rather odd.
> 
> Btw.: The em28xx driver wrongly lists the H5 as "Terratec Cinergy H5".
> 

Don't get me wrong on this. I am just asking. You have made the desicion
and if you are fine with it its ok.

> > 2. I stumbled over http://linux.terratec.de/tv_en.html where they list a
> > NXP TDA18271
> > 
> >     as used tuner for H5 and HTC Stick devices. I dont have any
> >     experience in this kind of stuff but i am just asking.
> 
> That's right.
> 

So this should be made like the other devices which are using the TDA18271?
Or is there no driver for this tuner yet?

Regards,

  Jens

PS: Thanks to Antti Palosaari for the detailed explanation.
