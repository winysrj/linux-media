Return-path: <mchehab@gaivota>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:65454 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755223Ab1ENWjq (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 14 May 2011 18:39:46 -0400
Received: by vws1 with SMTP id 1so2487231vws.19
        for <linux-media@vger.kernel.org>; Sat, 14 May 2011 15:39:45 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <AANLkTikgwQbrETmX7pOcBnsM2w+ipnMczCJBSa8LwEeQ@mail.gmail.com>
References: <AANLkTi=_LHucekW21KeGt3yWMNYHntQ5nVvHUO2EVHAO@mail.gmail.com>
	<AANLkTimDK7kwV3AeZm5+56W3V_yp+nghq67qYP2r4DWq@mail.gmail.com>
	<AANLkTimDVfv-SGv8d0TVPPQD+eU8yUQ08MrCGXrXhMtz@mail.gmail.com>
	<AANLkTi=wotgd2JQ5b65rh5ExoU=+c4cAOZNFAg-NzJwr@mail.gmail.com>
	<AANLkTin6LyzVV=xw7mPOx3TupmX0YjQ38Q2Jzzpve+nS@mail.gmail.com>
	<87oc73muul.fsf@nemi.mork.no>
	<AANLkTikgwQbrETmX7pOcBnsM2w+ipnMczCJBSa8LwEeQ@mail.gmail.com>
Date: Sun, 15 May 2011 00:39:44 +0200
Message-ID: <BANLkTims3znowDKpsFHHcO2BjBxAcbz5=A@mail.gmail.com>
Subject: Re: DVB driver for TerraTec H7 - how do I install them?
From: Torfinn Ingolfsen <tingox@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

Update:
There is a new / updated driver for the H7 over at TerraTec's site:
http://linux.terratec.de/files/TERRATEC_H7/20110323_TERRATEC_H7_Linux.tar.gz

and this time, it includes instructions. Using these instructions and
Xubuntu 10.10 with this kernel:
tingo@vm:~$ uname -a
Linux vm 2.6.35-28-generic-pae #50-Ubuntu SMP Fri Mar 18 20:43:15 UTC
2011 i686 GNU/Linux

I was able to get the H7 recognized. From /var/log/messages:
May 14 23:59:26 vm kernel: [ 4226.560048] usb 1-2: new high speed USB
device using ehci_hcd and address 3
May 14 23:59:27 vm kernel: [ 4227.007366] az6007: henry :: az6007 usb
module init
May 14 23:59:27 vm kernel: [ 4227.007551] az6007: usb in operation failed. (-32)
May 14 23:59:27 vm kernel: [ 4227.007795] az6007: FW GET_VERSION length: -32
May 14 23:59:27 vm kernel: [ 4227.007796]
May 14 23:59:27 vm kernel: [ 4227.007798] az6007: cold: 1
May 14 23:59:27 vm kernel: [ 4227.007798]
May 14 23:59:27 vm kernel: [ 4227.007800] dvb-usb: found a 'TerraTec
DTV StarBox DVB-T/C USB2.0 (az6007)' in cold state, will try to load a
firmware
May 14 23:59:27 vm kernel: [ 4227.009825] dvb-usb: downloading
firmware from file 'dvb-usb-az6007-03.fw'
May 14 23:59:27 vm kernel: [ 4227.084577] dvb-usb: found a 'TerraTec
DTV StarBox DVB-T/C USB2.0 (az6007)' in warm state.
May 14 23:59:27 vm kernel: [ 4227.084674] dvb-usb: will pass the
complete MPEG2 transport stream to the software demuxer.
May 14 23:59:27 vm kernel: [ 4227.302655] DVB: registering new adapter
(TerraTec DTV StarBox DVB-T/C USB2.0 (az6007))
May 14 23:59:27 vm kernel: [ 4227.311991] dvb-usb: MAC address:
c2:cd:0c:a3:10:00
May 14 23:59:27 vm kernel: [ 4227.312475] az6007:
az6007_frontend_poweron adap=f34ee88c adap->dev=f34ee000
May 14 23:59:27 vm kernel: [ 4227.312478]
May 14 23:59:28 vm kernel: [ 4227.720338] az6007: az6007_frontend_poweron
May 14 23:59:28 vm kernel: [ 4227.720343]
May 14 23:59:28 vm kernel: [ 4227.720349] az6007:
az6007_frontend_reset adap=f34ee88c adap->dev=f34ee000
May 14 23:59:28 vm kernel: [ 4227.720352]
May 14 23:59:28 vm kernel: [ 4228.332027] az6007: reset az6007 frontend
May 14 23:59:28 vm kernel: [ 4228.332032]
May 14 23:59:28 vm kernel: [ 4228.332036] az6007: az6007_frontend_attach
May 14 23:59:28 vm kernel: [ 4228.332038]
May 14 23:59:28 vm kernel: [ 4228.332040] az6007: az6007_drxk3913_config_DVBT
May 14 23:59:28 vm kernel: [ 4228.332042]
May 14 23:59:28 vm kernel: [ 4228.332046] state->frontend.ops =
drxk3913_ops_dvbt
May 14 23:59:28 vm kernel: [ 4228.332053] mt2063_attach: Attaching MT2063
May 14 23:59:28 vm kernel: [ 4228.332057] az6007: found STB6100
DVB-C/DVB-T frontend @0xc0
May 14 23:59:28 vm kernel: [ 4228.332059]
May 14 23:59:28 vm kernel: [ 4228.332066] DVB: registering adapter 0
frontend 0 (DRXK3913 Multistandard DVB_T)...
May 14 23:59:28 vm kernel: [ 4228.332278] input: IR-receiver inside an
USB DVB receiver as
/devices/pci0000:00/0000:00:13.5/usb1/1-2/input/input4
May 14 23:59:28 vm kernel: [ 4228.332335] dvb-usb: schedule remote
query interval to 400 msecs.
May 14 23:59:28 vm kernel: [ 4228.332341] dvb-usb: TerraTec DTV
StarBox DVB-T/C USB2.0 (az6007) successfully initialized and
connected.
May 14 23:59:28 vm kernel: [ 4228.332385] usbcore: registered new
interface driver dvb_usb_az6007

Unfortunately, I am not able to test if the driver works just now,
because currently the driver only supports DVB-T, and I only have
DVB-C.
-- 
Regards,
Torfinn Ingolfsen
