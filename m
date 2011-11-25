Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr10.xs4all.nl ([194.109.24.30]:4325 "EHLO
	smtp-vbr10.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754170Ab1KYLOj (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 25 Nov 2011 06:14:39 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: [PATCH 1/3] V4L2: Add per-device-node capabilities
Date: Fri, 25 Nov 2011 12:14:31 +0100
Cc: linux-media@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>
References: <1321956322-25084-1-git-send-email-hverkuil@xs4all.nl> <dc234659a7b513338583cb48ba9234460e52e9be.1321956058.git.hans.verkuil@cisco.com> <4ECF7328.3040706@redhat.com>
In-Reply-To: <4ECF7328.3040706@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201111251214.31645.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Friday, November 25, 2011 11:51:20 Mauro Carvalho Chehab wrote:
> Hi Hans,
> 
> I have a few notes about the wording. See bellow.
> 
> Em 22-11-2011 08:05, Hans Verkuil escreveu:
> > From: Hans Verkuil <hans.verkuil@cisco.com>
> > 
> > If V4L2_CAP_DEVICE_CAPS is set, then the new device_caps field is filled with
> > the capabilities of the opened device node.
> > 
> > The capabilities field traditionally contains the capabilities of the whole
> > device. 
> 
> Confusing. /dev/video is a "whole device", from kernel POV. 
> It should be, instead, "physical device".
> 
> Maybe it could be written as:
> 
> 	"The capabilities field traditionally contains the capabilities of the physical
> 	 device, being a superset of all capabilities available at the several device nodes."

Nice. I'll use your phrasing.

> 
> > E.g., if you open video0, then if it contains VBI caps then that means
> > that there is a corresponding vbi node as well. And the capabilities field of
> > both the video and vbi node should contain identical caps.
> > 
> > However, it would be very useful to also have a capabilities field that contains
> > just the caps for the currently open device, hence the new CAP bit and field.
> > 
> > Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> > ---
> >  Documentation/DocBook/media/v4l/compat.xml         |    9 ++++++
> >  Documentation/DocBook/media/v4l/v4l2.xml           |    9 +++++-
> >  .../DocBook/media/v4l/vidioc-querycap.xml          |   29 +++++++++++++++++--
> >  drivers/media/video/cx231xx/cx231xx-417.c          |    1 -
> >  drivers/media/video/pvrusb2/pvrusb2-v4l2.c         |    1 -
> >  drivers/media/video/v4l2-ioctl.c                   |    6 +++-
> >  include/linux/videodev2.h                          |   29 +++++++++++++------
> >  7 files changed, 67 insertions(+), 17 deletions(-)
> > 
> > diff --git a/Documentation/DocBook/media/v4l/compat.xml b/Documentation/DocBook/media/v4l/compat.xml
> > index b68698f..88ea4fc 100644
> > --- a/Documentation/DocBook/media/v4l/compat.xml
> > +++ b/Documentation/DocBook/media/v4l/compat.xml
> > @@ -2378,6 +2378,15 @@ that used it. It was originally scheduled for removal in 2.6.35.
> >          </listitem>
> >        </orderedlist>
> >      </section>
> > +    <section>
> > +      <title>V4L2 in Linux 3.3</title>
> > +      <orderedlist>
> > +        <listitem>
> > +	  <para>Added the device_caps field to struct v4l2_capabilities and added the new
> > +	  V4L2_CAP_DEVICE_CAPS capability.</para>
> > +        </listitem>
> > +      </orderedlist>
> > +    </section>
> >  
> >      <section id="other">
> >        <title>Relation of V4L2 to other Linux multimedia APIs</title>
> > diff --git a/Documentation/DocBook/media/v4l/v4l2.xml b/Documentation/DocBook/media/v4l/v4l2.xml
> > index 2ab365c..6b6e584 100644
> > --- a/Documentation/DocBook/media/v4l/v4l2.xml
> > +++ b/Documentation/DocBook/media/v4l/v4l2.xml
> > @@ -128,6 +128,13 @@ structs, ioctls) must be noted in more detail in the history chapter
> >  applications. -->
> >  
> >        <revision>
> > +	<revnumber>3.3</revnumber>
> > +	<date>2011-11-22</date>
> > +	<authorinitials>hv</authorinitials>
> > +	<revremark>Added device_caps field to struct v4l2_capabilities.</revremark>
> > +      </revision>
> > +
> > +      <revision>
> >  	<revnumber>3.2</revnumber>
> >  	<date>2011-08-26</date>
> >  	<authorinitials>hv</authorinitials>
> > @@ -417,7 +424,7 @@ and discussions on the V4L mailing list.</revremark>
> >  </partinfo>
> >  
> >  <title>Video for Linux Two API Specification</title>
> > - <subtitle>Revision 3.2</subtitle>
> > + <subtitle>Revision 3.3</subtitle>
> >  
> >    <chapter id="common">
> >      &sub-common;
> > diff --git a/Documentation/DocBook/media/v4l/vidioc-querycap.xml b/Documentation/DocBook/media/v4l/vidioc-querycap.xml
> > index e3664d6..632ad13 100644
> > --- a/Documentation/DocBook/media/v4l/vidioc-querycap.xml
> > +++ b/Documentation/DocBook/media/v4l/vidioc-querycap.xml
> > @@ -124,12 +124,29 @@ printf ("Version: %u.%u.%u\n",
> >  	  <row>
> >  	    <entry>__u32</entry>
> >  	    <entry><structfield>capabilities</structfield></entry>
> > -	    <entry>Device capabilities, see <xref
> > -		linkend="device-capabilities" />.</entry>
> > +	    <entry>Device capabilities of the physical device as a whole, see <xref
> > +		linkend="device-capabilities" />. The same physical device can export
> > +		multiple devices in /dev (e.g. /dev/videoX, /dev/vbiY and /dev/radioZ).
> > +		For all those devices the capabilities field returns the same set of
> > +		capabilities. This allows applications to open just the video device
> > +		and discover whether vbi or radio is also supported.
> 
> I would write it as:
> 
> 	    <entry>Available capabilities of the physical device as a whole, see <xref
> 		linkend="device-capabilities" />. The same physical device can export
> 		multiple devices in /dev (e.g. /dev/videoX, /dev/vbiY and /dev/radioZ).
> 		The capabilities field should contain an union of all capabilities available
> 		around the several V4L2 devices exported to userspace.
> 		For all those devices the capabilities field returns the same set of
> 		capabilities. This allows applications to open just one of the devices
> 		(typically the video device) and discover whether video, vbi and/or radio are
> 		also supported.

Ditto.

> 
> 
> > +	    </entry>
> >  	  </row>
> >  	  <row>
> >  	    <entry>__u32</entry>
> > -	    <entry><structfield>reserved</structfield>[4]</entry>
> > +	    <entry><structfield>device_caps</structfield></entry>
> > +	    <entry>Device capabilities of the open device, see <xref
> > +		linkend="device-capabilities" />. This is the set of capabilities
> > +		of just the open device. So <structfield>device_caps</structfield>
> > +		of a radio device will only contain radio related capabilities and
> > +		no video capabilities. This field is only set if the <structfield>capabilities</structfield>
> > +		field contains the <constant>V4L2_CAP_DEVICE_CAPS</constant>
> > +		capability.
> 
> I would write it as:
> 
> 	    <entry>Device capabilities of the opened device, see <xref
> 		linkend="device-capabilities" />. Should contain the available
> 		capabilities via that specific device node. So, for example,
> 		<structfield>device_caps</structfield> of a radio device will only 
> 		contain radio related capabilities and 	no video or vbi capabilities. 
> 	        This field is only set if the <structfield>capabilities</structfield>
> 		field contains the <constant>V4L2_CAP_DEVICE_CAPS</constant>
> 		capability.

Ditto.

Good suggestions, I should be able to prepare a new version today.

Regards,

	Hans
