Return-path: <linux-media-owner@vger.kernel.org>
Received: from hermes.mlbassoc.com ([64.234.241.98]:51782 "EHLO
	mail.chez-thomas.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755237Ab1JROHo (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 18 Oct 2011 10:07:44 -0400
Message-ID: <4E9D882F.5010608@mlbassoc.com>
Date: Tue, 18 Oct 2011 08:07:43 -0600
From: Gary Thomas <gary@mlbassoc.com>
MIME-Version: 1.0
To: Boris Todorov <boris.st.todorov@gmail.com>
CC: linux-media <linux-media@vger.kernel.org>
Subject: Re: omap3isp: BT.656 support
References: <CAFYgh7z4r+oZg4K7Zh6-CTm2Th9RNujOS-b8W_qb-C8q9LRr2w@mail.gmail.com>
In-Reply-To: <CAFYgh7z4r+oZg4K7Zh6-CTm2Th9RNujOS-b8W_qb-C8q9LRr2w@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 2011-10-18 07:33, Boris Todorov wrote:
> Hi
>
> I'm trying to run OMAP + TVP5151 in BT656 mode.
>
> I'm using omap3isp-omap3isp-yuv (git.linuxtv.org/pinchartl/media.git).
> Plus the following patches:
>
> TVP5151:
> https://github.com/ebutera/meta-igep/tree/testing-v2/recipes-kernel/linux/linux-3.0+3.1rc/tvp5150
>
> The latest RFC patches for BT656 support:
>
> Enrico Butera (2):
>    omap3isp: ispvideo: export isp_video_mbus_to_pix
>    omap3isp: ispccdc: configure CCDC registers and add BT656 support
>
> Javier Martinez Canillas (1):
>    omap3isp: ccdc: Add interlaced field mode to platform data
>
>
> I'm able to configure with media-ctl:
>
> media-ctl -v -r -l '"tvp5150 3-005c":0->"OMAP3 ISP CCDC":0[1], "OMAP3
> ISP CCDC":1->"OMAP3 ISP CCDC output":0[1]'
> media-ctl -v --set-format '"tvp5150 3-005c":0 [UYVY2X8 720x525]'
> media-ctl -v --set-format '"OMAP3 ISP CCDC":0 [UYVY2X8 720x525]'
> media-ctl -v --set-format '"OMAP3 ISP CCDC":1 [UYVY2X8 720x525]'
>
> But
> ./yavta -f UYVY -s 720x525 -n 4 --capture=4 -F /dev/video4
>
> sleeps after
> ...
> Buffer 1 mapped at address 0x4021d000.
> length: 756000 offset: 1515520
> Buffer 2 mapped at address 0x402d6000.
> length: 756000 offset: 2273280
> Buffer 3 mapped at address 0x4038f000.
>
> Anyone with the same issue??? This happens with every other v4l test app I used.
> I can see data from TVP5151 but there are no interrupts in ISP.

Why are you using /dev/video4?  The CCDC output is on /dev/video2

-- 
------------------------------------------------------------
Gary Thomas                 |  Consulting for the
MLB Associates              |    Embedded world
------------------------------------------------------------
