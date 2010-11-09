Return-path: <mchehab@pedra>
Received: from eu1sys200aog115.obsmtp.com ([207.126.144.139]:57110 "EHLO
	eu1sys200aog115.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754212Ab0KIIn7 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 9 Nov 2010 03:43:59 -0500
Received: from zeta.dmz-us.st.com (ns4.st.com [167.4.80.115])
	by beta.dmz-us.st.com (STMicroelectronics) with ESMTP id CDA29115
	for <linux-media@vger.kernel.org>; Tue,  9 Nov 2010 08:43:52 +0000 (GMT)
Received: from Webmail-eu.st.com (safex1hubcas3.st.com [10.75.90.18])
	by zeta.dmz-us.st.com (STMicroelectronics) with ESMTP id 19FCBA3
	for <linux-media@vger.kernel.org>; Tue,  9 Nov 2010 08:43:52 +0000 (GMT)
From: Michael PARKER <michael.parker@st.com>
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Date: Tue, 9 Nov 2010 09:43:29 +0100
Subject: Format of /dev/video0 data for HVR-4000 frame grabber
Message-ID: <A3BF01DB4A606149A4C20C4C4C808F6C2A2CACB088@SAFEX1MAIL1.st.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

All,

I'm attempting to capture a single frame from the /dev/video0 output of my HVR-4000 card's analogue tuner as a JPEG.

Whilst several resources exist for capturing the output of a card with h/w MPEG compression, I'm unable to determine the format of the /dev/video0 data for a frame grabber such as the HVR-4000.

Can anyone suggest a means by which I can capture a single frame from a frame grabber card? Can I just use "dd if=/dev/video0 of=image.jpg bs=64K" or similar or do I have to access the card via the V4L2 drivers?

Many thanks in advance,

Mike



