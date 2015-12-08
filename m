Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:46809 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750986AbbLHSEg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 8 Dec 2015 13:04:36 -0500
Date: Tue, 8 Dec 2015 16:04:30 -0200
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org
Subject: Re: [PATCH v8 41/55] [media] DocBook: update descriptions for the
 media controller entities
Message-ID: <20151208160430.20ed8203@recife.lan>
In-Reply-To: <2014911.aPaHEit1JK@avalon>
References: <ec40936d7349f390dd8b73b90fa0e0708de596a9.1441540862.git.mchehab@osg.samsung.com>
	<00369c40b69f5ce1473d98398e32a7842cf28366.1441540862.git.mchehab@osg.samsung.com>
	<55F2D37A.2060503@xs4all.nl>
	<2014911.aPaHEit1JK@avalon>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Sun, 06 Dec 2015 03:00:57 +0200
Laurent Pinchart <laurent.pinchart@ideasonboard.com> escreveu:

> Hello,
> 
> On Friday 11 September 2015 15:13:30 Hans Verkuil wrote:
> > On 09/06/2015 02:03 PM, Mauro Carvalho Chehab wrote:
> > > Cleanup the media controller entities description:
> > > - remove MEDIA_ENT_T_DEVNODE and MEDIA_ENT_T_V4L2_SUBDEV entity
> > >   types, as they don't mean anything;
> > > - add MEDIA_ENT_T_UNKNOWN with a proper description;
> > > - remove ALSA and FB entity types. Those should not be used, as
> > >   the types are deprecated. We'll soon be adidng ALSA, but with
> > >   a different entity namespace;
> > > - improve the description of some entities.
> > > 
> > > Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
> > > 
> > > diff --git a/Documentation/DocBook/media/v4l/media-ioc-enum-entities.xml
> > > b/Documentation/DocBook/media/v4l/media-ioc-enum-entities.xml index
> > > 32a783635649..bc101516e372 100644
> > > --- a/Documentation/DocBook/media/v4l/media-ioc-enum-entities.xml
> > > +++ b/Documentation/DocBook/media/v4l/media-ioc-enum-entities.xml
> > > @@ -179,70 +179,65 @@
> > >          <colspec colname="c2"/>
> > >  	<tbody valign="top">
> > >  	  <row>
> > > -	    <entry><constant>MEDIA_ENT_T_DEVNODE</constant></entry>
> > > -	    <entry>Unknown device node</entry>
> > > +	    <entry><constant>MEDIA_ENT_T_UNKNOWN</constant> and
> > > <constant>MEDIA_ENT_T_V4L2_SUBDEV_UNKNOWN</constant></entry> +	   
> > > <entry>Unknown entity. That generally indicates that
> > > +	    a driver didn't initialize properly the entity, with is a Kernel
> > > bug</entry>> 
> > >  	  </row>
> > 
> > I'm wondering: if userspace should never see an unknown entity, wouldn't it
> > be better to move these UNKNOWN defines out of the public header to a kernel
> > header and drop this from the documentation?
> 
> And shouldn't the bug be caught in kernelspace before it reaches the user ?

I don't like the idea of moving this to a Kernel header.

Yes, ideally, the user should never saw this, but IMHO, programs
should address this somehow, instead of simply crashing if such value
is found. Also, keeping this at documentation helps to inform developers
that this value is invalid and should never be present on any driver.

It should be noticed that getting rid of MEDIA_ENT_T_V4L2_SUBDEV_UNKNOWN
is not easy, and should be addressed on a separate patchset. It
requires each driver maintainer to check and fix the non-initialized
subdevices, and add new definitions at the public header. This will take
a while, and such work is independent on the actual MC next gen
patch series.

So, better to keep it documented there, at least while we're not
able to enforce the Kernel do do a BUG_ON() or something similar
if a driver doesn't fill the entity type/function.

