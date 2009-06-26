Return-path: <linux-media-owner@vger.kernel.org>
Received: from [195.7.61.12] ([195.7.61.12]:52941 "EHLO killala.koala.ie"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751299AbZFZOgt (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 26 Jun 2009 10:36:49 -0400
Message-ID: <4A44DCFB.3010906@koala.ie>
Date: Fri, 26 Jun 2009 15:36:43 +0100
From: Simon Kenyon <simon@koala.ie>
MIME-Version: 1.0
To: Devin Heitmueller <dheitmueller@kernellabs.com>
CC: Jelle de Jong <jelledejong@powercraft.nl>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: Pinnacle Systems PCTV 330e and Hauppauge WinTV HVR 900 (R2) not
 	working under Debian 2.6.30-1
References: <4A448634.7000209@powercraft.nl> <829197380906260640r45a31a83gd4bf23c06fdcf88f@mail.gmail.com>
In-Reply-To: <829197380906260640r45a31a83gd4bf23c06fdcf88f@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Devin Heitmueller wrote:
> Regarding the Terratec Cinergy T XS USB you sent me...  there are two
> variants of the same device with the same USB ID.  One has the zl10353
> and the other has the mt352.  I found one bug that was common to both,
> one bug in the zl10353 version, and one bug in the mt352.  I issued a
> PULL request for the zl10353 version last Tuesday.
>   
as you know i have the xl10353 variant. and you got it to work on my 
machine.

now i know you don't want to hear this but the same code will not work 
on another machine.
both are running 2.6.28-gentoo-r5, however i'm pretty sure the 
configurations are different.
the working machine has an MSI KA780G MS-7551 [SB700 chipset] 
motherboard and
the non-working machine has an ASUSTeK M3N78-EM [GeForce 8200 chipset] 
motherboard

in fact, i've seen reference on this list to the fact that there are 
problems with the SB700. that seems to be the opposite to me.
i will check it out on an Atom based netbook and an old Intel Centrino 
laptop to see if the code works there.
i suspect it will - but need to confirm it.

i'm afriad it is two steps forward and one step backwards
--
simon
