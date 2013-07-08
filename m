Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ea0-f169.google.com ([209.85.215.169]:46746 "EHLO
	mail-ea0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753288Ab3GHAXF (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 7 Jul 2013 20:23:05 -0400
Received: by mail-ea0-f169.google.com with SMTP id h15so2617480eak.28
        for <linux-media@vger.kernel.org>; Sun, 07 Jul 2013 17:23:03 -0700 (PDT)
Received: from localhost.localdomain (IGLD-84-228-222-170.inter.net.il. [84.228.222.170])
        by mx.google.com with ESMTPSA id p49sm37649382eeu.2.2013.07.07.17.23.01
        for <linux-media@vger.kernel.org>
        (version=TLSv1.1 cipher=ECDHE-RSA-RC4-SHA bits=128/128);
        Sun, 07 Jul 2013 17:23:02 -0700 (PDT)
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: linux-media@vger.kernel.org
Subject: rc: ene_ir: few fixes
Date: Mon,  8 Jul 2013 03:22:44 +0300
Message-Id: <1373242968-16055-1-git-send-email-maximlevitsky@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

Could you consider merging few fixes to my driver:

1. Fix accidently introduced error, that is the hardware is a bit unusual
in the way that it needs the interrupt number, and one of the recent patches
moved the irq number read to be too late for that.

2. I just now played with my remote that wakes the system, and noticed that
it wakes the system even if I disable the wake bit.
Just disable the device if wake is disabled, and this fixes the issue.

3. I noticed that debug prints from my driver don't work anymore,
and this is due to conversion to pr_dbg, which is in my opinion too restructive in
enabling it.
If you allow, I want to use pr_info instead.

patch #1 should go to stable as well, as it outright breaks my driver.

PS: I am very short on time, and I will be free in about month, after I pass
another round of exams.

Best regards,
	Maxim Levitsky

