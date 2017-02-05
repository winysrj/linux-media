Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:59191
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1750851AbdBEWWj (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Sun, 5 Feb 2017 17:22:39 -0500
Date: Sun, 5 Feb 2017 20:22:31 -0200
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Sean Young <sean@mess.org>, linux-media@vger.kernel.org
Subject: Re: linux-next: build failure after merge of the v4l-dvb tree
Message-ID: <20170205202231.55ef80ff@vento.lan>
In-Reply-To: <20170206091914.56836dd3@canb.auug.org.au>
References: <20170131115505.3f8c769b@canb.auug.org.au>
        <20170203092446.7e86e8af@canb.auug.org.au>
        <20170202204620.75b20605@vento.lan>
        <20170203095934.2bbbbf45@canb.auug.org.au>
        <20170202212440.5e514ebc@vento.lan>
        <20170203110117.4a0c5628@canb.auug.org.au>
        <20170202222435.2798402e@vento.lan>
        <20170206091914.56836dd3@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Mon, 6 Feb 2017 09:19:14 +1100
Stephen Rothwell <sfr@canb.auug.org.au> escreveu:

> Hi Mauro,
> 
> On Thu, 2 Feb 2017 22:24:35 -0200 Mauro Carvalho Chehab <mchehab@osg.samsung.com> wrote:
> >
> > So, if this is not a problem to you, maybe you can setup your
> > environment to pull (in this order) from:
> > 
> > 	git://linuxtv.org/media_tree.git fixes
> > 	git://linuxtv.org/media_tree.git master
> > 	git://linuxtv.org/mchehab/media-next.git master
> > 
> > Most of the time, the last pull won't get anything.  
> 
> OK, from today I have those three trees called v4l-dvb-fixes, v4l-dvb
> and v4l-dvb-next respectively.  We'll see how it goes.

OK!

Thanks!
Mauro
