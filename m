Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp22.services.sfr.fr ([93.17.128.10]:22785 "EHLO
	smtp22.services.sfr.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755595Ab2KMVAH (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 13 Nov 2012 16:00:07 -0500
Message-ID: <50A2C0C4.9040607@sfr.fr>
Date: Tue, 13 Nov 2012 22:51:00 +0100
From: Patrice Chotard <patrice.chotard@sfr.fr>
MIME-Version: 1.0
To: =?iso-8859-1?b?RnLpZOlyaWM=?= <fma@gbiloba.org>
CC: linux-media@vger.kernel.org
Subject: Re: Support for Terratec Cinergy 2400i DT in kernel 3.x
References: <201211131040.22114.fma@gbiloba.org>
In-Reply-To: <201211131040.22114.fma@gbiloba.org>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Hi Frédéric,

Two patches have been already submitted and are available since v3.7-rc1

media] ngene: add support for Terratec Cynergy 2400i Dual DVB-T  :
397e972350c42cbaf3228fe2eec23fecf6a69903

and

media] dvb: add support for Thomson DTT7520X :
5fb67074c6657edc34867cba78255b6f5b505f12

Reading your logs, everything seems OK, i think that with a plugged
antenna the w_scan should indicate that it founds at least some DVB-T
signals like these :

$ w_scan -ft -cFR
w_scan version 20120605 (compiled for DVB API 5.4)
using settings for FRANCE
DVB aerial
DVB-T FR
scan type TERRESTRIAL, channellist 5
output format vdr-1.6
output charset 'UTF-8', use -C <charset> to override
Info: using DVB adapter auto detection.
	/dev/dvb/adapter0/frontend0 -> TERRESTRIAL "Micronas DRXD DVB-T": good :-)
	/dev/dvb/adapter1/frontend0 -> TERRESTRIAL "Micronas DRXD DVB-T": good :-)
Using TERRESTRIAL frontend (adapter /dev/dvb/adapter0/frontend0)
-_-_-_-_ Getting frontend capabilities-_-_-_-_
Using DVB API 5.6
frontend 'Micronas DRXD DVB-T' supports
INVERSION_AUTO
QAM_AUTO
TRANSMISSION_MODE_AUTO
GUARD_INTERVAL_AUTO
HIERARCHY_AUTO
FEC_AUTO
FREQ (185.00MHz ... 855.25MHz)
-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_
Scanning 8MHz frequencies...
474000: (time: 00:03)
474166: (time: 00:05)
473834: (time: 00:08)
474332: (time: 00:10)
474498: (time: 00:13)
482000: (time: 00:15) (time: 00:16) signal ok:
	QAM_AUTO f = 482000 kHz I999B8C999D999T999G999Y999
undefined coderate HP
	new transponder:
	   (QAM_64   f = 4294967 kHz I999B8C999D0T8G32Y0) 0x405A
undefined coderate HP
undefined coderate HP
undefined coderate HP
undefined coderate HP
undefined coderate HP
undefined coderate HP
482166: (time: 00:30) (time: 00:31) signal ok:
	QAM_AUTO f = 482166 kHz I999B8C999D999T999G999Y999
undefined coderate HP
undefined coderate HP
undefined coderate HP
undefined coderate HP
undefined coderate HP
undefined coderate HP
undefined coderate HP
481834: (time: 00:45) (time: 00:46) signal ok:
	QAM_AUTO f = 481834 kHz I999B8C999D999T999G999Y999
undefined coderate HP
undefined coderate HP
undefined coderate HP
undefined coderate HP
undefined coderate HP
undefined coderate HP
undefined coderate HP
482332: (time: 01:00) (time: 01:01)
482498: (time: 01:02) (time: 01:04)
490000: (time: 01:05) (time: 01:06) signal ok:
	QAM_AUTO f = 490000 kHz I999B8C999D999T999G999Y999
undefined coderate HP
undefined coderate HP
undefined coderate HP
undefined coderate HP
undefined coderate HP
undefined coderate HP
undefined coderate HP
490166: (time: 01:20) (time: 01:21) signal ok:
	QAM_AUTO f = 490166 kHz I999B8C999D999T999G999Y999




Patrice

