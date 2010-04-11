Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp115.plus.mail.re1.yahoo.com ([69.147.102.78]:34345 "HELO
	smtp115.plus.mail.re1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753995Ab0DIIMY (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 9 Apr 2010 04:12:24 -0400
Message-ID: <4BC18364.6080006@yahoo.gr>
Date: Sun, 11 Apr 2010 11:08:04 +0300
From: Nick GIannakopoulos <int_nick_dot@yahoo.gr>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: cx23885: board id  [14f1:8852]
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

 Hi, 

 I've made tests with my *LV8H Hybrid PCI Express* board:

 *Model*: LV8H Hybrid PCI Express
 *Vendor/Product id*:[14f1:8852]
 *Kernel:* 2.6.33 + v4l-dvb-fw-bf7cd2fb7a35

 *Tests made*: 

     - Analog [No]
     - DVB    [No]
     - VBI    [No]

* Part of Kernel Logs:*
  
 --------------->
 [17.575569] cx23885 driver version 0.0.2 loaded
 [17.575592] cx23885 0000:04:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
 [17.575594] cx23885[0]: Your board isn't known (yet) to the driver.

  ...

 [17.575669] CORE cx23885[0]: subsystem: 14f1:ec80, board: UNKNOWN/GENERIC [card=0,autodetected]
 [17.703067] cx23885_dev_checkrevision() Hardware revision = 0xb0
 [17.703073] cx23885[0]/0: found at 0000:04:00.0, rev: 2, irq: 16, latency: 0, mmio: 0xfb800000

 ---------------->

 More tests i will post soon.
 If you need more informations/logs about this board let me know. 

 *Tested-by*: int_nick_dot@yahoo.gr



