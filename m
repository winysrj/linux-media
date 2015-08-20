Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:53975 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751700AbbHTXl0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 20 Aug 2015 19:41:26 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
	Helen Fornazier <helen.fornazier@gmail.com>,
	linux-media@vger.kernel.org
Subject: Re: VIMC: API proposal, configuring the topology through user space
Date: Fri, 21 Aug 2015 02:41:23 +0300
Message-ID: <2258601.NCY3XxYnn9@avalon>
In-Reply-To: <20150820001343.39b5f9cc@recife.lan>
References: <CAPW4XYagLAmCXpnFyzmfRjUHeTL0Q1mfcKiOCssh5o-NMZqR2w@mail.gmail.com> <1479402.af4JO5SPSd@avalon> <20150820001343.39b5f9cc@recife.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

On Thursday 20 August 2015 00:13:43 Mauro Carvalho Chehab wrote:
> Em Thu, 20 Aug 2015 02:33:15 +0300 Laurent Pinchart escreveu:
> > On Tuesday 18 August 2015 07:06:36 Mauro Carvalho Chehab wrote:
> >> Em Tue, 18 Aug 2015 09:35:14 +0300 Laurent Pinchart escreveu:
> >>> On Friday 14 August 2015 12:54:44 Hans Verkuil wrote:
> >
> > [snip]
> > 
> >>> I think this is becoming too complex. How about considering "deploy"
> >>> as a commit instead ? There would then be no need to undeploy, any
> >>> modification will start a new transaction that will be applied in one
> >>> go when committed. This includes removal of entities by removing the
> >>> corresponding directories.
> >> 
> >> Agreed. I would implement just a /configfs/vimc/commit file, instead of
> >> /configfs/vimc/vimc1/build_topology.
> >> 
> >> any write to the "commit" configfs file will make all changes to all
> >> vimc instances to be applied, or return an error if committing is not
> >> possible.
> > 
> > Wouldn't it be better to have a commit file inside each vimc[0-9]+
> > directory ? vimc device instances are completely independent, I'd prefer
> > having the configuration API operate per-instance as well.
> 
> I have no strong preference... but see below.
> 
> >> A read to it would return a message saying if the changes were committed
> >> or not.
> >> 
> >> This way, an entire vimc instance could be removed with just:
> >> 	rm -rf /configfs/vimc/vimc1
> >> 
> >> As we won't have unremoved files there anymore.
> > 
> > Some files will be automatically created by the kernel, such as the flags
> > file in link directories, or the name file in entity directories. rm -rf
> > might thus not work. That's a technical detail though, I haven't checked
> > how configfs operates.
> 
> I'm not an expert on configfs either. I guess if we can put those "extra"
> files outside, then the interface will be better, as we can just use
> rm -rf to remove a vimc instance.
> 
> The only big advantage I see on having a global "commit" is if we
> can make rm -rf work. Still, it would be possible to have, instead,
> commit_vimc0, commit_vimc1, ... in such case.

I believe having the commit file inside the vimc[0-9]+ directory won't prevent 
an rmdir, but it might get in the way of rm -rf. Let's check what configfs 
allows before deciding.

By the way, the USB gadget framework uses symlinks to functions to implement 
something similar to our commit. Maybe that would be a better fit for 
configfs.

-- 
Regards,

Laurent Pinchart

