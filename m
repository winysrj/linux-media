Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:64679 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753365Ab2HFMvM (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 6 Aug 2012 08:51:12 -0400
Received: by yhmm54 with SMTP id m54so2399348yhm.19
        for <linux-media@vger.kernel.org>; Mon, 06 Aug 2012 05:51:11 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CALF0-+Woc9s7_TFKyw74SAusg+YCmnFOeViP6kT0QthP4LN9zw@mail.gmail.com>
References: <1343485133-11090-1-git-send-email-elezegarcia@gmail.com>
	<CALF0-+XEStNrfdqYecKQHr=qkcFPtC5CyDC4DWWy_7+_oA0h=g@mail.gmail.com>
	<501FBBB1.1030802@redhat.com>
	<CALF0-+Woc9s7_TFKyw74SAusg+YCmnFOeViP6kT0QthP4LN9zw@mail.gmail.com>
Date: Mon, 6 Aug 2012 09:51:10 -0300
Message-ID: <CALF0-+V2MDBvtuNLYLjNMvu+GWU8-KypV_Y1PwLAUEGJUHt-SA@mail.gmail.com>
Subject: Re: [PATCH v7] media: Add stk1160 new driver
From: Ezequiel Garcia <elezegarcia@gmail.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: alsa-devel@alsa-project.org, linux-media@vger.kernel.org,
	Takashi Iwai <tiwai@suse.de>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Aug 6, 2012 at 9:46 AM, Ezequiel Garcia <elezegarcia@gmail.com> wrote:
> On Mon, Aug 6, 2012 at 9:42 AM, Mauro Carvalho Chehab
> <mchehab@redhat.com> wrote:
>> Em 06-08-2012 09:28, Ezequiel Garcia escreveu:
>>> Hi Mauro,
>>>
>>> On Sat, Jul 28, 2012 at 11:18 AM, Ezequiel Garcia <elezegarcia@gmail.com> wrote:
>>>> This driver adds support for stk1160 usb bridge as used in some
>>>> video/audio usb capture devices.
>>>> It is a complete rewrite of staging/media/easycap driver and
>>>> it's expected as a future replacement.
>>>>
>>>> Cc: Mauro Carvalho Chehab <mchehab@redhat.com>
>>>> Cc: Takashi Iwai <tiwai@suse.de>
>>>> Cc: Hans Verkuil <hverkuil@xs4all.nl>
>>>> Cc: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
>>>> Signed-off-by: Ezequiel Garcia <elezegarcia@gmail.com>
>>>> ---
>>>>
>>>
>>> Did you take a look at this?
>>
>> Patchwork didn't get it[1]. Maybe the patch got mangled?
>> If so, could you please re-post?
>>
>> [1] http://patchwork.linuxtv.org/project/linux-media/list/?state=*&q=stk1160
>>

I'm preparing v8 based on v3.7...

Ezequiel.
