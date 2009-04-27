Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from wf-out-1314.google.com ([209.85.200.168])
	by mail.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <tutuyu@usc.edu>) id 1LyW1y-0005Y9-5E
	for linux-dvb@linuxtv.org; Mon, 27 Apr 2009 20:58:18 +0200
Received: by wf-out-1314.google.com with SMTP id 28so62588wff.17
	for <linux-dvb@linuxtv.org>; Mon, 27 Apr 2009 11:58:12 -0700 (PDT)
MIME-Version: 1.0
Date: Mon, 27 Apr 2009 11:58:11 -0700
Message-ID: <cae4ceb0904271158l56cfc840t858ef5042b1e42f@mail.gmail.com>
From: Tu-Tu Yu <tutuyu@usc.edu>
To: linux-dvb@linuxtv.org
Subject: [linux-dvb] HVR1200 stop after RF tracking filter calibration
	complete
Reply-To: linux-media@vger.kernel.org
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

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

_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
