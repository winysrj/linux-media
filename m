Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qy0-f181.google.com ([209.85.216.181]:47963 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755513Ab1INHQR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 14 Sep 2011 03:16:17 -0400
Received: by qyk7 with SMTP id 7so1351348qyk.19
        for <linux-media@vger.kernel.org>; Wed, 14 Sep 2011 00:16:17 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAMjpGUfKehYY7_Tw+aUZ1hxtxxiO2i9hR1ENqw1MqibppYNKmw@mail.gmail.com>
References: <1315938892-20243-1-git-send-email-scott.jiang.linux@gmail.com>
	<1315938892-20243-4-git-send-email-scott.jiang.linux@gmail.com>
	<CAMjpGUfKehYY7_Tw+aUZ1hxtxxiO2i9hR1ENqw1MqibppYNKmw@mail.gmail.com>
Date: Wed, 14 Sep 2011 15:16:17 +0800
Message-ID: <CAHG8p1DEjntNnTabjhpdYFqEW07UFm=mAHkYP_z7c8rqaLhWVw@mail.gmail.com>
Subject: Re: [uclinux-dist-devel] [PATCH 4/4] v4l2: add blackfin capture
 bridge driver
From: Scott Jiang <scott.jiang.linux@gmail.com>
To: Mike Frysinger <vapier.adi@gmail.com>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	uclinux-dist-devel@blackfin.uclinux.org,
	linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

> i think at least these three are unused and should get punted
>
>> +static int __devinit bcap_probe(struct platform_device *pdev)
>> +{
>> +       struct bcap_device *bcap_dev;
>> +       struct video_device *vfd;
>> +       struct i2c_adapter *i2c_adap;
>
> you need to include linux/i2c.h for this
>
no, bfin_capture.h already contains this.
