Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout-de.gmx.net ([213.165.64.23]:46527 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S932590Ab1GNXqY (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 14 Jul 2011 19:46:24 -0400
From: Oliver Endriss <o.endriss@gmx.de>
Reply-To: linux-media@vger.kernel.org
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: [PATCH 0/5] Driver support for cards based on Digital Devices bridge (ddbridge)
Date: Fri, 15 Jul 2011 01:45:26 +0200
Cc: linux-media@vger.kernel.org, Ralph Metzler <rjkm@metzlerbros.de>
References: <201107032321.46092@orion.escape-edv.de> <201107040124.04924@orion.escape-edv.de> <4E1106B0.7030102@redhat.com>
In-Reply-To: <4E1106B0.7030102@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201107150145.29547@orion.escape-edv.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Monday 04 July 2011 02:17:52 Mauro Carvalho Chehab wrote:
> Em 03-07-2011 20:24, Oliver Endriss escreveu:
...
> > Anyway, I spent the whole weekend to re-format the code carefully
> > and create both patch series, trying not to break anything.
> > I simply cannot go through the driver code and verify everything.
> 
> As the changes on CHK_ERROR were done via script, it is unlikely that it
> introduced any problems (well, except if some function is returning
> a positive value as an error code, but I think that this is not the
> case).
> 
> I did the same replacement when I've cleanup the drx-d driver (well, the 
> script were not the same, but it used a similar approach), and the changes 
> didn't break anything, but it is safer to have a test, to be sure that no
> functional changes were introduced.
> 
> A simple test with the code and some working board is probably enough
> to verify that nothing broke.

Finally I found some time to do this 'simple' test.

Congratulations! You completely broke the DRXK for ngene and ddbridge:
- DVB-T tuning does not work anymore.
- Module unloading fails as well. drxk is 'in use' due to bad reference count.

(DVB-C not tested: I currently do not have access to a DVB-C signal.)

Loading the driver:
Jul 15 00:52:48 darkstar kernel: [  184.487399] Digital Devices PCIE bridge driver, Copyright (C) 2010-11 Digital Devices GmbH
Jul 15 00:52:48 darkstar kernel: [  184.487460] DDBridge 0000:01:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
Jul 15 00:52:48 darkstar kernel: [  184.487469] DDBridge driver detected: Digital Devices Octopus DVB adapter
Jul 15 00:52:48 darkstar kernel: [  184.487491] HW 00010001 FW 00010000
Jul 15 00:52:48 darkstar kernel: [  184.488321] Port 0 (TAB 1): DUAL DVB-S2
Jul 15 00:52:48 darkstar kernel: [  184.488837] Port 1 (TAB 2): NO MODULE
Jul 15 00:52:48 darkstar kernel: [  184.489654] Port 2 (TAB 3): DUAL DVB-C/T
Jul 15 00:52:48 darkstar kernel: [  184.490159] Port 3 (TAB 4): NO MODULE
Jul 15 00:52:48 darkstar kernel: [  184.491245] DVB: registering new adapter (DDBridge)
Jul 15 00:52:48 darkstar kernel: [  184.644296] LNBx2x attached on addr=b
Jul 15 00:52:48 darkstar kernel: [  184.644363] stv6110x_attach: Attaching STV6110x
Jul 15 00:52:48 darkstar kernel: [  184.644365] attach tuner input 0 adr 60
Jul 15 00:52:48 darkstar kernel: [  184.644368] DVB: registering adapter 2 frontend 0 (STV090x Multistandard)...
Jul 15 00:52:48 darkstar kernel: [  184.644435] DVB: registering new adapter (DDBridge)
Jul 15 00:52:48 darkstar kernel: [  184.680305] LNBx2x attached on addr=9
Jul 15 00:52:48 darkstar kernel: [  184.680373] stv6110x_attach: Attaching STV6110x
Jul 15 00:52:48 darkstar kernel: [  184.680375] attach tuner input 1 adr 63
Jul 15 00:52:48 darkstar kernel: [  184.680378] DVB: registering adapter 3 frontend 0 (STV090x Multistandard)...
Jul 15 00:52:48 darkstar kernel: [  184.680445] DVB: registering new adapter (DDBridge)
Jul 15 00:52:48 darkstar kernel: [  184.688938] drxk: detected a drx-3913k, spin A3, xtal 27.000 MHz
Jul 15 00:52:48 darkstar kernel: [  185.108839] DRXK driver version 0.9.4300
Jul 15 00:52:50 darkstar kernel: [  186.796361] DVB: registering adapter 4 frontend 0 (DRXK DVB-C)...
Jul 15 00:52:50 darkstar kernel: [  186.796429] DVB: registering adapter 4 frontend 0 (DRXK DVB-T)...
Jul 15 00:52:50 darkstar kernel: [  186.796471] DVB: registering new adapter (DDBridge)
Jul 15 00:52:50 darkstar kernel: [  186.804923] drxk: detected a drx-3913k, spin A3, xtal 27.000 MHz
Jul 15 00:52:50 darkstar kernel: [  187.224841] DRXK driver version 0.9.4300
Jul 15 00:52:52 darkstar kernel: [  188.912354] DVB: registering adapter 5 frontend 0 (DRXK DVB-C)...
Jul 15 00:52:52 darkstar kernel: [  188.912424] DVB: registering adapter 5 frontend 0 (DRXK DVB-T)...

When trying to tune, the log is flooded with:
Jul 15 00:53:15 darkstar kernel: [  211.537173] drxk: Error -22 on DVBTScCommand
Jul 15 00:53:15 darkstar kernel: [  211.538206] drxk: Error -22 on DVBTStart
Jul 15 00:53:15 darkstar kernel: [  211.539151] drxk: Error -22 on Start
Jul 15 00:53:15 darkstar kernel: [  211.940231] drxk: SCU not ready
Jul 15 00:53:15 darkstar kernel: [  211.941310] drxk: Error -5 on SetDVBT
Jul 15 00:53:15 darkstar kernel: [  211.942243] drxk: Error -5 on Start
Jul 15 00:53:15 darkstar kernel: [  212.340237] drxk: SCU not ready
Jul 15 00:53:15 darkstar kernel: [  212.341286] drxk: Error -5 on SetDVBT
Jul 15 00:53:15 darkstar kernel: [  212.342202] drxk: Error -5 on Start
Jul 15 00:53:16 darkstar kernel: [  212.740238] drxk: SCU not ready
...

Unloading:
ERROR: Module drxk is in use

lsmod:
Module                  Size  Used by
drxk                   47332  2


Sorry, I currently do not have the time to dig through your changesets.

With these bugs the driver is unusable and not ready for the kernel.

I hereby NACK submission of the driver to the kernel!

CU
Oliver

-- 
----------------------------------------------------------------
VDR Remote Plugin 0.4.0: http://www.escape-edv.de/endriss/vdr/
4 MByte Mod: http://www.escape-edv.de/endriss/dvb-mem-mod/
Full-TS Mod: http://www.escape-edv.de/endriss/dvb-full-ts-mod/
----------------------------------------------------------------
