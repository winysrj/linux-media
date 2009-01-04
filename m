Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n04AEUgo013374
	for <video4linux-list@redhat.com>; Sun, 4 Jan 2009 05:14:30 -0500
Received: from smtp2.versatel.nl (smtp2.versatel.nl [62.58.50.89])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id n04AEDop017404
	for <video4linux-list@redhat.com>; Sun, 4 Jan 2009 05:14:14 -0500
Message-ID: <49608C2B.5070304@hhs.nl>
Date: Sun, 04 Jan 2009 11:15:07 +0100
From: Hans de Goede <j.w.r.degoede@hhs.nl>
MIME-Version: 1.0
To: Olivier Lorin <o.lorin@laposte.net>
References: <19691783.686993.1231033681816.JavaMail.www@wwinf8403>
In-Reply-To: <19691783.686993.1231033681816.JavaMail.www@wwinf8403>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Cc: video4linux-list@redhat.com
Subject: =?utf-8?q?Re=3A_RFC_=3A_addition_of_a_flag_to_rotate_decoded_ima?=
 =?utf-8?q?ges_by_180=C2=B0?=
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

Olivier Lorin wrote:
> Hi all,
> 
> I maintain the driver of a webcam (Genesys 05O3:05e3) embedded in a laptop screen which has the ability to pivot vertically up to 180°. The raw Bayer data from the webcam come with the indication that the image is right up or upside down depending on how much the webcam has been rotated. One of the sensor embedded in that webcam does not support the mirror and flip so that the rotation of the image must be done by software at decoding time.
> So what about a new V4L2_xxx set by the driver to tell the image has to be rotated by 180°?
> As it does not seem to be anticipated that the driver can change the image state on the fly, a way to do that may be a new V4L2_CID_UPSIDEDOWN which is set by the driver and read by libv4l on a regular basis.
> 

As you know I've proposed adding an API for libv4l (and possibly others) to 
query webcam properties:
http://marc.info/?l=linux-video&m=122708661625554&w=2

In my proposal I propose a new CID range for this:

#define V4L2_CTRL_CLASS_CAMERA_PROPERTY 0x009b0000

#define V4L2_CID_CAMERA_PROPERTY_CLASS_BASE \
	(V4L2_CTRL_CLASS_CAMERA_PROPERTY | 0x900)
#define V4L2_CID_CAMERA_PROPERTY_CLASS \
	(V4L2_CTRL_CLASS_CAMERA_PROPERTY | 1)

/* Booleans */
#define V4L2_CID_WANTS_SW_WHITEBALANCE  (V4L2_CID_CAMERA_PROPERTY_CLASS_BASE+1)
#define V4L2_CID_WANTS_SW_AUTO_EXPOSURE (V4L2_CID_CAMERA_PROPERTY_CLASS_BASE+2)
#define V4L2_CID_WANTS_SW_GAMMA_CORRECT (V4L2_CID_CAMERA_PROPERTY_CLASS_BASE+3)
#define V4L2_CID_SENSOR_UPSIDE_DOWN     (V4L2_CID_CAMERA_PROPERTY_CLASS_BASE+4)

/* Fixed point, 16.16 stored in 32 bit integer */
#define V4L2_CID_DEF_GAMMA_CORR_FACTOR  (V4L2_CID_CAMERA_PROPERTY_CLASS_BASE+5)


This proposal has not seen much feedback, but no one so far has come out 
yelling that they don't like it. So I think the best way forward is to just 
submit a patch which actually implements this, since it is considered bad 
practice to submit patches which add new API to videodev2.h without actually 
using it I would start with adding this to videodev2.h:

#define V4L2_CTRL_CLASS_CAMERA_PROPERTY 0x009b0000

#define V4L2_CID_CAMERA_PROPERTY_CLASS_BASE \
	(V4L2_CTRL_CLASS_CAMERA_PROPERTY | 0x900)
#define V4L2_CID_CAMERA_PROPERTY_CLASS \
	(V4L2_CTRL_CLASS_CAMERA_PROPERTY | 1)

/* Booleans */
#define V4L2_CID_SENSOR_UPSIDE_DOWN     (V4L2_CID_CAMERA_PROPERTY_CLASS_BASE+1)


And then implementing V4L2_CID_SENSOR_UPSIDE_DOWN in your driver. I also 
welcome libv4l patches to query this and use it to determine weather or not to 
rotate the image.


Regards,

Hans

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
