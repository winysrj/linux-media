Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:60759 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753183AbaKPOGu (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 16 Nov 2014 09:06:50 -0500
Date: Sun, 16 Nov 2014 16:06:16 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH 1/3] v4l: Clean up sub-device format documentation
Message-ID: <20141116140616.GK8907@valkosipuli.retiisi.org.uk>
References: <1415487872-27500-1-git-send-email-sakari.ailus@iki.fi>
 <1415487872-27500-2-git-send-email-sakari.ailus@iki.fi>
 <5465BD6F.8030208@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5465BD6F.8030208@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On Fri, Nov 14, 2014 at 09:29:35AM +0100, Hans Verkuil wrote:
> Two small notes...
> 
> On 11/09/2014 12:04 AM, Sakari Ailus wrote:
> > The sub-device format documentation documented scaling configuration through
> > formats. Instead the compose selection rectangle is elsewhere documented to
> > be used for the purpose. Remove scaling related part of the documentation.
> > 
> > Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
> > ---
> >  Documentation/DocBook/media/v4l/dev-subdev.xml |  108 ++++++++++++++----------
> >  1 file changed, 62 insertions(+), 46 deletions(-)
> > 
> > diff --git a/Documentation/DocBook/media/v4l/dev-subdev.xml b/Documentation/DocBook/media/v4l/dev-subdev.xml
> > index d15aaf8..dbf9965 100644
> > --- a/Documentation/DocBook/media/v4l/dev-subdev.xml
> > +++ b/Documentation/DocBook/media/v4l/dev-subdev.xml
> > @@ -195,53 +195,59 @@
> >  	<title>Sample Pipeline Configuration</title>
> >  	<tgroup cols="3">
> >  	  <colspec colname="what"/>
> > -	  <colspec colname="sensor-0" />
> > -	  <colspec colname="frontend-0" />
> > -	  <colspec colname="frontend-1" />
> > -	  <colspec colname="scaler-0" />
> > -	  <colspec colname="scaler-1" />
> > +	  <colspec colname="sensor-0 format" />
> > +	  <colspec colname="frontend-0 format" />
> > +	  <colspec colname="frontend-1 format" />
> > +	  <colspec colname="scaler-0 format" />
> > +	  <colspec colname="scaler-0 compose" />
> > +	  <colspec colname="scaler-1 format" />
> >  	  <thead>
> >  	    <row>
> >  	      <entry></entry>
> > -	      <entry>Sensor/0</entry>
> > -	      <entry>Frontend/0</entry>
> > -	      <entry>Frontend/1</entry>
> > -	      <entry>Scaler/0</entry>
> > -	      <entry>Scaler/1</entry>
> > +	      <entry>Sensor/0 format</entry>
> > +	      <entry>Frontend/0 format</entry>
> > +	      <entry>Frontend/1 format</entry>
> > +	      <entry>Scaler/0 format</entry>
> > +	      <entry>Scaler/0 compose selection rectangle</entry>
> > +	      <entry>Scaler/1 format</entry>
> >  	    </row>
> >  	  </thead>
> >  	  <tbody valign="top">
> >  	    <row>
> >  	      <entry>Initial state</entry>
> > -	      <entry>2048x1536</entry>
> > -	      <entry>-</entry>
> > -	      <entry>-</entry>
> > -	      <entry>-</entry>
> > -	      <entry>-</entry>
> > +	      <entry>2048x1536/SGRBG8_1X8</entry>
> > +	      <entry>(default)</entry>
> > +	      <entry>(default)</entry>
> > +	      <entry>(default)</entry>
> > +	      <entry>(default)</entry>
> > +	      <entry>(default)</entry>
> >  	    </row>
> >  	    <row>
> > -	      <entry>Configure frontend input</entry>
> > -	      <entry>2048x1536</entry>
> > -	      <entry><emphasis>2048x1536</emphasis></entry>
> > -	      <entry><emphasis>2046x1534</emphasis></entry>
> > -	      <entry>-</entry>
> > -	      <entry>-</entry>
> > +	      <entry>Configure frontend sink format</entry>
> > +	      <entry>2048x1536/SGRBG8_1X8</entry>
> > +	      <entry><emphasis>2048x1536/SGRBG8_1X8</emphasis></entry>
> > +	      <entry><emphasis>2046x1534/SGRBG8_1X8</emphasis></entry>
> > +	      <entry>(default)</entry>
> > +	      <entry>(default)</entry>
> > +	      <entry>(default)</entry>
> >  	    </row>
> >  	    <row>
> > -	      <entry>Configure scaler input</entry>
> > -	      <entry>2048x1536</entry>
> > -	      <entry>2048x1536</entry>
> > -	      <entry>2046x1534</entry>
> > -	      <entry><emphasis>2046x1534</emphasis></entry>
> > -	      <entry><emphasis>2046x1534</emphasis></entry>
> > +	      <entry>Configure scaler sink format</entry>
> > +	      <entry>2048x1536/SGRBG8_1X8</entry>
> > +	      <entry>2048x1536/SGRBG8_1X8</entry>
> > +	      <entry>2046x1534/SGRBG8_1X8</entry>
> > +	      <entry><emphasis>2046x1534/SGRBG8_1X8</emphasis></entry>
> > +	      <entry><emphasis>0,0/2046x1534</emphasis></entry>
> > +	      <entry><emphasis>2046x1534/SGRBG8_1X8</emphasis></entry>
> >  	    </row>
> >  	    <row>
> > -	      <entry>Configure scaler output</entry>
> > -	      <entry>2048x1536</entry>
> > -	      <entry>2048x1536</entry>
> > -	      <entry>2046x1534</entry>
> > -	      <entry>2046x1534</entry>
> > -	      <entry><emphasis>1280x960</emphasis></entry>
> > +	      <entry>Configure scaler sink compose selection</entry>
> > +	      <entry>2048x1536/SGRBG8_1X8</entry>
> > +	      <entry>2048x1536/SGRBG8_1X8</entry>
> > +	      <entry>2046x1534/SGRBG8_1X8</entry>
> > +	      <entry>2046x1534/SGRBG8_1X8</entry>
> > +	      <entry><emphasis>0,0/1280x960</emphasis></entry>
> > +	      <entry><emphasis>1280x960/SGRBG8_1X8</emphasis></entry>
> >  	    </row>
> >  	  </tbody>
> >  	</tgroup>
> > @@ -249,19 +255,29 @@
> >  
> >        <para>
> >        <orderedlist>
> > -	<listitem><para>Initial state. The sensor output is set to its native 3MP
> > -	resolution. Resolutions on the host frontend and scaler input and output
> > -	pads are undefined.</para></listitem>
> > -	<listitem><para>The application configures the frontend input pad resolution to
> > -	2048x1536. The driver propagates the format to the frontend output pad.
> > -	Note that the propagated output format can be different, as in this case,
> > -	than the input format, as the hardware might need to crop pixels (for
> > -	instance when converting a Bayer filter pattern to RGB or YUV).
> 
> Does this Bayer filter note no longer apply?

Cropping is out of scope as it requires using the selection API. I can add
this where selections are discussed in more detail, if you think it's
relevant. IMO this may be a property of a particular piece of hardware, and
there are a lot more reasons to crop a a few pixels than just that.

> > </para></listitem>
> > -	<listitem><para>The application configures the scaler input pad resolution to
> > -	2046x1534 to match the frontend output resolution. The driver propagates
> > -	the format to the scaler output pad.</para></listitem>
> > -	<listitem><para>The application configures the scaler output pad resolution to
> > -	1280x960.</para></listitem>
> > +	<listitem><para>Initial state. The sensor source pad format is
> > +	set to its native 3MP size and V4L2_MBUS_FMT_SGRBG8_1X8
> > +	media bus code. Formats on the host frontend and scaler sink
> > +	and source pads have the default values, as well as the
> > +	compose rectangle on the scaler's sind pad.</para></listitem>
> 
> sind -> sink

I'll fix that.

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
