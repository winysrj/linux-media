Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:44248
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752378AbdCHQpn (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 8 Mar 2017 11:45:43 -0500
Date: Wed, 8 Mar 2017 13:45:36 -0300
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Greg KH <greg@kroah.com>, Alan Cox <alan@linux.intel.com>,
        linux-media@vger.kernel.org
Subject: Re: [PATCH] atomisp2: unify some ifdef cases caused by format
 changes
Message-ID: <20170308134536.2ceeed19@vento.lan>
In-Reply-To: <2540e923-6468-a283-26ff-9e48a4f18157@xs4all.nl>
References: <148879924465.10733.17814546240558419917.stgit@acox1-desk1.ger.corp.intel.com>
        <90583522-0afb-e556-b1a6-dea0efc5392d@xs4all.nl>
        <20170308133947.GB5221@kroah.com>
        <b13609bf-0e14-685a-01a7-0ba88e15db8c@xs4all.nl>
        <2540e923-6468-a283-26ff-9e48a4f18157@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Wed, 8 Mar 2017 14:55:44 +0100
Hans Verkuil <hverkuil@xs4all.nl> escreveu:

> On 08/03/17 14:45, Hans Verkuil wrote:
> > On 08/03/17 14:39, Greg KH wrote:  
> >> On Wed, Mar 08, 2017 at 01:49:23PM +0100, Hans Verkuil wrote:  
> >>> OK, so I discovered that these patches are for a driver added to linux-next
> >>> without it ever been cross-posted to linux-media.
> >>>
> >>> To be polite, I think that's rather impolite.  
> >>
> >> They were, but got rejected due to the size :(
> >>
> >> Mauro was cc:ed directly, he knew these were coming...
> >>
> >> I can take care of the cleanup patches for now, you don't have to review
> >> them if you don't want to.  
> >
> > Please do.
> >
> > For the next time if the patches are too large: at least post a message with
> > a link to a repo for people to look at. I would like to know what's going
> > on in staging/media, especially since I will do a lot of the reviewing (at
> > least if it is a V4L2 driver) when they want to move it out of staging.  
> 
> Same issue BTW with the bcm2835 driver. That too landed in staging without
> ever being posted to the linux-media mailinglist. Size is no excuse for that
> driver since it isn't that large.

This one got posted at media ML:
	https://patchwork.linuxtv.org/project/linux-media/list/?state=*&q=2835

(patches 1/6 to 6/6)

Thanks,
Mauro
