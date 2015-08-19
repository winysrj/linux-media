Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:52718 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750767AbbHSXcM (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 19 Aug 2015 19:32:12 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
	Helen Fornazier <helen.fornazier@gmail.com>,
	linux-media@vger.kernel.org
Subject: Re: VIMC: API proposal, configuring the topology through user space
Date: Thu, 20 Aug 2015 02:33:15 +0300
Message-ID: <1479402.af4JO5SPSd@avalon>
In-Reply-To: <20150818070636.22c23415@recife.lan>
References: <CAPW4XYagLAmCXpnFyzmfRjUHeTL0Q1mfcKiOCssh5o-NMZqR2w@mail.gmail.com> <2082947.pCFORmYODL@avalon> <20150818070636.22c23415@recife.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

On Tuesday 18 August 2015 07:06:36 Mauro Carvalho Chehab wrote:
> Em Tue, 18 Aug 2015 09:35:14 +0300 Laurent Pinchart escreveu:
> > On Friday 14 August 2015 12:54:44 Hans Verkuil wrote:

[snip]

> > I think this is becoming too complex. How about considering "deploy" as a
> > commit instead ? There would then be no need to undeploy, any modification
> > will start a new transaction that will be applied in one go when
> > committed. This includes removal of entities by removing the corresponding
> > directories.
>
> Agreed. I would implement just a /configfs/vimc/commit file, instead of
> /configfs/vimc/vimc1/build_topology.
> 
> any write to the "commit" configfs file will make all changes to all vimc
> instances to be applied, or return an error if committing is not possible.

Wouldn't it be better to have a commit file inside each vimc[0-9]+ directory ? 
vimc device instances are completely independent, I'd prefer having the 
configuration API operate per-instance as well.

> A read to it would return a message saying if the changes were committed or
> not.
> 
> This way, an entire vimc instance could be removed with just:
> 
> 	rm -rf /configfs/vimc/vimc1
> 
> As we won't have unremoved files there anymore.

Some files will be automatically created by the kernel, such as the flags file 
in link directories, or the name file in entity directories. rm -rf might thus 
not work. That's a technical detail though, I haven't checked how configfs 
operates.

> In order to remove a
> group of objects:
> 	rm -rf /configfs/vimc/vimc1/[files that belong to the group]
> 
> The API also become simpler and clearer, IMHO.
> 
> Btw, as we discussed at the userspace API RFC, if we end by having a new
> type of graph object that represents a group of objects (MEDIA_ID_T_GROUP),

Let's see about that when the userspace API will be agreed on.

> that could be used, for example, to represent a project ARA hardware module,
> it would be easier to remove an entire group by doing something like:
> 
> 	rm -rf /configfs/vimc/vimc1/obj_group_1

[snip]

> >> I misunderstood your original proposal, I thought the name of the
> >> link_to_raw_capture_0 directory was interpreted by the driver to mean
> >> that a link between the pad and pad 0 of the raw_capture entity should
> >> be created. But you don't interpret the name at all.
> >> 
> >> I think this is confusing. Wouldn't it be easier to interpret the name
> >> of the link directory? I.e. it has to be of the form: link_to_<entity
> >> name>_<pad name>.
> > 
> > I'd rather use symlinks and no link directory at all, but then we'd have
> > no place to specify link flags :-/ I believe that's the reason why a link
> > directory is needed.
> > 
> > Maybe I worry for no reason, but interpreting the name seems to me more
> > error- prone than using a symlink inside the link directory.
> 
> Yeah, using symlinks makes perfect sense to me, although I'm not so sure
> of adding them inside the pads (/configfs/vimc/vimc0/sensor_a/pad_0/).
> If we do that, we'll need to represent both links and backlinks, with
> makes harder to remove them.

I don't think we need to specify both, the forward link should be enough.

> I would, instead, have a separate part of the configfs for the links:
> 
> /configfs/vimc/vimc0/links
> 
> 	and a link from sensor_a/pad_0 to raw_capture_1/pad_0/ would
> be represented as:
> 
> ../../sensor_a/pad_0 -> /configfs/vimc/vimc0/links/link0/source
> ../../raw_capture_1/pad_0 -> /configfs/vimc/vimc0/links/link0/sink
> 
> This way, if one wants to remove the link, he can do just:
> 
> 	rm -rf /configfs/vimc/vimc0/links/link0
> 
> Also, the direction of the link is properly expressed by using the
> names "source" and "sink" there.

That's an interesting option. The drawback is that you can't easily see links 
in the configfs entities directory tree. I'll think about it.

-- 
Regards,

Laurent Pinchart

