Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:40958 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756256Ab2HFPnA (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 6 Aug 2012 11:43:00 -0400
Received: by weyx8 with SMTP id x8so2039291wey.19
        for <linux-media@vger.kernel.org>; Mon, 06 Aug 2012 08:42:58 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CALF0-+U7DYEgRFMaJx4kRpNb4aeeUaTywBVDkmw99azozG_0nQ@mail.gmail.com>
References: <1344260302-28849-1-git-send-email-elezegarcia@gmail.com>
	<CALF0-+Xwa6qNH3pEOgJq9f07C+ArNco6nxQcjGWoy5kwyQeScA@mail.gmail.com>
	<501FCFE1.7010802@redhat.com>
	<201208061618.56479.hverkuil@xs4all.nl>
	<CALF0-+U7DYEgRFMaJx4kRpNb4aeeUaTywBVDkmw99azozG_0nQ@mail.gmail.com>
Date: Mon, 6 Aug 2012 12:42:57 -0300
Message-ID: <CALF0-+UkH7o=mopJJSjRMBF-+60q+-6L=LdfJsWt17oJ0ij0Lw@mail.gmail.com>
Subject: Re: [alsa-devel] [PATCH v8] media: Add stk1160 new driver
From: Ezequiel Garcia <elezegarcia@gmail.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Hans Verkuil <hverkuil@xs4all.nl>, Takashi Iwai <tiwai@suse.de>,
	Sylwester Nawrocki <sylvester.nawrocki@gmail.com>,
	alsa-devel@alsa-project.org, linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

On Mon, Aug 6, 2012 at 12:21 PM, Ezequiel Garcia <elezegarcia@gmail.com> wrote:
> On Mon, Aug 6, 2012 at 11:18 AM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
>> On Mon August 6 2012 16:08:33 Mauro Carvalho Chehab wrote:
>>> Em 06-08-2012 10:58, Ezequiel Garcia escreveu:
>>> > Hi Mauro,
>>> >
>>> > On Mon, Aug 6, 2012 at 10:38 AM, Ezequiel Garcia <elezegarcia@gmail.com> wrote:
>>> >> This driver adds support for stk1160 usb bridge as used in some
>>> >> video/audio usb capture devices.
>>> >> It is a complete rewrite of staging/media/easycap driver and
>>> >> it's expected as a replacement.
>>> >> ---
>>> >>
>>> >
>>> > I just sent v8, but it looks it wasn't received by patchwork either.
>>> >
>>> > What's going on?
>>>
>>> The patch didn't arrive at linux-media ML.
>>>
>>> Not sure why it got rejected at vger. I suggest you to ping vger admin
>>> to see why your patches are being rejected there.
>>>
>>> I tested parsing this patch manually and patchwork accepted. So, once
>>> the issue with vger is solved, other patches should be properly
>>> handled there.
>>
>> Could it be related to the fact that a gmail account is used? Konke Radlow
>> had a similar issue recently when he posted a patch from a gmail account. It
>> worked fine when posted from a company account.
>>
>
> FWIW, I've always sent my patches from git-send-email through my gmail account.
> Don't know if this is an issue, but it never seemed to.
>

On a second thought, perhaps it makes sense to have a git repo (on linuxtv.org)
for me to work on stk1160.
That way I could simply send "git pull" requests instead of patches.

I'm not sure if this is a better workflow and/or would allow for
easier reviewing.

Thanks,
Ezequiel.
