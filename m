Return-path: <linux-media-owner@vger.kernel.org>
Received: from c2beaomr10.btconnect.com ([213.123.26.188]:54789 "EHLO
	mail.btconnect.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755433Ab3CMKBZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 13 Mar 2013 06:01:25 -0400
Message-ID: <51404D1C.1040100@peepo.com>
Date: Wed, 13 Mar 2013 09:55:40 +0000
From: Jonathan Chetwynd <jay@peepo.com>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: Re: VIDIOC_ENUM_FMT bug query
References: <514046E4.2090302@btconnect.com>
In-Reply-To: <514046E4.2090302@btconnect.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

dmesg: gspca_sn9c20x: OV7660 sensor detected

regards

Jonathan

On 13/03/13 09:29, jonathan chetwynd wrote:
> Is there any further action I can take to discover whether a webcam 
> can support a format?
> or to help develop a patch?
>
> the Sandberg Nightcam2 specification lists
> 1280 x 960 up to 15 frames per second
> but
> $ v4l2-ctl --list-formats-ext lists no such format as available
>
> regards
>
> Jonathan Chetwynd
>
> http://www.sandberg.it/product/NightCam-2
>
> $ v4l2-ctl --list-formats-ext
> ioctl: VIDIOC_ENUM_FMT
>     Index       : 0
>     Type        : Video Capture
>     Pixel Format: 'S920'
>     Name        : S920
>         Size: Discrete 160x120
>         Size: Discrete 320x240
>         Size: Discrete 640x480
>
>     Index       : 1
>     Type        : Video Capture
>     Pixel Format: 'BA81'
>     Name        : BA81
>         Size: Discrete 160x120
>         Size: Discrete 320x240
>         Size: Discrete 640x480
>
>     Index       : 2
>     Type        : Video Capture
>     Pixel Format: 'JPEG' (compressed)
>     Name        : JPEG
>         Size: Discrete 160x120
>         Size: Discrete 320x240
>         Size: Discrete 640x480
>


-- 
Jonathan Chetwynd
http://www.gnote.org
Eyetracking in HTML5

