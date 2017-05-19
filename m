Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:46188
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752320AbdESKyP (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 19 May 2017 06:54:15 -0400
Date: Fri, 19 May 2017 07:54:09 -0300
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Alan Cox <alan@linux.intel.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-media@vger.kernel.org, devel@driverdev.osuosl.org
Subject: Re: [PATCH 00/13] staging: media: atomisp queued up patches
Message-ID: <20170519075409.6d8597fa@vento.lan>
In-Reply-To: <1495125627.7848.69.camel@linux.intel.com>
References: <20170518135022.6069-1-gregkh@linuxfoundation.org>
        <20170518111010.756a13c2@vento.lan>
        <1495125627.7848.69.camel@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Thu, 18 May 2017 17:40:27 +0100
Alan Cox <alan@linux.intel.com> escreveu:

> On Thu, 2017-05-18 at 11:10 -0300, Mauro Carvalho Chehab wrote:
> > Em Thu, 18 May 2017 15:50:09 +0200
> > Greg Kroah-Hartman <gregkh@linuxfoundation.org> escreveu:
> >   
> > > 
> > > Hi Mauro,
> > > 
> > > Here's the set of accumulated atomisp staging patches that I had in
> > > my
> > > to-review mailbox.  After this, my queue is empty, the driver is
> > > all
> > > yours!  
> > 
> > Thanks!
> > 
> > Alan, please let me know if you prefer if I don't apply any of
> > such patches, otherwise I should be merging them tomorrow ;)  
> 
> I will assume you've merged them and resync the internal patch queue I
> have here to that. 

Merged, thanks! I'll also merge a patch I just sent with disables
several warnings that W=1 would otherwise turn on. They indicate
real issues there, but, as you pointed, there are much more
important tasks to to than to try fixing those warnings.

> At the moment I'm still slowly trying to unthread
> some of the fascinating layers of indirection without actually breaking
> anything.

I don't envy you trying to get some sense out of it ;-)

Good luck!

Thanks,
Mauro
