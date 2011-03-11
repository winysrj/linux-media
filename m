Return-path: <mchehab@pedra>
Received: from smtp-vbr9.xs4all.nl ([194.109.24.29]:2285 "EHLO
	smtp-vbr9.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750893Ab1CKQ4r (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 11 Mar 2011 11:56:47 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: "linux-media" <linux-media@vger.kernel.org>
Subject: Media Controller API: Thanks to all who worked on it!
Date: Fri, 11 Mar 2011 17:56:19 +0100
Cc: Manjunath Hadli <manjunath.hadli@ti.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201103111756.19899.hverkuil@xs4all.nl>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi all!

Today the Media Controller (and the OMAP3 driver that uses it!) was merged.
This is a major achievement after approximately three years of work. I think
I contacted Manju Hadli from Texas Instruments early 2008 and the first RFC
was posted July 18th 2008:

http://lists-archives.org/video4linux/23652-rfc-add-support-to-query-and-change-connections-inside-a-media-device.html

After rereading this RFC I am pleased to say that it closely resembles the
final version. The main difference is that the concept of 'media processors'
morphed eventually into the sub-device concept.

It was clear from the beginning that the only way the Media Controller could
be implemented was if the V4L2 core framework (what little there was at the
time) was substantially expanded. And the multiple incompatible APIs towards
those i2c drivers had to be resolved first since that blocked much of the
framework development and in turn the MC development.

It took more than a year to get that sorted (mostly, there is still some work
to be done for soc-camera drivers) and to create the required core framework
components, but on September 10th 2009 the second version of the RFC was posted:

http://www.mail-archive.com/linux-media@vger.kernel.org/msg09462.html

This formed the foundation of the final version we have today. Laurent
Pinchart took that and did all the hard work of actually implementing this
for the OMAP3 driver on behalf of Nokia.

I wanted to thank all of you who worked on this, and my special thanks go
to Manju (for without our discussions in 2008 none of this would have happened),
Laurent (for obvious reasons!), Sakari (for helping convince Nokia to fund this
work) and of course Mauro (for brainstorming, reviewing and finally merging it!).

We now have (I hope) a very strong framework to build on in the coming years.

There is still much work to be done, but this was 'the big one' and I am
very pleased to see this merged.

Thank you!

Regards,

	Hans

-- 
Hans Verkuil - video4linux developer - sponsored by Cisco
