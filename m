Return-path: <linux-media-owner@vger.kernel.org>
Received: from zoneX.GCU-Squad.org ([194.213.125.0]:34175 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754294Ab3HXLuE (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 24 Aug 2013 07:50:04 -0400
Received: from jdelvare.pck.nerim.net ([62.212.121.182] helo=endymion.delvare)
	by services.gcu-squad.org (GCU Mailer Daemon) with esmtpsa id 1VDCLv-0003H9-C4
	(TLSv1:AES128-SHA:128)
	(envelope-from <khali@linux-fr.org>)
	for linux-media@vger.kernel.org; Sat, 24 Aug 2013 13:49:59 +0200
Date: Sat, 24 Aug 2013 13:49:53 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Linux Media <linux-media@vger.kernel.org>
Subject: cx23885_wakeup: 3 buffers handled (should be 1)
Message-ID: <20130824134953.32c7a6e3@endymion.delvare>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi all,

I own a TerraTec Cinergy T PCIe Dual. From times to times I see the
following in the kernel log:

[31508.278300] cx23885_wakeup: 3 buffers handled (should be 1)
[36911.156435] cx23885_wakeup: 3 buffers handled (should be 1)
[52519.479142] cx23885_wakeup: 3 buffers handled (should be 1)
[53720.117787] cx23885_wakeup: 3 buffers handled (should be 1)
[55521.077548] cx23885_wakeup: 3 buffers handled (should be 1)
[56721.718509] cx23885_wakeup: 2 buffers handled (should be 1)
[59723.313871] cx23885_wakeup: 2 buffers handled (should be 1)
[78333.209720] cx23885_wakeup: 3 buffers handled (should be 1)

Recordings using this card have errors from times to times, I suppose
this could be related. Is there anything that can be done to prevent
the above from happening?

First occurrence of this message in my logs is on 2013-05-27, with
kernel 3.9.4. I am available for any form of debugging or
experimentation.

Thanks,
-- 
Jean Delvare
