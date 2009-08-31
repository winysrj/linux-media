Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:34040 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754244AbZHaCl1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 30 Aug 2009 22:41:27 -0400
Date: Sun, 30 Aug 2009 23:41:14 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: =?ISO-8859-1?B?TultZXRoIE3hcnRvbg==?= <nm127@freemail.hu>
Cc: Jean-Francois Moine <moinejf@free.fr>,
	Thomas Kaiser <thomas@kaiser-linux.li>,
	linux-media@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RESEND][PATCH 1/2] v4l2: modify the webcam video standard
 handling
Message-ID: <20090830234114.16b90c36@pedra.chehab.org>
In-Reply-To: <4A910C42.5000001@freemail.hu>
References: <4A52E897.8000607@freemail.hu>
	<4A910C42.5000001@freemail.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Németh,

Em Sun, 23 Aug 2009 11:30:42 +0200
Németh Márton <nm127@freemail.hu> escreveu:

> From: Márton Németh <nm127@freemail.hu>
> 
> Change the handling of the case when vdev->tvnorms == 0.
> 

This patch (together with a few others related to tvnorms and camera drivers)
reopens an old discussion: should webcams report a tvnorm?

There's no easy answer for it since:

1) removing support for VIDIOC_G_STD/VIDIOC_S_STD causes regressions, since
some userspace apps stops working;

2) It is a common scenario to use cameras connected to some capture only devices
like several bttv boards used on surveillance systems. Those drivers report STD,
since they are used also on TV;

3) There are even some devices that allows cameras to be connected to one input and
TV on another input. This is another case were the driver will report a TV std;

4) Most webcam formats are based on ITU-T formats designed to be compatible
with TV (formats like CIF and like 640x480 - and their multiple/sub-multiples);

5) There are formats that weren't originated from TV on some digital webcams,
so, for those formats, it makes no sense to report an existing std.

Once people proposed to create an special format for those cases
(V4L2_STD_DIGITAL or something like that), but, after lots of discussions,
no changes were done at API nor at the drivers.

While we don't have an agreement on this, I don't think we should apply a patch
like this.



Cheers,
Mauro
