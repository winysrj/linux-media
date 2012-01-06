Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:47267 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755385Ab2AFTV3 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 6 Jan 2012 14:21:29 -0500
Message-ID: <4F0749B1.7030504@redhat.com>
Date: Fri, 06 Jan 2012 17:21:21 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Mario Ceresa <mrceresa@gmail.com>
CC: Devin Heitmueller <dheitmueller@kernellabs.com>,
	V4L Mailing List <linux-media@vger.kernel.org>
Subject: Re: em28xx: no sound on board 1b80:e309 (sveon stv40)
References: <CAHVY3enRbcw-xKthuog5LXGMc_2tUAa0+owqbDm+C00mdWhV7w@mail.gmail.com> <CAHVY3emdMwEg9GPg1FMwVat3Xzn5AsoKZgveLvwHDxOFJiVtLA@mail.gmail.com> <CAGoCfixxiG+nxTRpLbvcy5CsktOtKk9k_3qwV4WUUhBHLaGPLQ@mail.gmail.com> <CAHVY3emdOaxQbCaZ1uRHTmVzfJ16aKq9yQedkDRXXowfcZYXCw@mail.gmail.com>
In-Reply-To: <CAHVY3emdOaxQbCaZ1uRHTmVzfJ16aKq9yQedkDRXXowfcZYXCw@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 06-01-2012 17:16, Mario Ceresa wrote:
> Hello Devin, you're right: here it goes!

Hi Mario,

Plese send it with your Signed-off-by:

It is a requirement for merging the patches upstream.
> 
> Best,
> 
> Mario
> 
> On 6 January 2012 19:33, Devin Heitmueller <dheitmueller@kernellabs.com> wrote:
>> On Fri, Jan 6, 2012 at 1:29 PM, Mario Ceresa <mrceresa@gmail.com> wrote:
>>> Ok boys: just to let you know that everything works now.
>>>
>>> thinking that the problem was with the audio input, I noticed that
>>> card=64 had an amux while card=19 no.
>>>
>>> .amux     = EM28XX_AMUX_LINE_IN,
>>>
>>> So I tried this card and modified the mplayer options accordingly:
>>>
>>> mplayer -tv device=/dev/video0:input=0:norm=PAL:forceaudio:alsa:immediatemode=0:audiorate=48000:amode=1:adevice=hw.2
>>> tv://
>>>
>>> notice the forceaudio parameter that reads the audio even if no source
>>> is reported from v4l (The same approach with card=19 does not work)
>>>
>>> The output was a bit slugglish so I switched off pulse audio control
>>> of the board (https://bbs.archlinux.org/viewtopic.php?id=114228) and
>>> now everything is ok!
>>>
>>> I hope this will help some lonenly googlers in the future :)
>>>
>>> Regards,
>>>
>>> Mario
>>
>> Hi Mario,
>>
>> Since you've spent the time to figure out the details of your
>> particular hardware, you should really consider submitting a patch to
>> the em28xx driver which adds your device's USB ID.  That would allow
>> others who have that hardware to have it work "out of the box" with no
>> need for figuring out the correct "cardid" value through
>> experimentation as you had to.
>>
>> Cheers,
>>
>> Devin
>>
>> --
>> Devin J. Heitmueller - Kernel Labs
>> http://www.kernellabs.com

