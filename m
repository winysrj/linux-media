Return-path: <mchehab@pedra>
Received: from mail.tu-berlin.de ([130.149.7.33])
	by www.linuxtv.org with esmtp (Exim 4.69)
	(envelope-from <ftirapelle@yahoo.it>) id 1P5EHq-0002RP-42
	for linux-dvb@linuxtv.org; Mon, 11 Oct 2010 11:03:15 +0200
Received: from nm15.bullet.mail.ukl.yahoo.com ([217.146.183.189])
	by mail.tu-berlin.de (exim-4.69/mailfrontend-d) with smtp
	for <linux-dvb@linuxtv.org>
	id 1P5EHp-0000Ho-29; Mon, 11 Oct 2010 11:03:13 +0200
Message-ID: <548853.29784.qm@web25406.mail.ukl.yahoo.com>
Date: Mon, 11 Oct 2010 10:03:11 +0100 (BST)
From: fabio tirapelle <ftirapelle@yahoo.it>
To: linux-dvb@linuxtv.org
MIME-Version: 1.0
Subject: [linux-dvb] Hauppauge WinTV-HVR-1120
Reply-To: linux-media@vger.kernel.org
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/options/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
Sender: <mchehab@pedra>
List-ID: <linux-dvb@linuxtv.org>

Hi

After upgrading from Ubuntu 9.10 to Ubuntu 10.04 my Hauppauge WinTV-HVR-1120 
sometimes doesn't work correctly.
I get random the following errors:

[   53.216153] DVB: registering new adapter (saa7133[0])
[   53.216156] DVB: registering adapter 2 frontend 0 (NXP TDA10048HN DVB-T)...
[   53.840013] tda10048_firmware_upload: waiting for firmware upload 
(dvb-fe-tda10048-1.0.fw)...
[   53.840019] saa7134 0000:01:06.0: firmware: requesting dvb-fe-tda10048-1.0.fw
[   53.880505] tda10048_firmware_upload: firmware read 24878 bytes.
[   53.880509] tda10048_firmware_upload: firmware uploading
[   58.280136] tda10048_firmware_upload: firmware uploaded
[   59.024537] tda18271_write_regs: ERROR: idx = 0x5, len = 1, i2c_transfer 
returned: -5
[   59.024541] tda18271c2_rf_tracking_filters_correction: error -5 on line 264
[   59.420153] tda18271_write_regs: ERROR: idx = 0x5, len = 1, i2c_transfer 
returned: -5
[   59.420157] tda18271_toggle_output: error -5 on line 47
[   91.004019] Clocksource tsc unstable (delta = -295012684 ns)
[  256.293639] eth0: link up.
[  256.294750] ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
[  263.523498] eth0: link down.
[  265.258740] eth0: link up.
[  266.460026] eth0: no IPv6 routers present
[ 9869.636167] tda18271_write_regs: ERROR: idx = 0x5, len = 1, i2c_transfer 
returned: -5
[ 9869.636178] tda18271_init: error -5 on line 826
[ 9872.636220] tda18271_write_regs: ERROR: idx = 0x5, len = 1, i2c_transfer 
returned: -5
[ 9872.636232] tda18271_toggle_output: error -5 on line 47
[ 9998.240167] tda18271_write_regs: ERROR: idx = 0x5, len = 1, i2c_transfer 
returned: -5
[ 9998.240178] tda18271_init: error -5 on line 826
[10001.240179] tda18271_write_regs: ERROR: idx = 0x5, len = 1, i2c_transfer 
returned: -5
[10001.240190] tda18271_toggle_output: error -5 on line 47



Any ideas?
Thanks


      

_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
