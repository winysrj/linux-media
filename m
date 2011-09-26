Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:40722 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752517Ab1IZUDt (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 26 Sep 2011 16:03:49 -0400
Message-ID: <4E80DA9B.5000604@redhat.com>
Date: Mon, 26 Sep 2011 17:03:39 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
CC: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Devin Heitmueller <dheitmueller@kernellabs.com>,
	linux-media@vger.kernel.org, srinivasa.deevi@conexant.com,
	Maxime Ripard <maxime.ripard@free-electrons.com>
Subject: Re: cx231xx: DMA problem on ARM
References: <20110921135604.64363a2e@skate> <20110926101323.41708d64@skate> <4E80B73F.5020804@redhat.com> <201109262102.49056.laurent.pinchart@ideasonboard.com> <20110926215954.5ab059e4@skate>
In-Reply-To: <20110926215954.5ab059e4@skate>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 26-09-2011 16:59, Thomas Petazzoni escreveu:
> Hello Laurent,
> 
> Le Mon, 26 Sep 2011 21:02:48 +0200,
> Laurent Pinchart <laurent.pinchart@ideasonboard.com> a écrit :
> 
>> Are you using the MMAP or USERPTR capture method ? If using MMAP, can
>> you try (as a test only) to unmap the buffer before queueing it and
>> to remap it after dequeuing it ?
> 
> So far, we have used VLC, Cheese, or a simple OpenCV based application
> to test the V4L2 device on our ARM platform, and I have no idea which
> capture method those are using. Is there a very simple V4L test
> application that we could use to hack the buffer unmap/remap trick
> you're suggesting as a test ?

The simplest application is the v4l2grab util:
	http://git.linuxtv.org/v4l-utils.git/blob/HEAD:/contrib/test/v4l2grab.c

it uses libv4l to convert to RGB and outputs a series of ppm images. By
generating one image per frame, it is easy to check artifacts on each
image.

> 
> Regards,
> 
> Thomas

