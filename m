Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lb0-f172.google.com ([209.85.217.172]:34922 "EHLO
	mail-lb0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030265AbbD1QZk (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 28 Apr 2015 12:25:40 -0400
Received: by lbbuc2 with SMTP id uc2so4284lbb.2
        for <linux-media@vger.kernel.org>; Tue, 28 Apr 2015 09:25:39 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAB0d6Ed==Eia5O8_hYZRcd9zsoFNC2naLh1MO-YOVPp8pdTfpg@mail.gmail.com>
References: <CAB0d6Ed==Eia5O8_hYZRcd9zsoFNC2naLh1MO-YOVPp8pdTfpg@mail.gmail.com>
Date: Tue, 28 Apr 2015 13:25:38 -0300
Message-ID: <CAB0d6EdNV8hqnmLYb2tKB-y21+QpeTJ36AWs0RvjChN+VwTgRg@mail.gmail.com>
Subject: Fwd: UVC Camera on BeagleBoneBlack does not achieve good resolutions
 for preview
From: Rafael Coutinho <rafael.coutinho@phiinnovations.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

I'm facing a problem on BeagleBoneBlack. For capturing pictures on a
USB UVC capture board camera I have to stick with a camera preview
streaming with a very low resolution of 320x240 otherwise I cannot get
the camera preview streaming.

I'm using Rowboat Android and a v4l2 camera hardware HAL.

However the same camera achieve 640x480 preview on other devices.

Not sure where to start investigating, might be it a kernel issue
(it's odd because on the other devices the kernel is older).

Or is there any hardware issue on BBB?

Any suggestions would help a lot.

Thanks.

-- 
Regards,
Coutinho
www.phiinnovations.com
