Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([88.97.38.141]:45747 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755165AbeBOJuk (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 15 Feb 2018 04:50:40 -0500
Date: Thu, 15 Feb 2018 09:50:38 +0000
From: Sean Young <sean@mess.org>
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: linux-media@vger.kernel.org
Subject: Re: [GIT PULL FOR v4.17] rc changes
Message-ID: <20180215095038.edavfnuzloq44yqk@gofer.mess.org>
References: <20180212200318.cxnxro2vsqauexqz@gofer.mess.org>
 <20180214164908.5676fab1@vento.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180214164908.5676fab1@vento.lan>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Feb 14, 2018 at 04:49:08PM -0200, Mauro Carvalho Chehab wrote:
> Em Mon, 12 Feb 2018 20:03:18 +0000
> Sean Young <sean@mess.org> escreveu:
> 
> >       media: rc: unnecessary use of do_div
> > 
> > From c52920c524d96db55b9b82440504a7ec40df0b32 Mon Sep 17 00:00:00 2001
> > From: Sean Young <sean@mess.org>
> > Date: Sun, 11 Feb 2018 17:23:14 +0000
> > Subject: media: rc: unnecessary use of do_div
> > Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
> >     Mauro Carvalho Chehab <mchehab@infradead.org>
> > 
> > No need to use do_div() when the remainder is thrown away.
> 
> That's not true at all! We need do_div() every time we're dividing an u64
> number, as otherwise, it will cause link errors when built with 32 bits.

I completely missed that. Thank you!


Sean
