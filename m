Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m7HCvI5N007727
	for <video4linux-list@redhat.com>; Sun, 17 Aug 2008 08:57:18 -0400
Received: from smtp1.versatel.nl (smtp1.versatel.nl [62.58.50.88])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m7HCuq4g007109
	for <video4linux-list@redhat.com>; Sun, 17 Aug 2008 08:56:52 -0400
Message-ID: <48A81B11.3080308@hhs.nl>
Date: Sun, 17 Aug 2008 14:35:29 +0200
From: Hans de Goede <j.w.r.degoede@hhs.nl>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
References: <489AD045.7030404@hhs.nl>
	<200808071237.47230.laurent.pinchart@skynet.be>
	<1218186636.1734.13.camel@localhost>
	<200808081129.02118.hverkuil@xs4all.nl>
In-Reply-To: <200808081129.02118.hverkuil@xs4all.nl>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: video4linux-list@redhat.com
Subject: Re: RFC: adding a flag to indicate a webcam sensor is installed
 upside down
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

Hans Verkuil wrote:
> On Friday 08 August 2008 11:10:36 Jean-Francois Moine wrote:
>> On Thu, 2008-08-07 at 12:37 +0200, Laurent Pinchart wrote:
>>> On Thursday 07 August 2008, Hans de Goede wrote:
>>>> Hi all,
>>>>
>>>> I have this Philips SPC 200NC webcam, which has its sensor
>>>> installed upside down and the sensor does not seem to support
>>>> flipping the image. So I believe the windows drivers fix this
>>>> little problem in software.
>>>>
>>>> I would like to add a flag somewhere to indicate this to
>>>> userspace (and then add flipping code to libv4l).
>>>>
>>>> I think the best place for this would the flags field of the
>>>> v4l2_fmtdesc struct. Any other ideas / objections to this?
>>> More often than sensors being mounted upside down in a webcam, what
>>> I've noticed frequently is webcam modules being mounted upside down
>>> in a laptop screen. There is no way that I'm aware of to check the
>>> module orientation based on the USB descriptors only. We will need
>>> a pure userspace solution.
>> Agree.
>>
>> Having a horizontal or vertical inversion may exist in any webcam
>> (and tuner?), and may be the fact of wire inversion when assembling
>> the device. So, having a flag in the driver could not work with
>> hardware error.
>>
>> If the sensor (or bridge?) may do H or V flip, we are done. If not,
>> this may be done by software, but in the userspace, i.e. at decoding
>> time.
>>
>> What I propose is to add a check of the control commands
>> V4L2_CID_HFLIP and V4L2_CID_VFLIP in the v4l library: if the driver
>> does not have these controls, the library silenctly adds them and
>> handles their requests. Then, at frame decoding time, the hflip and
>> vflip may be given to the decoding functions.
>>
>> How do you feel it, Hans?
> 
> I'm a different Hans :-), but I was thinking along the same lines. 
> Having the v4l lib implement HFLIP/VFLIP if the driver doesn't seems 
> like a good idea.
> 
> I also think that the UPSIDEDOWN flag doesn't belong to v4l2_fmtdesc 
> since this is a global property, not specific to a format. I would 
> suggest adding it to v4l2_capability instead: 
> V4L2_CAP_SENSOR_UPSIDE_DOWN. It should only be set if you know that the 
> sensor is always upside down for that specific device and if there is 
> no VFLIP capability (because if there is, then you can VFLIP by default 
> for that device).
> 


I agree that this is a per device thing, and that the flag thus should 
be moved to v4l2_capability. I'll redo a new patch against the gspca 
zc3xx driver with the flag moved to v4l2_capability.


About adding fake controls for HFLIP VFLIP to libv4l for devices which 
don't do this natively. This might be good to have, but my current patch 
for the upside down issue only supports. 180 degree rotation so, both 
vflip and hflip in one go.

Adding support for doing just vflip or just hflip is possible, but will 
take some time.

Also faking v4l2 controls currently is not done yet in libv4l, so doing 
this requires adding some infrastructure. All doable, but not at the top 
of my todo list at the moment.


As I see it there are 3 kind of upsidedown problems:

1) The sensor is upside down, and we can easily detect in the driver (by
usb id for example) and the driver does not support vflip and/or
hflip in the hardware. Solution: set a capability flag indicating this 
(and then in libv4l flip the image back in software, I've already 
written support for this).
(Note when h and vflip are supported the driver should invert the 
meaning of the ctrl's so that the image ends up the right way up).

2) The sensor is upside down, and we can not easily detect this in the 
driver, but we can detect it in userspace. For example a sensor mounted 
upside down in the screen bevel of a laptop, which we can detect be 
determining the model of laptop from dmi strings as hal already does for 
things like setting up bindings of special keyb keys and for enabling 
suspend / resume problem workarounds.

Proposed solution: Give userspace (hal) a way to tell the kernel that 
the sensor is upside down, I'm thinking about a sysfs file for each 
video device here myself. and then let the kernel behave as scenario 1.

3) There is no way to tell the sensor is upside down. Proposed solution 
write a videodev preferences gui, where this can be indicated and then 
use the sysfs file mentioned in 2) to tell the kernel about the sensor 
being upside down. Note that currently no practical examples of this 
version of the problem are known.


I'm currently focussing on 1)  as I actually have a cam which has its 
sensor upside down and has a unique device id. I'll submit a new patch 
against gspca adding a capability flag to indicate the image is upside 
down and adjust my libv4l patches to check for this flag and do flipping 
in sw when its set.

When this is in place adding a sysfs entry which allows userspace to set 
this flag should be easy.

Regards,

Hans



--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
