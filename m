Return-path: <mchehab@pedra>
Received: from perceval.ideasonboard.com ([95.142.166.194]:39796 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752607Ab1CFRVO (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 6 Mar 2011 12:21:14 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: [GIT PULL FOR 2.6.39] Media controller and OMAP3 ISP driver
Date: Sun, 6 Mar 2011 18:21:31 +0100
Cc: Sylwester Nawrocki <snjw23@gmail.com>,
	David Cohen <dacohen@gmail.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	alsa-devel@alsa-project.org,
	Sakari Ailus <sakari.ailus@retiisi.org.uk>,
	Pawel Osciak <pawel@osciak.com>
References: <201102171606.58540.laurent.pinchart@ideasonboard.com> <201103061238.42784.laurent.pinchart@ideasonboard.com> <4D738CFC.40301@redhat.com>
In-Reply-To: <4D738CFC.40301@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201103061821.31705.laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Mauro,

On Sunday 06 March 2011 14:32:44 Mauro Carvalho Chehab wrote:
> Em 06-03-2011 08:38, Laurent Pinchart escreveu:
> > On Sunday 06 March 2011 11:56:04 Mauro Carvalho Chehab wrote:
> >> Em 05-03-2011 20:23, Sylwester Nawrocki escreveu:
> >> 
> >> A somewhat unrelated question that occurred to me today: what happens
> >> when a format change happens while streaming?
> >> 
> >> Considering that some formats need more bits than others, this could
> >> lead into buffer overflows, either internally at the device or
> >> externally, on bridges that just forward whatever it receives to the
> >> DMA buffers (there are some that just does that). I didn't see anything
> >> inside the mc code preventing such condition to happen, and probably
> >> implementing it won't be an easy job. So, one alternative would be to
> >> require some special CAPS if userspace tries to set the mbus format
> >> directly, or to recommend userspace to create media controller nodes
> >> with 0600 permission.
> > 
> > That's not really a media controller issue. Whether formats can be
> > changed during streaming is a driver decision. The OMAP3 ISP driver
> > won't allow formats to be changed during streaming. If the hardware
> > allows for such format changes, drivers can implement support for that
> > and make sure that no buffer overflow will occur.
> 
> Such issues is caused by having two API's that allow format changes, one
> that does it device-based, and another one doing it subdev-based.
> 
> Ok, drivers can implementing locks to prevent such troubles, but, without
> the core providing a reliable mechanism, it is hard to implement a
> correct lock.
> 
> For example, let's suppose that some driver is using mt9m111 subdev (I just
> picked one random sensor that supports lots of MBUS formats). There's
> nothing there preventing a subdev call for it to change mbus format while
> streaming. Worse than that, the sensor driver has no way to block it, as
> it doesn't know that the bridge driver is streaming or not.
> 
> The code at subdev_do_ioctl() is just:
> 
> case VIDIOC_SUBDEV_S_FMT: {
>         struct v4l2_subdev_format *format = arg;
> 
>         if (format->which != V4L2_SUBDEV_FORMAT_TRY &&
>             format->which != V4L2_SUBDEV_FORMAT_ACTIVE)
>                 return -EINVAL;
> 
>         if (format->pad >= sd->entity.num_pads)
>                 return -EINVAL;
> 
>         return v4l2_subdev_call(sd, pad, set_fmt, subdev_fh, format);
> }
> 
> So, mc core won't be preventing it.
> 
> So, I can't see how such subdev request would be implementing a logic to
> return -EBUSY on those cases.

Drivers can use the media_device graph_mutex to serialize format and stream 
management calls. A finer grain locking mechanism implemented in the core 
might be better, but we're not stuck without a solution at the moment.

-- 
Regards,

Laurent Pinchart
