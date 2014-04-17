Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr2.xs4all.nl ([194.109.24.22]:4070 "EHLO
	smtp-vbr2.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751241AbaDQKj1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 17 Apr 2014 06:39:27 -0400
Received: from tschai.lan (209.80-203-20.nextgentel.com [80.203.20.209] (may be forged))
	(authenticated bits=0)
	by smtp-vbr2.xs4all.nl (8.13.8/8.13.8) with ESMTP id s3HAdO2O090526
	for <linux-media@vger.kernel.org>; Thu, 17 Apr 2014 12:39:26 +0200 (CEST)
	(envelope-from hverkuil@xs4all.nl)
Received: from tschai.fritz.box (localhost [127.0.0.1])
	by tschai.lan (Postfix) with ESMTPSA id F0EC72A0410
	for <linux-media@vger.kernel.org>; Thu, 17 Apr 2014 12:39:18 +0200 (CEST)
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Subject: [REVIEWv2 PATCH 00/11] saa7134: vb2 conversion
Date: Thu, 17 Apr 2014 12:39:03 +0200
Message-Id: <1397731154-34337-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch series splits up the previous version into smaller
pieces. The previous version is found here:

http://www.spinics.net/lists/linux-media/msg74171.html

Changes since v1:

- Split up the code in smaller parts where possible. The actual conversion
  is still a lot of code.
- Added the regression fix as the first patch to hopefully prevent merge
  conflicts since that should go to 3.14 and 15.
- Moved the vb2_queue out of the saa7134_dmaqueue struct and back to
  struct saa7134_dev. On closer examination the vb2_queue does not really
  belong to dmaqueue.
- Added a final patch to re-enable USERPTR support if explicitly enabled
  and it checks that the user pointer is page-aligned.

Regards,

	Hans

