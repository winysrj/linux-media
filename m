Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud9.xs4all.net ([194.109.24.26]:60493 "EHLO
        lb2-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726057AbeJINtX (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 9 Oct 2018 09:49:23 -0400
Subject: Re: [PATCH] media: vivid: Support 480p for webcam capture
To: Keiichi Watanabe <keiichiw@chromium.org>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Cc: Kieran Bingham <kieran.bingham@ideasonboard.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Tomasz Figa <tfiga@chromium.org>,
        Ricky Liang <jcliang@chromium.org>,
        Shik Chen <shik@chromium.org>
References: <20181003070656.193854-1-keiichiw@chromium.org>
 <b2dc51d7-fc92-2e7b-3a07-55a076b95d8b@ideasonboard.com>
 <20181008140302.2239633f@coco.lan>
 <00b0a8af-b7a5-cb49-0684-0fd0efefa196@xs4all.nl>
 <20181008152348.7ef6d77e@coco.lan>
 <931ca67d-3ac6-afc1-f933-c9733d561767@xs4all.nl>
 <20181008160029.1bd1f5a8@coco.lan>
 <CAD90VcY+n_jAWqQ09JBSE==aUxNB7Yc2BNNZRGsP4jd74OW3+g@mail.gmail.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <609798e1-ab23-75d8-ddc2-40fe55cb85d3@xs4all.nl>
Date: Tue, 9 Oct 2018 08:33:57 +0200
MIME-Version: 1.0
In-Reply-To: <CAD90VcY+n_jAWqQ09JBSE==aUxNB7Yc2BNNZRGsP4jd74OW3+g@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 10/09/2018 08:01 AM, Keiichi Watanabe wrote:
> Let me back to the topic about interval.
> I'd like to send a nex version of this patch to avoid duplication of intervals.
> 
> We need to choose two intervals from the three options: 1/20, 2/25 and 1/40.
> As Mauro said, we would want to have 2/25 for a fractional rate.
> Then, I think adding 2/25 and 1/40 will work well.
> If it's okay, I will send an updated version.

Fine by me!

	Hans

> 
> Best regards,
> Kei
> 
> On Tue, Oct 9, 2018 at 4:00 AM, Mauro Carvalho Chehab
> <mchehab+samsung@kernel.org> wrote:
>> Em Mon, 8 Oct 2018 20:31:10 +0200
>> Hans Verkuil <hverkuil@xs4all.nl> escreveu:
>>
>>>> (gdb) list *vivid_fillbuff+0x1e9b
>>>> 0x1936b is in vivid_fillbuff (drivers/media/platform/vivid/vivid-kthread-cap.c:495).
>>>> 490                                 ms % 1000,
>>>> 491                                 buf->vb.sequence,
>>>> 492                                 (dev->field_cap == V4L2_FIELD_ALTERNATE) ?
>>>> 493                                         (buf->vb.field == V4L2_FIELD_TOP ?
>>>> 494                                          " top" : " bottom") : "");
>>>> 495                 tpg_gen_text(tpg, basep, line++ * line_height, 16, str);
>>>> 496         }
>>>> 497         if (dev->osd_mode == 0) {
>>>> 498                 snprintf(str, sizeof(str), " %dx%d, input %d ",
>>>> 499                                 dev->src_rect.width, dev->src_rect.height, dev->input);
>>>>
>>>
>>> There is a bug with hflip handling in that function. Nothing to do with the
>>> resolution. I could reproduce it by just checking the hflip control.
>>> I'll investigate.
>>
>> Ah! Well, as I said, I got it only once last week while trying to use
>> vivid for some event racing test. I didn't have time to actually
>> seek. On that time, the bug only manifested when I changed the frame
>> rate.
>>
>> Thanks,
>> Mauro
