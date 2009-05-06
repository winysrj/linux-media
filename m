Return-path: <linux-media-owner@vger.kernel.org>
Received: from yx-out-2324.google.com ([74.125.44.29]:37979 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753628AbZEFSmJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 6 May 2009 14:42:09 -0400
Received: by yx-out-2324.google.com with SMTP id 3so158599yxj.1
        for <linux-media@vger.kernel.org>; Wed, 06 May 2009 11:42:08 -0700 (PDT)
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Message-Id: <247D2127-F564-4F55-A49D-3F0F8FA63112@gmail.com>
From: Britney Fransen <britney.fransen@gmail.com>
To: Devin Heitmueller <devin.heitmueller@gmail.com>
In-Reply-To: <412bdbff0905052114r7f481759r373fd0b814f458e@mail.gmail.com>
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0 (Apple Message framework v930.3)
Subject: Re: XC5000 improvements: call for testers!
Date: Wed, 6 May 2009 13:42:05 -0500
References: <412bdbff0905052114r7f481759r373fd0b814f458e@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Devin,

I have an HVR-950q.

Analog support is working much better for me.  I love the faster  
tuning.  Still no luck getting analog to work in MythTV.

I am seeing some major regressions on the the digital side.  mplayer  
can't tune any digital channels and seems to be failing because it  
can't access the tuner.  In MythTV it does tune my QAM64 channel that  
previously would only tune with Frank's QAM64 patch. The other QAM256  
channels either won't lock at all or if they do have bad pixelation  
and audio drops.  In mythtv-setup I can't do a channel scan because it  
says it can't open the card which seems similar to the problem mplayer  
had.  I had previously been using 11658 with the QAM64 patch.

The 950q is definitely cooler to the touch.  Not a big deal but I did  
notice that the tune light that would light orange when tuned to a  
channel no longer lights up.

Let me know if there is anything you would like me to try.

Thanks,
Britney

On May 5, 2009, at 11:14 PM, Devin Heitmueller wrote:

> Hello all,
>
> I'm happy to announce that there have been some considerable
> improvements to the xc5000 driver, and I am looking for people with
> xc5000 based devices to test:
>
> == Noteworthy changes ==
>
> * Power management is now properly supported - no more sucking up your
> laptop battery and burning your fingers on the tuner's f-connector
> when the device is idle (can be disabled with the "no_poweroff"
> modprobe option).
>
> * Faster tuning - average 10x improvement in time to lock.  Average
> lock time now around 350ms, down from 3200ms.  No more multi-second
> delays when trying to channel surf in tvtime.
>
> * Redistributable firmware - Xceive has graciously allowed us to
> redistribute the firmware and bundle it in the distros.  No more need
> for users to manually extract the blob from the Hauppauge Windows
> driver.
>
> * Various fixes to bridges and dvb core found during power  
> management testing.
>
> * Support for DVB-T tuning, thanks to David T.L. Wong <davidtlwong@gmail.com 
> >
>
> To test the code, clone from the following hg repository:
>
> http://linuxtv.org/hg/~dheitmueller/xc5000-improvements-beta/
>
> Unfortunately, current users are going to have to upgrade to the new
> firmware.  However, this is a one time cost and I will work with the
> distros to get it bundled so that users won't have to do this in the
> future:
>
> http://www.devinheitmueller.com/xc5000/dvb-fe-xc5000-1.6.114.fw
> http://www.devinheitmueller.com/xc5000/README.xc5000
>
> Thanks go out to Xceive for providing access to the xc5000
> specification, reference driver code, and firmware under the
> appropriate license.  Thanks also go out to Michael Krufky for his
> considerable effort in helping test/debug different xc5000 hardware.
>
> I look forward to hearing back from testers with any problems they may
> encounter.  Now is the time to bring these up before it gets merged
> into the mainline.
>
> Thanks,
>
> Devin
>
> -- 
> Devin J. Heitmueller
> http://www.devinheitmueller.com
> AIM: devinheitmueller
> --
> To unsubscribe from this list: send the line "unsubscribe linux- 
> media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

