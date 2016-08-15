Return-path: <linux-media-owner@vger.kernel.org>
Received: from buckingham.telekom.sk ([213.81.152.80]:55944 "EHLO
	smtp.t-com.sk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753030AbcHOPbf (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 15 Aug 2016 11:31:35 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-disposition: inline
Content-type: text/plain; charset=us-ascii
Received: from stonline.sk ([unknown] [192.168.32.30])
 by mta-out2.stonline.sk (STOnline ESMTP Server)
 with ESMTP id <0OBY00KYGIXNYVA0@mta-out2.stonline.sk> for
 linux-media@vger.kernel.org; Mon, 15 Aug 2016 17:27:23 +0200 (CEST)
From: =?iso-8859-2?B?TmVkdmXvYWwgTWFyaeFu?= <neiveial@stonline.sk>
To: linux-media@vger.kernel.org
Message-id: <7530c2753e75.57b1fc75@stonline.sk>
Date: Mon, 15 Aug 2016 17:31:33 +0200
Content-language: sk
Subject: TS discontinuity invalid eit section
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Hi,

I have PCI_e tbs6928(FE)-linux tbs driver; usb TT 3650CI-media build drivers.
For both cards noticing the same problem-astra 23.5;dvb-s2 transp.(not all).
It's about problem drivers.Tested with dvblast, mumudvb, vdr.

~$ dvblast -f 12363000
...
warning: TS discontinuity on pid   18 expected_cc 15 got  0 (EPG, sid 0)
warning: TS discontinuity on pid   18 expected_cc  7 got  8 (EPG, sid 0)
warning: invalid EIT section received on PID 18
error type: invalid_eit_section pid: 18
warning: TS discontinuity on pid   18 expected_cc  2 got  3 (EPG, sid 0)
...

image falls apart.
Tested on different kernels(ubuntu,debian).
It can do anything to help?
