Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ob0-f175.google.com ([209.85.214.175]:35007 "EHLO
	mail-ob0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753715AbbHYKxD (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 25 Aug 2015 06:53:03 -0400
Received: by obbwr7 with SMTP id wr7so138527975obb.2
        for <linux-media@vger.kernel.org>; Tue, 25 Aug 2015 03:53:02 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <2258601.NCY3XxYnn9@avalon>
References: <CAPW4XYagLAmCXpnFyzmfRjUHeTL0Q1mfcKiOCssh5o-NMZqR2w@mail.gmail.com>
 <1479402.af4JO5SPSd@avalon> <20150820001343.39b5f9cc@recife.lan> <2258601.NCY3XxYnn9@avalon>
From: Helen Fornazier <helen.fornazier@gmail.com>
Date: Tue, 25 Aug 2015 07:52:42 -0300
Message-ID: <CAPW4XYY9utKvxhouFPpKYTRNkzGNYxBKwYoRnkF7gdcckznGQA@mail.gmail.com>
Subject: Re: VIMC: API proposal, configuring the topology through user space
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi

On Thu, Aug 20, 2015 at 8:41 PM, Laurent Pinchart
<laurent.pinchart@ideasonboard.com> wrote:
>
> Hi Mauro,
>
> On Thursday 20 August 2015 00:13:43 Mauro Carvalho Chehab wrote:
> > Em Thu, 20 Aug 2015 02:33:15 +0300 Laurent Pinchart escreveu:
> > > On Tuesday 18 August 2015 07:06:36 Mauro Carvalho Chehab wrote:
> > >> Em Tue, 18 Aug 2015 09:35:14 +0300 Laurent Pinchart escreveu:
> > >>> On Friday 14 August 2015 12:54:44 Hans Verkuil wrote:
> > >
> > > [snip]
> > >
> > >>> I think this is becoming too complex. How about considering "deploy"
> > >>> as a commit instead ? There would then be no need to undeploy, any
> > >>> modification will start a new transaction that will be applied in one
> > >>> go when committed. This includes removal of entities by removing the
> > >>> corresponding directories.
> > >>
> > >> Agreed. I would implement just a /configfs/vimc/commit file, instead of
> > >> /configfs/vimc/vimc1/build_topology.
> > >>
> > >> any write to the "commit" configfs file will make all changes to all
> > >> vimc instances to be applied, or return an error if committing is not
> > >> possible.
> > >
> > > Wouldn't it be better to have a commit file inside each vimc[0-9]+
> > > directory ? vimc device instances are completely independent, I'd prefer
> > > having the configuration API operate per-instance as well.
> >
> > I have no strong preference... but see below.
> >
> > >> A read to it would return a message saying if the changes were committed
> > >> or not.
> > >>
> > >> This way, an entire vimc instance could be removed with just:
> > >>    rm -rf /configfs/vimc/vimc1
> > >>
> > >> As we won't have unremoved files there anymore.
> > >
> > > Some files will be automatically created by the kernel, such as the flags
> > > file in link directories, or the name file in entity directories. rm -rf
> > > might thus not work. That's a technical detail though, I haven't checked
> > > how configfs operates.
> >
> > I'm not an expert on configfs either. I guess if we can put those "extra"
> > files outside, then the interface will be better, as we can just use
> > rm -rf to remove a vimc instance.
> >
> > The only big advantage I see on having a global "commit" is if we
> > can make rm -rf work. Still, it would be possible to have, instead,
> > commit_vimc0, commit_vimc1, ... in such case.
>
> I believe having the commit file inside the vimc[0-9]+ directory won't prevent
> an rmdir, but it might get in the way of rm -rf. Let's check what configfs
> allows before deciding.

rm -rf doesn't work, configfs expects rmdir. The best we can do to
remove recursively is rmdir -p vim0/entity1/pad_0, but this won't work
if there are others pads or entities folders.

A global commit file would be better to remove an instance, we could
have a script to run rmdir recursively in vimc/vimc0/ and then commit
the changes.
Otherwise, some kind of destroy command would be easier.

>
> By the way, the USB gadget framework uses symlinks to functions to implement
> something similar to our commit. Maybe that would be a better fit for
> configfs.
>
> --
> Regards,
>
> Laurent Pinchart
>

I liked the solution of having a /configfs/vimc/vimc0/links/, it seems
cleaner to me.
Inside this folder I would add a file called flags to specify the link's flags.

-- 
Helen Fornazier
