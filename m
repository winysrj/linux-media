Return-path: <linux-media-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.172]:11443 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760317AbZD0TJa (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 27 Apr 2009 15:09:30 -0400
Received: by wf-out-1314.google.com with SMTP id 26so71032wfd.4
        for <linux-media@vger.kernel.org>; Mon, 27 Apr 2009 12:09:29 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <cae4ceb0904271158l56cfc840t858ef5042b1e42f@mail.gmail.com>
References: <cae4ceb0904271158l56cfc840t858ef5042b1e42f@mail.gmail.com>
Date: Mon, 27 Apr 2009 12:09:29 -0700
Message-ID: <cae4ceb0904271209k56c73f26m94adfa01d71daeaa@mail.gmail.com>
Subject: HVR1200 stop after RF tracking filter calibration complete
From: Tu-Tu Yu <tutuyu@usc.edu>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Dear sirs:
After I installed the HVR1200, it stop when we tune the frequency.
Could anyone tell me what should i do for this situation? Thank you.
The message in the log is below

kernel: cx23885_dev_checkrevision() Hardware revision unknown 0x0
kernel: cx23885[0]/0: found at 0000:0b:00.0, rev: 4, irq: 16, latency:
0, mmio: 0xfea00000
kernel: tda10048_firmware_upload: waiting for firmware upload
(dvb-fe-tda10048-1.0.fw)...
kernel: firmware: requesting dvb-fe-tda10048-1.0.fw
kernel: tda10048_firmware_upload: firmware read 24878 bytes.
kernel: tda10048_firmware_upload: firmware uploading
kernel: tda10048_firmware_upload: firmware uploaded
kernel: tda18271: performing RF tracking filter calibration
kernel: tda18271: RF tracking filter calibration complete

Audrey
