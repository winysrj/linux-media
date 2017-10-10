Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:44095 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754894AbdJJLhy (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 10 Oct 2017 07:37:54 -0400
Date: Tue, 10 Oct 2017 08:37:43 -0300
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>
Subject: Re: [PATCH v7 5/7] media: open.rst: Adjust some terms to match the
 glossary
Message-ID: <20171010083743.03e8f1b9@vento.lan>
In-Reply-To: <20171006124822.xjppck3ks4as3zqf@valkosipuli.retiisi.org.uk>
References: <cover.1506550930.git.mchehab@s-opensource.com>
        <9a2db3c52a3d894728d6ed29681f49e8745f98a9.1506550930.git.mchehab@s-opensource.com>
        <20171006124822.xjppck3ks4as3zqf@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Fri, 6 Oct 2017 15:48:22 +0300
Sakari Ailus <sakari.ailus@iki.fi> escreveu:

> Hi Mauro,
> 
> On Wed, Sep 27, 2017 at 07:23:47PM -0300, Mauro Carvalho Chehab wrote:
> > As we now have a glossary, some terms used on open.rst
> > require adjustments.
> > 
> > Acked-by: Hans Verkuil <hans.verkuil@cisco.com>
> > Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
> > ---
> >  Documentation/media/uapi/v4l/open.rst | 12 ++++++------
> >  1 file changed, 6 insertions(+), 6 deletions(-)
> > 
> > diff --git a/Documentation/media/uapi/v4l/open.rst b/Documentation/media/uapi/v4l/open.rst
> > index f603bc9b49a0..0daf0c122c19 100644
> > --- a/Documentation/media/uapi/v4l/open.rst
> > +++ b/Documentation/media/uapi/v4l/open.rst
> > @@ -143,7 +143,7 @@ Related Devices
> >  Devices can support several functions. For example video capturing, VBI
> >  capturing and radio support.
> >  
> > -The V4L2 API creates different nodes for each of these functions.
> > +The V4L2 API creates different V4L2 device nodes for each of these functions.  
> 
> A V4L2 device node is an instance of the V4L2 API. At the very least we
> should call them "V4L2 device node types", not device nodes only. This
> simply would suggests they're separate.

OK, I added "types" there.

> 
> s/creates/defines/ ?

It is meant to say create.

A device that supports both radio, video and VBI for the same V4L2
input will create three device nodes:
	/dev/video0
	/dev/radio0
	/dev/vbi0

As all are associated to the same video input, and an ioctl send 
to one device may affect the other devices too, as they all associated
with the same hardware.

Thanks,
Mauro
