Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr16.xs4all.nl ([194.109.24.36]:2902 "EHLO
	smtp-vbr16.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751883Ab2ILHBU (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 12 Sep 2012 03:01:20 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: "linux-media" <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Kconfig DVB_CAPTURE_DRIVERS no longer exists?
Date: Wed, 12 Sep 2012 09:01:14 +0200
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201209120901.14575.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

Two drivers, au0828 and cx2341xx depend on the DVB_CAPTURE_DRIVERS config
option, which no longer exists. So au0828 and the DVB part of cx231xx are
no longer built. Should this dependency be removed or was it renamed?

Can you take a look at it?

Thanks!

	Hans
