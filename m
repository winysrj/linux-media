Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr4.xs4all.nl ([194.109.24.24]:3242 "EHLO
	smtp-vbr4.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755607Ab3CDJFa (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 4 Mar 2013 04:05:30 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Prabhakar Lad <prabhakar.csengg@gmail.com>,
	Sekhar Nori <nsekhar@ti.com>,
	davinci-linux-open-source@linux.davincidsp.com,
	linux@arm.linux.org.uk, Scott Jiang <scott.jiang.linux@gmail.com>
Subject: [REVIEW PATCH 00/11] davinci/blackfin DV_PRESET/current_norm removal
Date: Mon,  4 Mar 2013 10:04:54 +0100
Message-Id: <1362387905-3666-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi all,

This patch series is for the most part identical to the RFC patch series
posted earlier:

http://www.mail-archive.com/linux-media@vger.kernel.org/msg58762.html

The main changes are:

- dropped the Samsung-related patches, those will go through a separate
  patch series.
- added patches 7-10.

The first set of patches deal with the removal of the obsolete dv_preset
API. Patch 7 converts one last davinci driver to the control framework,
patches 8 and 9 remove the use of the obsolete current_norm field and
patch 10 fixes a compiler warning.

Scott, the blackfin patch is here only because I want to make a single pull
request for both the davinci and blackfin patches. Since you have already
acked your patch there is no need for you to do anything.

Prabhakar, if you can look at patches 7-10 (note that patch 7 is different
from the one you saw earlier), then that would be appreciated. Once I have
your ack I can make a pull request by the end of the week.

Regards,

	Hans

