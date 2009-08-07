Return-path: <linux-media-owner@vger.kernel.org>
Received: from mp1-smtp-6.eutelia.it ([62.94.10.166]:55030 "EHLO
	smtp.eutelia.it" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757321AbZHGLKw (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 7 Aug 2009 07:10:52 -0400
Message-ID: <4A7C0BA2.3010406@email.it>
Date: Fri, 07 Aug 2009 13:10:26 +0200
From: xwang1976@email.it
MIME-Version: 1.0
To: Devin Heitmueller <dheitmueller@kernellabs.com>
CC: Douglas Schilling Landgraf <dougsland@gmail.com>,
	linux-media@vger.kernel.org
Subject: Re: Issues with Empire Dual Pen: request for help and suggestions!!!
References: <4A79EC82.4050902@email.it> <4A7AE0B0.20507@email.it>	 <829197380908060717ua009e78nc045f2940c7fc76e@mail.gmail.com>	 <20090806112317.21240b9c@gmail.com> <4A7AF3CF.3060803@email.it> <829197380908060821x6cfb60f0jd73e5f9b30c21569@mail.gmail.com> <4A7B0333.1010901@email.it>
In-Reply-To: <4A7B0333.1010901@email.it>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Just a little addendum.
I remember that the audio of analog tv has started to work with Markus' 
drivers when he added the em28xx-audioep driver because, if I have 
correctly understood, my device has a  noy standard audio.
Is it possible to import the necessary code in the main branch so that 
to have the device fully functional (today it is unusable to see analog 
tv because no audio is present).
Thank you to all,
Xwang

xwang1976@email.it ha scritto:
> Ok,
> I've tried to tune analog tv with tvtime-scanner and all the channels 
> have been tuned corretly.
> However, even if I use the following command to redirect the audio 
> from the device to the audio card:
> sox -r 48000 -t alsa hw:1,0 -t alsa default &
> no audio is present when I start tv time and sox exits with the output 
> as in the attached file.
> If it is possible to fix this, this device can be added to the fully 
> supported ones.
> Xwang
>
> Devin Heitmueller ha scritto:
>> On Thu, Aug 6, 2009 at 11:16 AM, <xwang1976@email.it> wrote:
>>  
>>> Ok,
>>> I've made the change and now the digital tv works perfectly.
>>> So now I should test the analog tv, but I fear to have another 
>>> kernel panic.
>>> Is there something I can do before testing so that to be sure that 
>>> at least
>>> all the file system are in a safety condition even if a kernel panic
>>> happens.
>>> I'm wondering if it is the case, for example, to umount them and 
>>> remount in
>>> read only mode so that if I have to turn off the pc, nothing can be
>>> corrupted (is it so?).
>>> What do you suggest?
>>> In case, how can I temporarly umount and remout the file systems in 
>>> read
>>> only mode? Should I use alt+sys+S followed by alt+sys+U? Can I use such
>>> commands while I'm in KDE?
>>> Thank you,
>>> Xwang
>>>     
>>
>> Glad to hear it's working now.  I will add the patch and issue a PULL
>> request to get it into the mainline (I had to do this already for
>> several other boards).
>>
>> Regarding your concerns on panic, as long as you have a modern
>> filesystem like ext3, and you don't have alot of applications running
>> which are doing writes, a panic is a pretty safe event.  I panic my
>> machine many times a week and never have any problems.
>>
>> Cheers,
>>
>> Devin
>>
>>   
>
> ------------------------------------------------------------------------
>
