Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:9890 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757955Ab3DYU77 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 25 Apr 2013 16:59:59 -0400
Date: Thu, 25 Apr 2013 17:59:54 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: "Abhishek Bansal" <abhishek@vizexperts.com>
Cc: <linux-media@vger.kernel.org>
Subject: Re: Video Signal Type in V4L
Message-ID: <20130425175954.71ecd0f1@redhat.com>
In-Reply-To: <001901ce41f5$c4da31f0$4e8e95d0$@vizexperts.com>
References: <001901ce41f5$c4da31f0$4e8e95d0$@vizexperts.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Fri, 26 Apr 2013 02:15:03 +0530
"Abhishek Bansal" <abhishek@vizexperts.com> escreveu:

> Hi All,
> 
> Is there any way by which I can know Input signal type (in terms of
> DVI/Composite/USB/SDI) 

As input "type", currently no. However, by looking at the video input 'name'
field, it is possible to know if it is a composite, S-video, ... input entry.
The input name is a string, and the naming convention depends on the driver.

see field 'name' at
http://linuxtv.org/downloads/v4l-dvb-apis/vidioc-enuminput.html

And this ioctl for retrieving it for the current input:
	http://linuxtv.org/downloads/v4l-dvb-apis/vidioc-g-input.html

> and refresh rate from a V4L video capture device.

Yes, via VIDIOC_G_PARM. see timeperframe field there:
	http://linuxtv.org/downloads/v4l-dvb-apis/vidioc-g-parm.html

Not all drivers implement it through.

> Any available V4L Structure/Flag from which I can deduce this information. 


> Please help !
> 
> Thank You
> Abhishek Bansal
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


-- 

Cheers,
Mauro
