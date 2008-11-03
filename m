Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mA3NJEOC028988
	for <video4linux-list@redhat.com>; Mon, 3 Nov 2008 18:19:14 -0500
Received: from mailrelay006.isp.belgacom.be (mailrelay006.isp.belgacom.be
	[195.238.6.172])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mA3NJ3cp008720
	for <video4linux-list@redhat.com>; Mon, 3 Nov 2008 18:19:03 -0500
From: Laurent Pinchart <laurent.pinchart@skynet.be>
To: video4linux-list@redhat.com
Date: Tue, 4 Nov 2008 00:19:17 +0100
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200811040019.17211.laurent.pinchart@skynet.be>
Subject: [RFC] Zoom controls in V4L2
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

Hi everybody,

USB cameras with integrated optical zoom support are hitting the market. V4L2 
currently lacks the necessary controls to support zoom. This RFC tries to 
define zoom-related controls.

As few camera models currently support optical zoom, only a subset of zoom 
functions are implemented in existing products, making it a bit harder to 
define a future proof zoom API in V4L2. To gather more usecases I've taken 
all zoom controls defined in the USB Video Class specification into account, 
even if they are not all implemented in existing products.

Zoom in digital cameras is implemented as optical zoom, digital zoom or a 
combination of both. V4L2 supports digital zoom through cropping and scaling 
(section 1.11). Digital cameras often implement digital zoom through a single 
linear control, providing a subset of the scaling capabilities of V4L2 with 
no easy way to map between both. Still, defining a new digital zoom API in 
addition to the V4L2 cropping and scaling mechanism would confuse developers 
and users and should be avoided. We should instead concentrate on defining a 
clear mapping between linear digital zoom and crop/scale.

As I don't own any UVC device with digital zoom support, and as I'm not 
knowledgeable about digital zoom support in non-UVC webcams, ideas for a 
mapping between linear digital zoom and crop/scale are welcome. In case of 
lack of feedback on the subject, I propose to concentrate on optical zoom 
only, except when digital zoom interacts with optical zoom.

The UVC specification approximates the optical magnification factor as the 
ratio between the ocular lens focal length and the objective lens focal 
length. Although lens groups can be much more sophisticated than that, the 
model can approximate most lens groups that are likely to be encountered in 
practice. Zoom can then be expressed either as the magnification factor or as 
the objective lens focal lens. To support both representations V4L2 should 
let the device set its minimum and maximum zoom values. In both cases the 
zoom is either an unsigned integer or an unsigned rational number that can be 
expressed with a fixed-point representation.

Optical zoom can be controlled in an absolute or relative fashion. Absolute 
zoom can easily be handled with a single unsigned integer control mapping to 
the magnification factor or objective lens focal length as described above. 
The absolute zoom control should not interact with any digital zoom function 
implemented in the device, if any. I suggest naming the control 
V4L2_CID_ZOOM_ABSOLUTE.

Relative zoom is a tad more complex. To begin with, there are two relative 
zoom implementations I can think of: incremental or continuous. Incremental 
relative zoom moves the optical zoom level by a fixed amount. This is how the 
relative pan, tilt and focus controls are specified in V4L2. However, this is 
not how relative zoom is specified in UVC.

UVC specifies relative zoom as a control that starts a zoom focal length 
modification at a given speed in the given direction until interrupted by the 
user (through the relative zoom control) or by a limit in the range of 
motion. This behaviour is closer to what a user would expect when controlling 
the zoom relatively : pressing a button would start zooming in or out, and 
releasing the button would stop zooming. A single V4L2 control encoded as a 
signed integer can set the speed and direction. The speed range should be 
device dependant.

We are thus facing a situation where three types of zoom controls can be 
implemented, among which two are of the relative type. The UVC specification 
specifies a continuous relative zoom only, but V4L2 already uses the 
_RELATIVE suffix for incremental relative pan, tilt and focus controls. Using 
V4L2_CID_ZOOM_RELATIVE for continuous relative zoom would not be consistent 
with the V4L2 pan, tilt and focus controls, while using 
V4L2_CID_ZOOM_RELATIVE for incremental relative zoom would not be consistent 
with the UVC specification. As the V4L2 specification is already not 
consistent with the UVC specification when it comes to relative pan, tilt and 
focus, I propose to call the incremental relative zoom control 
V4L2_CID_ZOOM_RELATIVE and use a different name for the continuous control. 
Comments are welcome, as well as suggestions for the control name.

Continuous relative zoom also suffers from another issue. While absolute and 
incremental relative zoom do not interact with digital zoom (when implemented 
by the device), it might be interesting to let the continuous relative zoom 
use digital zoom as an option when reaching the end of the optical zoom 
capabilities. This would give the user a large zoom range combining optical 
and digital zoom that can be navigated using a single control. This is how 
the UVC specification defines the relative zoom control. We would then need 
an additional control to enable or disable digital zoom when using the 
continuous relative zoom. Both the digital zoom enable and continuous 
relative zoom (sign + speed) values should then be set in a single operation 
through the extended controls API. Comments on this subject are welcome as 
well.

Best regards,

Laurent Pinchart

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
