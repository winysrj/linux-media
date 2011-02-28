Return-path: <mchehab@pedra>
Received: from cmsout02.mbox.net ([165.212.64.32]:36436 "EHLO
	cmsout02.mbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752706Ab1B1Kbw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 28 Feb 2011 05:31:52 -0500
Received: from cmsout02.mbox.net (co02-lo [127.0.0.1])
	by cmsout02.mbox.net (Postfix) with ESMTP id D938A1341A0
	for <linux-media@vger.kernel.org>; Mon, 28 Feb 2011 10:31:51 +0000 (GMT)
Date: Mon, 28 Feb 2011 11:31:47 +0100
From: "Issa Gorissen" <flop.m@usa.net>
To: <linux-media@vger.kernel.org>
Subject: Sony CXD2099AR support
Mime-Version: 1.0
Message-ID: <369PBbkEv0304S02.1298889107@web02.cms.usa.net>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi,

I have read that this CI chip driver is in staging because some questions on
how to handle it are still not answered.

I volunteer to handle this one. I'm a regular java developer, but I'm willing
to put effort in learning linux drivers writing.

So Ralph, can you give me some pointers on where the discussion should resume
?

Do we put people of Mythtv and VDR in the discussion ? I guess so.

I don't see anything related to MTD in the DVB CSA documents. I guess this
should be left out of the driver.

Thx,
--
Issa 

------ Original Message ------
Received: 11:48 AM CET, 02/25/2011
From: "Issa Gorissen" <flop.m@usa.net>
To: <linux-media@vger.kernel.org>
Subject: Re: Sony CXD2099AR decryption failing

> Follow up on the trouble with Digital Devices DuoFlex S2, CI, SMIT Viaccess
> CAM and Bis.tv card.
> 
> The whole combination works under Windows 7 with Media Center. I have been
> able to watch and change channels I'm entitled to in the Bis.TV package.
Only
> condition was to disable CI for tuner no 2. If the CI is activated for tuner
1
> and tuner 2, Media Center will not be able to change the channels.
> 
> Anything I can do to make progress for this issue under linux ?
> 
> 
> Thx
> --
> Issa

