Return-path: <linux-media-owner@vger.kernel.org>
Received: from mk-outboundfilter-5.mail.uk.tiscali.com ([212.74.114.1]:54778
	"EHLO mk-outboundfilter-5.mail.uk.tiscali.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752475AbZCOWYe (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 15 Mar 2009 18:24:34 -0400
From: Adam Baker <linux@baker-net.org.uk>
To: linux-media@vger.kernel.org, kilgota@banach.math.auburn.edu,
	Hans de Goede <j.w.r.degoede@hhs.nl>,
	"Jean-Francois Moine" <moinejf@free.fr>,
	Hans Verkuil <hverkuil@xs4all.nl>
Subject: [RFC][PATCH 0/2] Sensor orientation reporting
Date: Sun, 15 Mar 2009 22:24:28 +0000
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200903152224.29388.linux@baker-net.org.uk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi all,

I've finally got round to writing a sample patch to support the proposed 
mechanism of reporting sensor orientation to user space. It is split into 2 
parts, part 1 contains the kernel changes and part 2 the libv4l changes. In 
order to keep the patch simple I haven't attempted to add support to libv4l 
for HFLIP and VFLIP but just assumed for now that if a cam needs one then it 
needs both. If the basic idea gets accepted then fixing that is purely a user 
space change.

I also haven't provided an implementation of VIDIOC_ENUMINPUT in libv4l that 
updates the flags to reflect what libv4l has done to the image. Hans Verkuil 
originally said he wanted to leave the orientation information available to 
the user app but I suspect that is actually undesirable. If an app is 
designed to work without libv4l and to re-orient an image as required then if 
someone runs it with the LD_PRELOAD capability of libv4l then correct 
operation depends upon reporting the corrected orientation to the app, not 
the original orientation.

Adam
