Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:41109 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750884AbaKQPVu (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 17 Nov 2014 10:21:50 -0500
Date: Mon, 17 Nov 2014 17:21:46 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH 2/3] v4l: Add V4L2_SEL_TGT_NATIVE_SIZE selection target
Message-ID: <20141117152146.GQ8907@valkosipuli.retiisi.org.uk>
References: <1415487872-27500-1-git-send-email-sakari.ailus@iki.fi>
 <1415487872-27500-3-git-send-email-sakari.ailus@iki.fi>
 <5465C17E.60504@xs4all.nl>
 <20141116164059.GL8907@valkosipuli.retiisi.org.uk>
 <5469C12D.2070800@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5469C12D.2070800@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On Mon, Nov 17, 2014 at 10:34:37AM +0100, Hans Verkuil wrote:
> On 11/16/2014 05:40 PM, Sakari Ailus wrote:
> > Hi Hans,
> > 
> > Thank you for the review.
> > 
> > On Fri, Nov 14, 2014 at 09:46:54AM +0100, Hans Verkuil wrote:
> >> On 11/09/2014 12:04 AM, Sakari Ailus wrote:
> >>> The V4L2_SEL_TGT_NATIVE_SIZE target is used to denote e.g. the size of a
> >>> sensor's pixel array.
> >>>
> >>> Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
> >>> ---
> >>>  Documentation/DocBook/media/v4l/selections-common.xml |    8 ++++++++
> >>>  include/uapi/linux/v4l2-common.h                      |    2 ++
> >>>  2 files changed, 10 insertions(+)
> >>>
> >>> diff --git a/Documentation/DocBook/media/v4l/selections-common.xml b/Documentation/DocBook/media/v4l/selections-common.xml
> >>> index 7502f78..5fc833a 100644
> >>> --- a/Documentation/DocBook/media/v4l/selections-common.xml
> >>> +++ b/Documentation/DocBook/media/v4l/selections-common.xml
> >>> @@ -63,6 +63,14 @@
> >>>  	    <entry>Yes</entry>
> >>>  	  </row>
> >>>  	  <row>
> >>> +	    <entry><constant>V4L2_SEL_TGT_NATIVE_SIZE</constant></entry>
> >>> +	    <entry>0x0003</entry>
> >>> +	    <entry>The native size of the device, e.g. a sensor's
> >>> +	    pixel array.</entry>
> >>
> >> You might want to state that top and left are always 0.
> > 
> > Fixed. I also added a patch to fix this in the smiapp driver --- the values
> > were uninitialised. :-P
> > 
> >>> +	    <entry>Yes</entry>
> >>> +	    <entry>Yes</entry>
> >>> +	  </row>
> >>> +	  <row>
> >>>  	    <entry><constant>V4L2_SEL_TGT_COMPOSE</constant></entry>
> >>>  	    <entry>0x0100</entry>
> >>>  	    <entry>Compose rectangle. Used to configure scaling
> >>> diff --git a/include/uapi/linux/v4l2-common.h b/include/uapi/linux/v4l2-common.h
> >>> index 2f6f8ca..1527398 100644
> >>> --- a/include/uapi/linux/v4l2-common.h
> >>> +++ b/include/uapi/linux/v4l2-common.h
> >>> @@ -43,6 +43,8 @@
> >>>  #define V4L2_SEL_TGT_CROP_DEFAULT	0x0001
> >>>  /* Cropping bounds */
> >>>  #define V4L2_SEL_TGT_CROP_BOUNDS	0x0002
> >>> +/* Native frame size */
> >>> +#define V4L2_SEL_TGT_NATIVE_SIZE	0x0003
> >>>  /* Current composing area */
> >>>  #define V4L2_SEL_TGT_COMPOSE		0x0100
> >>>  /* Default composing area */
> >>>
> >>
> >> I like this. This would also make it possible to set the 'canvas' size of an
> >> mem2mem device. Currently calling S_FMT for a mem2mem device cannot setup any
> >> scaler since there is no native size. Instead S_FMT effectively *sets* the native
> >> size. The same is true for webcams with a scaler, which is why you added this in
> >> the first place. Obviously for sensors this target is read-only, but for a mem2mem
> >> device it can be writable as well.
> >>
> >> However, to make full use of this you also need to add input and output
> >> capabilities if the native size can be set:
> >>
> >> 	V4L2_IN_CAP_NATIVE_SIZE
> >> 	V4L2_OUT_CAP_NATIVE_SIZE
> > 
> > Do you think this would require a capability flag, rather than just
> > returning an error if the target is unsettable, as we otherwise already do
> > if a selection target isn't supported? For the compound controls it's even
> > easier, you just don't have a read-only flag set in the equivalent control.
> 
> No, I really want a capability flag here. Otherwise applications would have to
> call ENUMINPUT *and* call G_SELECTION followed by S_SELECTION just to test if
> it can be set. Besides, this is also a per-input capability, so you want to get
> hold of the capabilities without having to do a S_INPUT first. I.e. you don't
> want to have to do this:
> 
> 	// pseudo code just to give the idea
> 	for (i = 0; i < max_input; i++) {
> 		struct v4l2_selection sel = { NATIVE_SIZE };
> 
> 		ioctl(S_INPUT, i);
> 		ioctl(G_SELECTION, &sel);
> 		if (ioctl(S_SELECTION, &sel))
> 			// does not support NATIVE_SIZE
> 	}

Fair enough. I'll add a patch for that.

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
