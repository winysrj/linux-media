Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qg0-f51.google.com ([209.85.192.51]:45220 "EHLO
	mail-qg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751749AbaJENEd (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 5 Oct 2014 09:04:33 -0400
MIME-Version: 1.0
In-Reply-To: <20141005092913.1717dfc9@recife.lan>
References: <1412275758-31340-1-git-send-email-knightrider@are.ma>
	<542E2BF6.2090800@iki.fi>
	<CAKnK8-QOU7szWNcC1BsBZtNmHBLiLqZuCVYpjsVBkpfNCxGa-A@mail.gmail.com>
	<20141003075206.331006bd@recife.lan>
	<CAKnK8-QF7fWRzp24mhsUWuK610Ko7G=a4fEx0oyf+En+jRVoJA@mail.gmail.com>
	<CAKnK8-REiZ+Y_cjf9Lpbc+QiSpp2JZKq1wCi9_3-BNjSopzRLQ@mail.gmail.com>
	<20141005092913.1717dfc9@recife.lan>
Date: Sun, 5 Oct 2014 22:04:32 +0900
Message-ID: <CAKnK8-RRXB73=UZRzndyuQ2S19kefYkiXGn7z7PpTqDUNpp6Ow@mail.gmail.com>
Subject: Re: [PATCH] pt3 (pci, tc90522, mxl301rf, qm1d1c0042):
 pt3_unregister_subdev(), pt3_unregister_subdev(), cleanups...
From: "AreMa Inc." <info@are.ma>
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Antti Palosaari <crope@iki.fi>,
	linux-media <linux-media@vger.kernel.org>,
	Hans De Goede <hdegoede@redhat.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Michael Krufky <mkrufky@linuxtv.org>,
	Sylwester Nawrocki <sylvester.nawrocki@gmail.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Peter Senna Tschudin <peter.senna@gmail.com>,
	linux-kernel@vger.kernel.org, knightrider@are.ma
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Yeah, sorry if we are not familiar with submission rules as it was the
first time for us.
We already splitted the FE and tuners as I2C drivers, according to your request.

Maybe Tsukada is very clever and we are too busy with daily business,
but it doesn't mean that backstabbing is tolerated.
We already asked him to join the project, in a very good manner.

The fact is that, our DVB driver is already published and used widely
at least in Japan since August 2013
(chardev version is far earlier) and has become a de facto standard,
well tested without any major/minor issues
reported. Our driver is simpler/slimmer and yet, stable. And, it
conforms the rules of DVB core.

Or, do you have the card with you?

-Bud

2014-10-05 21:29 GMT+09:00 Mauro Carvalho Chehab <mchehab@osg.samsung.com>:
> Hi Bud,
>
> Em Sun, 05 Oct 2014 18:36:54 +0900
> "AreMa Inc." <info@are.ma> escreveu:
>
>> Dear Antti, Mauro & others,
>>
>> We don't want to flood the mailing lists with dirts.
>> It is regretful to send this kind of email, however
>> as we just received a "war declaration" from Tsukada Akihiro,
>> it is better to postpone delivering PT3 driver to the main kernel tree.
>>
>> A series proof of facts follow.
>>
>> Thanks again for your appreciation.
>> Bud @ AreMa Inc.
>>
>> official contacts:
>> +81 50 5552 1666
>> info@are.ma
>>
>>
>> 2014-10-04 16:16 GMT+09:00 AreMa Inc. <info@are.ma>:
>> > Hi Mauro,
>> >
>> > The biggest reason is that, the submitted driver, also published at
>> > https://github.com/knight-rider/ptx/tree/master/pt3_dvb
>> > is well proven to be running smoothly and already used by Japanese community
>> > for more than a year (i.e. de facto standard) without any major issues.
>> >
>> > The second is more about his personal reasons in violating the rules
>> > and we don't want to comment further unless there is no response from him
>> > within a week.
>> >
>> > Many patches will follow.
>> >
>> > Thanks again for your info.
>> > Regards
>> > -Bud
>
> Sorry, but the PT3 driver was already merged at the main tree and I can't
> simply remove the PT3 patches without causing problems for all other patches
> that are ready to be submitted.
>
> What might be done would be to remove the driver on a separate patch,
> but that would require a really strong reason for doing that.
>
> At least from where I sit, tens of thousands kilimeters away from you both,
> it sounds to me that we're talking about two different drivers for the
> same piece of hardware. The big diff between your driver and his shows
> that they're very different.
>
> That's the history of what happened with PT3 drivers submission:
>         https://patchwork.linuxtv.org/project/linux-media/list/?submitter=6259&state=*
>         https://patchwork.linuxtv.org/project/linux-media/list/?submitter=6368&state=*
>
> All the public e-mails are there, and I don't care (not I am aware) of
> any other e-mails exchanged in priv.
>
> Both drivers had issues when submitted, and both series were properly
> reviewed. Yet, Akihiro was fast to fix the pointed issues, and his patches
> followed the proper submission rules since the beginning. Also, the
> per-driver patch split helped the reviewers to better do their work.
> His series was discussed during the last 3-4 months without a single reply
> arguing against its merge, and all comments pointing to issues at the driver
> were fixed.
>
> As it followed all the submission rules and fixup requests, it got merged.
>
> So, I am unable to see any reason to remove his driver from the Kernel.
>
> Am I missing something?
>
> Regards,
> Mauro
