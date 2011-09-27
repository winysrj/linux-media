Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vx0-f174.google.com ([209.85.220.174]:45467 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751861Ab1I0IXg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 27 Sep 2011 04:23:36 -0400
Received: by vcbfk10 with SMTP id fk10so3439763vcb.19
        for <linux-media@vger.kernel.org>; Tue, 27 Sep 2011 01:23:35 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <201109261609.32349.hverkuil@xs4all.nl>
References: <1316465981-28469-1-git-send-email-scott.jiang.linux@gmail.com>
	<1316465981-28469-4-git-send-email-scott.jiang.linux@gmail.com>
	<201109261609.32349.hverkuil@xs4all.nl>
Date: Tue, 27 Sep 2011 16:23:35 +0800
Message-ID: <CAHG8p1BiKzS8sJ+qxWSFw0Uk+0gC0e7ABmJaT8igaSeYttOtLw@mail.gmail.com>
Subject: Re: [PATCH 4/4 v2][FOR 3.1] v4l2: add blackfin capture bridge driver
From: Scott Jiang <scott.jiang.linux@gmail.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	linux-media@vger.kernel.org,
	uclinux-dist-devel@blackfin.uclinux.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

>
>> +             ret = v4l2_subdev_call(bcap_dev->sd, video,
>> +                                     g_mbus_fmt, &mbus_fmt);
>> +             if (ret < 0)
>> +                     return ret;
>> +
>> +             for (i = 0; i < BCAP_MAX_FMTS; i++) {
>> +                     if (mbus_fmt.code != bcap_formats[i].mbus_code)
>> +                             continue;
>> +                     bcap_fmt = &bcap_formats[i];
>> +                     v4l2_fill_pix_format(pixfmt, &mbus_fmt);
>> +                     pixfmt->pixelformat = bcap_fmt->pixelformat;
>> +                     pixfmt->bytesperline = pixfmt->width * bcap_fmt->bpp / 8;
>> +                     pixfmt->sizeimage = pixfmt->bytesperline * pixfmt->height;
>> +                     break;
>> +             }
>> +             if (i == BCAP_MAX_FMTS) {
>> +                     v4l2_err(&bcap_dev->v4l2_dev,
>> +                                     "subdev fmt is not supported by bcap\n");
>> +                     return -EINVAL;
>> +             }
>
> Why do this on first open? Shouldn't it be better to do this after the subdev
> was loaded?
>
Hi Hans, thank you for your comments.
This point I haven't had a good solution. PPI is only a parallel port,
it has no default std or format.
That's why you always found I have no default std and format.
Sylwester Nawrocki recommend me add this code here, but different
input can has different std and format according to v4l2 spec.
That means if app only set input, or set input and std without setting
format, the default format getting here may be invalid.
Do you have any better solution for this?
