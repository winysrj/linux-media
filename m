Return-path: <mchehab@pedra>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:40353 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752864Ab1DDSgD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 4 Apr 2011 14:36:03 -0400
Received: by bwz15 with SMTP id 15so4227055bwz.19
        for <linux-media@vger.kernel.org>; Mon, 04 Apr 2011 11:36:01 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <BANLkTikqBPdr2M8jyY1zmu4TPLsXo0y5Xw@mail.gmail.com>
References: <BANLkTim2MQcHw+T_2g8wSpGkVnOH_OeXzg@mail.gmail.com>
	<1301922737.5317.7.camel@morgan.silverblock.net>
	<BANLkTikqBPdr2M8jyY1zmu4TPLsXo0y5Xw@mail.gmail.com>
Date: Mon, 4 Apr 2011 14:36:01 -0400
Message-ID: <BANLkTi=dVYRgUbQ5pRySQLptnzaHOMKTqg@mail.gmail.com>
Subject: Re: HVR-1600 (model 74351 rev F1F5) analog Red Screen
From: Eric B Munson <emunson@mgebm.net>
To: Andy Walls <awalls@md.metrocast.net>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>, mchehab@infradead.org,
	linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Mon, Apr 4, 2011 at 11:16 AM, Eric B Munson <emunson@mgebm.net> wrote:
> On Mon, Apr 4, 2011 at 9:12 AM, Andy Walls <awalls@md.metrocast.net> wrote:
>> On Mon, 2011-04-04 at 08:20 -0400, Eric B Munson wrote:
>>> I the above mentioned capture card and the digital side of the card
>>> works well.  However, when I try to get video from the analog side of
>>> the card, all I get is a red screen and no sound regardless of channel
>>> requested.  This is a problem I see in 2.6.39-rc1 though I typically
>>> run the ubuntu 10.10 kernel with the newest drivers built from source.
>>>  Is there something in setup or configuration that I may be missing?
>>
>> Eric,
>>
>> You are likely missing the last 3 fixes here:
>>
>> http://git.linuxtv.org/awalls/media_tree.git?a=shortlog;h=refs/heads/cx18_39
>>
>> (one of which is critical for analog to work).
>>
>> Also check the ivtv-users and ivtv-devel list for past discussions on
>> the "red screen" showing up for known well supported models and what to
>> try.
>>
> Thanks, I will try hand applying these.
>

I don't have a red screen anymore, now all get from analog static and
mythtv's digital channel scanner now seems broken.
