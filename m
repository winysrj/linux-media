Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.irobotique.be ([92.243.18.41]:34244 "EHLO
	perceval.irobotique.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932241Ab0CaVZi (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 31 Mar 2010 17:25:38 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Frank Schaefer <fschaefer.oss@googlemail.com>
Subject: Re: [PATCH v2 1/2] v4l: Add V4L2_CID_IRIS_ABSOLUTE and V4L2_CID_IRIS_RELATIVE controls
Date: Wed, 31 Mar 2010 18:08:56 +0200
Cc: linux-media@vger.kernel.org
References: <1268917018-3458-1-git-send-email-laurent.pinchart@ideasonboard.com> <1268917018-3458-2-git-send-email-laurent.pinchart@ideasonboard.com> <4BA39794.7010208@googlemail.com>
In-Reply-To: <4BA39794.7010208@googlemail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201003311808.56687.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Frank,

On Friday 19 March 2010 16:26:12 Frank Schaefer wrote:
> Laurent Pinchart schrieb:
> > Those control, as their names imply, control the camera aperture
> > settings.
> > 
> > Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> > ---
> > 
> >  Documentation/DocBook/v4l/compat.xml      |   11 +++++++++++
> >  Documentation/DocBook/v4l/controls.xml    |   19 +++++++++++++++++++
> >  Documentation/DocBook/v4l/videodev2.h.xml |    3 +++
> >  include/linux/videodev2.h                 |    3 +++
> >  4 files changed, 36 insertions(+), 0 deletions(-)
> > 
> > diff --git a/Documentation/DocBook/v4l/compat.xml
> > b/Documentation/DocBook/v4l/compat.xml index b9dbdf9..854235b 100644
> > --- a/Documentation/DocBook/v4l/compat.xml
> > +++ b/Documentation/DocBook/v4l/compat.xml
> > @@ -2332,6 +2332,17 @@ more information.</para>
> > 
> >  	</listitem>
> >  	
> >        </orderedlist>
> >      
> >      </section>
> > 
> > +    <section>
> > +      <title>V4L2 in Linux 2.6.34</title>
> > +      <orderedlist>
> > +	<listitem>
> > +	  <para>Added
> > +<constant>V4L2_CID_IRIS_ABSOLUTE</constant> and
> > +<constant>V4L2_CID_IRIS_RELATIVE</constant> controls to the
> > +	    <link linkend="camera-controls">Camera controls class</link>.
> > +	  </para>
> > +	</listitem>
> > +      </orderedlist>
> > 
> >     </section>
> >     
> >     <section id="other">
> > 
> > diff --git a/Documentation/DocBook/v4l/controls.xml
> > b/Documentation/DocBook/v4l/controls.xml index f464506..e47999d 100644
> > --- a/Documentation/DocBook/v4l/controls.xml
> > +++ b/Documentation/DocBook/v4l/controls.xml
> > @@ -1825,6 +1825,25 @@ wide-angle direction. The zoom speed unit is
> > driver-specific.</entry>
> > 
> >  	  <row><entry></entry></row>
> >  	  
> >  	  <row>
> > 
> > +	    <entry
> > spanname="id"><constant>V4L2_CID_IRIS_ABSOLUTE</constant>&nbsp;</entry>
> > +	    <entry>integer</entry>
> > +	  </row><row><entry spanname="descr">This control sets the
> > +camera's aperture to the specified value. The unit is undefined.
> > +Larger values open the iris wider, smaller values close it.</entry>
> > +	  </row>
> > +	  <row><entry></entry></row>
> > +
> > +	  <row>
> > +	    <entry
> > spanname="id"><constant>V4L2_CID_IRIS_RELATIVE</constant>&nbsp;</entry>
> > +	    <entry>integer</entry>
> > +	  </row><row><entry spanname="descr">This control modifies the
> > +camera's aperture by the specified amount. The unit is undefined.
> > +Positive values open the iris one step further, negative values close
> > +it one step further. This is a write-only control.</entry>
> > +	  </row>
> > +	  <row><entry></entry></row>
> > +
> > +	  <row>
> > 
> >  	    <entry
> >  	    spanname="id"><constant>V4L2_CID_PRIVACY</constant>&nbsp;</entry>
> >  	    <entry>boolean</entry>
> >  	  
> >  	  </row><row><entry spanname="descr">Prevent video from being acquired
> > 
> > diff --git a/Documentation/DocBook/v4l/videodev2.h.xml
> > b/Documentation/DocBook/v4l/videodev2.h.xml index 0683259..c18dfeb
> > 100644
> > --- a/Documentation/DocBook/v4l/videodev2.h.xml
> > +++ b/Documentation/DocBook/v4l/videodev2.h.xml
> > @@ -1271,6 +1271,9 @@ enum  <link
> > linkend="v4l2-exposure-auto-type">v4l2_exposure_auto_type</link> {
> > 
> >  #define V4L2_CID_PRIVACY                       
> >  (V4L2_CID_CAMERA_CLASS_BASE+16)
> > 
> > +#define V4L2_CID_IRIS_ABSOLUTE                 
> > (V4L2_CID_CAMERA_CLASS_BASE+17) +#define V4L2_CID_IRIS_RELATIVE         
> >         (V4L2_CID_CAMERA_CLASS_BASE+18) +
> > 
> >  /* FM Modulator class control IDs */
> >  #define V4L2_CID_FM_TX_CLASS_BASE               (V4L2_CTRL_CLASS_FM_TX |
> >  0x900) #define V4L2_CID_FM_TX_CLASS                   
> >  (V4L2_CTRL_CLASS_FM_TX | 1)
> > 
> > diff --git a/include/linux/videodev2.h b/include/linux/videodev2.h
> > index 3c26560..c9d2120 100644
> > --- a/include/linux/videodev2.h
> > +++ b/include/linux/videodev2.h
> > @@ -1277,6 +1277,9 @@ enum  v4l2_exposure_auto_type {
> > 
> >  #define V4L2_CID_PRIVACY			(V4L2_CID_CAMERA_CLASS_BASE+16)
> > 
> > +#define V4L2_CID_IRIS_ABSOLUTE			(V4L2_CID_CAMERA_CLASS_BASE+17)
> > +#define V4L2_CID_IRIS_RELATIVE			(V4L2_CID_CAMERA_CLASS_BASE+18)
> > +
> > 
> >  /* FM Modulator class control IDs */
> >  #define V4L2_CID_FM_TX_CLASS_BASE		(V4L2_CTRL_CLASS_FM_TX | 0x900)
> >  #define V4L2_CID_FM_TX_CLASS			(V4L2_CTRL_CLASS_FM_TX | 1)
> 
> Please also add proper titles to v4l2_ctrl_get_name() in v4l2-common.c.

Very good point. I'll resubmit the patches.

-- 
Regards,

Laurent Pinchart
