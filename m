Return-path: <video4linux-list-bounces@redhat.com>
From: Laurent Pinchart <laurent.pinchart@skynet.be>
To: Hans Verkuil <hverkuil@xs4all.nl>
Date: Thu, 27 Nov 2008 15:26:03 +0100
References: <200811032103.36711.laurent.pinchart@skynet.be>
	<200811260105.03177.laurent.pinchart@skynet.be>
	<200811260833.45485.hverkuil@xs4all.nl>
In-Reply-To: <200811260833.45485.hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200811271526.03215.laurent.pinchart@skynet.be>
Cc: video4linux-list@redhat.com, mchehab@redhat.com
Subject: Re: [PATCH 2/2] v4l2: Add camera privacy control.
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

Hi Hans,

On Wednesday 26 November 2008, Hans Verkuil wrote:
> On Wednesday 26 November 2008 01:05:02 Laurent Pinchart wrote:
> > On Tuesday 04 November 2008, Hans Verkuil wrote:

[snip]

> > Regarding v4l2_ctrl_query_fill_std(), the UVC specification doesn't
> > specify boundaries for most controls so I can't fill the required
> > values.
>
> How is that handled in practice? If you have an integer control without
> min-max values, then how can you present that to the user in a control
> panel?

UVC-compliant devices can be queried for their boundaries at runtime.

> A simple 0-15 control can be represented by e.g. a slider, but 
> not a 0-INT_MAX control.

Btw, speaking of sliders, I believe the V4L2_CTRL_FLAG_SLIDER was a mistake in 
the first place.

> If the min/max are completely unknown, then you can always fill in the
> INT_MIN and INT_MAX values.

They are not completely unknown, they just have no fixed value at compile 
time.

Best regards,

Laurent Pinchart

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
