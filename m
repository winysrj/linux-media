Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:57567 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752093Ab2HSV3s (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 19 Aug 2012 17:29:48 -0400
Received: by weyx8 with SMTP id x8so3544784wey.19
        for <linux-media@vger.kernel.org>; Sun, 19 Aug 2012 14:29:46 -0700 (PDT)
Message-ID: <50315AC8.5060100@gmail.com>
Date: Sun, 19 Aug 2012 23:29:44 +0200
From: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
MIME-Version: 1.0
To: Sangwook Lee <sangwook.lee@linaro.org>
CC: linux-media@vger.kernel.org, laurent.pinchart@ideasonboard.com,
	sakari.ailus@maxwell.research.nokia.com, suapapa@insignal.co.kr,
	quartz.jang@samsung.com, linaro-dev@lists.linaro.org,
	patches@linaro.org, usman.ahmad@linaro.org
Subject: Re: [PATH v3 0/2] Add v4l2 subdev driver for S5K4ECGX sensor with
 embedded SoC ISP
References: <1343914971-23007-1-git-send-email-sangwook.lee@linaro.org> <501ADEF6.1080901@gmail.com> <CADPsn1b6TxhmWVzzH1u-wr0UZs6D3cif4+r1S9OOROx1iXCXUQ@mail.gmail.com>
In-Reply-To: <CADPsn1b6TxhmWVzzH1u-wr0UZs6D3cif4+r1S9OOROx1iXCXUQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sangwook,

On 08/03/2012 04:24 PM, Sangwook Lee wrote:
> I was thinking about this, but this seems to be is a bit time-consuming because
> I have to do this just due to lack of s5k4ecgx hardware information.
> let me try it later once
> this patch is accepted.

I've converted this driver to use function calls instead of the register
arrays. It can be pulled, along with a couple of minor fixes/improvements, 
from following git tree:

	git://linuxtv.org/snawrocki/media.git s5k4ecgx
	(gitweb: http://git.linuxtv.org/snawrocki/media.git/s5k4ecgx)

I don't own any Origen board thus it's untested. Could you give it a try ?
The register write sequence should be identical as in the case of using
the arrays. 

Regarding support for still (JPEG) capture features of S5K4ECGX, it should 
be possible to make this work with the mainline s5p-fimc driver, it supports 
V4L2_PIX_FMT_JPEG/V4L2_MBUS_FMT_JPEG_1X8 formats. There is only missing 
an API for preallocating proper memory buffer for the snapshot frame. 
Currently s5p-fimc calculates buffer's size from pixel resolution, using some 
fixed coefficient.

I'm planning on adding new V4L2_CID_FRAMESIZE control that could be 
a replacement for V4L2_CID_CAM_JPEG_MEMSIZE, as found in this driver:
https://android.googlesource.com/kernel/samsung.git/+/3b0c5d2887fca99cab7dd506817b1049d38198a1/drivers/media/video/s5k4ecgx.c

Except that, there would be needed a new V4L2_CID_SNAPSHOT control in place 
of custom V4L2_CID_CAM_CAPTURE. I might try to add that and document in near 
future.

You won't find much regarding the face detection features in V4L2, 
unfortunately. _Maybe_ I'll try to address this as well on some day, for 
now private controls might be your only solution. Unless you feel like 
adding face detection features support to V4L2.. ;)

BTW, are your requirements to support both EVT1.0 and EVT1.1 S5K4ECGX 
revisions ?

--

Regards,
Sylwester
