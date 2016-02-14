Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qk0-f170.google.com ([209.85.220.170]:33629 "EHLO
	mail-qk0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751580AbcBNQwN (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 14 Feb 2016 11:52:13 -0500
Received: by mail-qk0-f170.google.com with SMTP id s5so48371025qkd.0
        for <linux-media@vger.kernel.org>; Sun, 14 Feb 2016 08:52:13 -0800 (PST)
Date: Sun, 14 Feb 2016 11:52:10 -0500 (EST)
From: Nicolas Pitre <nicolas.pitre@linaro.org>
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
cc: Arnd Bergmann <arnd@arndb.de>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	Stefan Richter <stefanr@s5r6.in-berlin.de>,
	linux-media@vger.kernel.org,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Subject: Re: [PATCH] [media] zl10353: use div_u64 instead of do_div
In-Reply-To: <CAKv+Gu9YWEkArjssR9Urh0_MOR3duNOo2UNiV=tXoQNgFtDngQ@mail.gmail.com>
Message-ID: <alpine.LFD.2.20.1602141139110.13632@knanqh.ubzr>
References: <1455287246-3540549-1-git-send-email-arnd@arndb.de> <2712691.b9gkR7KMX7@wuerfel> <alpine.LFD.2.20.1602121305180.13632@knanqh.ubzr> <6737272.LXr2g355Yt@wuerfel> <CAKv+Gu8dFz28tGgQTv+WYAvKpeiFXaj8JANUFtOJwKPRsB8F5A@mail.gmail.com>
 <alpine.LFD.2.20.1602131652560.13632@knanqh.ubzr> <CAKv+Gu9YWEkArjssR9Urh0_MOR3duNOo2UNiV=tXoQNgFtDngQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, 14 Feb 2016, Ard Biesheuvel wrote:

> On 13 February 2016 at 22:57, Nicolas Pitre <nicolas.pitre@linaro.org> wrote:
> > On Sat, 13 Feb 2016, Ard Biesheuvel wrote:
> >
> >> On 12 February 2016 at 22:01, Arnd Bergmann <arnd@arndb.de> wrote:
> >> > However, I did stumble over an older patch I did now, which I could
> >> > not remember what it was good for. It does fix the problem, and
> >> > it seems to be a better solution.
> >> >
> >> >         Arnd
> >> >
> >> > diff --git a/include/linux/compiler.h b/include/linux/compiler.h
> >> > index b5acbb404854..b5ff9881bef8 100644
> >> > --- a/include/linux/compiler.h
> >> > +++ b/include/linux/compiler.h
> >> > @@ -148,7 +148,7 @@ void ftrace_likely_update(struct ftrace_branch_data *f, int val, int expect);
> >> >   */
> >> >  #define if(cond, ...) __trace_if( (cond , ## __VA_ARGS__) )
> >> >  #define __trace_if(cond) \
> >> > -       if (__builtin_constant_p((cond)) ? !!(cond) :                   \
> >> > +       if (__builtin_constant_p(!!(cond)) ? !!(cond) :                 \
> >> >         ({                                                              \
> >> >                 int ______r;                                            \
> >> >                 static struct ftrace_branch_data                        \
> >> >
> >>
> >> I remember seeing this patch, but I don't remember the exact context.
> >> But when you think about it, !!cond can be a build time constant even
> >> if cond is not, as long as you can prove statically that cond != 0. So
> >
> > You're right.  I just tested it and to my surprise gcc is smart enough
> > to figure that case out.
> >
> >> I think this change is obviously correct, and an improvement since it
> >> will remove the profiling overhead of branches that are not true
> >> branches in the first place.
> >
> > Indeed.
> >
> 
> ... and perhaps we should not evaluate cond twice either?

It is not. The value of the argument to __builtin_constant_p() is not 
itself evaluated and therefore does not produce side effects.


Nicolas
