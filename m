Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:58646 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751413AbbHTDNt (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 19 Aug 2015 23:13:49 -0400
Date: Thu, 20 Aug 2015 00:13:43 -0300
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
	Helen Fornazier <helen.fornazier@gmail.com>,
	linux-media@vger.kernel.org
Subject: Re: VIMC: API proposal, configuring the topology through user space
Message-ID: <20150820001343.39b5f9cc@recife.lan>
In-Reply-To: <1479402.af4JO5SPSd@avalon>
References: <CAPW4XYagLAmCXpnFyzmfRjUHeTL0Q1mfcKiOCssh5o-NMZqR2w@mail.gmail.com>
	<2082947.pCFORmYODL@avalon>
	<20150818070636.22c23415@recife.lan>
	<1479402.af4JO5SPSd@avalon>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Thu, 20 Aug 2015 02:33:15 +0300
Laurent Pinchart <laurent.pinchart@ideasonboard.com> escreveu:

> Hi Mauro,
> 
> On Tuesday 18 August 2015 07:06:36 Mauro Carvalho Chehab wrote:
> > Em Tue, 18 Aug 2015 09:35:14 +0300 Laurent Pinchart escreveu:
> > > On Friday 14 August 2015 12:54:44 Hans Verkuil wrote:
> 
> [snip]
> 
> > > I think this is becoming too complex. How about considering "deploy" as a
> > > commit instead ? There would then be no need to undeploy, any modification
> > > will start a new transaction that will be applied in one go when
> > > committed. This includes removal of entities by removing the corresponding
> > > directories.
> >
> > Agreed. I would implement just a /configfs/vimc/commit file, instead of
> > /configfs/vimc/vimc1/build_topology.
> > 
> > any write to the "commit" configfs file will make all changes to all vimc
> > instances to be applied, or return an error if committing is not possible.
> 
> Wouldn't it be better to have a commit file inside each vimc[0-9]+ directory ? 
> vimc device instances are completely independent, I'd prefer having the 
> configuration API operate per-instance as well.

I have no strong preference... but see below.

> 
> > A read to it would return a message saying if the changes were committed or
> > not.
> > 
> > This way, an entire vimc instance could be removed with just:
> > 
> > 	rm -rf /configfs/vimc/vimc1
> > 
> > As we won't have unremoved files there anymore.
> 
> Some files will be automatically created by the kernel, such as the flags file 
> in link directories, or the name file in entity directories. rm -rf might thus 
> not work. That's a technical detail though, I haven't checked how configfs 
> operates.

I'm not an expert on configfs either. I guess if we can put those "extra"
files outside, then the interface will be better, as we can just use
rm -rf to remove a vimc instance.

The only big advantage I see on having a global "commit" is if we
can make rm -rf work. Still, it would be possible to have, instead,
commit_vimc0, commit_vimc1, ... in such case.

> 
> > In order to remove a
> > group of objects:
> > 	rm -rf /configfs/vimc/vimc1/[files that belong to the group]
> > 
> > The API also become simpler and clearer, IMHO.
> > 
> > Btw, as we discussed at the userspace API RFC, if we end by having a new
> > type of graph object that represents a group of objects (MEDIA_ID_T_GROUP),
> 
> Let's see about that when the userspace API will be agreed on.

Sure.

> 
> > that could be used, for example, to represent a project ARA hardware module,
> > it would be easier to remove an entire group by doing something like:
> > 
> > 	rm -rf /configfs/vimc/vimc1/obj_group_1
> 
> [snip]
> 
> > >> I misunderstood your original proposal, I thought the name of the
> > >> link_to_raw_capture_0 directory was interpreted by the driver to mean
> > >> that a link between the pad and pad 0 of the raw_capture entity should
> > >> be created. But you don't interpret the name at all.
> > >> 
> > >> I think this is confusing. Wouldn't it be easier to interpret the name
> > >> of the link directory? I.e. it has to be of the form: link_to_<entity
> > >> name>_<pad name>.
> > > 
> > > I'd rather use symlinks and no link directory at all, but then we'd have
> > > no place to specify link flags :-/ I believe that's the reason why a link
> > > directory is needed.
> > > 
> > > Maybe I worry for no reason, but interpreting the name seems to me more
> > > error- prone than using a symlink inside the link directory.
> > 
> > Yeah, using symlinks makes perfect sense to me, although I'm not so sure
> > of adding them inside the pads (/configfs/vimc/vimc0/sensor_a/pad_0/).
> > If we do that, we'll need to represent both links and backlinks, with
> > makes harder to remove them.
> 
> I don't think we need to specify both, the forward link should be enough.

Ok.

> > I would, instead, have a separate part of the configfs for the links:
> > 
> > /configfs/vimc/vimc0/links
> > 
> > 	and a link from sensor_a/pad_0 to raw_capture_1/pad_0/ would
> > be represented as:
> > 
> > ../../sensor_a/pad_0 -> /configfs/vimc/vimc0/links/link0/source
> > ../../raw_capture_1/pad_0 -> /configfs/vimc/vimc0/links/link0/sink
> > 
> > This way, if one wants to remove the link, he can do just:
> > 
> > 	rm -rf /configfs/vimc/vimc0/links/link0
> > 
> > Also, the direction of the link is properly expressed by using the
> > names "source" and "sink" there.
> 
> That's an interesting option. The drawback is that you can't easily see links 
> in the configfs entities directory tree. I'll think about it.
> 

Well, if one wants to see all links that belong to an entity
named "entity_1", linked as:

	"sensor_a" -> "entity_1" -> "raw_capture_1"

He could do:

ls -lR /configfs/vimc/vimc0/links/ |grep "entity_1"

This is actually easier than storing it inside an entity, as the above
grep will show both links:

	link1/sink -> ../sensor_a/pad0
	link2/source -> ../raw_capture_1/pad0

and will need to seek only inside the links sub-directory.

Regards,
Mauro