On 13/11/2012 10:40, Frédéric wrote:
> Hi there,
> 
> This is my first post on this list; I hope I'm on the right place to discuss this problem. If 
> not, feel free to tell me where I should post.
> 
> I bought this DVB-T dual tuner card, in order to put it in my HTPC (running geeXboX/XBMC).
> 
> As far as I know, there where only support (patches) for kernel 2.6.x; I didn't find anything 
> for 3.x branch. So I tried to port the patches. And I think I got something... Well, maybe!
> 
> I followed the links on this wiki page:
> 
>     http://linuxtv.org/wiki/index.php/TerraTec_Cinergy_2400i_DVB-T
> 
> It seems that the PCIe bridge used on this card needs a firmware in order to work; this is what 
> the patch does. I used this files:
> 
>     http://wiki.ubuntuusers.de/_attachment?target=/Terratec_Cinergy_2400i_DT/ngene_p11.tar.gz
> 
> As my desktop PC runs under debian sid, I only have a 3.2 kernel, so this is the version I 
> patched to test the driver.
> 
> I can provide all files needed, but I just want to know if the following messages sounds good 
> or if there are still problems...
> 
> During boot, I get:
> 
>  nGene PCIE bridge driver, Copyright (C) 2005-2007 Micronas
>  ngene 0000:03:00.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
>  ngene: Found Terratec Integra/Cinergy2400i Dual DVB-T
>  ngene 0000:03:00.0: setting latency timer to 64
>  ngene: Device version 1
>  ngene: Loading firmware file ngene_17.fw.
>  cxd2099_attach: driver disabled by Kconfig
>  DVB: registering new adapter (nGene)
>  DVB: registering adapter 0 frontend 0 (Micronas DRXD DVB-T)...
>  DVB: registering new adapter (nGene)
>  DVB: registering adapter 1 frontend 0 (Micronas DRXD DVB-T)...
> 
> Then, when I launch w_scan, I get this from kernel:
> 
>  drxd: deviceId = 0000
>  DRX3975D-A2
>  read deviation -520
>  drxd: deviceId = 0000
>  DRX3975D-A2
>  read deviation -333
> 
> and this from w_scan (no antenna pluged):
> 
>  $ w_scan -ft -cFR
>  w_scan version 20120605 (compiled for DVB API 5.4)
>  using settings for FRANCE
>  DVB aerial
>  DVB-T FR
>  scan type TERRESTRIAL, channellist 5
>  output format vdr-1.6
>  output charset 'UTF-8', use -C <charset> to override
>  Info: using DVB adapter auto detection.
>          /dev/dvb/adapter0/frontend0 -> TERRESTRIAL "Micronas DRXD DVB-T": good :-) ¹
>          /dev/dvb/adapter1/frontend0 -> TERRESTRIAL "Micronas DRXD DVB-T": good :-) ¹
>  Using TERRESTRIAL frontend (adapter /dev/dvb/adapter0/frontend0)
>  -_-_-_-_ Getting frontend capabilities-_-_-_-_ 
>  Using DVB API 5.4
>  frontend 'Micronas DRXD DVB-T' supports
>  INVERSION_AUTO
>  QAM_AUTO
>  TRANSMISSION_MODE_AUTO
>  GUARD_INTERVAL_AUTO
>  HIERARCHY_AUTO
>  FEC_AUTO
>  FREQ (47.12MHz ... 855.25MHz)
>  -_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_ 
>  Scanning 8MHz frequencies...
>  474000: (time: 00:00) 
>  474166: (time: 00:03) 
>  473834: (time: 00:05) 
>  ...
>  849834: (time: 09:57) 
>  850332: (time: 09:59) 
>  850498: (time: 10:02) 
>  858000: (time: 10:04)   skipped: (freq 858000000 unsupported by driver)
> 
>  initial_tune:2265: Setting frontend failed QAM_AUTO f = 858000 kHz I999B8C999D999T999G999Y999
>  858166: (time: 10:04)   skipped: (freq 858166000 unsupported by driver)
> 
>  initial_tune:2265: Setting frontend failed QAM_AUTO f = 858166 kHz I999B8C999D999T999G999Y999
>  857834: (time: 10:04)   skipped: (freq 857834000 unsupported by driver)
> 
>  initial_tune:2265: Setting frontend failed QAM_AUTO f = 857834 kHz I999B8C999D999T999G999Y999
>  858332: (time: 10:04)   skipped: (freq 858332000 unsupported by driver)
> 
>  initial_tune:2265: Setting frontend failed QAM_AUTO f = 858332 kHz I999B8C999D999T999G999Y999
>  858498: (time: 10:04)   skipped: (freq 858498000 unsupported by driver)
> 
>  initial_tune:2265: Setting frontend failed QAM_AUTO f = 858498 kHz I999B8C999D999T999G999Y999
> 
>  ERROR: Sorry - i couldn't get any working frequency/transponder
>   Nothing to scan!!
> 
> Reading all these logs, can you tell me if you see obvious problems? I'm neither a kernel guru 
> (this is my first driver contact), nor a DVB-T user (so far!), so a lot of things are not clear 
> to me.
> 
> Thanks for reading.
> 
> ¹ first time w_scan is launched, these lines take 2-3 seconds, and I guess this is when the 
> drxd kernel messages are output.
> 
