Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr11.xs4all.nl ([194.109.24.31]:1824 "EHLO
	smtp-vbr11.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755243Ab3AYKk3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 25 Jan 2013 05:40:29 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Hans de Goede <hdegoede@redhat.com>
Subject: Re: partial revert of "uvcvideo: set error_idx properly"
Date: Fri, 25 Jan 2013 11:40:13 +0100
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
References: <CAKbGBLiOuyUUHd+eEm+z=THEu57b2LSDFtoN9frXASZ5BG7Huw@mail.gmail.com> <20121225025648.5208189a@redhat.com> <510255BD.8060605@redhat.com>
In-Reply-To: <510255BD.8060605@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201301251140.13707.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri January 25 2013 10:51:57 Hans de Goede wrote:
> <modified the CC list to be more appropriate>
> 
> Hi,
> 
> On 12/25/2012 05:56 AM, Mauro Carvalho Chehab wrote:
> 
> > The pwc driver can currently return -ENOENT at VIDIOC_S_FMT ioctl. This
> > doesn't seem right. Instead, it should be getting the closest format to
> > the requested one and return 0, passing the selected format back to
> > userspace, just like the other drivers do. I'm c/c Hans de Goede for him
> > to take a look on it.
> 
> I've been looking into this today, and the ENOENT gets returned by
> pwc_set_video_mode and through that by:
> 1) Device init
> 2) VIDIOC_STREAMON
> 3) VIDIOC_S_PARM
> 4) VIDIOC_S_FMT
> 
> But only when the requested width + height + pixelformat is an
> unsupported combination, and it being a supported combination
> already gets enforced by a call to pwc_get_size in
> pwc_vidioc_try_fmt, which also gets called from pwc_s_fmt_vid_cap
> before it does anything else.
> 
> So the ENOENT can only happen on some internal driver error,
> I'm open for suggestions for a better error code to return in
> this case.

Perhaps returning EINVAL but adding a WARN_ON would be a good compromise.

> What I did notice is that pwc_vidioc_try_fmt returns EINVAL when
> an unsupported pixelformat is requested. IIRC we agreed that the
> correct behavior in this case is to instead just change the
> pixelformat to a default format, so I'll write a patch fixing
> this.

There are issues with that idea in the case of TV capture cards, since
some important apps (tvtime and mythtv to a lesser extent) assume -EINVAL
in the case of unsupported pixelformats.

Webcam apps can't assume that since gspca never returned -EINVAL, so I
think it should be OK to fix this in pwc, but Mauro may disagree.

Regards,

	Hans
