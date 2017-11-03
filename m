Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-io0-f194.google.com ([209.85.223.194]:55251 "EHLO
        mail-io0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751805AbdKCXmK (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 3 Nov 2017 19:42:10 -0400
Received: by mail-io0-f194.google.com with SMTP id e89so9627017ioi.11
        for <linux-media@vger.kernel.org>; Fri, 03 Nov 2017 16:42:10 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20171103221736.c5stezumtwneqdgu@dtor-ws>
References: <20171025004005.hyb43h3yvovp4is2@dtor-ws> <20171031172758.ugfo6br344iso4ni@gofer.mess.org>
 <20171031174558.vsdpdudcwjneq2nu@gofer.mess.org> <20171031182236.cxrasbayon7h52mm@dtor-ws>
 <20171031200758.avdowtmcem5fnlb5@gofer.mess.org> <20171031201143.ziwohlwpdvc4barr@gofer.mess.org>
 <CAGXu5jLZaSDXdCVO3G1zsh3WLYaKvqm32xrJ8saBnCP8a7dZ8w@mail.gmail.com>
 <20171102235037.4gndwq5223uyv5kw@dtor-ws> <20171102221658.6d41bfcf@vento.lan> <20171103221736.c5stezumtwneqdgu@dtor-ws>
From: Kees Cook <keescook@chromium.org>
Date: Fri, 3 Nov 2017 16:42:09 -0700
Message-ID: <CAGXu5jJqQ54H6LAycFeq=GLinZevhUixO=hT67ehtSGqn9S4fA@mail.gmail.com>
Subject: Re: [PATCH v2] media: ttpci: remove autorepeat handling and use timer_setup
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sean Young <sean@mess.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        linux-media@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Nov 3, 2017 at 3:17 PM, Dmitry Torokhov
<dmitry.torokhov@gmail.com> wrote:
> On Thu, Nov 02, 2017 at 10:16:58PM -0200, Mauro Carvalho Chehab wrote:
>> Em Thu, 2 Nov 2017 16:50:37 -0700
>> Dmitry Torokhov <dmitry.torokhov@gmail.com> escreveu:
>>
>> > On Thu, Nov 02, 2017 at 04:24:27PM -0700, Kees Cook wrote:
>> > > On Tue, Oct 31, 2017 at 1:11 PM, Sean Young <sean@mess.org> wrote:
>> > > > Leave the autorepeat handling up to the input layer, and move
>> > > > to the new timer API.
>> > > >
>> > > > Compile tested only.
>> > > >
>> > > > Signed-off-by: Sean Young <sean@mess.org>
>> > >
>> > > Hi! Just checking up on this... the input timer conversion is blocked
>> > > by getting this sorted out, so I'd love to have something either
>> > > media, input, or timer tree can carry. :)
>> >
>> > Acked-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
>> >
>> > From my POV the patch is good. Mauro, do you want me to take it through
>> > my tree, or maybe you could create an immutable branch off 4.14-rc5 (or
>> > 6) with this commit and I will pull it in and then can apply Kees input
>> > core conversion patch?
>>
>> Feel free to apply it into your tree with my ack:
>>
>> Acked-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
>
> Applied and pulled Kees' patch to the input core (dropping the timer_data
> business) on top.

Awesome, thanks! :)

-Kees

-- 
Kees Cook
Pixel Security
