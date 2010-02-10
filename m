Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:10806 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752532Ab0BJXdX (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 10 Feb 2010 18:33:23 -0500
Message-ID: <4B73422F.8010707@redhat.com>
Date: Wed, 10 Feb 2010 21:33:03 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Carlos Jenkins <carlos.jenkins.perez@gmail.com>
CC: Devin Heitmueller <dheitmueller@kernellabs.com>,
	linux-media@vger.kernel.org
Subject: Re: Want to help in MSI TV VOX USB 2.0
References: <f535cc5a1002100021u37bf47a5y50a0a90873a082e2@mail.gmail.com> 	<f535cc5a1002101058h4d8e4bd1p6fd03abd4f724f52@mail.gmail.com> 	<f535cc5a1002101101k709bbe9bv504cf33fab14dedc@mail.gmail.com> 	<f535cc5a1002101102w146050c5v91ddc6ec86542153@mail.gmail.com> 	<4B731A10.9000108@redhat.com> <829197381002101255x2af2776ftd1c7a7d32584946@mail.gmail.com> 	<f535cc5a1002101310y3faf7688hdbb0db0b1d45e081@mail.gmail.com> 	<829197381002101324i600c0fbdtdae2b5fac4b84f35@mail.gmail.com> <f535cc5a1002101435u10825bedn4dd845cd10a2cd0b@mail.gmail.com>
In-Reply-To: <f535cc5a1002101435u10825bedn4dd845cd10a2cd0b@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Carlos Jenkins wrote:
> Hi :) Thank again for the replies.
> 
>> Well, if it actually has a tuner, then it is unlikely that any
>> existing board profile is going to help (ruling out the ability to
>> just use a "card=").
> Profile 5 is for this same card.
> 
>> Do you know what tuner it contains?  Can you
>> provide some hi-res photos of the internals of the device?
> 
> Yes, I can :)
> 
> http://www.cjenkins.net/files/msivoxusb2.0.png

The tuner is LG/Innotek TALN-H200T.

>From Documentation/video4linux/CARDLIST.tuner:

tuner=25 - LG PAL_I+FM (TAPC-I001D)
tuner=26 - LG PAL_I (TAPC-I701D)
tuner=27 - LG NTSC+FM (TPI8NSR01F)
tuner=28 - LG PAL_BG+FM (TPI8PSB01D)
tuner=29 - LG PAL_BG (TPI8PSB11D)
tuner=37 - LG PAL (newer TAPC series)
tuner=39 - LG NTSC (newer TAPC series)
tuner=47 - LG NTSC (TAPE series)
tuner=64 - LG TDVS-H06xF
tuner=66 - LG TALN series

Probably, tuner=66 will work better.

So, you'll need to probe your card with

	modprobe em28xx card=5 tuner=66

> 
> Note: Mauro I'll test everything you said later and I'll post the result here.

Ok.

-- 

Cheers,
Mauro
