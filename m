Return-path: <video4linux-list-bounces@redhat.com>
From: Laurent Pinchart <laurent.pinchart@skynet.be>
To: "Hans Verkuil" <hverkuil@xs4all.nl>
Date: Thu, 27 Nov 2008 16:19:23 +0100
References: <13858.62.70.2.252.1227797591.squirrel@webmail.xs4all.nl>
In-Reply-To: <13858.62.70.2.252.1227797591.squirrel@webmail.xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200811271619.23820.laurent.pinchart@skynet.be>
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

On Thursday 27 November 2008, Hans Verkuil wrote:
> > Hi Hans,
> >
> > On Wednesday 26 November 2008, Hans Verkuil wrote:
> >> On Wednesday 26 November 2008 01:05:02 Laurent Pinchart wrote:
> >> > On Tuesday 04 November 2008, Hans Verkuil wrote:
> >
> > [snip]
> >
> >> > Regarding v4l2_ctrl_query_fill_std(), the UVC specification doesn't
> >> > specify boundaries for most controls so I can't fill the required
> >> > values.
> >>
> >> How is that handled in practice? If you have an integer control without
> >> min-max values, then how can you present that to the user in a control
> >> panel?
> >
> > UVC-compliant devices can be queried for their boundaries at runtime.
>
> Ah, now I understand. Just fill in 0 to 255 as the default min/max values.
> They'll be overridden in any case for UVC.

Ok.

> >> A simple 0-15 control can be represented by e.g. a slider, but
> >> not a 0-INT_MAX control.
> >
> > Btw, speaking of sliders, I believe the V4L2_CTRL_FLAG_SLIDER was a
> > mistake in
> > the first place.
>
> Why? When I made the qv4l2 control panel it was the one thing that was
> missing. Usually it is pretty obvious what type of control is best
> represented as a slider (volume, brightness, hue, etc) and if you are not
> sure, then you can leave it out. It prevents applications from having to
> keep a hardcoded list of controls that should be shown as a slider instead
> of a numeric input field.

Because, in my opinion, drivers shouldn't care how controls are displayed to 
the user. Even though it would achieve the same result, a different semantic 
such as V4L2_CTRL_FLAG_EXACT (or its opposite V4L2_CTRL_FLAG_FUZZY) to signal 
that a control requires (or doesn't require) an exact value (no slider) would 
have been better.

Applications might want to use dials instead of sliders, and the following 
pseudo-code looks a bit weird :-)

if (ctrl & V4L2_CTRL_FLAG_SLIDER)
	create_widget(DIAL_BUTTON);
else
	create_widget(LINE_EDIT);

Best regards,

Laurent Pinchart

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
