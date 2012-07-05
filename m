Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr6.xs4all.nl ([194.109.24.26]:1831 "EHLO
	smtp-vbr6.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755578Ab2GEK0M (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 5 Jul 2012 06:26:12 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans de Goede <hdegoede@redhat.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	halli manjunatha <hallimanju@gmail.com>
Subject: [PATCH 0/6] Add frequency band information
Date: Thu,  5 Jul 2012 12:25:27 +0200
Message-Id: <1341483933-9986-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

This should be the final patch series for adding multiband support to the
kernel.

This patch series assumes that this pull request was merged first:

http://patchwork.linuxtv.org/patch/13180/

Changes since the previous RFC patch series:
(See http://www.mail-archive.com/linux-media@vger.kernel.org/msg48549.html)

- The name field was dropped.
- A new modulation field was added that describes the possible modulation
  systems for that frequency band (currently only one modulation system can
  be supported per band).
- Compat code was added to allow VIDIOC_ENUM_FREQ_BANDS to be used for
  existing drivers.

A note regarding the cadet driver: I want to do a follow-up patch to this
at a later date so that it uses the tea575x-tuner framework. But with these
patches it will at least work correctly again.

Regards,

	Hans

