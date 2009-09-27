Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f210.google.com ([209.85.218.210]:54350 "EHLO
	mail-bw0-f210.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753000AbZI0Bd5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 26 Sep 2009 21:33:57 -0400
Received: by bwz6 with SMTP id 6so644389bwz.37
        for <linux-media@vger.kernel.org>; Sat, 26 Sep 2009 18:33:59 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20090927002339.GA23032@zverina>
References: <829197380909211349r68b92b3em577c02d0dee9e4fc@mail.gmail.com>
	 <829197380909211529r7ff7eab0nccc8d5fd55516ca2@mail.gmail.com>
	 <20090922091235.GA10335@zverina>
	 <829197380909221647p33236306ked2137a35707646d@mail.gmail.com>
	 <20090925172209.GA10054@zverina>
	 <829197380909251041i637a0790g10cc4b82a791f695@mail.gmail.com>
	 <20090925182213.GA6941@zverina> <20090925221015.GA21295@zverina>
	 <829197380909261359l22588d31v6fcc2cef40b12acd@mail.gmail.com>
	 <20090927002339.GA23032@zverina>
Date: Sat, 26 Sep 2009 21:33:59 -0400
Message-ID: <829197380909261833uc08f661vff2695e2986b672d@mail.gmail.com>
Subject: Re: Questions about Terratec Hybrid XS (em2882) [0ccd:005e]
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, Sep 26, 2009 at 8:23 PM, Uros Vampl <mobile.leecher@gmail.com> wrote:
> On 26.09.09 16:59, Devin Heitmueller wrote:
>> On Fri, Sep 25, 2009 at 6:10 PM, Uros Vampl <mobile.leecher@gmail.com> wrote:
>> > Alright, success!!!
>> >
>> > Since it seems everything for this tuner is set up the same as for the
>> > Hauppauge WinTV HVR 900, I figured let's set things up *exactly* the
>> > same. So, like it's there for the Hauppauge, I added .mts_firmware = 1
>> > to the definition of the hybrid XS em2882. And well, working TV audio!!
>> >
>> >
>> > dmesg output this time:
>> >
>> > xc2028 4-0061: Loading firmware for type=BASE F8MHZ MTS (7), id 0000000000000000.
>> > MTS (4), id 00000000000000ff:
>> > xc2028 4-0061: Loading firmware for type=MTS (4), id 0000000100000007.
>> >
>> >
>> > So now with the attached patch, everything (analog, digital, remote)
>> > works!
>> >
>> > Regards,
>> > Uroš
>> >
>>
>> Hello Uros,
>>
>> Please test out the following tree, which has all the relevant fixes
>> (enabling dvb, your audio fix, proper gpio setting, etc).
>>
>> http://kernellabs.com/hg/~dheitmueller/misc-fixes2/
>>
>> If you have any trouble, please let me know.  Otherwise I would like
>> to issue a PULL request for this tree.
>
>
> Hi,
>
> Your tree does not work, no audio. I quickly found the problem though:
> gpio is set to default_analog, but it needs to be set to
> hauppauge_wintv_hvr_900_analog. So I guess treating the EM2880 and
> EM2882 as the same will not work, because they require different gpio
> settings.
>
> Regards,
> Uroš

Hmm..  Interesting.  That does make me wonder whether the GPIOs are
setup for audio properly on the em2880 version of the profile, or
whether the user in question just never tested it.  I'll have to go
back and check the USB trace.

Nonetheless, I'll just check in your version of the patch, and scrap
my version entirely for now.  Could you please add your SOB to the
patch?

Thanks,

Devin



-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
