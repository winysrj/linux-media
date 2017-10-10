Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:52296 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751415AbdJJWTB (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 10 Oct 2017 18:19:01 -0400
Date: Wed, 11 Oct 2017 01:18:58 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>,
        Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [PATCH v7 1/7] media: add glossary.rst with a glossary of terms
 used at V4L2 spec
Message-ID: <20171010221857.tlf3y2to353ybwk5@valkosipuli.retiisi.org.uk>
References: <cover.1506550930.git.mchehab@s-opensource.com>
 <047245414a82a6553361b1dd3497f796855a657d.1506550930.git.mchehab@s-opensource.com>
 <20171006102229.evjyn77udfcc76gs@valkosipuli.retiisi.org.uk>
 <20171006115105.wqabs3cm34gdy3w5@valkosipuli.retiisi.org.uk>
 <20171010061339.67584102@vento.lan>
 <20171010115435.eer5yaybxdni2ck7@valkosipuli.retiisi.org.uk>
 <20171010094938.044fb335@vento.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171010094938.044fb335@vento.lan>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

On Tue, Oct 10, 2017 at 09:49:38AM -0300, Mauro Carvalho Chehab wrote:
> Em Tue, 10 Oct 2017 14:54:35 +0300
> Sakari Ailus <sakari.ailus@iki.fi> escreveu:
> 
> > On Tue, Oct 10, 2017 at 06:15:03AM -0300, Mauro Carvalho Chehab wrote:
> > > Em Fri, 6 Oct 2017 14:51:06 +0300
> > > Sakari Ailus <sakari.ailus@iki.fi> escreveu:
> > >   
> > > > Hi Mauro,
> > > > 
> > > > On Fri, Oct 06, 2017 at 01:22:29PM +0300, Sakari Ailus wrote:  
> > > > > > +    V4L2 device node
> > > > > > +	A device node that is associated to a V4L2 main driver,
> > > > > > +	as specified in :ref:`v4l2_device_naming`.    
> > > > 
> > > > I think we need to name the interface, not so much their instances.
> > > > 
> > > > How about adding:
> > > > 
> > > >     V4L2
> > > > 	Video4Linux 2 interface. The interface implemented by **V4L2 device
> > > > 	nodes**.
> > > > 
> > > > and:
> > > > 
> > > >     V4L2 device node
> > > > 	A device node implementing the **V4L2** interface.  
> > > 
> > > Not sure if I answered it already. subdev API is part of V4L2.
> > > So, a change like that would cause more harm than good ;-)  
> > 
> > Hmm. There seems to be a gap here. It'd be much easier to maintain
> > consistency in naming and definitions if V4L2 sub-device nodes were also
> > documented to be V4L2 device nodes, just as any other device nodes exposed
> > by drivers through the V4L2 framework.
> > 
> > > 
> > > The definition should let it clear that only the devnodes 
> > > implemented by the V4L2 main driver are considered as
> > > V4L2 device nodes.  
> > 
> > Why? I don't think we should make assumptions on which driver exposes a
> > device node; this is not visible to the user space after all.
> 
> Because the V4L2 spec documents, with the exception of the subdev.rst
> (and where otherwise noticed), assumes that a V4L2 device node doesn't
> include subdevs.
> 
> So, if you loo, for example, at the chapter 1 name:
> 	"common API elements"
> 
> it implies that every single V4L2 device node supports what's there.
> But that's not the case, for example, for what's described at
> Documentation/media/uapi/v4l/querycap.rst (with is part of
> chapter 1).

Ah. I see what you mean.

> 
> There are a couple of possible alternatives:
> 
> 1) define V4L2 device nodes excluding /dev/subdev, with is the
>    current approach;
> 
> 2) rewrite the entire V4L2 uAPI spec to explicitly talk, on each
>    section, if it applies or not to sub-devices;

There are exceptions in the common API elements section even now. For
instance, it mentions that radio devices don't support video streaming
related IOCTLs. Under common API elements, also the first section (opening
and closing devices) refers to the interfaces section which, as we know,
contains sub-device documentation.

Do you see that something else is needed than telling which common API
elements aren't relevant for sub-devices? (I didn't find explicit
information in other sections, by a quick glance at least, telling which
interfaces they apply to.)

Should we make such a change, this would be an additional argument for
supporting VIDIOC_QUERYCAP on sub-devices. Further on, section 8, "Common
definitions for V4L2 and V4L2 subdev interfaces", should probably be merged
with the "common API elements" section.

Just my thougts. Anyway... let's continue tomorrow.

> 
> 3) "promote" subdev API to a separate part of the media spec,
>    just like what it was done for media controller, e. g. adding
>    a /Documentation/media/uapi/subdev directory and add there
>    descriptions for all syscalls that apply to subdevs
>    (open, close, ioctl). That would be weird from kAPI point of
>    view, as splitting it from V4L2 won't make sense there. So,
>    we'll likely need to add some notes at both kAPI and uAPI to
>    explain that the subdev API userspace API is just a different
>    way to expose V4L2 hardware control, but, internally, both
>    are implemented by the same V4L2 core.
> 
> This patchset assumes (1). I'm ok if someone wants to do either
> (2) or (3), but I won't have the required time to do such
> changes.

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi
