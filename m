Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:51219
	"EHLO s-opensource.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751055AbcHDQZW (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 4 Aug 2016 12:25:22 -0400
Date: Thu, 4 Aug 2016 13:25:15 -0300
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Markus Heiser <markus.heiser@darmarit.de>
Cc: Charles-Antoine Couret <charles-antoine.couret@nexvision.fr>,
	linux-media@vger.kernel.org
Subject: Re: [PATCH v2] V4L2: Add documentation for SDI timings and related
 flags
Message-ID: <20160804132515.3b3fb132@recife.lan>
In-Reply-To: <65FBAAA2-4460-4940-920A-575D01EE0923@darmarit.de>
References: <1470325151-14522-1-git-send-email-charles-antoine.couret@nexvision.fr>
	<65FBAAA2-4460-4940-920A-575D01EE0923@darmarit.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Thu, 4 Aug 2016 18:04:50 +0200
Markus Heiser <markus.heiser@darmarit.de> escreveu:

> Am 04.08.2016 um 17:39 schrieb Charles-Antoine Couret <charles-antoine.couret@nexvision.fr>:
> 
> > Signed-off-by: Charles-Antoine Couret <charles-antoine.couret@nexvision.fr>
> > ---
> > Documentation/media/uapi/v4l/vidioc-enuminput.rst  | 31 +++++++++++++++++-----
> > .../media/uapi/v4l/vidioc-g-dv-timings.rst         | 16 +++++++++++
> > 2 files changed, 40 insertions(+), 7 deletions(-)
> > 
> > diff --git a/Documentation/media/uapi/v4l/vidioc-enuminput.rst b/Documentation/media/uapi/v4l/vidioc-enuminput.rst
> > index 5060f54..18331b9 100644
> > --- a/Documentation/media/uapi/v4l/vidioc-enuminput.rst
> > +++ b/Documentation/media/uapi/v4l/vidioc-enuminput.rst
> > @@ -260,17 +260,34 @@ at index zero, incrementing by one until the driver returns ``EINVAL``.
> > 
> >    -  .. row 11
> > 
> > -       -  :cspan:`2` Digital Video
> > +       -  ``V4L2_IN_ST_NO_V_LOCK``
> > +
> > +       -  0x00000400
> > +
> > +       -  No vertical sync lock.
> > 
> >    -  .. row 12
> > 
> > +       -  ``V4L2_IN_ST_NO_STD_LOCK``
> > +
> > +       -  0x00000800
> > +
> > +       -  No standard format lock in case of auto-detection format
> > +	  by the component.
> > +
> > +    -  .. row 13
> > +
> > +       -  :cspan:`2` Digital Video
> > +
> > +    -  .. row 14
> > +
> >       -  ``V4L2_IN_ST_NO_SYNC``
> > 
> >       -  0x00010000
> > 
> >       -  No synchronization lock.
> > 
> > -    -  .. row 13
> > +    -  .. row 15  
> 
> Hi Charles,
> 
> you don't need to continue the "row nn" comments. These row-numbering 
> comes from the migration tool when we migrated from DocBook.
> 
> @Mauro: may it is the best, we drop all these "row nn" comments?

For now, let's just keep it. I'll address it later. On several
tables, the best way would actually to replace the "row \d" comment
by a reference, like:

    -  .. _v4l2-in-st-no-sync:

      -  ``V4L2_IN_ST_NO_SYNC``

      -  0x00010000


and then fix the cross-references at the videodev2.h file, removing
the exceptions at the videodev2.h.rst.exceptions file.

I intend to take care of it for 4.9.

-- 
Thanks,
Mauro
