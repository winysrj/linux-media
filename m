Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:62441 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751128Ab2FDTuq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 4 Jun 2012 15:50:46 -0400
Received: by obbtb18 with SMTP id tb18so7631453obb.19
        for <linux-media@vger.kernel.org>; Mon, 04 Jun 2012 12:50:46 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <201206041047.40804.hverkuil@xs4all.nl>
References: <1338651169-10446-1-git-send-email-elezegarcia@gmail.com>
	<201206031233.24758.hverkuil@xs4all.nl>
	<CALF0-+XYy+fUsksYF+ok7PTZs0tX+L2G9z48NpYU4wdyPZcHzQ@mail.gmail.com>
	<201206041047.40804.hverkuil@xs4all.nl>
Date: Mon, 4 Jun 2012 16:50:46 -0300
Message-ID: <CALF0-+XZ_LTgk8n32gD7H4+dJTyxADPzs-1tw2AVjNzXU9waXg@mail.gmail.com>
Subject: Re: [RFC/PATCH v2] media: Add stk1160 new driver
From: Ezequiel Garcia <elezegarcia@gmail.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Sylwester Nawrocki <snjw23@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Jun 4, 2012 at 5:47 AM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
>
>> Would you care to explain me this change in your patch?
>> +       set_bit(V4L2_FL_USE_FH_PRIO, &dev->vdev.flags);
>
> See Documentation/video4linux/v4l2-framework.txt:
>
> "flags: optional. Set to V4L2_FL_USE_FH_PRIO if you want to let the framework
>  handle the VIDIOC_G/S_PRIORITY ioctls. This requires that you use struct
>  v4l2_fh. Eventually this flag will disappear once all drivers use the core
>  priority handling. But for now it has to be set explicitly."
>

So, by using v4l2_fh and setting V4L2_FL_USE_FH_PRIO, I can have
{g,s}_priority ioctls for free, right?
As far as I can see __video_do_ioctl checks if the ioctl is possible, like this:

 520     if (test_bit(V4L2_FL_USES_V4L2_FH, &vfd->flags)) {
 521         vfh = file->private_data;
 522         use_fh_prio = test_bit(V4L2_FL_USE_FH_PRIO, &vfd->flags);
 523     }
 524
 525     if (use_fh_prio)
 526         ret_prio = v4l2_prio_check(vfd->prio, vfh->prio);

Just checking,
Thanks!

Ezequiel.
