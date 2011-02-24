Return-path: <mchehab@pedra>
Received: from cmsout01.mbox.net ([165.212.64.31]:56445 "EHLO
	cmsout01.mbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753815Ab1BXKab convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 24 Feb 2011 05:30:31 -0500
Date: Thu, 24 Feb 2011 11:30:27 +0100
From: "Issa Gorissen" <flop.m@usa.net>
To: <linux-media@vger.kernel.org>
Subject: Re: Sony CXD2099AR decryption failing
CC: <o.endriss@gmx.de>
Mime-Version: 1.0
Message-ID: <752PBXkdb2464S02.1298543427@web02.cms.usa.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Oliver,

I have managed to make a test under Windows. It worked.

I only managed to watch France 2 with BIS.TV card and SMIT Viaccess CAM with
MediaPortal 1.2.0 Alpha.

What's the next step, shall I do another test ?


Support from DD tells me this

> Name: 	Manfred Völkel
> 
> Message:
> 
> Hello Issa
> 
> The SMIT Viaccess has originally been testet with a SRG card. After
restesting now i
> have indeed found a problem with the BIS Card and the SMIT Viaccess module.
> This combination does not work reliable with MTD. It however works in single
transponder
> mode, which is the only mode currently supported with Linux (until someone
writes 
> plugins for VDR etc tu remux). Please assign only one tuner to the CI and
also configure
> WMC with only one tuner and retest. This worked here.
> 
> My BIS card's serial starts with 400 00 xxx
> 
> The SMIT Viaccess:
>
> Hardware Version 1.3.0(221)
> Loader Version: 4.2.3 seq:2
> Software version: 1.6.1(166)m2
> UA: 000 000 000 000
> STB identifier: FFFFFFFF.
> ACS Version: 463-2.1.2.11
>
> Gruß
> DD-Guru

