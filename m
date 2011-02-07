Return-path: <mchehab@pedra>
Received: from mail-out.m-online.net ([212.18.0.10]:33184 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751954Ab1BGNBv (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 7 Feb 2011 08:01:51 -0500
From: Detlev Zundel <dzu@denx.de>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Anatolij Gustschin <agust@denx.de>, linux-media@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	Dan Williams <dan.j.williams@intel.com>,
	Markus Niebel <Markus.Niebel@tqs.de>
Subject: Re: [PATCH 2/2 v2] dma: ipu_idmac: do not lose valid received data in the irq handler
References: <1296031789-1721-3-git-send-email-agust@denx.de>
	<1296476549-10421-1-git-send-email-agust@denx.de>
	<Pine.LNX.4.64.1102031104090.21719@axis700.grange>
	<20110205143505.0b300a3a@wker>
	<Pine.LNX.4.64.1102051735270.11500@axis700.grange>
	<20110205210457.7218ecdc@wker>
	<Pine.LNX.4.64.1102071205570.29036@axis700.grange>
	<20110207122147.4081f47d@wker>
	<Pine.LNX.4.64.1102071232440.29036@axis700.grange>
Date: Mon, 07 Feb 2011 14:01:48 +0100
In-Reply-To: <Pine.LNX.4.64.1102071232440.29036@axis700.grange> (Guennadi
	Liakhovetski's message of "Mon, 7 Feb 2011 12:35:44 +0100 (CET)")
Message-ID: <m24o8g80cj.fsf@ohwell.denx.de>
MIME-Version: 1.0
Content-Type: text/plain
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Guennadi,

>> How small are the frames in you test? What is the highest fps value in
>> your test?
>
> QVGA, don't know fps exactly, pretty high, between 20 and 60fps, I think. 
> Just try different frams sizes, go down to 64x48 or something.

Is this a "real" usage scenario?  It feels that this is not what most
users will do and it certainly is not relevant for our application.  

Is it possible that if you are interested in such a scenario that you do
the testing?  We have spent quite a lot of time to fix the driver for
real (well full frame) capturing already and I am relucatant to spend
more time for corner cases.  Maybe we should document this as "known
limitations" of the setup?  What do you think?  I'll much rather have a
driver working for real world scenarios than for marginal test cases.

Thanks
  Detlev

--
DENX Software Engineering GmbH,      MD: Wolfgang Denk & Detlev Zundel
HRB 165235 Munich,  Office: Kirchenstr.5, D-82194 Groebenzell, Germany
Phone: (+49)-8142-66989-40 Fax: (+49)-8142-66989-80 Email: dzu@denx.de
