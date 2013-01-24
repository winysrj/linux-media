Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr2.xs4all.nl ([194.109.24.22]:4025 "EHLO
	smtp-vbr2.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751141Ab3AXQrM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 24 Jan 2013 11:47:12 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: "=?iso-8859-15?q?forum=3A=3Af=FCr=3A=3Auml=E4ute?="
	<zmoelnig@umlaeute.mur.at>
Subject: Re: v4l2loopback and kernel-3.7
Date: Thu, 24 Jan 2013 17:47:01 +0100
Cc: linux-media@vger.kernel.org
References: <51015A68.50808@umlaeute.mur.at>
In-Reply-To: <51015A68.50808@umlaeute.mur.at>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 8BIT
Message-Id: <201301241747.01296.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu January 24 2013 16:59:36 forum::für::umläute wrote:
> hi all,
> 
> i'm currently maintainer of the "v4l2loopback" device [1], a virtual
> video device that allows applications to share video-streams via the
> v4l2 API (each device being V4L2_CAP_VIDEO_CAPTURE | V4L2_CAP_VIDEO_OUTPUT).
> 
> now (unfortunately for someone maintaining a driver) i have not been
> following development of the linux-kernel very closely (mainly using
> debian unstable kernels myself), but some of my users do.
> it seems that with newer kernel-versions the functionality for
> video-output modules have been somehow removed from the kernel (3.7.1
> has been confirmed to make troubles, whereas 3.6.10 still works).
> 
> i'd like to inquire, what happened in/to the mainstream kernel, and
> what's the supposed way to proceed for a virtual video device like mine.
> (i naively ask the question here, as i'm a bit afraid of kernel-dev
> mailing list :-))

In 3.7 the vfl_dir field was added to struct video_device. For output
devices this has to be set to VFL_DIR_TX. For devices that do both
capture and output it has to be set to VFL_DIR_M2M (memory-to-memory).
Otherwise the v4l2 core will assume that it is a capture device and
disable any output support.

> 
> what's more, if the v4l2-taskforce would be interested to take over a
> kernel-module that - to my knowledge - is currently the only feasible
> way on linux to exchange live video streams between applications, we
> might talk about that :-)

Personally I am all for that, but I know Mauro has (had?) reservations
about it. Looking at the code it would also be a fair amount of work
to get it ready for inclusion in the kernel.

Frankly, I wonder if much of the functionality isn't already part of the
mem2mem_testdev driver.

Regards,

	Hans
