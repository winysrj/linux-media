Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qy0-f192.google.com ([209.85.221.192]:48883 "EHLO
	mail-qy0-f192.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752968AbZLSROu (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 19 Dec 2009 12:14:50 -0500
Received: by qyk30 with SMTP id 30so1962950qyk.33
        for <linux-media@vger.kernel.org>; Sat, 19 Dec 2009 09:14:49 -0800 (PST)
Message-ID: <4B2D33BA.9080006@gmail.com>
Date: Sat, 19 Dec 2009 15:12:42 -0500
From: Douglas Schilling Landgraf <dougsland@gmail.com>
MIME-Version: 1.0
To: Andreas Lunderhage <lunderhage@home.se>
CC: Devin Heitmueller <dheitmueller@kernellabs.com>,
	linux-media@vger.kernel.org
Subject: Re: Pinnacle Hybrid Pro Stick USB scan problems
References: <4B268C96.2020605@home.se>	<829197380912141134o49ec613du97600464c23fe49@mail.gmail.com> <4B2CBD2B.4080706@home.se>
In-Reply-To: <4B2CBD2B.4080706@home.se>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Andreas,

On 12/19/2009 06:46 AM, Andreas Lunderhage wrote:
> There is a missing header file in the repo...
>
> /home/lunderhage/v4l-dvb/v4l/radio-miropcm20.c:20:23: error: 
> sound/aci.h: No such file or directory
>
> Can someone push that file into the repo or send it to me, please?
>

Thanks for your report.

Please add into v4l/versions.txt file:
[2.6.33]
RADIO_MIROPCM20

then

make distclean
make
make rmmod
make install

Cheers
Douglas
> BR
> /Andreas
>
> Devin Heitmueller wrote:
>> On Mon, Dec 14, 2009 at 2:05 PM, Andreas Lunderhage 
>> <lunderhage@home.se> wrote:
>>> Hi,
>>>
>>> I have problems scanning with my Pinnacle Hybrid Pro Stick (320E). When
>>> using the scan command, it finds the channels in the first mux in 
>>> the mux
>>> file but it fails to tune the next ones. If I use Kaffeine to scan, 
>>> it gives
>>> the same result but I can also see that the signal strength shows 
>>> 99% on
>>> those muxes it fails to scan.
>>>
>>> I thinks this is a problem with the tuning since if I watch one 
>>> channel and
>>> switch to another (on another mux), it fails to tune. If I stop the 
>>> viewing
>>> of the current channel first, then it will succeed tuning the next.
>>>
>>> I'm running Ubuntu 9.04 32-bit (kernel 2.6.28-17-generic) with the code
>>> built from the repository today.
>>> I'm also running Ubuntu 9.10 64-bit (kernel 2.6.31-16) (on another 
>>> machine),
>>> but it gives the same problem.
>>
>> First, make sure you are running the latest v4l-dvb code (instructions
>> at http://linuxtv.org/repo), and then try commenting out line 181 of
>> em28xx-cards.c and see if that fixes the issue.
>>
>> Devin
>>
>
> -- 
> video4linux-list mailing list
> Unsubscribe 
> mailto:video4linux-list-request@redhat.com?subject=unsubscribe
> https://www.redhat.com/mailman/listinfo/video4linux-list

