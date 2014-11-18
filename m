Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:55430 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753300AbaKRVHQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 18 Nov 2014 16:07:16 -0500
Date: Tue, 18 Nov 2014 22:59:34 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, hans.verkuil@xs4all.nl
Subject: Re: [REVIEW PATCH v2 3/5] v4l: Add intput and output capability
 flags for native size setting
Message-ID: <20141118205934.GU8907@valkosipuli.retiisi.org.uk>
References: <1416289220-32673-1-git-send-email-sakari.ailus@iki.fi>
 <1416289220-32673-4-git-send-email-sakari.ailus@iki.fi>
 <546B09A0.7060705@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <546B09A0.7060705@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On Tue, Nov 18, 2014 at 09:56:00AM +0100, Hans Verkuil wrote:
> Hi Sakari,
> 
> A few notes:
> 
> Typo in subject: intput -> input

Will fix.

> On 11/18/14 06:40, Sakari Ailus wrote:
> > Add input and output capability flags for setting native size of the device,
> > and document them.
> > 
> > Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
> > ---
> >  Documentation/DocBook/media/v4l/vidioc-enuminput.xml  |    8 ++++++++
> >  Documentation/DocBook/media/v4l/vidioc-enumoutput.xml |    8 ++++++++
> >  include/uapi/linux/videodev2.h                        |    2 ++
> >  3 files changed, 18 insertions(+)
> > 
> > diff --git a/Documentation/DocBook/media/v4l/vidioc-enuminput.xml b/Documentation/DocBook/media/v4l/vidioc-enuminput.xml
> > index 493a39a..603fece 100644
> > --- a/Documentation/DocBook/media/v4l/vidioc-enuminput.xml
> > +++ b/Documentation/DocBook/media/v4l/vidioc-enuminput.xml
> > @@ -287,6 +287,14 @@ input/output interface to linux-media@vger.kernel.org on 19 Oct 2009.
> >  	    <entry>0x00000004</entry>
> >  	    <entry>This input supports setting the TV standard by using VIDIOC_S_STD.</entry>
> >  	  </row>
> > +	  <row>
> > +	    <entry><constant>V4L2_IN_CAP_NATIVE_SIZE</constant></entry>
> > +	    <entry>0x00000008</entry>
> > +	    <entry>This input supports setting the native size using
> > +	    the <constant>V4L2_SEL_TGT_NATIVE_SIZE</constant>
> > +	    selection target, see <xref
> > +	    linkend="v4l2-selections-common"/>.</entry>
> > +	  </row>
> 
> I would expand on this a little bit (or alternatively add that to the
> V4L2_SEL_TGT_NATIVE_SIZE documentation itself, at your discretion):

I think I'd prefer having this in the selection target documentation, as
that's something which involves this flag, not so much the capability flags.

> 
> "Setting the native size will generally only make sense for memory
> to memory devices where the software can create a canvas of a given
> size in which for example a video frame can be composed. In that case
> V4L2_SEL_TGT_NATIVE_SIZE can be used to configure the size of that
> canvas."

I'll use the text as-is.

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
