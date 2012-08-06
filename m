Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:56738 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932187Ab2HFPVH (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 6 Aug 2012 11:21:07 -0400
Received: by yenl2 with SMTP id l2so2588692yen.19
        for <linux-media@vger.kernel.org>; Mon, 06 Aug 2012 08:21:06 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <201208061618.56479.hverkuil@xs4all.nl>
References: <1344260302-28849-1-git-send-email-elezegarcia@gmail.com>
	<CALF0-+Xwa6qNH3pEOgJq9f07C+ArNco6nxQcjGWoy5kwyQeScA@mail.gmail.com>
	<501FCFE1.7010802@redhat.com>
	<201208061618.56479.hverkuil@xs4all.nl>
Date: Mon, 6 Aug 2012 12:21:05 -0300
Message-ID: <CALF0-+U7DYEgRFMaJx4kRpNb4aeeUaTywBVDkmw99azozG_0nQ@mail.gmail.com>
Subject: Re: [alsa-devel] [PATCH v8] media: Add stk1160 new driver
From: Ezequiel Garcia <elezegarcia@gmail.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sylwester Nawrocki <sylvester.nawrocki@gmail.com>,
	alsa-devel@alsa-project.org, linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Aug 6, 2012 at 11:18 AM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> On Mon August 6 2012 16:08:33 Mauro Carvalho Chehab wrote:
>> Em 06-08-2012 10:58, Ezequiel Garcia escreveu:
>> > Hi Mauro,
>> >
>> > On Mon, Aug 6, 2012 at 10:38 AM, Ezequiel Garcia <elezegarcia@gmail.com> wrote:
>> >> This driver adds support for stk1160 usb bridge as used in some
>> >> video/audio usb capture devices.
>> >> It is a complete rewrite of staging/media/easycap driver and
>> >> it's expected as a replacement.
>> >> ---
>> >>
>> >
>> > I just sent v8, but it looks it wasn't received by patchwork either.
>> >
>> > What's going on?
>>
>> The patch didn't arrive at linux-media ML.
>>
>> Not sure why it got rejected at vger. I suggest you to ping vger admin
>> to see why your patches are being rejected there.
>>
>> I tested parsing this patch manually and patchwork accepted. So, once
>> the issue with vger is solved, other patches should be properly
>> handled there.
>
> Could it be related to the fact that a gmail account is used? Konke Radlow
> had a similar issue recently when he posted a patch from a gmail account. It
> worked fine when posted from a company account.
>

FWIW, I've always sent my patches from git-send-email through my gmail account.
Don't know if this is an issue, but it never seemed to.

Regards,
Ezequiel.
