Return-path: <mchehab@pedra>
Received: from perceval.ideasonboard.com ([95.142.166.194]:40699 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752795Ab1CENCV (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 5 Mar 2011 08:02:21 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: [GIT PULL FOR 2.6.39] Media controller and OMAP3 ISP driver
Date: Sat, 5 Mar 2011 14:02:33 +0100
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	alsa-devel@alsa-project.org,
	Sakari Ailus <sakari.ailus@retiisi.org.uk>,
	Pawel Osciak <pawel@osciak.com>
References: <201102171606.58540.laurent.pinchart@ideasonboard.com> <201103031125.06419.laurent.pinchart@ideasonboard.com> <4D713CBD.7030405@redhat.com>
In-Reply-To: <4D713CBD.7030405@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201103051402.34416.laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Mauro,

Thanks for the review. Let me address all your concerns in a single mail.

- ioctl numbers

I'll send you a patch that reserves a range in Documentation/ioctl/ioctl-
number.txt and update include/linux/media.h accordingly.

- private ioctls

As already explained by David, the private ioctls are used to control advanced 
device features that can't be handled by V4L2 controls at the moment (such as 
setting a gamma correction table). Using those ioctls is not mandatory, and 
the device will work correctly without them (albeit with a non optimal image 
quality).

David said he will submit a patch to document the ioctls.

- media bus formats

As Hans explained, there's no 1:1 relationship between media bus formats and 
pixel formats.

- FOURCC and media bus codes documentation

I forgot to document some of them. I'll send a new patch that adds the missing 
documentation.


Is there any other issue I need to address ? My understanding is that there's 
no need to rebase the existing patches, is that correct ?

-- 
Regards,

Laurent Pinchart
