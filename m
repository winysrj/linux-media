Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:63102 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752678AbeBFKPd (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 6 Feb 2018 05:15:33 -0500
Date: Tue, 6 Feb 2018 08:15:26 -0200
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
        Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: media_device.c question: can this workaround be removed?
Message-ID: <20180206081526.079a63be@vento.lan>
In-Reply-To: <20180205214838.uu6n4if5bnl6ch4k@valkosipuli.retiisi.org.uk>
References: <f4e9e722-9c73-e27c-967f-33c7e76de0d5@xs4all.nl>
        <20180205115954.j7e5npbwuyfgl5il@valkosipuli.retiisi.org.uk>
        <2291cc25-50fd-90cc-8948-6def4acc73a3@xs4all.nl>
        <20180205143039.uhlxala2vc4diysp@valkosipuli.retiisi.org.uk>
        <10d299e0-4edf-75dc-56f1-3acfb6ed719b@xs4all.nl>
        <20180205143228.728d0e73@vento.lan>
        <20180205214838.uu6n4if5bnl6ch4k@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Mon, 5 Feb 2018 23:48:38 +0200
Sakari Ailus <sakari.ailus@iki.fi> escreveu:

> Hi Mauro and Hans,

> > Adding pad index to new API is trivial, as your RFC patch pointed.
> > 
> > Changing media-ctl to fully use the new ioctl is not trivial, as it
> > was written on a non-portable way, very dependent on the kernel API
> > specifics[1]. I suspect that it is a lot more easier to add support
> > for MEDIA_IOC_SETUP_LINK to mc_nextgen_test and rename it to
> > media-ctl[2].  
> 
> libmediactl (which media-ctl uses) was intended to be the user space
> library for MC. Perhaps analogous to libv4l on V4L2.
> 
> It builds an internal state from what it queries from the kernel, it
> shouldn't be *that* difficult to change it. The API can be changed, too,
> it's not exported as a library from v4l-utils.

Yes, I saw that at the time I tried to add support for G_TOPOLOGY
on it. Have you ever seen the contrib/test/mc_nextgen_test.c code?

It was written in a way that its code could easily be changed into
a library to store/retrieve the topology.

It uses only 3 functions to get topology:

mc_open() - opens device and allocs an struct
media_get_topology() - implements support for G_TOPOLOGY
mc_close() - closes devide and frees allocated data

And provides other functions to show the retrieved data:

	media_show_graphviz()
	media_show_entities()
	media_show_interfaces()
	media_show_links()

It is not a library, but it shouldn't be hard to convert into one,
copying the relevant parts of mc_open(), media_get_topology() 
and mc_close() into libmediactl, and removing/changing a few
prints there in order to match the way libmediactl works.

The big challenge with libmediactl is that it is too bound to the
API v1. For example, extending the logic there to support links
between entities and interfaces would be a challenge, and won't
be too efficient.

So, IMHO, it is easier to get the data model and the retrieve function
from mc_nextgen_test and use it as basis for V2-compliant version of
libmediactl. All it needs (from MC API PoV) is to add support for
setting links. As it uses the data provided by G_TOPOLOGY, if we add
new fields there, it will automatically be stored inside its data
model, as there's no abstraction layer.

With regards to the subdev API part of libmediactl, that probably doesn't
need to be touched (or if it needs, it would likely be just binding stuff
with the new data model).

> 
> > 
> > [1] I tried it before working at contrib/test/mc_nextgen_test.c. The
> > internal data model used by media-ctl library was just a clone of the
> > model returned by the ioctls. Even a minimal change on the way ioctls 
> > return things (even adding new entity types) is enough to break it.  
> 
> The entity type is only used for informational purposes AFAIK. Otherwise
> it'll just say "unknown".
> 
> Don't forget that media-ctl also supports most of V4L2 sub-device API.

Yes, but that part likely doesn't require changes - of if it requires,
it would probably be minimal ones.

> > Nah, Let's not touch the old ioctls. Instead, we should stick
> > with the new API and convert (or replace) existing applications to
> > use it, as the old ioctl set can't even represent the interfaces.  
> 
> MC v2 would need better support for pad information, as well as flags. At
> least. I haven't decided yet what to think of this.

While we don't have a properties API, let's add what's needed for
media-ctl to work. If flags are needed, let's add it.

Thanks,
Mauro
