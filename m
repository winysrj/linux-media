Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp06.smtpout.orange.fr ([80.12.242.128]:29499 "EHLO
	smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752435AbcHNTaO (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 14 Aug 2016 15:30:14 -0400
From: Robert Jarzmik <robert.jarzmik@free.fr>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Jiri Kosina <trivial@kernel.org>, linux-kernel@vger.kernel.org,
	linux-media@vger.kernel.org
Subject: Re: [PATCH v3 12/14] media: platform: pxa_camera: add debug register access
References: <1470684652-16295-1-git-send-email-robert.jarzmik@free.fr>
	<1470684652-16295-13-git-send-email-robert.jarzmik@free.fr>
	<c0b25215-b11a-c4bc-fa08-dbd55470daa7@xs4all.nl>
Date: Sun, 14 Aug 2016 21:30:12 +0200
Message-ID: <8737m7rvwb.fsf@belgarion.home>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hans Verkuil <hverkuil@xs4all.nl> writes:

> On 08/08/2016 09:30 PM, Robert Jarzmik wrote:
>> Add pxa_camera registers access through advanced video debugging.
>> +static int pxac_vidioc_g_chip_info(struct file *file, void *fh,
>> +				   struct v4l2_dbg_chip_info *chip)
>
> You shouldn't need this g_chip_info function, it should be handled automatically
> by the v4l2 core. Just drop it.
Okay, let me try and rerun v4l-compliance to be sure I'm covered, and stage it
afterwards for v4.

Cheers.

--
Robert
