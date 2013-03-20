Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ve0-f176.google.com ([209.85.128.176]:36317 "EHLO
	mail-ve0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755469Ab3CTLLM (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 20 Mar 2013 07:11:12 -0400
Received: by mail-ve0-f176.google.com with SMTP id cz10so1242251veb.21
        for <linux-media@vger.kernel.org>; Wed, 20 Mar 2013 04:11:11 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <201303201004.05563.hverkuil@xs4all.nl>
References: <1363707694-27224-1-git-send-email-edubezval@gmail.com>
	<201303201004.05563.hverkuil@xs4all.nl>
Date: Wed, 20 Mar 2013 07:11:11 -0400
Message-ID: <CAC-25o-rJGeYnQ91E4W888Ak6GxVe9u6e0ZY-qcpfoaKNkU0hw@mail.gmail.com>
Subject: Re: [PATCH 0/4] media: si4713: minor updates
From: "edubezval@gmail.com" <edubezval@gmail.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

My last email didn't reach the list, so re-sending.

On Wed, Mar 20, 2013 at 5:04 AM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
>
> Hi Eduardo!
>
> On Tue 19 March 2013 16:41:30 Eduardo Valentin wrote:
> > Hello Mauro and Hans,
> >
> > Here are a couple of minor changes for si4713 FM transmitter driver.
>
> Thanks!

No problem!

>
> Patches 2-4 are fine, but I don't really see the point of the first patch
> (except for the last chunk which is a real improvement).
>
> The Codingstyle doesn't require such alignment, and in fact it says:
>
> "Descendants are always substantially shorter than the parent and
> are placed substantially to the right. The same applies to function
> headers
> with a long argument list."
>
> Unless Mauro thinks otherwise, I would leave all the alignment stuff alone
> and just post a version with the last chunk.
>

OK. The chunks on patch 01 are mostly to get rid of these outputs out
of checkpatch.pl --strict -f drivers/media/radio/radio-si4713.c:
CHECK: Alignment should match open parenthesis
#97: FILE: media/radio/radio-si4713.c:97:
+       strlcpy(capability->card, "Silicon Labs Si4713 Modulator",
+                               sizeof(capability->card));


> For patches 2-4:
>
> Acked-by: Hans Verkuil <hans.verkuil@cisco.com>
>


Nice! I will add your Acked-by.


> Are you still able to test the si4713 driver? Because I have patches



I see. In fact that is my next step on my todo list for si4713. I
still have an n900 that I can fetch from my drobe, so just a matter of
booting it with newer kernel.

> outstanding that I would love for someone to test for me:
>
> http://git.linuxtv.org/hverkuil/media_tree.git/shortlog/refs/heads/si4713
>
> In particular, run the latest v4l2-compliance test over it.
>


OK. I will check your branch once I get my setup done and let you know.

> Regards,
>
>         Hans
>
> >
> > These changes are also available here:
> > https://git.gitorious.org/si4713/si4713.git
> >
> > All best,
> >
> > Eduardo Valentin (4):
> >   media: radio: CodingStyle changes on si4713
> >   media: radio: correct module license (==> GPL v2)
> >   media: radio: add driver owner entry for radio-si4713
> >   media: radio: add module alias entry for radio-si4713
> >
> >  drivers/media/radio/radio-si4713.c |   57
> > ++++++++++++++++++-----------------
> >  1 files changed, 29 insertions(+), 28 deletions(-)
> >
> >




--
Eduardo Bezerra Valentin
