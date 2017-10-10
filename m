Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:52680 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1756609AbdJJWlD (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 10 Oct 2017 18:41:03 -0400
Date: Wed, 11 Oct 2017 01:41:00 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>
Subject: Re: [PATCH v7 5/7] media: open.rst: Adjust some terms to match the
 glossary
Message-ID: <20171010224100.lfdnvzkxw457setj@valkosipuli.retiisi.org.uk>
References: <cover.1506550930.git.mchehab@s-opensource.com>
 <9a2db3c52a3d894728d6ed29681f49e8745f98a9.1506550930.git.mchehab@s-opensource.com>
 <20171006124822.xjppck3ks4as3zqf@valkosipuli.retiisi.org.uk>
 <20171010083743.03e8f1b9@vento.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171010083743.03e8f1b9@vento.lan>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

On Tue, Oct 10, 2017 at 08:37:43AM -0300, Mauro Carvalho Chehab wrote:
> Em Fri, 6 Oct 2017 15:48:22 +0300
> Sakari Ailus <sakari.ailus@iki.fi> escreveu:
> 
> > Hi Mauro,
> > 
> > On Wed, Sep 27, 2017 at 07:23:47PM -0300, Mauro Carvalho Chehab wrote:
> > > As we now have a glossary, some terms used on open.rst
> > > require adjustments.
> > > 
> > > Acked-by: Hans Verkuil <hans.verkuil@cisco.com>
> > > Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
> > > ---
> > >  Documentation/media/uapi/v4l/open.rst | 12 ++++++------
> > >  1 file changed, 6 insertions(+), 6 deletions(-)
> > > 
> > > diff --git a/Documentation/media/uapi/v4l/open.rst b/Documentation/media/uapi/v4l/open.rst
> > > index f603bc9b49a0..0daf0c122c19 100644
> > > --- a/Documentation/media/uapi/v4l/open.rst
> > > +++ b/Documentation/media/uapi/v4l/open.rst
> > > @@ -143,7 +143,7 @@ Related Devices
> > >  Devices can support several functions. For example video capturing, VBI
> > >  capturing and radio support.
> > >  
> > > -The V4L2 API creates different nodes for each of these functions.
> > > +The V4L2 API creates different V4L2 device nodes for each of these functions.  
> > 
> > A V4L2 device node is an instance of the V4L2 API. At the very least we
> > should call them "V4L2 device node types", not device nodes only. This
> > simply would suggests they're separate.
> 
> OK, I added "types" there.
> 
> > 
> > s/creates/defines/ ?
> 
> It is meant to say create.
> 
> A device that supports both radio, video and VBI for the same V4L2
> input will create three device nodes:
> 	/dev/video0
> 	/dev/radio0
> 	/dev/vbi0
> 
> As all are associated to the same video input, and an ioctl send 
> to one device may affect the other devices too, as they all associated
> with the same hardware.

Right. In this case I'd change the sentence. What would you think of this?

"Each of these functions is available via separate V4L2 device node."

For it's not the V4L2 API that creates them. I failed to grasp what the
original sentence meant. Was it about API, or framework, or were the
devices nodes just separate or unlike as well?

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi
