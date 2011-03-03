Return-path: <mchehab@pedra>
Received: from stevekez.vm.bytemark.co.uk ([80.68.91.30]:36552 "EHLO
	stevekerrison.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751786Ab1CCQP4 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 3 Mar 2011 11:15:56 -0500
Received: from localhost (localhost.localdomain [127.0.0.1])
	by stevekerrison.com (Postfix) with ESMTP id 45A3816405
	for <linux-media@vger.kernel.org>; Thu,  3 Mar 2011 16:15:55 +0000 (GMT)
Received: from stevekerrison.com ([127.0.0.1])
	by localhost (stevekez.vm.bytemark.co.uk [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 8wpHkCw2jtHr for <linux-media@vger.kernel.org>;
	Thu,  3 Mar 2011 16:15:49 +0000 (GMT)
Received: from [192.168.1.19] (94-193-106-123.zone7.bethere.co.uk [94.193.106.123])
	(Authenticated sender: steve@stevekerrison.com)
	by stevekerrison.com (Postfix) with ESMTPSA id 2F57D163E5
	for <linux-media@vger.kernel.org>; Thu,  3 Mar 2011 16:15:49 +0000 (GMT)
Subject: Re: em28xx: dvb lock bug on re-plug of device?
From: Steve Kerrison <steve@stevekerrison.com>
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
In-Reply-To: <AANLkTikkz74O96-CPZXOGiXFhcck6dXge8NRknxXTfQy@mail.gmail.com>
References: <1299168093.2864.14.camel@ares>
	 <AANLkTikkz74O96-CPZXOGiXFhcck6dXge8NRknxXTfQy@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 03 Mar 2011 16:15:48 +0000
Message-ID: <1299168948.2864.19.camel@ares>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Re-sending due to HTML accident.

Thank you Devin, that is useful to know. It means I can have some
confidence in the problem not being caused by my actions. I will focus
my efforts on getting the device working in spite of this, but might
have a chance to look into this bug thereafter.

Regards,
-- 
Steve Kerrison MEng Hons.
http://www.stevekerrison.com/ 

On Thu, 2011-03-03 at 11:07 -0500, Devin Heitmueller wrote:
> On Thu, Mar 3, 2011 at 11:01 AM, Steve Kerrison <steve@stevekerrison.com> wrote:
> > Hi all,
> >
> > I wonder if Devin/Mauro could help me with something as I've run into a
> > problem developing a driver for the PCTV 290e?
> >
> > First plug of the device works fine, em28xx and em28xx_dvb are loaded.
> > However, if I disconnect and then re-plug the device, the em28xx_dvb
> > module will hang in dvb_init() where it performs mutex_lock(&dev->lock);
> 
> Hi Steve,
> 
> I saw this too and brought it to Mauro's attention some months ago
> (because I believed strongly it was related to locking changes).  It
> looks like he never did anything to address it though (and I've been
> working on other bridges so haven't had any time to dig into it).
> 
> So, for what it's worth, I can confirm the problem that you are experiencing.
> 
> Devin
> 