> 
> > >  	  <row>
> > >  	    <entry><constant>MEDIA_ENT_T_V4L2_VIDEO</constant></entry>
> > > -	    <entry>V4L video, radio or vbi device node</entry>
> > > +	    <entry>V4L video streaming input or output entity</entry>
> > >  	  </row>
> > > -	  <row>
> > > -	    <entry><constant>MEDIA_ENT_T_DEVNODE_FB</constant></entry>
> > > -	    <entry>Frame buffer device node</entry>
> > > +	    <entry><constant>MEDIA_ENT_T_V4L2_VBI</constant></entry>
> > > +	    <entry>V4L VBI streaming input or output entity</entry>
> > >  	  </row>
> > > -	  <row>
> > > -	    <entry><constant>MEDIA_ENT_T_DEVNODE_ALSA</constant></entry>
> > > -	    <entry>ALSA card</entry>
> > > +	    <entry><constant>MEDIA_ENT_T_V4L2_SWRADIO</constant></entry>
> > > +	    <entry>V4L Sofware Digital Radio (SDR) streaming input or output
> > > entity</entry>
> >
> > s/Sofware/Software/
> > 
> > >  	  </row>
> > >  	  <row>
> > >  	    <entry><constant>MEDIA_ENT_T_DVB_DEMOD</constant></entry>
> > > -	    <entry>DVB frontend devnode</entry>
> > > +	    <entry>DVB demodulator entity</entry>
> > >  	  </row>
> > >  	  <row>
> > >  	    <entry><constant>MEDIA_ENT_T_DVB_DEMUX</constant></entry>
> > > -	    <entry>DVB demux devnode</entry>
> > > +	    <entry>DVB demux entity. Could be implemented on hardware or in
> > > Kernelspace</entry>
> 
> s/Could be/Can be/
> 
> > s/on/in/
> > 
> > >  	  </row>
> > >  	  <row>
> > >  	    <entry><constant>MEDIA_ENT_T_DVB_TSOUT</constant></entry>
> > > -	    <entry>DVB DVR devnode</entry>
> > > +	    <entry>DVB Transport Stream output entity</entry>
> > >  	  </row>
> > >  	  <row>
> > >  	    <entry><constant>MEDIA_ENT_T_DVB_CA</constant></entry>
> > > -	    <entry>DVB CAM devnode</entry>
> > > +	    <entry>DVB Conditional Access module (CAM) entity</entry>
> > >  	  </row>
> > >  	  <row>
> > >  	    
> <entry><constant>MEDIA_ENT_T_DVB_DEMOD_NET_DECAP</constant></entry>
> > > -	    <entry>DVB network devnode</entry>
> > > -	  </row>
> > > -	  <row>
> > > -	    <entry><constant>MEDIA_ENT_T_V4L2_SUBDEV</constant></entry>
> > > -	    <entry>Unknown V4L sub-device</entry>
> > > +	    <entry>DVB network ULE/MLE desencapsulation entity. Could be
> > > implemented on hardware or in Kernelspace</entry>
> 
> s/Could be/Can be/
> 
> > s/on/in/
> > 
> > Hmm, is desencapsulation correct? Could it be 'de-encapsulation' instead? It
> > looks weird.
> >
> > >  	  </row>
> > >  	  <row>
> > >  	    
> <entry><constant>MEDIA_ENT_T_V4L2_SUBDEV_SENSOR</constant></entry>
> > > -	    <entry>Video sensor</entry>
> > > +	    <entry>Camera video sensor entity</entry>
> 
> s/video sensor/image sensor/
> 
> > >  	  </row>
> > >  	  <row>
> > >  	    <entry><constant>MEDIA_ENT_T_V4L2_SUBDEV_FLASH</constant></entry>
> > > -	    <entry>Flash controller</entry>
> > > +	    <entry>Flash controller entity</entry>
> > >  	  </row>
> > >  	  <row>
> > >  	    <entry><constant>MEDIA_ENT_T_V4L2_SUBDEV_LENS</constant></entry>
> > > -	    <entry>Lens controller</entry>
> > > +	    <entry>Lens controller entity</entry>
> > >  	  </row>
> > >  	  <row>
> > >  	    
> <entry><constant>MEDIA_ENT_T_V4L2_SUBDEV_DECODER</constant></entry>
> > > -	    <entry>Video decoder, the basic function of the video decoder is 
> to
> > > -	    accept analogue video from a wide variety of sources such as
> > > +	    <entry>Analog video decoder, the basic function of the video 
> decoder
> > > +	    is to accept analogue video from a wide variety of sources such 
> as
> > >  	    broadcast, DVD players, cameras and video cassette recorders, in
> > > -	    either NTSC, PAL or HD format and still occasionally SECAM, 
> separate
> > > -	    it into its component parts, luminance and chrominance, and 
> output
> > > +	    either NTSC, PAL, SECAM or HD format, separating the stream
> > > +	    into its component parts, luminance and chrominance, and output
> > >  	    it in some digital video standard, with appropriate embedded 
> timing
> > >  	    signals.</entry>
> 
> Does timing signals refer to synchronization signals ? They don't have to be 
> embedded, do they ?
> 
> > >  	  </row>
> > >  	  <row>
> > >  	    <entry><constant>MEDIA_ENT_T_V4L2_SUBDEV_TUNER</constant></entry>
> > > -	    <entry>TV and/or radio tuner</entry>
> > > +	    <entry>Digital TV, analog TV, radio and/or software radio
> > > tuner</entry>> 
> > >  	  </row>
> > >  	</tbody>
> > >        </tgroup>
> 

