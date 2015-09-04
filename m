Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:34308 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760273AbbIDRIc (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 4 Sep 2015 13:08:32 -0400
Date: Fri, 4 Sep 2015 14:08:27 -0300
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCH v8 48/55] [media] media_device: add a topology version
 field
Message-ID: <20150904140827.424c6d81@recife.lan>
In-Reply-To: <55E4582A.5050205@xs4all.nl>
References: <cover.1440902901.git.mchehab@osg.samsung.com>
	<e8cb8de5ad8f2da3c32418d67340fe4bb663ce5c.1440902901.git.mchehab@osg.samsung.com>
	<55E448A8.6060004@xs4all.nl>
	<20150831095213.667d7a22@recife.lan>
	<55E4582A.5050205@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Mon, 31 Aug 2015 15:35:38 +0200
Hans Verkuil <hverkuil@xs4all.nl> escreveu:

> On 08/31/2015 02:52 PM, Mauro Carvalho Chehab wrote:
> > Em Mon, 31 Aug 2015 14:29:28 +0200
> > Hans Verkuil <hverkuil@xs4all.nl> escreveu:
> > 
> >> On 08/30/2015 05:06 AM, Mauro Carvalho Chehab wrote:
> >>> Every time a graph object is added or removed, the version
> >>> of the topology changes. That's a requirement for the new
> >>> MEDIA_IOC_G_TOPOLOGY, in order to allow userspace to know
> >>> that the topology has changed after a previous call to it.
> >>>
> >>> Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
> >>
> >> I think this should be postponed until we actually have dynamic reconfigurable
> >> graphs.
> > 
> > So far, we're using the term "dynamic" to mean partial graph object
> > removal.
> > 
> > But even today, MC does support "dynamic" in the sense of graph
> > object additions.
> > 
> > You should notice that having a topology_version is something that
> > IMHO, it is needed since the beginning, even without dynamic
> > reconfigurable graphs, because the graph may grow in runtime.
> > 
> > That will happen, for example, if usb-snd-audio is blacklisted
> > at /etc/modprobe*, and someone connects an au0828.
> > 
> > New entities/links will be created (after Shuah patches) if one would
> > modprobe latter snd-usb-audio.
> 
> latter -> later :-)
> 
> You are right, this would trigger a topology change. I hadn't thought about
> that.
> 
> > 
> >>
> >> I would also like to reserve version 0: if 0 is returned, then the graph is
> >> static.
> > 
> > Why? Implementing this would be really hard, as that would mean that
> > G_TOPOLOGY would need to be blocked until all drivers and subdevices
> > get probed.
> > 
> > In order to implement that, some logic would be needed at the drivers
> > to identify if everything was set and unlock G_TOPOLOGY.
> 
> That wouldn't be needed if the media device node was created last. Which
> I think is a good idea anyway.

Creating the media device node last won't work. It should be the first
thing to be created, as all objects should be added to media_device
linked lists. 

Also, the numberspace should be local to a given media_device, as the
graph traversal algorithm relies on having the number of entities <= 64,
currently, in order to be able to detect loops. We should increase that
number, but removing an "as low as possible" entity number limit is not
trivial.

> 
> > 
> > What would be the gain for that? I fail to see any.
> 
> It would tell userspace that it doesn't have to cope with dynamically
> changing graphs.
> 
> Even though with the au0828 example you can expect to see cases like that,
> I can pretty much guarantee that no generic v4l2 applications will ever
> support dynamic changes.

Well, my test app supports it and it is generic ;) My plan is to use it
as a basis for the library to be used on userspace for generic apps,
extending it to be used by other tools like xawtv, qv4l2 and the dvbv5 apps.

I don't think it is hard to handle it on a generic app, and this should
be done anyway if we want dynamic support.

The logic seems actually be simple:

at G_TOPOLOGY, if the topology changes, reload the objects;

at SETUP_LINK_V2, the topology will be sent. if the driver detects that
topology changed, it returns an error.

The caller will then need to reload the topology and re-apply the
transaction to select the links, if the entities affected still
exists. In other words, if the user's intent were to change the pipeline
to receive the data at /dev/video2, e. g. something like:
	./yavta/yavta -f UYVY -s 720x312 -n 1 --capture=1 -F /dev/video2

What userspace would do is to reload everything, check if /dev/video2
still exists and then redo the function that it is equivalent to the
above command, failing otherwise. That doesn't sound hard to implement.

> Those that will support it will be custom-made.
> 
> Being able to see that graphs can change dynamically would allow such apps
> to either refuse to use the device, or warn the user.

The way I see is that applications that will assume that the graph
is static will be the custom-made ones. As they know the hardware,
they can just either ignore the topology_version or wait for it to
stabilize when the hardware is still being probed.

In any case, if we end by needing to have an explicit way for the
Kernelspace to tell userspace that a graph is static, that could
be done via an extra flag at MEDIA_INFO.

Enabling this flag could be as easy as waiting for all graph
elements to be created (where the topology is still dynamic),
and raise such flag after finishing the probe sequence.

Regards,
Mauro
