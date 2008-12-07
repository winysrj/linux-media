Return-path: <video4linux-list-bounces@redhat.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
To: video4linux-list@redhat.com
Date: Sun, 7 Dec 2008 11:33:56 +0100
References: <200811271536.46779.laurent.pinchart@skynet.be>
	<200811271546.30778.laurent.pinchart@skynet.be>
In-Reply-To: <200811271546.30778.laurent.pinchart@skynet.be>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200812071133.57060.hverkuil@xs4all.nl>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Michael Schimek <mschimek@gmx.at>
Subject: Re: [PATCH 3/4] v4l2: Add missing control names
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

On Thursday 27 November 2008 15:46:30 Laurent Pinchart wrote:
> Update v4l2_ctrl_get_name() and v4l2_ctrl_get_menu() with missing
> control names and menu values.
>
> Signed-off-by: Laurent Pinchart <laurent.pinchart@skynet.be>

Hi Laurent,

I noticed something:

> +	/* CAMERA controls */
> +	case V4L2_CID_CAMERA_CLASS:		return "Camera Controls";
> +	case V4L2_CID_EXPOSURE_AUTO:		return "Auto-Exposure";

Shouldn't this be: "Exposure, Automatic"?

> +	case V4L2_CID_EXPOSURE_ABSOLUTE:	return "Exposure Time, Absolute";
> +	case V4L2_CID_EXPOSURE_AUTO_PRIORITY:	return "Auto-Exposure
> Priority"; 

This description doesn't seem meaningful. Looking at the v4l2 doc I see 
this:

"When V4L2_CID_EXPOSURE_AUTO is set to AUTO or SHUTTER_PRIORITY, this 
control determines if the device may dynamically vary the frame rate. 
By default this feature is disabled (0) and the frame rate must remain 
constant."

First of all, I wonder if it shouldn't be "AUTO or APERTURE_PRIORITY". 
Secondly, I wonder if a better control description would be: "Exposure, 
Dynamic Framerate". 

Regards,

	Hans

> +	case V4L2_CID_PAN_RELATIVE:		return "Pan, Relative"; 
> +	case V4L2_CID_TILT_RELATIVE:		return "Tilt, Relative";
> +	case V4L2_CID_PAN_RESET:		return "Pan, Reset";
> +	case V4L2_CID_TILT_RESET:		return "Tilt, Reset";
> +	case V4L2_CID_PAN_ABSOLUTE:		return "Pan, Absolute";
> +	case V4L2_CID_TILT_ABSOLUTE:		return "Tilt, Absolute";
> +	case V4L2_CID_FOCUS_ABSOLUTE:		return "Focus, Absolute";
> +	case V4L2_CID_FOCUS_RELATIVE:		return "Focus, Relative";
> +	case V4L2_CID_FOCUS_AUTO:		return "Focus, Automatic";
> +	case V4L2_CID_ZOOM_ABSOLUTE:		return "Zoom, Absolute";
> +	case V4L2_CID_ZOOM_RELATIVE:		return "Zoom, Relative";
> +	case V4L2_CID_ZOOM_CONTINUOUS:		return "Zoom, Continuous";
> +	case V4L2_CID_PRIVACY:			return "Privacy";


-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
