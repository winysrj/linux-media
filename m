Return-path: <mchehab@pedra>
Received: from smtp-vbr18.xs4all.nl ([194.109.24.38]:1628 "EHLO
	smtp-vbr18.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752611Ab0KNNoy (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 14 Nov 2010 08:44:54 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Jonathan Corbet <corbet@lwn.net>
Subject: cafe_ccic: can ioctl be replaced by unlocked_ioctl?
Date: Sun, 14 Nov 2010 14:44:52 +0100
Cc: linux-media@vger.kernel.org
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201011141444.52248.hverkuil@xs4all.nl>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Jon,

I looked through the cafe_ccic.c source code and as far as I can tell the
s_mutex lock is used in all the right places.

Unless you have any objections I'd like to replace .ioctl by .unlocked_ioctl
in this driver.

Regards,

	Hans

-- 
Hans Verkuil - video4linux developer - sponsored by Cisco
