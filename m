Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.10]:53815 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756919Ab0FIN7O (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 9 Jun 2010 09:59:14 -0400
Message-ID: <4C0F9E2A.5000708@online.de>
Date: Wed, 09 Jun 2010 15:59:06 +0200
From: =?ISO-8859-15?Q?Andrea_N=F6tzel?= <andrea.noetzel@online.de>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: TECHNOTREND TT-budget C-1501 broken in latest tree budget_ci?
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

since some weeks the TT-budget C-1501 is not longer recognized as
/dev/dvb/.. device using the latest  V4L Snapshot from hg

http://linuxtv.org/hg/v4l-dvb

I have exactly the same problem this user seems to have:
http://www.vdrportal.de/board/thread.php?postid=895650

Using an old V4L snapshot from April works.
I'm using:
ubuntu 2.6.32-22-generic-pae on Ubuntu Lucid
dmesg tells a lot of warnings
[   10.265004] budget_ci: disagrees about version of symbol
ir_codes_budget_ci_old_table
[   10.265006] budget_ci: Unknown symbol ir_codes_budget_ci_old_table
[   10.265321] budget_ci: disagrees about version of symbol
ir_codes_hauppauge_new_table
[   10.265322] budget_ci: Unknown symbol ir_codes_hauppauge_new_table
[   10.265543] budget_ci: disagrees about version of symbol
ir_codes_tt_1500_table
[   10.265545] budget_ci: Unknown symbol ir_codes_tt_1500_table
[   10.265669] budget_ci: disagrees about version of symbol ir_input_init
[   10.265670] budget_ci: Unknown symbol ir_input_init
[   10.265960] budget_ci: disagrees about version of symbol ir_input_nokey
[   10.265961] budget_ci: Unknown symbol ir_input_nokey
[   10.266475] budget_ci: disagrees about version of symbol ir_input_keydown
[   10.266476] budget_ci: Unknown symbol ir_input_keydown
lsmod lists some dvb modules but dvb device is absent
loading budget_ci with modprobe leads to more errors with unknown symbols
[ 1821.613142] budget_ci: disagrees about version of symbol
saa7146_unregister_extension
[ 1821.613151] budget_ci: Unknown symbol saa7146_unregister_extension
[ 1821.613456] budget_ci: disagrees about version of symbol
dvb_ca_en50221_init
[ 1821.613462] budget_ci: Unknown symbol dvb_ca_en50221_init
[ 1821.613855] budget_ci: disagrees about version of symbol
ttpci_budget_debiwrite
[ 1821.613860] budget_ci: Unknown symbol ttpci_budget_debiwrite
[ 1821.614311] budget_ci: disagrees about version of symbol
ttpci_budget_irq10_handler
[ 1821.614316] budget_ci: Unknown symbol ttpci_budget_irq10_handler
[ 1821.614554] budget_ci: Unknown symbol __ir_input_register
[ 1821.614768] budget_ci: disagrees about version of symbol
ttpci_budget_deinit
[ 1821.614773] budget_ci: Unknown symbol ttpci_budget_deinit
[ 1821.615003] budget_ci: disagrees about version of symbol
saa7146_register_extension
[ 1821.615008] budget_ci: Unknown symbol saa7146_register_extension
[ 1821.615658] budget_ci: Unknown symbol ir_keydown
[ 1821.615893] budget_ci: disagrees about version of symbol
ttpci_budget_set_video_port
[ 1821.615898] budget_ci: Unknown symbol ttpci_budget_set_video_port
[ 1821.616116] budget_ci: disagrees about version of symbol
ttpci_budget_debiread
[ 1821.616121] budget_ci: Unknown symbol ttpci_budget_debiread
[ 1821.616576] budget_ci: disagrees about version of symbol
dvb_frontend_detach
[ 1821.616581] budget_ci: Unknown symbol dvb_frontend_detach
[ 1821.617515] budget_ci: disagrees about version of symbol
dvb_unregister_frontend
[ 1821.617521] budget_ci: Unknown symbol dvb_unregister_frontend
[ 1821.618001] budget_ci: disagrees about version of symbol
ttpci_budget_init_hooks
[ 1821.618006] budget_ci: Unknown symbol ttpci_budget_init_hooks
[ 1821.618309] budget_ci: disagrees about version of symbol
ttpci_budget_init
[ 1821.618314] budget_ci: Unknown symbol ttpci_budget_init
[ 1821.618532] budget_ci: disagrees about version of symbol
dvb_register_frontend
[ 1821.618537] budget_ci: Unknown symbol dvb_register_frontend
[ 1821.618764] budget_ci: disagrees about version of symbol saa7146_setgpio
[ 1821.618769] budget_ci: Unknown symbol saa7146_setgpio
[ 1821.619011] budget_ci: Unknown symbol get_rc_map

Can somebody help me out please?

Best Regards,
Andrea



