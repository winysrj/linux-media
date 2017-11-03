Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-io0-f194.google.com ([209.85.223.194]:53387 "EHLO
        mail-io0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754501AbdKCWRk (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 3 Nov 2017 18:17:40 -0400
Date: Fri, 3 Nov 2017 15:17:36 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Kees Cook <keescook@chromium.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sean Young <sean@mess.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        linux-media@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH v2] media: ttpci: remove autorepeat handling and use
 timer_setup
Message-ID: <20171103221736.c5stezumtwneqdgu@dtor-ws>
References: <20171025004005.hyb43h3yvovp4is2@dtor-ws>
 <20171031172758.ugfo6br344iso4ni@gofer.mess.org>
 <20171031174558.vsdpdudcwjneq2nu@gofer.mess.org>
 <20171031182236.cxrasbayon7h52mm@dtor-ws>
 <20171031200758.avdowtmcem5fnlb5@gofer.mess.org>
 <20171031201143.ziwohlwpdvc4barr@gofer.mess.org>
 <CAGXu5jLZaSDXdCVO3G1zsh3WLYaKvqm32xrJ8saBnCP8a7dZ8w@mail.gmail.com>
 <20171102235037.4gndwq5223uyv5kw@dtor-ws>
 <20171102221658.6d41bfcf@vento.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171102221658.6d41bfcf@vento.lan>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Nov 02, 2017 at 10:16:58PM -0200, Mauro Carvalho Chehab wrote:
> Em Thu, 2 Nov 2017 16:50:37 -0700
> Dmitry Torokhov <dmitry.torokhov@gmail.com> escreveu:
> 
> > On Thu, Nov 02, 2017 at 04:24:27PM -0700, Kees Cook wrote:
> > > On Tue, Oct 31, 2017 at 1:11 PM, Sean Young <sean@mess.org> wrote:  
> > > > Leave the autorepeat handling up to the input layer, and move
> > > > to the new timer API.
> > > >
> > > > Compile tested only.
> > > >
> > > > Signed-off-by: Sean Young <sean@mess.org>  
> > > 
> > > Hi! Just checking up on this... the input timer conversion is blocked
> > > by getting this sorted out, so I'd love to have something either
> > > media, input, or timer tree can carry. :)  
> > 
> > Acked-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
> > 
> > From my POV the patch is good. Mauro, do you want me to take it through
> > my tree, or maybe you could create an immutable branch off 4.14-rc5 (or
> > 6) with this commit and I will pull it in and then can apply Kees input
> > core conversion patch?
> 
> Feel free to apply it into your tree with my ack:
> 
> Acked-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>

Applied and pulled Kees' patch to the input core (dropping the timer_data
business) on top.

Thanks.

-- 
Dmitry
