Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wg0-f44.google.com ([74.125.82.44]:57663 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933161Ab2GEWgZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 5 Jul 2012 18:36:25 -0400
Received: by wgbdr13 with SMTP id dr13so8733218wgb.1
        for <linux-media@vger.kernel.org>; Thu, 05 Jul 2012 15:36:24 -0700 (PDT)
Message-ID: <4FF616E5.6040206@gmail.com>
Date: Fri, 06 Jul 2012 00:36:21 +0200
From: Sylwester Nawrocki <snjw23@gmail.com>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>
CC: Ezequiel Garcia <elezegarcia@gmail.com>,
	linux-media@vger.kernel.org, Hans Verkuil <hverkuil@xs4all.nl>
Subject: Re: [PATCH v4] media: Add stk1160 new driver
References: <1340991243-2951-1-git-send-email-elezegarcia@gmail.com> <4FF61111.7050900@redhat.com>
In-Reply-To: <4FF61111.7050900@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 07/06/2012 12:11 AM, Mauro Carvalho Chehab wrote:
>> +static int vidioc_dqbuf(struct file *file, void *priv, struct v4l2_buffer *p)
>> +{
>> +	struct stk1160 *dev = video_drvdata(file);
>> +
>> +	if (!stk1160_is_owner(dev, file))
>> +		return -EBUSY;
>> +
>> +	return vb2_dqbuf(&dev->vb_vidq, p, file->f_flags&  O_NONBLOCK);
> 
> Why to use O_NONBLOCK here? it should be doing whatever userspace wants.

This is OK, since the third argument to vb2_dqbuf() is a boolean indicating 
whether this call should be blocking or not. And a "& O_NONBLOCK" masks this 
information out from file->f_flags.

--
Regards,
Sylwester
