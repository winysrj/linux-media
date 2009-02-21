Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr3.xs4all.nl ([194.109.24.23]:4306 "EHLO
	smtp-vbr3.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752419AbZBUNm0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 21 Feb 2009 08:42:26 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Subject: G_STD on radio devices
Date: Sat, 21 Feb 2009 14:42:12 +0100
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902211442.12794.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

I was playing with a radio-only device yesterday when I noticed that it 
somehow implemented G_STD. It turns out to be a side-effect of the G_STD 
implementation in v4l2-ioctl.c:

        case VIDIOC_G_STD:
        {
                v4l2_std_id *id = arg;

                ret = 0;
                /* Calls the specific handler */
                if (ops->vidioc_g_std)
                        ret = ops->vidioc_g_std(file, fh, id);
                else
                        *id = vfd->current_norm;
                break;
	}

I was thinking of fixing this by changing it as follows:

	else if (vfd->tvnorms == 0)
		return -EINVAL;
	else
                *id = vfd->current_norm;

Is this the correct solution? Or do you have a better idea?

Regards,

	Hans

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG
