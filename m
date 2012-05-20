Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:32907 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752540Ab2ETBVa (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 19 May 2012 21:21:30 -0400
From: Hans de Goede <hdegoede@redhat.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Ondrej Zary <linux@rainbow-software.org>
Subject: [PATCH 0/6] snd_tea575x: Various patches
Date: Sun, 20 May 2012 03:25:25 +0200
Message-Id: <1337477131-21578-1-git-send-email-hdegoede@redhat.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi All,

This patch series contains various patches for the tea575x driver to prepare
for adding support for the Griffin radioSHARK device. The 6th patch adds
support for tuning AM, which depends on the discussions surrounding the
v4l2 API and radio devices with multiple tuners. I plan to add patches 1-5
to my next pull request to Mauro, I will leave patch 6 out until the API
discussion is done.

Regards,

Hans
