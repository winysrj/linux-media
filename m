Return-path: <mchehab@pedra>
Received: from smtp-gw11.han.skanova.net ([81.236.55.20]:44967 "EHLO
	smtp-gw11.han.skanova.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755923Ab0JYOqW (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 25 Oct 2010 10:46:22 -0400
Subject: [PATCH 0/2 v3] media, mfd: Add timberdale video-in driver
From: Richard =?ISO-8859-1?Q?R=F6jfors?=
	<richard.rojfors@pelagicore.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Samuel Ortiz <sameo@linux.intel.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Douglas Schilling Landgraf <dougsland@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 25 Oct 2010 16:40:08 +0200
Message-ID: <1288017608.8517.26.camel@debian>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

To follow are two patches.

The first adds the timberdale video-in driver to the media tree.

The second adds it to the timberdale MFD driver.

Changes since last version:
* Using the unlocked_ioctl to avoid BKL, instead using a mutex in
  the ioctl callbacks where needed.
* The try_fmt function does _not_ set the format anymore.

As Samuel pointed out earlier the patch to timberdale should be trivial
so I hope Mauro can take the patches via his tree.

Thanks
--Richard

