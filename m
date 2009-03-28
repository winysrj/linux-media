Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp1.versatel.nl ([62.58.50.88]:43575 "EHLO smtp1.versatel.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753701AbZC1Lm1 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 28 Mar 2009 07:42:27 -0400
Message-ID: <49CE0D93.6000806@hhs.nl>
Date: Sat, 28 Mar 2009 12:44:19 +0100
From: Hans de Goede <j.w.r.degoede@hhs.nl>
MIME-Version: 1.0
To: Lamarque Vieira Souza <lamarque@gmail.com>
CC: Mauro Carvalho Chehab <mchehab@infradead.org>,
	video4linux-list@redhat.com, linux-media@vger.kernel.org
Subject: Re: [PATCH] Implement V4L2_CAP_STREAMING for zr364xx driver
References: <200903252025.11544.lamarque@gmail.com>	<200903271539.27515.lamarque@gmail.com>	<20090328063448.66ff0340@pedra.chehab.org> <200903280711.37892.lamarque@gmail.com>
In-Reply-To: <200903280711.37892.lamarque@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 03/28/2009 11:11 AM, Lamarque Vieira Souza wrote:
> This patch implements V4L2_CAP_STREAMING for the zr364xx driver, by
> converting the driver to use videobuf.
>
> Tested with Creative PC-CAM 880.
>
> It basically:
> . implements V4L2_CAP_STREAMING using videobuf;
>
> . re-implements V4L2_CAP_READWRITE using videobuf;
>
> . copies cam->udev->product to the card field of the v4l2_capability struct.
> That gives more information to the users about the webcam;
>
> . moves the brightness setting code from before requesting a frame (in
> read_frame) to the vidioc_s_ctrl ioctl. This way the brightness code is
> executed only when the application requests a change in brightness and
> not before every frame read;
>
> . comments part of zr364xx_vidioc_try_fmt_vid_cap that says that Skype +
> libv4l do not work.
>

Note that this may make things work, but is not correct, applications
which properly honor the field value may get bitten by this. The correct
fix is to unconditionally set the field value to V4L2_FIELD_NONE.


> This patch fixes zr364xx for applications such as mplayer,
> Kopete+libv4l and Skype+libv4l can make use of the webcam that comes
> with zr364xx chip.
>
> Signed-off-by: Lamarque V. Souza<lamarque@gmail.com>

<snip>

Regards,

Hans
