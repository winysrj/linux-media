Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qg0-f54.google.com ([209.85.192.54]:34326 "EHLO
	mail-qg0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750904AbcBLVi4 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 12 Feb 2016 16:38:56 -0500
Received: by mail-qg0-f54.google.com with SMTP id b67so72539681qgb.1
        for <linux-media@vger.kernel.org>; Fri, 12 Feb 2016 13:38:56 -0800 (PST)
Date: Fri, 12 Feb 2016 16:38:53 -0500 (EST)
From: Nicolas Pitre <nicolas.pitre@linaro.org>
To: Arnd Bergmann <arnd@arndb.de>
cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	linux-arm-kernel@lists.infradead.org,
	Stefan Richter <stefanr@s5r6.in-berlin.de>,
	linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [media] zl10353: use div_u64 instead of do_div
In-Reply-To: <6737272.LXr2g355Yt@wuerfel>
Message-ID: <alpine.LFD.2.20.1602121634040.13632@knanqh.ubzr>
References: <1455287246-3540549-1-git-send-email-arnd@arndb.de> <2712691.b9gkR7KMX7@wuerfel> <alpine.LFD.2.20.1602121305180.13632@knanqh.ubzr> <6737272.LXr2g355Yt@wuerfel>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, 12 Feb 2016, Arnd Bergmann wrote:

> On Friday 12 February 2016 13:21:33 Nicolas Pitre wrote:
> > This is all related to the gcc bug for which I produced a test case 
> > here:
> > 
> > http://article.gmane.org/gmane.linux.kernel.cross-arch/29801
> > 
> > Do you know if this is fixed in recent gcc?
> 
> I have a fairly recent gcc, but I also never got around to submit
> it properly.
> 
> However, I did stumble over an older patch I did now, which I could
> not remember what it was good for. It does fix the problem, and
> it seems to be a better solution.

WTF?

Hmmm... it apparently doesn't fix it if I apply this change to the gcc 
test case.


> diff --git a/include/linux/compiler.h b/include/linux/compiler.h
> index b5acbb404854..b5ff9881bef8 100644
> --- a/include/linux/compiler.h
> +++ b/include/linux/compiler.h
> @@ -148,7 +148,7 @@ void ftrace_likely_update(struct ftrace_branch_data *f, int val, int expect);
>   */
>  #define if(cond, ...) __trace_if( (cond , ## __VA_ARGS__) )
>  #define __trace_if(cond) \
> -	if (__builtin_constant_p((cond)) ? !!(cond) :			\
> +	if (__builtin_constant_p(!!(cond)) ? !!(cond) :			\
>  	({								\
>  		int ______r;						\
>  		static struct ftrace_branch_data			\
> 
> 
