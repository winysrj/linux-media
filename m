Return-path: <linux-media-owner@vger.kernel.org>
Received: from el-out-1112.google.com ([209.85.162.181]:38519 "EHLO
	el-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751283AbZA2C4x (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 28 Jan 2009 21:56:53 -0500
Received: by el-out-1112.google.com with SMTP id b25so1715753elf.1
        for <linux-media@vger.kernel.org>; Wed, 28 Jan 2009 18:56:51 -0800 (PST)
MIME-Version: 1.0
Reply-To: siegeljb@umich.edu
In-Reply-To: <1233191016.3098.4.camel@palomino.walls.org>
References: <2d21cac80901280817s4dcb498cx73c931e513f9161d@mail.gmail.com>
	 <1233191016.3098.4.camel@palomino.walls.org>
Date: Wed, 28 Jan 2009 21:56:51 -0500
Message-ID: <2d21cac80901281856qbdb0541h762ecbbb6e85ab0a@mail.gmail.com>
Subject: Re: cx18, HVR-1600 Clear qam tuning
From: Jason Siegel <siegeljb@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Thanks Andy,

That did the trick! QAM256 is working!

-J

On Wed, Jan 28, 2009 at 8:03 PM, Andy Walls <awalls@radix.net> wrote:
> On Wed, 2009-01-28 at 11:17 -0500, Jason Siegel wrote:
>> What is the status of clear qam tuning with the HVR-1600?
>
> It should work.
>
>> I've got me card setup and working, analog captures work well with
>> cable, and ATSC tuning of ota signals work great with an antenna, but
>> I can't find any clear qam cable stations.
>
> How are you scanning for cable channels?
>
>
>> I have a FusionHTDV5 usb tuner which finds 336 stations using qam256,
>> so I know that they are there, and the cable signal is good.
>>
>> The HVR-1600 is even working with clear qam in Windows7... and has a
>> SNR of around 30 dB.
>> http://thegreenbutton.com/forums/thread/321338.aspx
>
>
> Devin just commited a patch to improve the lock time of the
> cx24227/s5h1409 demodulator:
>
> http://linuxtv.org/hg/~dheitmueller/v4l-dvb-s5h1409/rev/6bb4e117a614
>
> I've tested it with my HVR-1600 and it improved things for me when
> tuning ATSC OTA.  You may wish to give it a try.
>
> Regards,
> Andy
>
>> Thanks,
>>
>> -Jason
>
>
>
