Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mAJ9NQwQ027887
	for <video4linux-list@redhat.com>; Wed, 19 Nov 2008 04:23:26 -0500
Received: from smtp4.versatel.nl (smtp4.versatel.nl [62.58.50.91])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mAJ9NDVF006259
	for <video4linux-list@redhat.com>; Wed, 19 Nov 2008 04:23:14 -0500
Message-ID: <4923DC47.6010101@hhs.nl>
Date: Wed, 19 Nov 2008 10:28:39 +0100
From: Hans de Goede <j.w.r.degoede@hhs.nl>
MIME-Version: 1.0
To: Linux and Kernel Video <video4linux-list@redhat.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Cc: =?windows-1252?Q?Luk=E1=9A_Karas?= <lukas.karas@centrum.cz>
Subject: RFC: API to query webcams for various webcam specific properties
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

Hi All,

With libv4l giving us the ability to do some much needed image conversion in 
userspace, it has become clear that for (some) webcams more processing then 
just format conversion is necessary.

So far I've been keeping various proposed patches for doing things like 
software white balance correction out of libv4l as I first want a proper API 
for drivers to signal they need this to libv4l.

Part of the problem is that various cams needs various additional processing 
steps for best results, and currently there is no way to ask a driver which 
additional steps should be done (and using which values). Another part is that 
we do not have a complete picture of all possible existing processing steps we 
want to do, so what ever we come up with needs to be extensible.

To give an idea, here are a few things which libv4l should know about an video 
input source:
-does this cam need software whitebalance
-does this cam need software auto exposure
-does this cam need gamma correction, and what initial gamma to use
-if the sensor is mounted upside down, and the hardware cannot flip the image
  itself

This has been discussed at the plumbers conference, and there the solution we 
came up with for "does this cam need software whitebalance?" was (AFAIK), check 
if has a V4L2_CID_AUTO_WHITE_BALANCE, if it does not do software whitebalance. 
This of course means we will be doing software whitebalance on things like 
framefrabbers etc. too, so the plan was to combine this with an "is_webcam" 
flag in the capabilities struct. The is_webcam workaround, already shows what 
is wrong with this approach, we are checking for something not being there, 
were we should be checking for the driver asking something actively,

So we need an extensible mechanism to query devices if they could benefit from 
certain additional processing being done on the generated image data.

This sounds a lot like the existing mechanism for v4l2 controls, except that 
these are all read only controls, and not controls which we want to show up in 
v4l control panels like v4l2ucp.

Still I think that using the existing controls mechanism is the best way todo 
this, so therefor I propose to add a number of standard CID's to query the 
things listed above. All these CID's will always be shown by the driver as 
readonly and disabled (as they are not really controls).

Here is an initial proposal for the new CID's, I'm sure the list will grow this 
is just a first revision:

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


Please let me know what you think of this proposal, as I would like to move 
forward with this soon.

Regards,

Hans

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
