Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qy0-f118.google.com ([209.85.221.118]:41199 "EHLO
	mail-qy0-f118.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751536AbZC1NJv (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 28 Mar 2009 09:09:51 -0400
Received: by qyk16 with SMTP id 16so2533160qyk.33
        for <linux-media@vger.kernel.org>; Sat, 28 Mar 2009 06:09:49 -0700 (PDT)
From: Lamarque Vieira Souza <lamarque@gmail.com>
To: Hans de Goede <j.w.r.degoede@hhs.nl>
Subject: Re: [PATCH] Implement V4L2_CAP_STREAMING for zr364xx driver
Date: Sat, 28 Mar 2009 10:09:40 -0300
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	video4linux-list@redhat.com, linux-media@vger.kernel.org
References: <200903252025.11544.lamarque@gmail.com> <200903280711.37892.lamarque@gmail.com> <49CE0D93.6000806@hhs.nl>
In-Reply-To: <49CE0D93.6000806@hhs.nl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200903281009.41682.lamarque@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Saturday 28 March 2009, Hans de Goede escreveu:
> On 03/28/2009 11:11 AM, Lamarque Vieira Souza wrote:
> > This patch implements V4L2_CAP_STREAMING for the zr364xx driver, by
> > converting the driver to use videobuf.
> >
> > Tested with Creative PC-CAM 880.
> >
> > It basically:
> > . implements V4L2_CAP_STREAMING using videobuf;
> >
> > . re-implements V4L2_CAP_READWRITE using videobuf;
> >
> > . copies cam->udev->product to the card field of the v4l2_capability
> > struct. That gives more information to the users about the webcam;
> >
> > . moves the brightness setting code from before requesting a frame (in
> > read_frame) to the vidioc_s_ctrl ioctl. This way the brightness code is
> > executed only when the application requests a change in brightness and
> > not before every frame read;
> >
> > . comments part of zr364xx_vidioc_try_fmt_vid_cap that says that Skype +
> > libv4l do not work.
>
> Note that this may make things work, but is not correct, applications
> which properly honor the field value may get bitten by this. The correct
> fix is to unconditionally set the field value to V4L2_FIELD_NONE.

	The part of zr364xx_vidioc_try_fmt_vid_cap which was commented was the "if" 
that checks the field value, now the driver does not do the check, it always 
set the field value to V4L2_FIELD_NONE, since that is the only value that the 
card accepts.

> > This patch fixes zr364xx for applications such as mplayer,
> > Kopete+libv4l and Skype+libv4l can make use of the webcam that comes
> > with zr364xx chip.
> >
> > Signed-off-by: Lamarque V. Souza<lamarque@gmail.com>
>
> <snip>
>
> Regards,
>
> Hans


-- 
Lamarque V. Souza
http://www.geographicguide.com/brazil.htm
Linux User #57137 - http://counter.li.org/
