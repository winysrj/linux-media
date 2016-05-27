Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud3.xs4all.net ([194.109.24.30]:57165 "EHLO
	lb3-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754032AbcE0I4S (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 27 May 2016 04:56:18 -0400
Subject: Re: RFC: HSV format
To: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>,
	linux-media <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>
References: <CAPybu_3+PsND193UKfrP7Hy_Qs7gu=QWRxZcmfiDaDRmiC6h4g@mail.gmail.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <57480BAC.6050201@xs4all.nl>
Date: Fri, 27 May 2016 10:56:12 +0200
MIME-Version: 1.0
In-Reply-To: <CAPybu_3+PsND193UKfrP7Hy_Qs7gu=QWRxZcmfiDaDRmiC6h4g@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 05/24/2016 11:19 PM, Ricardo Ribalda Delgado wrote:
> Hi
> 
> HSV is a  cylindrical-coordinate representation of a color. It is very
> useful for computer vision because the Hue component can be used to
> segment a scene.
> 
> My plan was to add a format in videodev2.h and then add support for
> vivid, libv4l2-convert and qv4l2.
> 
> There are also plans to prepare a patch for opencv to use this format
> without any software conversion, and also for Gstreamer... but all
> these changes depend on the changes on videodev2.h
> 
> The question is how open would be the linux-media community for such a
> change, considering that there is no real device driver using it in
> tree ( Our hardware is currently out of tree_
> 
> Today we only have an HSV format on v4l2-mediabus.h
> V4L2_MBUS_FROM_MEDIA_BUS_FMT(AHSV8888_1X32), but no HSV format on
> videodev2.h

It's always a bit tricky to decide what to do with this. In general I feel
uncomfortable with the idea of defines that aren't used. Certainly for very
hardware-specific formats I don't like the idea of adding unused formats to
the kernel.

In this case I am however inclined to accept it provided:

- it's not a crazy format: e.g. AHSV (32 bit) or HSV (24 bit) would be fine,
  but some weird macroblock format would be a lot more problematic.
- it's fully documented
- implemented in vivid etc.
- patches adding it to opencv/gstreamer are CC-ed to linux-media as well so
  I know that it is going to be used there.

But you will have to check with Mauro as well, he has the final say in this.

Regards,

	Hans
