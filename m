Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-we0-f179.google.com ([74.125.82.179]:49493 "EHLO
	mail-we0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750984Ab3AGMx1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 7 Jan 2013 07:53:27 -0500
Received: by mail-we0-f179.google.com with SMTP id r6so9700789wey.38
        for <linux-media@vger.kernel.org>; Mon, 07 Jan 2013 04:53:25 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <50EAA778.6000307@gmail.com>
References: <507FE752.6010409@schinagl.nl>
	<50D0E7A7.90002@schinagl.nl>
	<50EAA778.6000307@gmail.com>
Date: Mon, 7 Jan 2013 13:53:25 +0100
Message-ID: <CAL7owaA1b8FamRX7TtbmmaJ3ip5txGY1qSGvu9P21RG1ASQ4Gg@mail.gmail.com>
Subject: Re: [RFC] Initial scan files troubles and brainstorming
From: Christoph Pfister <christophpfister@gmail.com>
To: Jiri Slaby <jirislaby@gmail.com>, js@linuxtv.org
Cc: Oliver Schinagl <oliver+list@schinagl.nl>,
	linux-media <linux-media@vger.kernel.org>, adq_dvb@lidskialf.net,
	cus@fazekas.hu, mws@linuxtv.org, jmccrohan@gmail.com,
	shaulkr@gmail.com, mkrufky@linuxtv.org, mchehab@redhat.com,
	lubomir.carik@gmail.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Okay guys, I think this is a good time to discuss scan file
maintenance [ should have taken care of it earlier, but well ...].

I've been updating the scan data for the past few years, but found
barely no time in the last (many!) months. This won't change in
future, so I've decided to step down from the task; may others do what
is necessary ...

@Johannes: As I don't need the account anymore, please delete it.

Christoph


2013/1/7 Jiri Slaby <jirislaby@gmail.com>:
> On 12/18/2012 11:01 PM, Oliver Schinagl wrote:
>> Unfortunatly, I have had zero replies.
>
> Hmm, it's sad there is a silence in this thread from linux-media guys :/.
>
>> So why bring it up again? On 2012/11/30 Jakub Kasprzycki provided us
>> with updated polish DVB-T frequencies for his region. This has yet to be
>> merged, almost 3 weeks later.
>
> I sent a patch for cz data too:
> https://patchwork.kernel.org/patch/1844201/
>
>> I'll quickly repeat why I think this approach would be quite reasonable.
>>
>> * dvb-apps binary changes don't result in unnecessary releases
>> * frequency updates don't result in unnecessary dvb-app releases
>> * Less strict requirements for commits (code reviews etc)
>
> Well the code should be reviewed still. See commit a2e96055db297 in your
> repo, it's bogus. The freq added is in kHz instead of MHz.
>
>> * Possibly easier entry for new submitters
>> * much easier to package (tag it once per month if an update was)
>> * Separate maintainer possible
>> * just seems more logical to have it separated ;)
>
> The downside is you have to change the URL in kaffeine sources as
> kaffeine generates its scan file from that repo (on the server side and
> the client downloads then http://kaffeine.kde.org/scanfile.dvb.qz).
>
>> This obviously should find a nice home on linuxtv where it belongs!
>
> At best.
>
>> Here is my personal repository with the work I mentioned done.
>> git://git.schinagl.nl/dvb_frequency_scanfiles.git
>>
>> If an issue is that none of the original maintainers are not looking
>> forward to do the job, I am willing to take maintenance on me for now.
>
> Ping? Anybody? I would help with that too as I hate resending patches.
> But the first step I would do is a conversion to GIT. HG is demented to
> begin with.
>
> --
> js
