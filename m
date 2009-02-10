Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.emlix.com ([193.175.82.87]:49445 "EHLO mx1.emlix.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753153AbZBJOra (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 10 Feb 2009 09:47:30 -0500
Received: from gate.emlix.com ([193.175.27.217]:55764 helo=mailer.emlix.com)
	by mx1.emlix.com with esmtp (Exim 4.63)
	(envelope-from <dg@emlix.com>)
	id 1LWtOi-0007Kp-NA
	for linux-media@vger.kernel.org; Tue, 10 Feb 2009 15:15:36 +0100
Date: Tue, 10 Feb 2009 15:15:36 +0100
From: =?ISO-8859-15?Q?Daniel_Gl=F6ckner?= <dg@emlix.com>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: Clarification for V4L2_FIELD_SEQ_TB in planar modes
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 8bit
Message-Id: <E1LWtOi-0003pM-LT@mailer.emlix.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,
I'm writing a driver for a device that appears to support only planar video
modes. For video out I would like to use the auto-repeat functionality of
its DMA engine. In interlaced modes this requires a plane of the second
field to directly follow the corresponding plane of the first field in memory.

I could not find any driver supporting SEQ_TB/SEQ_BT in planar modes, so my
question is:

Does V4L2_FIELD_SEQ_TB in planar YCbCr modes correspond to
  Y1 Y2 Cb1 Cb2 Cr1 Cr2
or
  Y1 Cb1 Cr1 Y2 Cb2 Cr2
?

  Daniel


-- 
Dipl.-Math. Daniel Glöckner, emlix GmbH, http://www.emlix.com
Fon +49 551 30664-0, Fax -11, Bahnhofsallee 1b, 37081 Göttingen, Germany
Geschäftsführung: Dr. Uwe Kracke, Dr. Cord Seele, Ust-IdNr.: DE 205 198 055
Sitz der Gesellschaft: Göttingen, Amtsgericht Göttingen HR B 3160

emlix - your embedded linux partner
