Return-path: <linux-media-owner@vger.kernel.org>
Received: from nm1-vm0.bt.bullet.mail.ukl.yahoo.com ([217.146.182.223]:28885
	"HELO nm1-vm0.bt.bullet.mail.ukl.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752778Ab2A1MbV (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 28 Jan 2012 07:31:21 -0500
Received: from volcano.underworld (volcano.underworld [192.168.0.3])
	by wellhouse.underworld (8.14.3/8.14.3/Debian-5+lenny1) with ESMTP id q0SCVGUX007732
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NOT)
	for <linux-media@vger.kernel.org>; Sat, 28 Jan 2012 12:31:19 GMT
Message-ID: <4F23EA94.9080004@yahoo.com>
Date: Sat, 28 Jan 2012 12:31:16 +0000
From: Chris Rankin <rankincj@yahoo.com>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: Fwd: em28xx leaks
References: <4F22F94E.4010605@ct0.com>
In-Reply-To: <4F22F94E.4010605@ct0.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Subject: em28xx leaks
Date: Fri, 27 Jan 2012 13:21:50 -0600
From: Todd Squires <squirest@ct0.com>
Organisation: Core Technologies
To: rankincj@yahoo.com

Hi Chris,

I've recently started using an em28xx, and have run into a memory
leak in the 3.2.1 kernel.

Poking around the Internet, I found that you've been recently
submitting patches for this driver.

I have a program which opens a V4L2 device, configures it, reads a
frame, then closes the device and exits. This program runs every
minute or so. After a short time, I noticed my Linux machine
complaining that vmalloc was out of memory.

Digging into the driver, I found the problem is in em28xx_v4l2_close.

Specifically, this test is not succeeding, and videobuf_stop is
not being called when it should be:

if (res_check(fh, EM28XX_RESOURCE_VIDEO)) {
	videobuf_stop(&fh->vb_vidq);
	res_free(fh, EM28XX_RESOURCE_VIDEO);
}

After failing to call videobuf_stop, em28xx_v4l2_close
then calls this:

videobuf_mmap_free(&fh->vb_vidq);

and it fails to deallocate because it sees "fh->vb_vidq.reading" is
still set. This leaks lots of memory.

I hacked around the problem by sticking this in the code:

if (fh->vb_vidq.reading)
	videobuf_read_stop(&fh->vb_vidq);

However, the proper fix is to go through the code and work out
why EM28XX_RESOURCE_VIDEO is not getting set as it should be.

Since I'm not terribly familiar with the driver, I figured I'd point
this issue out to you. If you can fix it, please let me know.
Otherwise I'll dig deeper and take care of it properly on my end
when I get some free time.

Cheers,

-Todd