Changes done.

New patch follows.

>From 88a5f01638adaf0c5f0fe2dfb34b3a68a2997d8a Mon Sep 17 00:00:00 2001
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Date: Thu, 7 May 2015 22:12:40 -0300
Subject: [media] DocBook: update descriptions for the media controller
 entities
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
    Mauro Carvalho Chehab <mchehab@infradead.org>

Cleanup the media controller entities description:
- remove MEDIA_ENT_T_DEVNODE and MEDIA_ENT_T_V4L2_SUBDEV entity
  types, as they don't mean anything;
- add MEDIA_ENT_T_UNKNOWN with a proper description;
- remove ALSA and FB entity types. Those should not be used, as
  the types are deprecated. We'll soon be adidng ALSA, but with
  a different entity namespace;
- improve the description of some entities.

Change-Id: I0db7672809b567e04a5f367ff6b31315f7b7be8a
Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
---
 Documentation/DocBook/media/v4l/media-ioc-enum-entities.xml |   49 +++++-------
 1 file changed, 22 insertions(+), 27 deletions(-)

--- patchwork.orig/Documentation/DocBook/media/v4l/media-ioc-enum-entities.xml
+++ patchwork/Documentation/DocBook/media/v4l/media-ioc-enum-entities.xml
@@ -179,70 +179,65 @@
         <colspec colname="c2"/>
 	<tbody valign="top">
 	  <row>
-	    <entry><constant>MEDIA_ENT_T_DEVNODE</constant></entry>
-	    <entry>Unknown device node</entry>
+	    <entry><constant>MEDIA_ENT_T_UNKNOWN</constant> and <constant>MEDIA_ENT_T_V4L2_SUBDEV_UNKNOWN</constant></entry>
+	    <entry>Unknown entity. That generally indicates that
+	    a driver didn't initialize properly the entity, with is a Kernel bug</entry>
 	  </row>
 	  <row>
 	    <entry><constant>MEDIA_ENT_T_V4L2_VIDEO</constant></entry>
-	    <entry>V4L video, radio or vbi device node</entry>
+	    <entry>V4L video streaming input or output entity</entry>
 	  </row>
-	  <row>
-	    <entry><constant>MEDIA_ENT_T_DEVNODE_FB</constant></entry>
-	    <entry>Frame buffer device node</entry>
+	    <entry><constant>MEDIA_ENT_T_V4L2_VBI</constant></entry>
+	    <entry>V4L VBI streaming input or output entity</entry>
 	  </row>
