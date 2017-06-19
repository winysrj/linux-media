Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.anw.at ([195.234.101.228]:55121 "EHLO mail.anw.at"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752137AbdFSWO0 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 19 Jun 2017 18:14:26 -0400
Subject: Re: [PATCH v3 00/13] stv0367/ddbridge: support CTv6/FlexCT hardware
To: Daniel Scheller <d.scheller.oss@gmail.com>,
        linux-media@vger.kernel.org, mchehab@kernel.org,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Hans Verkuil <hverkuil@xs4all.nl>
References: <20170329164313.14636-1-d.scheller.oss@gmail.com>
 <20170412212327.5b75be19@macbox>
 <20170507174212.2e45ab71@audiostation.wuest.de>
 <20170528234537.3bed2dde@macbox> <20170619221821.022fc473@macbox>
Cc: liplianin@netup.ru, rjkm@metzlerbros.de, crope@iki.fi
From: "Jasmin J." <jasmin@anw.at>
Message-ID: <f2f432f5-e594-4992-6af5-8006617abe30@anw.at>
Date: Tue, 20 Jun 2017 00:14:11 +0200
MIME-Version: 1.0
In-Reply-To: <20170619221821.022fc473@macbox>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello !

On 06/19/2017 10:18 PM, Daniel Scheller wrote:
> Am Sun, 28 May 2017 23:45:37 +0200
> schrieb Daniel Scheller <d.scheller.oss@gmail.com>:
> 
>> Am Sun, 7 May 2017 17:42:12 +0200
>> schrieb Daniel Scheller <d.scheller.oss@gmail.com>:
>>
>>> Am Wed, 12 Apr 2017 21:23:27 +0200
>>> schrieb Daniel Scheller <d.scheller.oss@gmail.com>:
>>>   
>>>> Am Wed, 29 Mar 2017 18:43:00 +0200
>>>> schrieb Daniel Scheller <d.scheller.oss@gmail.com>:
>>>>     
>>>>> From: Daniel Scheller <d.scheller@gmx.net>
>>>>>
>>>>> Third iteration of the DD CineCTv6/FlexCT support patches with
>>>>> mostly all things cleaned up that popped up so far. Obsoletes V1
>>>>> and V2 series.
>>>>>
>>>>> These patches enhance the functionality of dvb-frontends/stv0367
>>>>> to work with Digital Devices hardware driven by the ST STV0367
>>>>> demodulator chip and adds probe & attach bits to ddbridge to
>>>>> make use of them, effectively enabling full support for
>>>>> CineCTv6 PCIe bridges and (older) DuoFlex CT addon
>>>>> modules.      
>>>>
>>>> Since V1 was sent over five weeks ago: Ping? Anyone? I'd really
>>>> like to get this upstreamed.    
>>>
>>> Don't want to sound impatient, but V1 nears nine weeks, so: Second
>>> Ping.  
>>
>> Friendly third time Ping on this - Really, I'd like to have this
>> merged so those quite aging (but still fine) DD CineCTv6 boards
>> finally are supported without having to install out-of-tree drivers
>> which even break the V4L-DVB subsystem...
> 
> Well. From how things look, these and the cxd2841er+C2T2 ddbridge
> support patches won't make it in time for the 4.13 merge window.
> Also, unfortunately, the original owners and/or maintainers of the
> affected drivers (besides cxd2841er), namely stv0367 and ddbridge,
> either are MIA or not interested in reviewing or acking this.
> 
> I have plenty of more work (patches) done, all building upon this CT
> and C2T2 hardware support, which - together with the work Jasmin has
> done regarding the en50221 and cxd2099 support - would finally bring
> the in-tree ddbridge driver on par with the package Digital Devices'
> provides, having addressed most of the critics the previous attempts to
> bump the driver received (incremental changes which are more or less
> easy to review, from what can be done by tearing tarballs without
> proper changelogs apart).
> 
> The original series of this will be four(!) months old soon :/
> 
> Is there anything wrong with this? How to proceed with this?
> 
> (Cc Hans since you also seem to be reviewing patches)
> 
> That said, fourth ping.

May I add another aspect.
Daniel put a lot of effort into this and also other people in testing his
drivers. Daniel was highly motivated to bring this driver into the Kernel.

That sayd, waiting 4 months is pretty frustrating and might reduce the
motivation to continue.

There are 7 more patch series waiting to review and when each of then requires
4 or more months to get into the Kernel, the project is dead before it really
started!

The community using the DD cards is growing and it is often frustrating using
the drivers provided by DD, when you plan to use other cards too, because
the DD drivers are simply not compatible.
Daniel made them working within the current media tree and a lot of people
(including me) would be very happy to see the DD cards supported out of the
box by the Kernel. Hopefully before the Kernel 5.x development hast started.

I hope there will be soon a review of this series, so that we can move forward
with our work!

BR,
   Jasmin
