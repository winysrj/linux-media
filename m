Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:49596 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752276Ab3IAWWZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 1 Sep 2013 18:22:25 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: purchase@utopiacontrol.com
Cc: linux-media@vger.kernel.org
Subject: Re: Fw: Fw: Memory acquisition problem with yavta and media control.
Date: Mon, 02 Sep 2013 00:23:52 +0200
Message-ID: <10939564.Cr93PsC9Lz@avalon>
In-Reply-To: <FF672DFF18414DF29388FFBB2E9FAE23@store>
References: <FF672DFF18414DF29388FFBB2E9FAE23@store>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

On Sunday 01 September 2013 12:35:35 purchase@utopiacontrol.com wrote:
> On Sunday, September 01, 2013 1:59 AM Laurent Pinchart wrote:
> > On Saturday 31 August 2013 10:07:14 purchase@utopiacontrol.com wrote:
> >> //=================================
> >> linux-media@vger.kernel.org
> >> laurent.pinchart@ideasonboard.com
> >> //=================================
> >> 
> >> Hi laurent pinchart,
> >
> > Just Laurent will do :-)
> >
> >> You have done a great work for snapshot mode image sensor driver for
> >> linux. I am using your media control tool with yavta test application for
> >> interfacing the mt9v032 image sensor with Gumstix Overo Water Com board.
> >> I have successfully tested the snapshot mode with this combination. But
> >> the problem is that, when I attempt to grab lots of images (thousands) of
> >> images by this test application yavta. I found that the free memory goes
> >> increasing by some amount which will not get free. Afterwards I have
> >> calculate the amount of ram acquires on every snap is about 0.618 KB
> >> (after averaging 100000 frames). Will you please Give me any reason why
> >> this is happening with this test application? And how can I get overcome
> >> on this problem.
> >
> > That's definitely not expected and should be debugged. First of all, is
> > the memory released when you stop yavta ? If it isn't then we have a
> > kernel bug, if it is the bug could be either on the kernel side or the
> > application side.
>
> Thank you for quick reply,
> 
> I have checked the memory status before starting yavta and while running .
> then after killing yavta. the results are as below.
> 
> 
> Example condition 1
> 1) Before Starting yavta Free memory is 370528KB
> 2) After running yavta and before first trigger free memory is 370108KB       
> //acquired   420KB for initial buffer allocations
> 3) After 1008 triggers free memory is 369488KB 
> //unexpected 620KB for 1008 images ( I.e. 0.61KB / image ) acquired
> 4) After killing yavta free memory is 369908KB
> //620KB not released only    420KB released
> 
> Example condition 2
> 1) Before Starting yavta Free memory is 366064KB
> 2) After running yavta and before first trigger free memory is 365520KB   
> //acquired   544KB for initial buffer allocations
> 3) After 10000 triggers free memory is 359328KB
> //unexpected 6192KB for 10000 images ( I.e. 0.6192KB / image ) acquired
> 4) After killing yavta free memory is 359864KB
> //6200KB not released only    536KB released
> 
> As per your guidance can I conclude that memory acquired during triggering
> and image grab process is an bug in kernel or driver ?

Not yet, you should be careful about how you compute the free memory. Merely 
running free won't give you an accurate information about potential memory 
leaks.

I also don't know what you mean by trigger above, could you please elaborate ?

> If it is how can I found it to get resolve my error?
> 
> From where can I get the correct source for MT9V032 driver working in
> snapshot mode and  kernel source code(3.2.0+ or any). for my platform?
> Platform          :    Gumstix Overo Water Com
> OS                 :    Angstrom
> Kernel            :    3.2.0+
> Image sensor  :    MT9V032

3.2.0 is old, you should upgrade to the latest mainline kernel. The mt9v032 
driver is present in mainline, and sample board code is available at 
http://git.linuxtv.org/pinchartl/media.git/shortlog/refs/heads/board/overo/mt9v032.

-- 
Regards,

Laurent Pinchart

