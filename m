Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:45444 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1755221AbdJJLyi (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 10 Oct 2017 07:54:38 -0400
Date: Tue, 10 Oct 2017 14:54:35 +0300
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
Message-ID: <20171010115435.eer5yaybxdni2ck7@valkosipuli.retiisi.org.uk>
References: <cover.1506550930.git.mchehab@s-opensource.com>
 <047245414a82a6553361b1dd3497f796855a657d.1506550930.git.mchehab@s-opensource.com>
 <20171006102229.evjyn77udfcc76gs@valkosipuli.retiisi.org.uk>
 <20171006115105.wqabs3cm34gdy3w5@valkosipuli.retiisi.org.uk>
 <20171010061339.67584102@vento.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171010061339.67584102@vento.lan>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Oct 10, 2017 at 06:15:03AM -0300, Mauro Carvalho Chehab wrote:
> Em Fri, 6 Oct 2017 14:51:06 +0300
> Sakari Ailus <sakari.ailus@iki.fi> escreveu:
> 
> > Hi Mauro,
> > 
> > On Fri, Oct 06, 2017 at 01:22:29PM +0300, Sakari Ailus wrote:
> > > > +    V4L2 device node
> > > > +	A device node that is associated to a V4L2 main driver,
> > > > +	as specified in :ref:`v4l2_device_naming`.  
> > 
> > I think we need to name the interface, not so much their instances.
> > 
> > How about adding:
> > 
> >     V4L2
> > 	Video4Linux 2 interface. The interface implemented by **V4L2 device
> > 	nodes**.
> > 
> > and:
> > 
> >     V4L2 device node
> > 	A device node implementing the **V4L2** interface.
> 
> Not sure if I answered it already. subdev API is part of V4L2.
> So, a change like that would cause more harm than good ;-)

Hmm. There seems to be a gap here. It'd be much easier to maintain
consistency in naming and definitions if V4L2 sub-device nodes were also
documented to be V4L2 device nodes, just as any other device nodes exposed
by drivers through the V4L2 framework.

> 
> The definition should let it clear that only the devnodes 
> implemented by the V4L2 main driver are considered as
> V4L2 device nodes.

Why? I don't think we should make assumptions on which driver exposes a
device node; this is not visible to the user space after all.

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi
