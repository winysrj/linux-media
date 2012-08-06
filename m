Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:26132 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755783Ab2HFMme (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 6 Aug 2012 08:42:34 -0400
Message-ID: <501FBBB1.1030802@redhat.com>
Date: Mon, 06 Aug 2012 09:42:25 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Ezequiel Garcia <elezegarcia@gmail.com>
CC: alsa-devel@alsa-project.org, linux-media@vger.kernel.org,
	Takashi Iwai <tiwai@suse.de>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
Subject: Re: [PATCH v7] media: Add stk1160 new driver
References: <1343485133-11090-1-git-send-email-elezegarcia@gmail.com> <CALF0-+XEStNrfdqYecKQHr=qkcFPtC5CyDC4DWWy_7+_oA0h=g@mail.gmail.com>
In-Reply-To: <CALF0-+XEStNrfdqYecKQHr=qkcFPtC5CyDC4DWWy_7+_oA0h=g@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 06-08-2012 09:28, Ezequiel Garcia escreveu:
> Hi Mauro,
> 
> On Sat, Jul 28, 2012 at 11:18 AM, Ezequiel Garcia <elezegarcia@gmail.com> wrote:
>> This driver adds support for stk1160 usb bridge as used in some
>> video/audio usb capture devices.
>> It is a complete rewrite of staging/media/easycap driver and
>> it's expected as a future replacement.
>>
>> Cc: Mauro Carvalho Chehab <mchehab@redhat.com>
>> Cc: Takashi Iwai <tiwai@suse.de>
>> Cc: Hans Verkuil <hverkuil@xs4all.nl>
>> Cc: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
>> Signed-off-by: Ezequiel Garcia <elezegarcia@gmail.com>
>> ---
>>
> 
> Did you take a look at this?

Patchwork didn't get it[1]. Maybe the patch got mangled?
If so, could you please re-post?

[1] http://patchwork.linuxtv.org/project/linux-media/list/?state=*&q=stk1160

Thanks!
Mauro

> 
> Perhaps we can discuss now you're previous comments:
> 
> 1. Place for ac97 code: media or alsa? (see Takashis' comments)
> 2. current_norm usage (see Hans' comments)
> 3. vb2_dqbuf and O_NONBLOCK flag (also see Hans' comments)
> 
> I know it's a big patch*, so there is no need to rush.
> I just wanted to discuss a bit about this before my brain-cache
> flushes completely :-)
> 
> Thanks,
> Ezequiel.
> 
> * Actually it's huge (12k lines) since I'm removing staging/easycap.
> 

