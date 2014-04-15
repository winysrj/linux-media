Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr1.xs4all.nl ([194.109.24.21]:3046 "EHLO
	smtp-vbr1.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750770AbaDOIXw (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 15 Apr 2014 04:23:52 -0400
Message-ID: <534CEC76.8060102@xs4all.nl>
Date: Tue, 15 Apr 2014 10:23:18 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
CC: Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [RFC] Drop support for kernel 2.6.31 in the media_build
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I've been updating the compatibility build for 3.15-rc1 (it should be OK again)
and as usual it is the 2.6.31 kernel that gives me the most trouble due to
changes in device.h.

I would like to drop support for 2.6.31 because of this. Frankly, I have better
things to do with my time :-)

Comments?

Regards,

	Hans
