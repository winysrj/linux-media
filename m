Return-path: <video4linux-list-bounces@redhat.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
To: video4linux-list@redhat.com
Date: Fri, 12 Dec 2008 14:25:01 +0100
References: <200812121401.55277.laurent.pinchart@skynet.be>
	<200812121410.36590.laurent.pinchart@skynet.be>
In-Reply-To: <200812121410.36590.laurent.pinchart@skynet.be>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200812121425.01922.hverkuil@xs4all.nl>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Michael Schimek <mschimek@gmx.at>
Subject: Re: [PATCH v2 3/4] v4l2: Add missing control names
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

Hi Laurent,

Just one tiny suggestion:

On Friday 12 December 2008 14:10:36 Laurent Pinchart wrote:
> +	/* CAMERA controls */
> +	case V4L2_CID_CAMERA_CLASS:		return "Camera Controls";
> +	case V4L2_CID_EXPOSURE_AUTO:		return "Auto-Exposure";

I would suggest "Auto Exposure" (no dash). It seems to be the most 
common way to write it. At least to my eyes the dash looks strange. 
Perhaps some native English speakers can help out here?

Regards,

	Hans

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
