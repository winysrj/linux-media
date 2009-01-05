Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n050NCLq019967
	for <video4linux-list@redhat.com>; Sun, 4 Jan 2009 19:23:12 -0500
Received: from mk-outboundfilter-1.mail.uk.tiscali.com
	(mk-outboundfilter-1.mail.uk.tiscali.com [212.74.114.37])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id n050MqkZ026449
	for <video4linux-list@redhat.com>; Sun, 4 Jan 2009 19:22:53 -0500
From: Adam Baker <linux@baker-net.org.uk>
To: video4linux-list@redhat.com
Date: Mon, 5 Jan 2009 00:22:49 +0000
References: <19691783.686993.1231033681816.JavaMail.www@wwinf8403>
	<49608C2B.5070304@hhs.nl>
In-Reply-To: <49608C2B.5070304@hhs.nl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Disposition: inline
Message-Id: <200901050022.49431.linux@baker-net.org.uk>
Content-Transfer-Encoding: 8bit
Cc: 
Subject: Re: RFC : addition of a flag to rotate decoded images by
	=?utf-8?b?MTgwwrA=?=
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

On Sunday 04 January 2009, Hans de Goede wrote:
> Olivier Lorin wrote:
> > Hi all,
> >
> > I maintain the driver of a webcam (Genesys 05O3:05e3) embedded in a
> > laptop screen which has the ability to pivot vertically up to 180°. The
> > raw Bayer data from the webcam come with the indication that the image is
> > right up or upside down depending on how much the webcam has been
> > rotated. One of the sensor embedded in that webcam does not support the
> > mirror and flip so that the rotation of the image must be done by
> > software at decoding time. So what about a new V4L2_xxx set by the driver
> > to tell the image has to be rotated by 180°? As it does not seem to be
> > anticipated that the driver can change the image state on the fly, a way
> > to do that may be a new V4L2_CID_UPSIDEDOWN which is set by the driver
> > and read by libv4l on a regular basis.
>
> As you know I've proposed adding an API for libv4l (and possibly others) to
> query webcam properties:
> http://marc.info/?l=linux-video&m=122708661625554&w=2
>
> In my proposal I propose a new CID range for this:
>
> #define V4L2_CTRL_CLASS_CAMERA_PROPERTY 0x009b0000
>
> #define V4L2_CID_CAMERA_PROPERTY_CLASS_BASE \
> 	(V4L2_CTRL_CLASS_CAMERA_PROPERTY | 0x900)
> #define V4L2_CID_CAMERA_PROPERTY_CLASS \
> 	(V4L2_CTRL_CLASS_CAMERA_PROPERTY | 1)
>
> /* Booleans */
> #define V4L2_CID_WANTS_SW_WHITEBALANCE 
> (V4L2_CID_CAMERA_PROPERTY_CLASS_BASE+1) #define
> V4L2_CID_WANTS_SW_AUTO_EXPOSURE (V4L2_CID_CAMERA_PROPERTY_CLASS_BASE+2)
> #define V4L2_CID_WANTS_SW_GAMMA_CORRECT
> (V4L2_CID_CAMERA_PROPERTY_CLASS_BASE+3) #define V4L2_CID_SENSOR_UPSIDE_DOWN
>     (V4L2_CID_CAMERA_PROPERTY_CLASS_BASE+4)
>
> /* Fixed point, 16.16 stored in 32 bit integer */
> #define V4L2_CID_DEF_GAMMA_CORR_FACTOR 
> (V4L2_CID_CAMERA_PROPERTY_CLASS_BASE+5)
>
>
> This proposal has not seen much feedback, but no one so far has come out
> yelling that they don't like it. So I think the best way forward is to just
> submit a patch which actually implements this, since it is considered bad
> practice to submit patches which add new API to videodev2.h without
> actually using it I would start with adding this to videodev2.h:
>
> #define V4L2_CTRL_CLASS_CAMERA_PROPERTY 0x009b0000
>
> #define V4L2_CID_CAMERA_PROPERTY_CLASS_BASE \
> 	(V4L2_CTRL_CLASS_CAMERA_PROPERTY | 0x900)
> #define V4L2_CID_CAMERA_PROPERTY_CLASS \
> 	(V4L2_CTRL_CLASS_CAMERA_PROPERTY | 1)
>
> /* Booleans */
> #define V4L2_CID_SENSOR_UPSIDE_DOWN    
> (V4L2_CID_CAMERA_PROPERTY_CLASS_BASE+1)
>
>
> And then implementing V4L2_CID_SENSOR_UPSIDE_DOWN in your driver. I also
> welcome libv4l patches to query this and use it to determine weather or not
> to rotate the image.
>

This camera adds a new facet that hadn't previously been considered that the 
camera recommended adjustment would vary with time - I and I guess you had 
assumed the driver recommended value could be read once and then stored for 
as long as the camera was present. In the case of a camera like this what 
would be the best approach to handling this value change if the user had also 
adjusted the pseudo control in libv4l - should the value from the driver be 
xor'ed with the user value?

I can also say now I've seen an sq905 camera working through libv4l that the 
default gamma looks OK but it would benefit from a whitebalance control. At 
the moment I'm relying on turning the camera itself upside down to implement 
rotate.

Another issue I've been pondering is how should multiple versions of libv4l be 
handled. Should the shared memory for controls have some sort of version 
field in the first word and the libv4l that initialises the memory sets that 
field and if the memory then gets accessed by a libv4l version with a 
different memory format it prints an error and disables all controls?

Adam Baker


--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
