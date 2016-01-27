Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f45.google.com ([74.125.82.45]:33831 "EHLO
	mail-wm0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753160AbcA0MOv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 27 Jan 2016 07:14:51 -0500
Received: by mail-wm0-f45.google.com with SMTP id n5so25203877wmn.1
        for <linux-media@vger.kernel.org>; Wed, 27 Jan 2016 04:14:50 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <m3io2gfksk.fsf@t19.piap.pl>
References: <1451183213-2733-1-git-send-email-ezequiel@vanguardiasur.com.ar>
	<569CE27F.6090702@xs4all.nl>
	<CAAEAJfCs1fipSadLj8WyxiJd9g7MCJj1KX5UdAPx1hPt16t0VA@mail.gmail.com>
	<m31t96j8u4.fsf@t19.piap.pl>
	<CAAEAJfBM_vVBVRd3P0kJ1QLzk-M==L=x6CS0ggXgRX=7K_aK_A@mail.gmail.com>
	<m3si1kioa9.fsf@t19.piap.pl>
	<CAAEAJfC_Sa_6opADoz0Ab8NrmhX+cjNmSK_Nw_Ne9nk-ROaj0Q@mail.gmail.com>
	<m3io2gfksk.fsf@t19.piap.pl>
Date: Wed, 27 Jan 2016 09:14:49 -0300
Message-ID: <CAAEAJfDb84ZbRkq9GVOmeWp=vpn_GBX9Fx0w+aGnZ9n29PsR8A@mail.gmail.com>
Subject: Re: [PATCH] media: Support Intersil/Techwell TW686x-based video
 capture cards
From: Ezequiel Garcia <ezequiel@vanguardiasur.com.ar>
To: =?UTF-8?Q?Krzysztof_Ha=C5=82asa?= <khalasa@piap.pl>
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
	linux-media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 26 January 2016 at 12:00, Krzysztof Hałasa <khalasa@piap.pl> wrote:
> Ezequiel Garcia <ezequiel@vanguardiasur.com.ar> writes:
>
>> I reviewed the driver as soon as it was sent, and planned to submit
>> changes to support my setup once your driver was merged, but that
>> never happened.
>
> This was because you, shortly thereafter, stated:
>
>> I'm working on an improved version of the tw686x driver. I've started
>> with the patches
>> you posted and made a significant number of changes:
>
>> * Handling events in the top-half (removed bottom halves).
>> * Audio support
>> * Added CIF and D1 size support
>> * some other goodies
>> * a lot of code refactoring
>
>> I'm now working on supporting both S-G and frame modes,
>> so the driver will support INTERLACED and SEQ frames, and the
>> user will have both options.
>
>> I'll post a patchset as soon as it's working. Since I've started with
>> your patch,
>> your authorship will be retained and I'll add only my Signed-off-by.
>
> And, when I asked about merging the combined work properly:
>
>> Problem is I've re-written the driver, taking yours as a starting point
>> and reference.
>
>> In other words, I don't have a proper git branch with a history, starting
>> from the patch you submitted. Instead, I would be submitting a new
>> patch for Hans and Mauro to review.
>
>> This patch is based in yours, so AFAIK should have your signature.
>
> The latter was obviously not true - the code may retain the original
> authors and copyrights (if it hasn't been rewritten completely), but
> you have to remove the original S-O-B when you are submitting heavily
> modified code - see the rules. Signature is not copyright/authorship,
> it's who posts the code.
>
>
> This is also why separating the work helps (especially in such
> non-trivial cases) - the original code bears the original signature,
> and the subsequent changes have their own. These things are invented
> for a reason.
>
>
> I really thought you have rewritten the driver from scratch, so my
> inferior driver was of no use. In this situation submitting v2 didn't
> make sense, though obviously I haven't written a driver for nothing -
> I'm using it for my purposes.
>

Well, I kept the general organization, kept the registers definitions,
the rest was probably changed or re-written, mostly to meet
CodingStyle or to fix bugs. In any case it's hard to say, as it took
me 2 months to get that driver in a stable shape, and the
implementation changed a lot until it was stable.

On my setup, the requirement was to support an array of 2-chip cards
(16 ch per card). Ideally, it would be able to stream up to 96
channels simultaneously, in a single x86 box.

On those machines DMA scatter-gather wouldn't work because it ran out
of s-g resources (don't have the exact error here). Then I tried DMA
frame mode, which seemed to work fine until I found those unexplained
machine freezing.

As you can see in this patch, I had to use a very annoying memcpy to
avoid writing to the DMA, and also a timer to avoid resetting
registers too often.

This version of the driver passed all stress testing, and it's
installed on a lot of boxes running with long uptime.

Since I have no idea if this is a tw6869 issue or a card issue (it's
definitely not a software issue), I thought it would be important to
keep this workarounds in the mainline driver (interestingly, the
"official" windows driver also copies the buffers from the DMA buffer
to the buffer returned to the user).

>
> What other options did I have at that time?
>
>> If you want your driver merged, then you would have to submit it
>> again, addressing
>> my review comments.
>
> Well, then this is something I can do. I wonder if it would be better
> to post the raw code as a single patch, or to repost the original
> version (already reviewed) and the subsequent patches (much smaller)
> instead. Hans?
>
>> However, I have just posted a v2 and it would be nice if
>> you can review it and test it.
>
> I can review it, however I can't really test it, because my ARM-based
> systems require DMA to buffer functionality. Also, please not I'm not
> a V4L2 expert, though I have a bit of experience with low level hw.
>
>
> However, it would be much easier if you had posted an incremental patch
> set instead. Also, WRT the merging, since this turns out to be in fact
> my driver with your subsequent modifications (most of them very
> valuable, I'm sure), I'd really think we should merge the original
> driver first, and add the modifications, perhaps one-by-one, next.
>

Since your driver is not merged, there's no real benefit in my sending
me patches against it.

Also, notice that your driver from July needs a lot of work. Aside
from the review I provided back in July, you need to get rid of your
kthread, port it to the new API, and add audio.

Since I just submitted a v2 driver that seems to be ready to be
merged, how about I just add DMA s-g support so you get all the
functionality you need?

This option sounds much easier than you going through all the pain of
cleaning up your driver.

How does it sound?
-- 
Ezequiel García, VanguardiaSur
www.vanguardiasur.com.ar
