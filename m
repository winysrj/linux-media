Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud2.xs4all.net ([194.109.24.25]:53485 "EHLO
	lb2-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755009AbcCNIZ5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 14 Mar 2016 04:25:57 -0400
To: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: Any reason why media_entity_pads_init() isn't void?
Message-ID: <56E6758F.7020205@xs4all.nl>
Date: Mon, 14 Mar 2016 09:25:51 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I was fixing a sparse warning in media_entity_pads_init() and I noticed that that
function always returns 0. Any reason why this can't be changed to a void function?

That return value is checked a zillion times in the media code. By making it void
it should simplify code all over.

See e.g. uvc_mc_init_entity in drivers/media/usb/uvc/uvc_entity.c: that whole
function can become a void function itself.

Regards,

	Hans
