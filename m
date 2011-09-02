Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.free-electrons.com ([88.190.12.23]:41838 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751083Ab1IBLwH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 2 Sep 2011 07:52:07 -0400
Date: Fri, 2 Sep 2011 13:51:58 +0200
From: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: "Wu, Josh" <Josh.wu@atmel.com>, linux-media@vger.kernel.org
Subject: Re: Using atmel-isi for direct output on framebuffer ?
Message-ID: <20110902135158.41e9c84d@skate>
In-Reply-To: <201109021342.03721.laurent.pinchart@ideasonboard.com>
References: <20110901170555.568af6ea@skate>
	<4C79549CB6F772498162A641D92D532802A09156@penmb01.corp.atmel.com>
	<20110902111853.292d7f26@skate>
	<201109021342.03721.laurent.pinchart@ideasonboard.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

Le Fri, 2 Sep 2011 13:42:03 +0200,
Laurent Pinchart <laurent.pinchart@ideasonboard.com> a écrit :

> I'm not sure if V4L2_CAP_VIDEO_OVERLAY is a good solution for this.
> This driver type (or rather buffer type) was used on old systems to
> capture directly to the PCI graphics card memory. Nowadays I would
> advice using USERPTR with framebuffer memory.

Could you give a short summary of how the USERPTR mechanism works?

Thanks,

Thomas
-- 
Thomas Petazzoni, Free Electrons
Kernel, drivers, real-time and embedded Linux
development, consulting, training and support.
http://free-electrons.com
