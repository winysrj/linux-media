Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([80.229.237.210]:59889 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754542AbcKJK5n (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 10 Nov 2016 05:57:43 -0500
Date: Thu, 10 Nov 2016 10:57:41 +0000
From: Sean Young <sean@mess.org>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: dib0700_core.c: uninitialized variable warning, not sure how to
 fix
Message-ID: <20161110105741.GA7346@gofer.mess.org>
References: <aa490920-cb2e-bb3d-a031-f18e6f0ded9b@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aa490920-cb2e-bb3d-a031-f18e6f0ded9b@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Nov 10, 2016 at 08:49:43AM +0100, Hans Verkuil wrote:
> The daily build produces this compiler warning:
> 
> dib0700_core.c: In function 'dib0700_rc_urb_completion':
> dib0700_core.c:787:2: warning: 'protocol' may be used uninitialized in this function [-Wmaybe-uninitialized]
>   rc_keydown(d->rc_dev, protocol, keycode, toggle);
>   ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> 
> This is indeed correct as there is a path in that function where protocol is
> uninitialized, but I lack the knowledge how this should be fixed.
> 
> Mauro, can you take a look?
> 
> It goes wrong in the switch in case RC_BIT_NEC if the first 'if' is true.
> Note that keycode is also uninitialized, but it is declared as uninitialized_var(),
> although why you would want to do that instead of just initializing it to 0 or
> something like that is a mystery to me.

This is already solved in this patch:

https://patchwork.linuxtv.org/patch/37516/


Sean
