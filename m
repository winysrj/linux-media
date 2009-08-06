Return-path: <linux-media-owner@vger.kernel.org>
Received: from mp1-smtp-5.eutelia.it ([62.94.10.165]:55074 "EHLO
	smtp.eutelia.it" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756006AbZHFPQv (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 6 Aug 2009 11:16:51 -0400
Message-ID: <4A7AF3CF.3060803@email.it>
Date: Thu, 06 Aug 2009 17:16:31 +0200
From: xwang1976@email.it
MIME-Version: 1.0
To: Douglas Schilling Landgraf <dougsland@gmail.com>,
	linux-media@vger.kernel.org
Subject: Re: Issues with Empire Dual Pen: request for help and suggestions!!!
References: <4A79EC82.4050902@email.it>	<4A7AE0B0.20507@email.it>	<829197380908060717ua009e78nc045f2940c7fc76e@mail.gmail.com> <20090806112317.21240b9c@gmail.com>
In-Reply-To: <20090806112317.21240b9c@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Ok,
I've made the change and now the digital tv works perfectly.
So now I should test the analog tv, but I fear to have another kernel panic.
Is there something I can do before testing so that to be sure that at 
least all the file system are in a safety condition even if a kernel 
panic happens.
I'm wondering if it is the case, for example, to umount them and remount 
in read only mode so that if I have to turn off the pc, nothing can be 
corrupted (is it so?).
What do you suggest?
In case, how can I temporarly umount and remout the file systems in read 
only mode? Should I use alt+sys+S followed by alt+sys+U? Can I use such 
commands while I'm in KDE?
Thank you,
Xwang

Douglas Schilling Landgraf ha scritto:
> Hello Xwang,
>
>        Could you please try the bellow suggestion? 
> If you want I can make this change in my development tree and you can
> test from there.
>
> Let me know the results
>
> Cheers,
> Douglas
>
>  On Thu, 6 Aug 2009 10:17:28 -0400
> Devin Heitmueller <dheitmueller@kernellabs.com> wrote:
>
>   
>> On Thu, Aug 6, 2009 at 9:54 AM, <xwang1976@email.it> wrote:
>>     
>>> Hi,
>>> I want to inform you that thanks to Douglas Schilling Landgraf, the
>>> first point (automatic recognition of the device when plugged in)
>>> ha been resolved (using his development tree driver).
>>> I've tried to scan for digital channels again and the result has
>>> not changed but in the dmesg attached there are a lot of messages
>>> created during the scan process. I hope they are useful to solve at
>>> list the issue related with the digital scanning.
>>> Thank you,
>>> Xwang
>>>       
>> <snip>
>>
>> Yeah, I've seen that before.  Open up em28xx-dvb.c, and move the
>> following:
>>
>> case EM2880_BOARD_EMPIRE_DUAL_TV:
>>
>> from line 402 to line 492.  So it should look like this:
>>
>> case EM2880_BOARD_HAUPPAUGE_WINTV_HVR_900:
>> case EM2880_BOARD_EMPIRE_DUAL_TV:
>>       dvb->frontend = dvb_attach(zl10353_attach,
>>
>> &em28xx_zl10353_xc3028_no_i2c_gate,
>>                                               dev->i2c_adap);
>>
>> Then unplug the device, recompile, reinstall and see if the dvb
>> starts working.
>>
>> Devin
>>
>>     
>
>
>   
