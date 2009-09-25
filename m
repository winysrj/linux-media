Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f218.google.com ([209.85.220.218]:64189 "EHLO
	mail-fx0-f218.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752690AbZIYXBb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 25 Sep 2009 19:01:31 -0400
Received: by fxm18 with SMTP id 18so2564612fxm.17
        for <linux-media@vger.kernel.org>; Fri, 25 Sep 2009 16:01:34 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20090925221015.GA21295@zverina>
References: <20090913193118.GA12659@zverina>
	 <829197380909211349r68b92b3em577c02d0dee9e4fc@mail.gmail.com>
	 <20090921221505.GA5187@zverina>
	 <829197380909211529r7ff7eab0nccc8d5fd55516ca2@mail.gmail.com>
	 <20090922091235.GA10335@zverina>
	 <829197380909221647p33236306ked2137a35707646d@mail.gmail.com>
	 <20090925172209.GA10054@zverina>
	 <829197380909251041i637a0790g10cc4b82a791f695@mail.gmail.com>
	 <20090925182213.GA6941@zverina> <20090925221015.GA21295@zverina>
Date: Fri, 25 Sep 2009 19:01:34 -0400
Message-ID: <829197380909251601q587131d0q51eda218f9aeaf9d@mail.gmail.com>
Subject: Re: Questions about Terratec Hybrid XS (em2882) [0ccd:005e]
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Sep 25, 2009 at 6:10 PM, Uros Vampl <mobile.leecher@gmail.com> wrote:
> On 25.09.09 20:22, Uros Vampl wrote:
>> On 25.09.09 13:41, Devin Heitmueller wrote:
>> > >> Interesting.  Have you tried the A/V inputs (as opposed to the tuner)?
>> > >>  That might help us identify whether it's an issue with the xc3028
>> > >> tuner chip extracting the audio carrier or whether it's something
>> > >> about the way we are programming the emp202.
>> > >
>> > >
>> > > Hello,
>> > >
>> > > That was a great idea. Tested with a Playstation2 and audio is ok. It's
>> > > just TV input that has a problem. So I guess that means the issue is
>> > > with the tuner chip. That's progress. Where do I go from here?
>> >
>> > Ok, that's good to hear.  What video standard specifically are you
>> > using?  I suspect the core issue is that the application is not
>> > properly specifying the video standard, which results in the xc3028
>> > improperly decoding the audio (the xc3028 needs to know exactly what
>> > standard is being used).
>>
>> I'm from Slovenia, which is a PAL-B country. Tvtime can be set to either
>> PAL-BG, PAL-DK or PAL-I, makes no difference. MPlayer has a whole bunch
>> of options (PAL, PAL-BG, etc...), but again none of them make a
>> difference.
>>
>> When the app is started, this appears in dmesg:
>>
>> xc2028 4-0061: Loading firmware for type=BASE F8MHZ (3), id 0000000000000000.
>> (0), id 00000000000000ff:
>> xc2028 4-0061: Loading firmware for type=(0), id 0000000100000007.
>> xc2028 4-0061: Loading SCODE for type=MONO SCODE HAS_IF_5320 (60008000), id 0000000f00000007.
>
>
> Alright, success!!!
>
> Since it seems everything for this tuner is set up the same as for the
> Hauppauge WinTV HVR 900, I figured let's set things up *exactly* the
> same. So, like it's there for the Hauppauge, I added .mts_firmware = 1
> to the definition of the hybrid XS em2882. And well, working TV audio!!
>
>
> dmesg output this time:
>
> xc2028 4-0061: Loading firmware for type=BASE F8MHZ MTS (7), id 0000000000000000.
> MTS (4), id 00000000000000ff:
> xc2028 4-0061: Loading firmware for type=MTS (4), id 0000000100000007.
>
>
> So now with the attached patch, everything (analog, digital, remote)
> works!
>
> Regards,
> Uroš
>

Excellent!  I will check your patch into my current hg tree
(http://kernellabs.com/hg/~dheitmueller/misc-fixes2/), which I planned
on submitting a PULL for on Monday.

Cheers,

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
