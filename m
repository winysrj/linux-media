Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:43938 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750740Ab1IOGhO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 15 Sep 2011 02:37:14 -0400
Received: by qwj8 with SMTP id 8so717856qwj.33
        for <linux-media@vger.kernel.org>; Wed, 14 Sep 2011 23:37:14 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.64.1109130943021.17902@axis700.grange>
References: <1315938892-20243-1-git-send-email-scott.jiang.linux@gmail.com>
	<1315938892-20243-4-git-send-email-scott.jiang.linux@gmail.com>
	<Pine.LNX.4.64.1109130943021.17902@axis700.grange>
Date: Thu, 15 Sep 2011 14:37:13 +0800
Message-ID: <CAHG8p1AM9HxRSfEOEc8_cuvSkRO8LvUw0DCAfcK+_SHD8yr=cg@mail.gmail.com>
Subject: Re: [PATCH 4/4] v4l2: add blackfin capture bridge driver
From: Scott Jiang <scott.jiang.linux@gmail.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
	uclinux-dist-devel@blackfin.uclinux.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

>
>> +
>> +#define CAPTURE_DRV_NAME        "bfin_capture"
>> +#define BCAP_MIN_NUM_BUF        2
>> +
>> +struct bcap_format {
>> +     u8 *desc;
>> +     u32 pixelformat;
>> +     enum v4l2_mbus_pixelcode mbus_code;
>> +     int bpp; /* bytes per pixel */
>
> Don't you think you might have to process 12 bpp formats at some point,
> like YUV 4:2:0, or NV12? Maybe better calculate in bits from the beginning?
>
I have a question here. How to calculate bytesperline for planar format?
According to v4l2 specification  width, height and bytesperline apply
to largest plane.
Does it mean bytesperline equal to Y plane distance between two line?
And so you can't use bytesperline x height to calculate sizeimage?
