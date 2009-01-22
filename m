Return-path: <linux-media-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.153]:37347 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751105AbZAVFIq (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 22 Jan 2009 00:08:46 -0500
Received: by fg-out-1718.google.com with SMTP id 19so2023795fgg.17
        for <linux-media@vger.kernel.org>; Wed, 21 Jan 2009 21:08:44 -0800 (PST)
Subject: Re: Request for new pixel format (JPEG2000)
From: Alexey Klimov <klimov.linux@gmail.com>
To: Vladimir Davydov <vladimir.davydov@promwad.com>
Cc: "video4linux-list@redhat.com" <video4linux-list@redhat.com>,
	linux-media@vger.kernel.org
In-Reply-To: <200901212146.39153.vladimir.davydov@promwad.com>
References: <200901212146.39153.vladimir.davydov@promwad.com>
Content-Type: text/plain
Date: Thu, 22 Jan 2009 08:09:02 +0300
Message-Id: <1232600942.3764.130.camel@tux.localhost>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

(added linux-media mail-list)

Hello, Vladimir

On Wed, 2009-01-21 at 21:46 +0200, Vladimir Davydov wrote:
> Hi,
> Is it possible to add new pixel format to videodev2.h file?
> 
> #define V4L2_PIX_FMT_MJ2C   v4l2_fourcc('M','J','2','C') /* Morgan JPEG 2000*/
> 
> I have developed a V4L2 driver for the board with hardware JPEG2000 codec 
> (ADV202 chip). This driver uses that pixel format.
> I think JPEG 2000 is very perspective codec and it will be good if V4L2 will 
> support it.
> 
> Short description of the device is here:
> http://www.promwad.com/markets/linux-video-jpeg2000-blackfin.html
> 
> Thanks,
> Vladimir.

Please, send patches and other e-mails related to drivers development to
linux-media@vger.kernel.org
Such tool like patchwork.kernel.org will cares about patches, so they
don't lost. 

I think you already check this page
http://linuxtv.org/wiki/index.php/Development:_How_to_submit_patches
if not, please check.

-- 
Best regards, Klimov Alexey

