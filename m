Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:49262 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751995Ab2F1VVD (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 28 Jun 2012 17:21:03 -0400
Received: by bkcji2 with SMTP id ji2so2503011bkc.19
        for <linux-media@vger.kernel.org>; Thu, 28 Jun 2012 14:21:02 -0700 (PDT)
From: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
To: linux-media@vger.kernel.org
Subject: [media] drxk: Minor cleanup (basically logging related).
Date: Thu, 28 Jun 2012 23:20:38 +0200
Message-Id: <1340918440-17523-1-git-send-email-martin.blumenstingl@googlemail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

this little patch series cleans up the dmesg when using the drxk driver.
The first patch fixes a warning regarding the wrong QAM demodulator
command (this depends on the drxk's firmware). These warnings were
spamming my dmesg.
The second patch just fixes some partially incorrect dprintk's/printk's.

Regards,
Martin

