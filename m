Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailex.mailcore.me ([94.136.40.61]:33302 "EHLO
	mailex.mailcore.me" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753177Ab3IQR4J (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 17 Sep 2013 13:56:09 -0400
Message-ID: <523897AF.6000202@sca-uk.com>
Date: Tue, 17 Sep 2013 14:55:59 -0300
From: Steve Cookson <it@sca-uk.com>
MIME-Version: 1.0
To: Devin Heitmueller <dheitmueller@kernellabs.com>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Steven Toth <stoth@kernellabs.com>
Subject: Re: Canvassing for Linux support for Startech PEXHDCAP
References: <523769B0.6070908@sca-uk.com> <CAGoCfiwVPGKSYOObirz+X3_AN6S1LL5Eff9kcWswcHx-msguiA@mail.gmail.com> <5238720B.7040106@sca-uk.com> <CAGoCfiwYHXWBe-SLix-Qep9Ciu94iir66_oc9CmJSmaa8UBg7Q@mail.gmail.com>
In-Reply-To: <CAGoCfiwYHXWBe-SLix-Qep9Ciu94iir66_oc9CmJSmaa8UBg7Q@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 17/09/2013 12:38, Devin Heitmueller wrote:

 > Nope, the opposite.  In order to compress the video you need to store
 > enough context to look for repetition.

Ok, quite intuitive, once you know what to look for.

 > Yup. We've been through the exercise several times with various HD 
capture boards. Adjust the multiplier based on the level of experience 
of the developer doing the work.

So it is do-able.  That's good to know.

If I want to capture 480i/576i and 1080i analogue my alternatives seem 
to be:

- Something like Dazzle, $50 (480i/576i only - s-video and composite),
- Intensity Pro, $200 (480i in s-video and composite, plus, 480i/576i & 
1080i in Component but YPbPr only).  S-Video and Component in 480i/576i 
seem to have very similar picture quality.

Which leaves me with how to capture RGBS 1080i composite synch.

What do you think of Epiphan VGA2USB (with the internal PCIe mounting 
kit)?  The basic model at $299 doesn't cover RGBS, but it does do 
1080i.  Maybe I could use a sync splitter and inverter, like the 
LS1881n, to make the RGBS composite synch fit the VGA H+V pins. The LR 
at $799 doesn't seem to capture 1080i.  I thought it did, but now I look 
at the website again, I can't see it.  Have you used it?   If not those 
then there is only the HR at $1,600 :(

But Epiphan appears to support v4l2 and gstreamer.  Is it fast?  I guess 
it doesn't do S-Video and Composite.

If not Epiphan then what?  The Epixinc PIXCI® A310?

It seems quite a hard problem.

Regards

Steve.
