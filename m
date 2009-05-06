Return-path: <linux-media-owner@vger.kernel.org>
Received: from yx-out-2324.google.com ([74.125.44.30]:55256 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754475AbZEFVCm (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 6 May 2009 17:02:42 -0400
Received: by yx-out-2324.google.com with SMTP id 3so204631yxj.1
        for <linux-media@vger.kernel.org>; Wed, 06 May 2009 14:02:43 -0700 (PDT)
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Message-Id: <B9B32CC0-1CA5-4A89-A0FC-C1770014ED09@gmail.com>
From: Britney Fransen <britney.fransen@gmail.com>
To: Devin Heitmueller <devin.heitmueller@gmail.com>
In-Reply-To: <412bdbff0905061150g2e46f919i57823c8700252926@mail.gmail.com>
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0 (Apple Message framework v930.3)
Subject: Re: XC5000 improvements: call for testers!
Date: Wed, 6 May 2009 16:02:33 -0500
References: <412bdbff0905052114r7f481759r373fd0b814f458e@mail.gmail.com> <247D2127-F564-4F55-A49D-3F0F8FA63112@gmail.com> <412bdbff0905061150g2e46f919i57823c8700252926@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On May 6, 2009, at 1:50 PM, Devin Heitmueller wrote:

> First off, the QAM64 patches that Frank provided have not been merged
> it.  It's on my todo list.

I see that now.  Weird that MythTV is tuning the QAM64 channel now.   
Could it be related to the DVB-T additions?  Could the DVB-T additions  
cause the QAM256 corruption I am seeing?

> Has the MythTV situation gotten *worse* with this code compared to the
> current v4l-dvb tip?  It would not surprise me if there are some
> general MythTV issues with the 950q (I am in the process of building a
> MythTV box so I can test/debug).  However, I would be surprised if
> there were *new* issues.

Looking at the MythTV logs I would say the situation is better as  
there are fewer errors.  It returns to the menu much quicker so it  
could just be that it is failing before it hits a timeout.

> I do know that mkrufky was mentioning there
> was some sort of way to tell MythTV about hybrid devices, so that the
> application doesn't try to use both the analog and digital at the same
> time - and if you didn't do that then this could explain your issue.

  I believe that mkrufky is referring to input groups.  I do have the  
analog and digital set to the same group.

> Regarding the mplayer issue, please try this:
>
> <unplug the 950q>
> cd v4l-dvb
> make unload
> modprobe xc5000 no_poweroff=1
> <plug in the 950q>
>
> ... and then see if mplayer still has issues.  This might be somehow
> related to the firmware having to be reloaded taking too long for
> mplayer (the firmware has to be reloaded when the chip is woken up
> after being powered down).

Did that and it still failed with the following (same as before):
Playing dvb://2@FOX.
FE_GET_INFO error: 19, FD: 4

DVB CONFIGURATION IS EMPTY, exit
Failed to open dvb://2@FOX.

FOX is the first entry in my .mplayer/channels.conf file.

Thanks,
Britney

