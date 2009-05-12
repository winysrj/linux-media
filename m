Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr16.xs4all.nl ([194.109.24.36]:3115 "EHLO
	smtp-vbr16.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754351AbZELGRJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 12 May 2009 02:17:09 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: "Kim, Heung Jun" <riverful@gmail.com>
Subject: Re: about exact usage of definition - Control Flags in videodev.h
Date: Tue, 12 May 2009 08:16:47 +0200
Cc: mchehab@infradead.org, linux-media@vger.kernel.org,
	kyungmin.park@samsung.com, jongse.won@samsung.com,
	dongsoo45.kim@samsung.com
References: <b64afca20905112312x217e4349pf90d6c0c89f58a42@mail.gmail.com>
In-Reply-To: <b64afca20905112312x217e4349pf90d6c0c89f58a42@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200905120816.47546.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tuesday 12 May 2009 08:12:35 Kim, Heung Jun wrote:
> Hello Hans,
>
> Nice to meet u on the mailing-list.
> I'm an engineer of camera device driver, and work with Nathaniel(Dongsoo,
> Kim). I'm wondering about how to use the Control Flags defined in the
> videodev2.h. The Control Flags defined in the videodev2.h is the
> following as you know,
>
> /*  Control flags  */
> #define V4L2_CTRL_FLAG_DISABLED		0x0001
> #define V4L2_CTRL_FLAG_GRABBED		0x0002
> #define V4L2_CTRL_FLAG_READ_ONLY 	0x0004
> #define V4L2_CTRL_FLAG_UPDATE 		0x0008
> #define V4L2_CTRL_FLAG_INACTIVE 	0x0010
> #define V4L2_CTRL_FLAG_SLIDER 		0x0020
>
> I tryed to find the usage of this definitions in the directories of
> drivers/media/video
> & include/, but I didn't. Actually, I need to use this definitions for
> checking of ISP status.
> So, I wanna know exact usage of this definitions to make the generic
> driver code.
>
> i'll appreciate your answer beforehand.
> Thanks to read.
>
> Regard,
> riverful (HeungJun, Kim)

The V4L2 API spec is here:

http://www.linuxtv.org/downloads/video4linux/API/V4L2_API/spec-single/v4l2.html

And you can find a description of these flags here:

http://www.linuxtv.org/downloads/video4linux/API/V4L2_API/spec-single/v4l2.html#VIDIOC-QUERYCTRL

Let me know if you have questions not answered in the spec.

Regards,

	Hans

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG Telecom
