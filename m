Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx1.redhat.com (mx1.redhat.com [172.16.48.31])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n51NoK74010119
	for <video4linux-list@redhat.com>; Mon, 1 Jun 2009 19:50:20 -0400
Received: from mail-bw0-f218.google.com (mail-bw0-f218.google.com
	[209.85.218.218])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id n51No6UA024555
	for <video4linux-list@redhat.com>; Mon, 1 Jun 2009 19:50:07 -0400
Received: by bwz18 with SMTP id 18so7696811bwz.3
	for <video4linux-list@redhat.com>; Mon, 01 Jun 2009 16:50:06 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1243899120.3719.70.camel@pc07.localdom.local>
References: <745af8a00906011105x7a69b478obbab7c738aaa9e06@mail.gmail.com>
	<4A2433E2.4050807@alstadheim.priv.no>
	<745af8a00906011553v69455099j9da74a82754b592c@mail.gmail.com>
	<1243896595.3719.60.camel@pc07.localdom.local>
	<745af8a00906011631m4e6917c2r881da4e744396ff@mail.gmail.com>
	<1243899120.3719.70.camel@pc07.localdom.local>
Date: Tue, 2 Jun 2009 00:50:06 +0100
Message-ID: <921ad39e0906011650u546341b8re32bb92b380f90da@mail.gmail.com>
From: Roman Gaufman <hackeron@gmail.com>
Cc: video4linux-list@redhat.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Subject: Re: saa7134 surveillance
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

Can you take a photo of the card?

2009/6/2 hermann pitton <hermann-pitton@arcor.de>:
> Hi,
>
> Am Dienstag, den 02.06.2009, 01:31 +0200 schrieb S P:
>> It has 4 chips only, and 2 D-SUB-like input, and it has four-four
>> coax(for video) and eight-eight RCA(for sound) cable per input.
>> If you wish, I could make a picture of it.
>>
>> Regards, Peter Sarkozi
>
> if it has only four chips, it can only support four inputs at once.
>
> The idea having 8 cameras at once is realized only in software then,
> by switching between at least two inputs per saa713x.
>
> The card=0 only has one input per saa713x chip, so you should add the
> second one for each. Have a look at saa7134-cards.c.
>
> In short, it likely is only a software and not a driver problem.
>
> Only if the TS/DVB input is used at once, the chips can handle two
> inputs at the same time. Some (likely unsupported) hardware mpeg/TS
> encoder there?
>
> Cheers,
> Hermann
>
>
>>
>> 2009/6/2 hermann pitton <hermann-pitton@arcor.de>:
>> > Hi,
>> >
>> > Am Dienstag, den 02.06.2009, 00:53 +0200 schrieb S P:
>> >> I have 2.6.28 version kernel(The default with ubuntu jaunty). But I
>> >> had checked the documentation of 2.6.29 and saw that the v4l framework
>> >> redesinged a bit...so I have to compile the 2.6.29 kernel to see all
>> >> the cameras? Nice...but I will try.
>> >> Anyway: Thanks for the reply!
>> >>
>> >> Regards, Peter Sarkozi
>> >
>> > that won't help.
>> >
>> > We had always support for at least eight saa713x chips.
>> >
>> > Do you have four such chips on the board or eight?
>> >
>> > Cheers,
>> > Hermann
>> >
>> >
>> >> 2009/6/1 Håkon Alstadheim <hakon@alstadheim.priv.no>:
>> >> > S P wrote:
>> >> >>
>> >> >> Hi!
>> >> >> I have a surveillance card with saa7134 chips. It should be able to
>> >> >> see 8 cameras at a time, but there is only 4 video devices in /dev of
>> >> >> this card.
>> >> >> These devices are working fine, each device's channel 0(there isn't
>> >> >> any other channel of these devices) is an input for a camera.
>> >> >> So, how could I manage it to be 8 devices?
>> >> >>
>> >> >>
>> >> >
>> >> > Kernel-version ? Newer kernels allow you to set v4l subsystem to "allocate
>> >> > minor device numbers dynamically". This is supposed to allow more than 4
>> >> > devices on a single card, according to the help-text of the 2.6.29 kernel I
>> >> > just compiled.
>> >> >
>> >> > Caveat: All this is from memory, ~24hours old.
>> >> >
>> >> > --
>> >> > Håkon Alstadheim
>> >> > 47 35 39 38
>> >> >
>> >> >
>> >> >
>> >> > --
>
>
> --
> video4linux-list mailing list
> Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
> https://www.redhat.com/mailman/listinfo/video4linux-list
>

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
