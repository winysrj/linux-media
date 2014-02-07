Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:42592 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750818AbaBGBUH (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 6 Feb 2014 20:20:07 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>,
	Lars-Peter Clausen <lars@metafoo.de>
Subject: Re: [PATCH 27/47] v4l: Add support for DV timings ioctls on subdev nodes
Date: Fri, 07 Feb 2014 02:21:05 +0100
Message-ID: <11225547.hIkMZ05ThT@avalon>
In-Reply-To: <52F27562.9070103@xs4all.nl>
References: <1391618558-5580-1-git-send-email-laurent.pinchart@ideasonboard.com> <1391618558-5580-28-git-send-email-laurent.pinchart@ideasonboard.com> <52F27562.9070103@xs4all.nl>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

Thank you for the comments.

On Wednesday 05 February 2014 18:31:14 Hans Verkuil wrote:
> On 02/05/2014 05:42 PM, Laurent Pinchart wrote:
> > Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> > ---
> > 
> >  .../DocBook/media/v4l/vidioc-dv-timings-cap.xml    | 27 ++++++++++++++---
> >  .../DocBook/media/v4l/vidioc-enum-dv-timings.xml   | 27 ++++++++++++++---
> >  drivers/media/v4l2-core/v4l2-subdev.c              | 15 ++++++++++++
> >  include/uapi/linux/v4l2-subdev.h                   |  5 ++++
> >  4 files changed, 63 insertions(+), 11 deletions(-)
> > 
> > diff --git a/Documentation/DocBook/media/v4l/vidioc-dv-timings-cap.xml
> > b/Documentation/DocBook/media/v4l/vidioc-dv-timings-cap.xml index
> > cd7720d..baef771 100644
> > --- a/Documentation/DocBook/media/v4l/vidioc-dv-timings-cap.xml
> > +++ b/Documentation/DocBook/media/v4l/vidioc-dv-timings-cap.xml

[snip]

> > @@ -54,10 +55,19 @@
> > 
> >        interface and may change in the future.</para>
> >      
> >      </note>
> > 
> > -    <para>To query the capabilities of the DV receiver/transmitter
> > applications can call -this ioctl and the driver will fill in the
> > structure. Note that drivers may return +    <para>To query the
> > capabilities of the DV receiver/transmitter applications +can call the
> > <constant>VIDIOC_DV_TIMINGS_CAP</constant> ioctl on a video node +and the
> > driver will fill in the structure. Note that drivers may return> 
> >  different values after switching the video input or output.</para>
> > 
> > +    <para>When implemented by the driver DV capabilities of subdevices
> > can be +queried by calling the
> > <constant>VIDIOC_SUBDEV_DV_TIMINGS_CAP</constant> ioctl +directly on a
> > subdevice node. The capabilities are specific to inputs (for DV
> > +receivers) or outputs (for DV transmitters), application must specify
> > the
>
> s/application/the application/

I've replaced "application" with "applications" to be consistent with the 
first paragraph, but I can change both if desired.

> > +desired pad number in the &v4l2-dv-timings-cap;
> > <structfield>pad</structfield> +field. Attemps to query capabilities on a
> > pad that doesn't support them will
>
> s/Attemps/Attempts/
> 
> > +return an &EINVAL;.</para>
> > +
> >      <table pgwide="1" frame="none" id="v4l2-bt-timings-cap">
> >        <title>struct <structname>v4l2_bt_timings_cap</structname></title>
> >        <tgroup cols="3">
> > @@ -127,7 +137,14 @@ different values after switching the video input or
> > output.</para>> 
> >  	  </row>
> >  	  <row>
> >  	    <entry>__u32</entry>
> > -	    <entry><structfield>reserved</structfield>[3]</entry>
> > +	    <entry><structfield>pad</structfield></entry>
> > +	    <entry>Pad number as reported by the media controller API. This
> > field
> > +	    is only used when operating on a subdevice node. When operating 
on a
> > +	    video node applications must set this field to zero.</entry>
> 
> Currently the spec says that the driver will zero the reserved array. No
> mention is made of the application having to zero it. This means that
> drivers cannot rely on what is in the pad field since apps can leave it
> uninitialized.
> 
> If we keep that behavior, then the text has to change as follows:
> 
> s/applications must set this field to zero/this field is ignored/
> 
> However, should be keep that behavior? This ioctl is still marked as
> experimental, so perhaps we should change the spec to require that reserved
> should be zeroed by applications as well. I'm not certain, to be honest.

I would vote for changing the spec and forcing applications to zero the array. 
This won't cause any regression on subdev nodes (as the ioctl is new there) or 
video nodes (where the pad number is ignored) for now. The only risk is 
applications written before the spec modification that might break later when 
the reserved field is used for a different purpose. That's very unlikely.

> 
> > +	  </row>
> > +	  <row>
> > +	    <entry>__u32</entry>
> > +	    <entry><structfield>reserved</structfield>[2]</entry>
> >  	    <entry>Reserved for future extensions. Drivers must set the array 
to
> >  	    zero.</entry>>  	  
> >  	  </row>
> >  	  <row>
> > diff --git a/Documentation/DocBook/media/v4l/vidioc-enum-dv-timings.xml
> > b/Documentation/DocBook/media/v4l/vidioc-enum-dv-timings.xml index
> > b3e17c1..e55df46 100644
> > --- a/Documentation/DocBook/media/v4l/vidioc-enum-dv-timings.xml
> > +++ b/Documentation/DocBook/media/v4l/vidioc-enum-dv-timings.xml

[snip]

> > @@ -82,7 +90,14 @@ application.</entry>
> >  	  </row>
> >  	  <row>
> >  	    <entry>__u32</entry>
> > -	    <entry><structfield>reserved</structfield>[3]</entry>
> > +	    <entry><structfield>pad</structfield></entry>
> > +	    <entry>Pad number as reported by the media controller API. This
> > field
> > +	    is only used when operating on a subdevice node. When operating 
on a
> > +	    video node applications must set this field to zero.</entry>
> > +	  </row>
> > +	  <row>
> > +	    <entry>__u32</entry>
> > +	    <entry><structfield>reserved</structfield>[2]</entry>
> >  	    <entry>Reserved for future extensions. Drivers must set the array 
> >  	    to zero.</entry>
>
> This needs to change to:
> 
> "Drivers and applications must set the array to zero."
> 
> The description section for this ioctl clearly states that applications must
> zero the array, so this field description is not correct.

OK, I'll fix that.
 
> >  	  </row>
> >  	  <row>

[snip]

-- 
Regards,

Laurent Pinchart

