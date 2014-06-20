Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr9.xs4all.nl ([194.109.24.29]:2456 "EHLO
	smtp-vbr9.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934353AbaFTHIs (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 20 Jun 2014 03:08:48 -0400
Message-ID: <53A3DDC7.50909@xs4all.nl>
Date: Fri, 20 Jun 2014 09:07:51 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@infradead.org>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: bttv and colorspace
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

I wonder if you remember anything about the reported broken colorspace handling
of bttv. The spec talks about V4L2_COLORSPACE_BT878 where the Y range is 16-253
instead of the usual 16-235.

I downloaded a bt878 datasheet and that mentions the normal 16-235 range.

I wonder if this was perhaps a bug in older revisions of the bt878. Do you
remember anything about this? I plan on doing some tests with my bttv cards
next week.

The main reason I'm interested in this is that I am researching the colorspace
handling in v4l2 (and how it is defined in the spec). That needs to be nailed
down because today nobody really knows how it is supposed to work and it is a
complicated topic.

Regards,

	Hans