-	  <row>
-	    <entry><constant>MEDIA_ENT_T_DEVNODE_ALSA</constant></entry>
-	    <entry>ALSA card</entry>
+	    <entry><constant>MEDIA_ENT_T_V4L2_SWRADIO</constant></entry>
+	    <entry>V4L Software Digital Radio (SDR) streaming input or output entity</entry>
 	  </row>
 	  <row>
 	    <entry><constant>MEDIA_ENT_T_DVB_DEMOD</constant></entry>
-	    <entry>DVB frontend devnode</entry>
+	    <entry>DVB demodulator entity</entry>
 	  </row>
 	  <row>
 	    <entry><constant>MEDIA_ENT_T_DVB_DEMUX</constant></entry>
-	    <entry>DVB demux devnode</entry>
+	    <entry>DVB demux entity. Can be implemented in hardware or in Kernelspace</entry>
 	  </row>
 	  <row>
 	    <entry><constant>MEDIA_ENT_T_DVB_TSOUT</constant></entry>
-	    <entry>DVB DVR devnode</entry>
+	    <entry>DVB Transport Stream output entity</entry>
 	  </row>
 	  <row>
 	    <entry><constant>MEDIA_ENT_T_DVB_CA</constant></entry>
-	    <entry>DVB CAM devnode</entry>
+	    <entry>DVB Conditional Access module (CAM) entity</entry>
 	  </row>
 	  <row>
 	    <entry><constant>MEDIA_ENT_T_DVB_DEMOD_NET_DECAP</constant></entry>
-	    <entry>DVB network devnode</entry>
-	  </row>
-	  <row>
-	    <entry><constant>MEDIA_ENT_T_V4L2_SUBDEV</constant></entry>
-	    <entry>Unknown V4L sub-device</entry>
+	    <entry>DVB network ULE/MLE de-encapsulation entity. Can be implemented in hardware or in Kernelspace</entry>
 	  </row>
 	  <row>
 	    <entry><constant>MEDIA_ENT_T_V4L2_SUBDEV_SENSOR</constant></entry>
-	    <entry>Video sensor</entry>
+	    <entry>Camera image sensor entity</entry>
 	  </row>
 	  <row>
 	    <entry><constant>MEDIA_ENT_T_V4L2_SUBDEV_FLASH</constant></entry>
-	    <entry>Flash controller</entry>
+	    <entry>Flash controller entity</entry>
 	  </row>
 	  <row>
 	    <entry><constant>MEDIA_ENT_T_V4L2_SUBDEV_LENS</constant></entry>
-	    <entry>Lens controller</entry>
+	    <entry>Lens controller entity</entry>
 	  </row>
 	  <row>
 	    <entry><constant>MEDIA_ENT_T_V4L2_SUBDEV_DECODER</constant></entry>
-	    <entry>Video decoder, the basic function of the video decoder is to
-	    accept analogue video from a wide variety of sources such as
+	    <entry>Analog video decoder, the basic function of the video decoder
+	    is to accept analogue video from a wide variety of sources such as
 	    broadcast, DVD players, cameras and video cassette recorders, in
-	    either NTSC, PAL or HD format and still occasionally SECAM, separate
-	    it into its component parts, luminance and chrominance, and output
-	    it in some digital video standard, with appropriate embedded timing
+	    either NTSC, PAL, SECAM or HD format, separating the stream
+	    into its component parts, luminance and chrominance, and output
+	    it in some digital video standard, with appropriate timing
 	    signals.</entry>
 	  </row>
 	  <row>
 	    <entry><constant>MEDIA_ENT_T_V4L2_SUBDEV_TUNER</constant></entry>
-	    <entry>TV and/or radio tuner</entry>
+	    <entry>Digital TV, analog TV, radio and/or software radio tuner</entry>
 	  </row>
 	</tbody>
       </tgroup>


