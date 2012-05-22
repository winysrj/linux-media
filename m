Return-path: <linux-media-owner@vger.kernel.org>
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:37253 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752370Ab2EVWHF (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 22 May 2012 18:07:05 -0400
References: <4FBBF83C.8040201@gmail.com> <CAGoCfiwgpnAFZ0axsZqzWBzjGffLZPeZ8bnA_vaL1jcia0rk5A@mail.gmail.com>
In-Reply-To: <CAGoCfiwgpnAFZ0axsZqzWBzjGffLZPeZ8bnA_vaL1jcia0rk5A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
Subject: Re: HVR1600 and Centos 6.2 x86_64 -- Strange Behavior
From: Andy Walls <awalls@md.metrocast.net>
Date: Tue, 22 May 2012 18:06:41 -0400
To: Devin Heitmueller <dheitmueller@kernellabs.com>,
	Bob Lightfoot <boblfoot@gmail.com>
CC: linux-media@vger.kernel.org, atrpms-users@atrpms.net
Message-ID: <e95d008d-1d5a-4fde-b858-0041a9253a47@email.android.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Devin Heitmueller <dheitmueller@kernellabs.com> wrote:

>On Tue, May 22, 2012 at 4:34 PM, Bob Lightfoot <boblfoot@gmail.com>
>wrote:
>> -----BEGIN PGP SIGNED MESSAGE-----
>> Hash: SHA1
>>
>> Dear LinuxTv and AtRpms Communities:
>>     In the most recent three kernels {2.6.32-220.7.1 ;
>> 2.6.32-220.13.1 ; 2.6.32-220.17.1} released for CentOS 6.2 I have
>> experienced what can only be described as a strange behavior of the
>> V4L kernel modules with the Hauppage HVR 1600 Card.  If I reboot the
>> PC in question {HP Pavillion Elite M9040n} I will lose sound on the
>> Analog TV Tuner.  If I Power off the PC, leave it off for 30-60
>> seconds and start it back up then I have sound with the Analog TV
>> Tuner every time.  Not sure what is causing this, but thought the
>> condition was worth sharing.
>
>Could you please clarify which HVR-1600 board you have (e.g. the PCI
>ID)?  I suspect we're probably not resetting the audio processor
>properly, but I would need to know exactly which board you have in
>order to check that.
>
>Devin
>
>-- 
>Devin J. Heitmueller - Kernel Labs
>http://www.kernellabs.com
>--
>To unsubscribe from this list: send the line "unsubscribe linux-media"
>in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html

Also, if you not done so already, verify that it is not a sound card playback issue.   Make a recording when you suspect the HVR1600 is not capturing sound. Then play the recording when you know your sound is working.

Also, does audio line in with Svideo or CVBS exhibit the same symptoms?

I had to go through a good bit of trial and error to get the CX23418's APU to capture audio reliably after boot up, so I am reluctant to mess with that unless needed.

We will want to try to narrow the problem down to one of the analog tuner, integrated CX25843, or APU.

Regards,
Andy
