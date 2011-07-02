Return-path: <mchehab@pedra>
Received: from smtp-vbr11.xs4all.nl ([194.109.24.31]:3949 "EHLO
	smtp-vbr11.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753040Ab1GBJla (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 2 Jul 2011 05:41:30 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Hans de Goede <hdegoede@redhat.com>
Subject: V4L2_PIX_FMT_SE401: can support be removed from libv4lconvert.c?
Date: Sat, 2 Jul 2011 11:41:20 +0200
Cc: "linux-media" <linux-media@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201107021141.20932.hverkuil@xs4all.nl>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Hans,

V4L2_PIX_FMT_SE401 was removed in the latest videodev2.h. I assume that that
code can also be removed from libv4lconvert.c?

Regards,

	Hans
