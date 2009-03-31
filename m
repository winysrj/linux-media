Return-path: <linux-media-owner@vger.kernel.org>
Received: from cinke.fazekas.hu ([195.199.244.225]:36408 "EHLO
	cinke.fazekas.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754008AbZCaWOp (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 31 Mar 2009 18:14:45 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 0 of 3] cx88: add stereo/sap detection for A2
Message-Id: <patchbomb.1238536910@roadrunner.athome>
Date: Wed, 01 Apr 2009 00:01:50 +0200
From: Marton Balint <cus@fazekas.hu>
To: linux-media@vger.kernel.org
Cc: mchehab@infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patchset implements reliable stereo and sap detection for the A2 sound
standard. This is achieved by processing the samples of the audio RDS fifo of
the cx2388x chip.

The first patch adds the support for stereo detection.
The second fixes problems with the audio thread.
The third eliminates the clicking noise on mono/stereo change.

