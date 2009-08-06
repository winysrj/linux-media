Return-path: <linux-media-owner@vger.kernel.org>
Received: from mp1-smtp-6.eutelia.it ([62.94.10.166]:45771 "EHLO
	smtp.eutelia.it" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751541AbZHFQWd (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 6 Aug 2009 12:22:33 -0400
Message-ID: <4A7B0333.1010901@email.it>
Date: Thu, 06 Aug 2009 18:22:11 +0200
From: xwang1976@email.it
MIME-Version: 1.0
To: Devin Heitmueller <dheitmueller@kernellabs.com>
CC: Douglas Schilling Landgraf <dougsland@gmail.com>,
	linux-media@vger.kernel.org
Subject: Re: Issues with Empire Dual Pen: request for help and suggestions!!!
References: <4A79EC82.4050902@email.it> <4A7AE0B0.20507@email.it>	 <829197380908060717ua009e78nc045f2940c7fc76e@mail.gmail.com>	 <20090806112317.21240b9c@gmail.com> <4A7AF3CF.3060803@email.it> <829197380908060821x6cfb60f0jd73e5f9b30c21569@mail.gmail.com>
In-Reply-To: <829197380908060821x6cfb60f0jd73e5f9b30c21569@mail.gmail.com>
Content-Type: multipart/mixed;
 boundary="------------020707010806070901020106"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is a multi-part message in MIME format.
--------------020707010806070901020106
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Ok,
I've tried to tune analog tv with tvtime-scanner and all the channels 
have been tuned corretly.
However, even if I use the following command to redirect the audio from 
the device to the audio card:
sox -r 48000 -t alsa hw:1,0 -t alsa default &
no audio is present when I start tv time and sox exits with the output 
as in the attached file.
If it is possible to fix this, this device can be added to the fully 
supported ones.
Xwang

Devin Heitmueller ha scritto:
> On Thu, Aug 6, 2009 at 11:16 AM, <xwang1976@email.it> wrote:
>   
>> Ok,
>> I've made the change and now the digital tv works perfectly.
>> So now I should test the analog tv, but I fear to have another kernel panic.
>> Is there something I can do before testing so that to be sure that at least
>> all the file system are in a safety condition even if a kernel panic
>> happens.
>> I'm wondering if it is the case, for example, to umount them and remount in
>> read only mode so that if I have to turn off the pc, nothing can be
>> corrupted (is it so?).
>> What do you suggest?
>> In case, how can I temporarly umount and remout the file systems in read
>> only mode? Should I use alt+sys+S followed by alt+sys+U? Can I use such
>> commands while I'm in KDE?
>> Thank you,
>> Xwang
>>     
>
> Glad to hear it's working now.  I will add the patch and issue a PULL
> request to get it into the mainline (I had to do this already for
> several other boards).
>
> Regarding your concerns on panic, as long as you have a modern
> filesystem like ext3, and you don't have alot of applications running
> which are doing writes, a panic is a pretty safe event.  I panic my
> machine many times a week and never have any problems.
>
> Cheers,
>
> Devin
>
>   

--------------020707010806070901020106
Content-Type: image/jpeg;
 name="sox_output.jpg"
Content-Transfer-Encoding: base64
Content-Disposition: inline;
 filename="sox_output.jpg"

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
--------------020707010806070901020106--
