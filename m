Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.free-electrons.com ([88.190.12.23]:44154 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751385Ab1IZUAD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 26 Sep 2011 16:00:03 -0400
Date: Mon, 26 Sep 2011 21:59:54 +0200
From: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Devin Heitmueller <dheitmueller@kernellabs.com>,
	linux-media@vger.kernel.org, srinivasa.deevi@conexant.com,
	Maxime Ripard <maxime.ripard@free-electrons.com>
Subject: Re: cx231xx: DMA problem on ARM
Message-ID: <20110926215954.5ab059e4@skate>
In-Reply-To: <201109262102.49056.laurent.pinchart@ideasonboard.com>
References: <20110921135604.64363a2e@skate>
	<20110926101323.41708d64@skate>
	<4E80B73F.5020804@redhat.com>
	<201109262102.49056.laurent.pinchart@ideasonboard.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Laurent,

Le Mon, 26 Sep 2011 21:02:48 +0200,
Laurent Pinchart <laurent.pinchart@ideasonboard.com> a écrit :

> Are you using the MMAP or USERPTR capture method ? If using MMAP, can
> you try (as a test only) to unmap the buffer before queueing it and
> to remap it after dequeuing it ?

So far, we have used VLC, Cheese, or a simple OpenCV based application
to test the V4L2 device on our ARM platform, and I have no idea which
capture method those are using. Is there a very simple V4L test
application that we could use to hack the buffer unmap/remap trick
you're suggesting as a test ?

Regards,

Thomas
-- 
Thomas Petazzoni, Free Electrons
Kernel, drivers, real-time and embedded Linux
development, consulting, training and support.
http://free-electrons.com
