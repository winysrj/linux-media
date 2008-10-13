Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail-gx0-f20.google.com ([209.85.217.20])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <eduardhc@gmail.com>) id 1KpKv7-0007hr-0Y
	for linux-dvb@linuxtv.org; Mon, 13 Oct 2008 12:45:03 +0200
Received: by gxk13 with SMTP id 13so3120160gxk.17
	for <linux-dvb@linuxtv.org>; Mon, 13 Oct 2008 03:44:25 -0700 (PDT)
Message-ID: <617be8890810130344o697b53f8lfd27d8a4ce5a6d8c@mail.gmail.com>
Date: Mon, 13 Oct 2008 12:44:25 +0200
From: "Eduard Huguet" <eduardhc@gmail.com>
To: linux-dvb@linuxtv.org
In-Reply-To: <617be8890810090326k19c56583x9cb35b457286a939@mail.gmail.com>
MIME-Version: 1.0
References: <617be8890810090326k19c56583x9cb35b457286a939@mail.gmail.com>
Subject: [linux-dvb] Fwd: Pinnacle PCTV DVB-T Flash Stick (2304:0228) -
	supported?
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============0261576134=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--===============0261576134==
Content-Type: multipart/alternative;
	boundary="----=_Part_120955_11831440.1223894665779"

------=_Part_120955_11831440.1223894665779
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

No ideas...? That's a pity, I really thought that support for this device
was very close, as there seems to be at least some degree of control of the
device from Linux. Maybe someone experienced with Pinnacle PCTV devices
could give any clue or hint...

Regards,
  Eduard



---------- Forwarded message ----------
From: Eduard Huguet <eduardhc@gmail.com>
Date: 2008/10/9
Subject: Pinnacle PCTV DVB-T Flash Stick (2304:0228) - supported?
To: linux-dvb@linuxtv.org


Hi,
    I'm trying to make this device work. I've been unable to determine from
wiki if this device is really supported or not, although I'm afraid is not,
but probably not much effort is needed to support it. I say this because the
device is indeed detected and initialized when using up-to-date HG drivers,
but scanning for channels seems apparently fails althogh the device is
apparently tunning fine.

The device is identified by USB ids 2304:0228.


Here's the relevant dmesg output for this device:

[11180.541995] usb 6-6: new high speed USB device using ehci_hcd and address
6
[11180.682817] usb 6-6: configuration #1 chosen from 1 choice
[11180.683106] hub 6-6:1.0: USB hub found
[11180.683694] hub 6-6:1.0: 2 ports detected
[11180.985547] usb 6-6.1: new high speed USB device using ehci_hcd and
address 7
[11181.082133] usb 6-6.1: configuration #1 chosen from 1 choice
[11181.082757] scsi5 : SCSI emulation for USB Mass Storage devices
[11181.082834] usb-storage: device found at 7
[11181.082838] usb-storage: waiting for device to settle before scanning
[11186.072931] usb-storage: device scan complete
[11186.074053] scsi 5:0:0:0: Direct-Access     GENERIC  STORAGE DEVICE
2269 PQ: 0 ANSI: 0
[11186.075169] scsi 5:0:0:1: CD-ROM            GENERIC  STORAGE DEVICE
2269 PQ: 0 ANSI: 0 CCS
[11186.076657] sd 5:0:0:0: [sdb] 2041856 512-byte hardware sectors (1045 MB)
[11186.077899] sd 5:0:0:0: [sdb] Write Protect is off
[11186.077905] sd 5:0:0:0: [sdb] Mode Sense: 02 00 00 00
[11186.077911] sd 5:0:0:0: [sdb] Assuming drive cache: write through
[11186.080018] sd 5:0:0:0: [sdb] 2041856 512-byte hardware sectors (1045 MB)
[11186.081267] sd 5:0:0:0: [sdb] Write Protect is off
[11186.081273] sd 5:0:0:0: [sdb] Mode Sense: 02 00 00 00
[11186.081277] sd 5:0:0:0: [sdb] Assuming drive cache: write through
[11186.081282]  sdb:<4>printk: 5 messages suppressed.
[11186.081336] Buffer I/O error on device sdb, logical block 0
[11186.081354] Buffer I/O error on device sdb, logical block 0
[11186.081372] Buffer I/O error on device sdb, logical block 0
[11186.081386] Buffer I/O error on device sdb, logical block 0
[11186.081402] Buffer I/O error on device sdb, logical block 0
[11186.081411] ldm_validate_partition_table(): Disk read failed.
[11186.081424] Buffer I/O error on device sdb, logical block 0
[11186.081439] Buffer I/O error on device sdb, logical block 0
[11186.081455] Buffer I/O error on device sdb, logical block 0
[11186.081470] Buffer I/O error on device sdb, logical block 0
[11186.081478] Dev sdb: unable to read RDB block 0
[11186.081490] Buffer I/O error on device sdb, logical block 0
[11186.081545]  unable to read partition table
[11186.081921] sd 5:0:0:0: [sdb] Attached SCSI removable disk
[11186.081985] sd 5:0:0:0: Attached scsi generic sg3 type 0
[11186.164614] usb 6-6.1: reset high speed USB device using ehci_hcd and
address 7
[11186.336325] usb 6-6.1: reset high speed USB device using ehci_hcd and
address 7
[11186.432666] sr2: scsi3-mmc drive: 40x/40x cd/rw xa/form2 cdda tray
[11186.432741] sr 5:0:0:1: Attached scsi CD-ROM sr2
[11186.432807] sr 5:0:0:1: Attached scsi generic sg4 type 5
[11186.433558] sd 5:0:0:0: [sdb] 2041856 512-byte hardware sectors (1045 MB)
[11186.508035] usb 6-6.1: reset high speed USB device using ehci_hcd and
address 7
[11186.604380] sd 5:0:0:0: [sdb] Write Protect is off
[11186.604389] sd 5:0:0:0: [sdb] Mode Sense: 02 00 00 00
[11186.604393] sd 5:0:0:0: [sdb] Assuming drive cache: write through
[11186.608190] sd 5:0:0:0: [sdb] 2041856 512-byte hardware sectors (1045 MB)
[11186.679735] usb 6-6.1: reset high speed USB device using ehci_hcd and
address 7
[11186.775834] sd 5:0:0:0: [sdb] Write Protect is off
[11186.775845] sd 5:0:0:0: [sdb] Mode Sense: 02 00 00 00
[11186.775849] sd 5:0:0:0: [sdb] Assuming drive cache: write through
[11186.775858]  sdb:<6>usb 6-6.1: reset high speed USB device using ehci_hcd
and address 7
[11186.943809]
[11187.015157] usb 6-6.1: reset high speed USB device using ehci_hcd and
address 7
[11187.218801] usb 6-6.1: reset high speed USB device using ehci_hcd and
address 7
[11187.382516] usb 6-6.2: new high speed USB device using ehci_hcd and
address 8
[11187.475115] usb 6-6.2: configuration #1 chosen from 1 choice
[11187.475362] dvb-usb: found a 'Pinnacle PCTV DVB-T Flash Stick' in cold
state, will try to load a firmware
[11187.489855] dvb-usb: downloading firmware from file
'dvb-usb-dib0700-1.10.fw'
[11187.546243] usb 6-6.1: reset high speed USB device using ehci_hcd and
address 7
[11187.689702] dib0700: firmware started successfully.
[11187.749886] usb 6-6.1: reset high speed USB device using ehci_hcd and
address 7
[11187.917601] usb 6-6.1: reset high speed USB device using ehci_hcd and
address 7
[11188.121242] usb 6-6.1: reset high speed USB device using ehci_hcd and
address 7
[11188.192872] dvb-usb: found a 'Pinnacle PCTV DVB-T Flash Stick' in warm
state.
[11188.192953] dvb-usb: will pass the complete MPEG2 transport stream to the
software demuxer.
[11188.193214] DVB: registering new adapter (Pinnacle PCTV DVB-T Flash
Stick)
[11188.409625] DVB: registering frontend 2 (DiBcom 7000PC)...
[11188.528545] usb 6-6.1: reset high speed USB device using ehci_hcd and
address 7
[11188.592931] DiB0070: successfully identified
[11188.593049] input: IR-receiver inside an USB DVB receiver as
/class/input/input8
[11188.593088] dvb-usb: schedule remote query interval to 150 msecs.
[11188.593096] dvb-usb: Pinnacle PCTV DVB-T Flash Stick successfully
initialized and connected.
[11188.935863] usb 6-6.1: reset high speed USB device using ehci_hcd and
address 7
[11189.103561] usb 6-6.1: reset high speed USB device using ehci_hcd and
address 7
[11189.271272] usb 6-6.1: reset high speed USB device using ehci_hcd and
address 7
[11189.438981] usb 6-6.1: reset high speed USB device using ehci_hcd and
address 7
[11189.606693] usb 6-6.1: reset high speed USB device using ehci_hcd and
address 7
[11189.774402] usb 6-6.1: reset high speed USB device using ehci_hcd and
address 7
[11189.942109] usb 6-6.1: reset high speed USB device using ehci_hcd and
address 7
[11190.109815] usb 6-6.1: reset high speed USB device using ehci_hcd and
address 7
[11190.281524] usb 6-6.1: reset high speed USB device using ehci_hcd and
address 7
[11190.449235] usb 6-6.1: reset high speed USB device using ehci_hcd and
address 7
[11190.616956] usb 6-6.1: reset high speed USB device using ehci_hcd and
address 7
[11190.784907] usb 6-6.1: reset high speed USB device using ehci_hcd and
address 7
[11190.952376] usb 6-6.1: reset high speed USB device using ehci_hcd and
address 7
[11191.120086] usb 6-6.1: reset high speed USB device using ehci_hcd and
address 7
[11191.287794] usb 6-6.1: reset high speed USB device using ehci_hcd and
address 7
[11191.455505] usb 6-6.1: reset high speed USB device using ehci_hcd and
address 7
[11191.671129] usb 6-6.1: reset high speed USB device using ehci_hcd and
address 7
[11191.838840] usb 6-6.1: reset high speed USB device using ehci_hcd and
address 7
[11192.006547] usb 6-6.1: reset high speed USB device using ehci_hcd and
address 7
[11192.174269] usb 6-6.1: reset high speed USB device using ehci_hcd and
address 7
[11192.341974] usb 6-6.1: reset high speed USB device using ehci_hcd and
address 7
[11192.509685] usb 6-6.1: reset high speed USB device using ehci_hcd and
address 7
[11192.677402] usb 6-6.1: reset high speed USB device using ehci_hcd and
address 7
[11192.845100] usb 6-6.1: reset high speed USB device using ehci_hcd and
address 7
[11193.076709] usb 6-6.1: reset high speed USB device using ehci_hcd and
address 7
[11193.244412] usb 6-6.1: reset high speed USB device using ehci_hcd and
address 7
[11193.412136] usb 6-6.1: reset high speed USB device using ehci_hcd and
address 7
[11193.579840] usb 6-6.1: reset high speed USB device using ehci_hcd and
address 7
[11193.747549] usb 6-6.1: reset high speed USB device using ehci_hcd and
address 7
[11193.915261] usb 6-6.1: reset high speed USB device using ehci_hcd and
address 7
[11194.082968] usb 6-6.1: reset high speed USB device using ehci_hcd and
address 7
[11194.250687] usb 6-6.1: reset high speed USB device using ehci_hcd and
address 7
[11194.418390] usb 6-6.1: reset high speed USB device using ehci_hcd and
address 7
[11194.586113] usb 6-6.1: reset high speed USB device using ehci_hcd and
address 7
[11194.753819] usb 6-6.1: reset high speed USB device using ehci_hcd and
address 7
[11194.921537] usb 6-6.1: reset high speed USB device using ehci_hcd and
address 7


Note that this device is a USB key containing both 1GB of memory (since the
USB storage messages shown) and the DVB-T adapter itself. The device seems
to be based on same DIBComm 7000PC device, apparentlyt handled by
dvb_usb_dib0700 driver (in dmesg you can see how 1.10 firmware file is
loaded for it). The frontend is created succesfully, so.


However, when trying to scan channels I get the following result:

using '/dev/dvb/adapter2/frontend0' and '/dev/dvb/adapter2/demux0'
initial transponder 514000000 0 2 9 3 1 3 0
initial transponder 570000000 0 2 9 3 1 3 0
initial transponder 794000000 0 2 9 3 1 3 0
initial transponder 818000000 0 2 9 3 1 3 0
initial transponder 834000000 0 2 9 3 1 3 0
initial transponder 842000000 0 2 9 3 1 3 0
initial transponder 850000000 0 2 9 3 1 3 0
initial transponder 858000000 0 2 9 3 1 3 0
>>> tune to:
514000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_2_3:FEC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_4:HIERARCHY_NONE
WARNING: filter timeout pid 0x0011
WARNING: filter timeout pid 0x0000
WARNING: filter timeout pid 0x0010
>>> tune to:
570000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_2_3:FEC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_4:HIERARCHY_NONE
WARNING: filter timeout pid 0x0011
WARNING: filter timeout pid 0x0000
WARNING: filter timeout pid 0x0010
>>> tune to:
794000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_2_3:FEC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_4:HIERARCHY_NONE
WARNING: filter timeout pid 0x0011
WARNING: filter timeout pid 0x0000
WARNING: filter timeout pid 0x0010
>>> tune to:
818000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_2_3:FEC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_4:HIERARCHY_NONE
WARNING: filter timeout pid 0x0011
WARNING: filter timeout pid 0x0000
WARNING: filter timeout pid 0x0010
>>> tune to:
834000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_2_3:FEC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_4:HIERARCHY_NONE
WARNING: filter timeout pid 0x0011
WARNING: filter timeout pid 0x0000
WARNING: filter timeout pid 0x0010
>>> tune to:
842000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_2_3:FEC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_4:HIERARCHY_NONE
WARNING: filter timeout pid 0x0011
WARNING: filter timeout pid 0x0000
WARNING: filter timeout pid 0x0010
>>> tune to:
850000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_2_3:FEC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_4:HIERARCHY_NONE
WARNING: filter timeout pid 0x0011
WARNING: filter timeout pid 0x0000
WARNING: filter timeout pid 0x0010
>>> tune to:
858000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_2_3:FEC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_4:HIERARCHY_NONE
WARNING: filter timeout pid 0x0011
WARNING: filter timeout pid 0x0000
WARNING: filter timeout pid 0x0010
dumping lists (0 services)
Done.


So, as you can see the device is apparently tunning fine, but no channels
are detected. Note that this system has also a Nova-T 500 installed that
detects perfectly all available channels, so it's not an antenna problem.
Also, if I remove the antenna then I get (as expected) the usual "tunning
failed" messages, as the card is not able to lock on the signal then.



Best regards,
  Eduard Huguet

------=_Part_120955_11831440.1223894665779
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

<div dir="ltr">No ideas...? That&#39;s a pity, I really thought that support for this device was very close, as there seems to be at least some degree of control of the device from Linux. Maybe someone experienced with Pinnacle PCTV devices could give any clue or hint...<br>
<br>Regards, <br>&nbsp; Eduard<br><br><br><br><div class="gmail_quote">---------- Forwarded message ----------<br>From: <b class="gmail_sendername">Eduard Huguet</b> <span dir="ltr">&lt;<a href="mailto:eduardhc@gmail.com">eduardhc@gmail.com</a>&gt;</span><br>
Date: 2008/10/9<br>Subject: Pinnacle PCTV DVB-T Flash Stick (2304:0228) - supported?<br>To: <a href="mailto:linux-dvb@linuxtv.org">linux-dvb@linuxtv.org</a><br><br><br><div dir="ltr"><div>Hi, <br>&nbsp;&nbsp;&nbsp; I&#39;m trying to make this device work. I&#39;ve been unable to determine from wiki if this device is really supported or not, although I&#39;m afraid is not, but probably not much effort is needed to support it. I say this because the device is indeed detected and initialized when using up-to-date HG drivers, but scanning for channels seems apparently fails althogh the device is apparently tunning fine.<br>

<br>The device is identified by USB ids 2304:0228.<br><br><br>Here&#39;s the relevant dmesg output for this device:<br><br></div><span style="font-family: courier new,monospace;">[11180.541995] usb 6-6: new high speed USB device using ehci_hcd and address 6</span><br style="font-family: courier new,monospace;">

<span style="font-family: courier new,monospace;">[11180.682817] usb 6-6: configuration #1 chosen from 1 choice</span><br style="font-family: courier new,monospace;"><span style="font-family: courier new,monospace;">[11180.683106] hub 6-6:1.0: USB hub found</span><br style="font-family: courier new,monospace;">

<span style="font-family: courier new,monospace;">[11180.683694] hub 6-6:1.0: 2 ports detected</span><br style="font-family: courier new,monospace;"><span style="font-family: courier new,monospace;">[11180.985547] usb 6-6.1: new high speed USB device using ehci_hcd and address 7</span><br style="font-family: courier new,monospace;">

<span style="font-family: courier new,monospace;">[11181.082133] usb 6-6.1: configuration #1 chosen from 1 choice</span><br style="font-family: courier new,monospace;"><span style="font-family: courier new,monospace;">[11181.082757] scsi5 : SCSI emulation for USB Mass Storage devices</span><br style="font-family: courier new,monospace;">

<span style="font-family: courier new,monospace;">[11181.082834] usb-storage: device found at 7</span><br style="font-family: courier new,monospace;"><span style="font-family: courier new,monospace;">[11181.082838] usb-storage: waiting for device to settle before scanning</span><br style="font-family: courier new,monospace;">

<span style="font-family: courier new,monospace;">[11186.072931] usb-storage: device scan complete</span><br style="font-family: courier new,monospace;"><span style="font-family: courier new,monospace;">[11186.074053] scsi 5:0:0:0: Direct-Access&nbsp;&nbsp;&nbsp;&nbsp; GENERIC&nbsp; STORAGE DEVICE&nbsp;&nbsp; 2269 PQ: 0 ANSI: 0</span><br style="font-family: courier new,monospace;">

<span style="font-family: courier new,monospace;">[11186.075169] scsi 5:0:0:1: CD-ROM&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; GENERIC&nbsp; STORAGE DEVICE&nbsp;&nbsp; 2269 PQ: 0 ANSI: 0 CCS</span><br style="font-family: courier new,monospace;"><span style="font-family: courier new,monospace;">[11186.076657] sd 5:0:0:0: [sdb] 2041856 512-byte hardware sectors (1045 MB)</span><br style="font-family: courier new,monospace;">

<span style="font-family: courier new,monospace;">[11186.077899] sd 5:0:0:0: [sdb] Write Protect is off</span><br style="font-family: courier new,monospace;"><span style="font-family: courier new,monospace;">[11186.077905] sd 5:0:0:0: [sdb] Mode Sense: 02 00 00 00</span><br style="font-family: courier new,monospace;">

<span style="font-family: courier new,monospace;">[11186.077911] sd 5:0:0:0: [sdb] Assuming drive cache: write through</span><br style="font-family: courier new,monospace;"><span style="font-family: courier new,monospace;">[11186.080018] sd 5:0:0:0: [sdb] 2041856 512-byte hardware sectors (1045 MB)</span><br style="font-family: courier new,monospace;">

<span style="font-family: courier new,monospace;">[11186.081267] sd 5:0:0:0: [sdb] Write Protect is off</span><br style="font-family: courier new,monospace;"><span style="font-family: courier new,monospace;">[11186.081273] sd 5:0:0:0: [sdb] Mode Sense: 02 00 00 00</span><br style="font-family: courier new,monospace;">

<span style="font-family: courier new,monospace;">[11186.081277] sd 5:0:0:0: [sdb] Assuming drive cache: write through</span><br style="font-family: courier new,monospace;"><span style="font-family: courier new,monospace;">[11186.081282]&nbsp; sdb:&lt;4&gt;printk: 5 messages suppressed.</span><br style="font-family: courier new,monospace;">

<span style="font-family: courier new,monospace;">[11186.081336] Buffer I/O error on device sdb, logical block 0</span><br style="font-family: courier new,monospace;"><span style="font-family: courier new,monospace;">[11186.081354] Buffer I/O error on device sdb, logical block 0</span><br style="font-family: courier new,monospace;">

<span style="font-family: courier new,monospace;">[11186.081372] Buffer I/O error on device sdb, logical block 0</span><br style="font-family: courier new,monospace;"><span style="font-family: courier new,monospace;">[11186.081386] Buffer I/O error on device sdb, logical block 0</span><br style="font-family: courier new,monospace;">

<span style="font-family: courier new,monospace;">[11186.081402] Buffer I/O error on device sdb, logical block 0</span><br style="font-family: courier new,monospace;"><span style="font-family: courier new,monospace;">[11186.081411] ldm_validate_partition_table(): Disk read failed.</span><br style="font-family: courier new,monospace;">

<span style="font-family: courier new,monospace;">[11186.081424] Buffer I/O error on device sdb, logical block 0</span><br style="font-family: courier new,monospace;"><span style="font-family: courier new,monospace;">[11186.081439] Buffer I/O error on device sdb, logical block 0</span><br style="font-family: courier new,monospace;">

<span style="font-family: courier new,monospace;">[11186.081455] Buffer I/O error on device sdb, logical block 0</span><br style="font-family: courier new,monospace;"><span style="font-family: courier new,monospace;">[11186.081470] Buffer I/O error on device sdb, logical block 0</span><br style="font-family: courier new,monospace;">

<span style="font-family: courier new,monospace;">[11186.081478] Dev sdb: unable to read RDB block 0</span><br style="font-family: courier new,monospace;"><span style="font-family: courier new,monospace;">[11186.081490] Buffer I/O error on device sdb, logical block 0</span><br style="font-family: courier new,monospace;">

<span style="font-family: courier new,monospace;">[11186.081545]&nbsp; unable to read partition table</span><br style="font-family: courier new,monospace;"><span style="font-family: courier new,monospace;">[11186.081921] sd 5:0:0:0: [sdb] Attached SCSI removable disk</span><br style="font-family: courier new,monospace;">

<span style="font-family: courier new,monospace;">[11186.081985] sd 5:0:0:0: Attached scsi generic sg3 type 0</span><br style="font-family: courier new,monospace;"><span style="font-family: courier new,monospace;">[11186.164614] usb 6-6.1: reset high speed USB device using ehci_hcd and address 7</span><br style="font-family: courier new,monospace;">

<span style="font-family: courier new,monospace;">[11186.336325] usb 6-6.1: reset high speed USB device using ehci_hcd and address 7</span><br style="font-family: courier new,monospace;"><span style="font-family: courier new,monospace;">[11186.432666] sr2: scsi3-mmc drive: 40x/40x cd/rw xa/form2 cdda tray</span><br style="font-family: courier new,monospace;">

<span style="font-family: courier new,monospace;">[11186.432741] sr 5:0:0:1: Attached scsi CD-ROM sr2</span><br style="font-family: courier new,monospace;"><span style="font-family: courier new,monospace;">[11186.432807] sr 5:0:0:1: Attached scsi generic sg4 type 5</span><br style="font-family: courier new,monospace;">

<span style="font-family: courier new,monospace;">[11186.433558] sd 5:0:0:0: [sdb] 2041856 512-byte hardware sectors (1045 MB)</span><br style="font-family: courier new,monospace;"><span style="font-family: courier new,monospace;">[11186.508035] usb 6-6.1: reset high speed USB device using ehci_hcd and address 7</span><br style="font-family: courier new,monospace;">

<span style="font-family: courier new,monospace;">[11186.604380] sd 5:0:0:0: [sdb] Write Protect is off</span><br style="font-family: courier new,monospace;"><span style="font-family: courier new,monospace;">[11186.604389] sd 5:0:0:0: [sdb] Mode Sense: 02 00 00 00</span><br style="font-family: courier new,monospace;">

<span style="font-family: courier new,monospace;">[11186.604393] sd 5:0:0:0: [sdb] Assuming drive cache: write through</span><br style="font-family: courier new,monospace;"><span style="font-family: courier new,monospace;">[11186.608190] sd 5:0:0:0: [sdb] 2041856 512-byte hardware sectors (1045 MB)</span><br style="font-family: courier new,monospace;">

<span style="font-family: courier new,monospace;">[11186.679735] usb 6-6.1: reset high speed USB device using ehci_hcd and address 7</span><br style="font-family: courier new,monospace;"><span style="font-family: courier new,monospace;">[11186.775834] sd 5:0:0:0: [sdb] Write Protect is off</span><br style="font-family: courier new,monospace;">

<span style="font-family: courier new,monospace;">[11186.775845] sd 5:0:0:0: [sdb] Mode Sense: 02 00 00 00</span><br style="font-family: courier new,monospace;"><span style="font-family: courier new,monospace;">[11186.775849] sd 5:0:0:0: [sdb] Assuming drive cache: write through</span><br style="font-family: courier new,monospace;">

<span style="font-family: courier new,monospace;">[11186.775858]&nbsp; sdb:&lt;6&gt;usb 6-6.1: reset high speed USB device using ehci_hcd and address 7</span><br style="font-family: courier new,monospace;"><span style="font-family: courier new,monospace;">[11186.943809]</span><br style="font-family: courier new,monospace;">

<span style="font-family: courier new,monospace;">[11187.015157] usb 6-6.1: reset high speed USB device using ehci_hcd and address 7</span><br style="font-family: courier new,monospace;"><span style="font-family: courier new,monospace;">[11187.218801] usb 6-6.1: reset high speed USB device using ehci_hcd and address 7</span><br style="font-family: courier new,monospace;">

<span style="font-family: courier new,monospace;">[11187.382516] usb 6-6.2: new high speed USB device using ehci_hcd and address 8</span><br style="font-family: courier new,monospace;"><span style="font-family: courier new,monospace;">[11187.475115] usb 6-6.2: configuration #1 chosen from 1 choice</span><br style="font-family: courier new,monospace;">

<span style="font-family: courier new,monospace;">[11187.475362] dvb-usb: found a &#39;Pinnacle PCTV DVB-T Flash Stick&#39; in cold state, will try to load a firmware</span><br style="font-family: courier new,monospace;">

<span style="font-family: courier new,monospace;">[11187.489855] dvb-usb: downloading firmware from file &#39;dvb-usb-dib0700-1.10.fw&#39;</span><br style="font-family: courier new,monospace;"><span style="font-family: courier new,monospace;">[11187.546243] usb 6-6.1: reset high speed USB device using ehci_hcd and address 7</span><br style="font-family: courier new,monospace;">

<span style="font-family: courier new,monospace;">[11187.689702] dib0700: firmware started successfully.</span><br style="font-family: courier new,monospace;"><span style="font-family: courier new,monospace;">[11187.749886] usb 6-6.1: reset high speed USB device using ehci_hcd and address 7</span><br style="font-family: courier new,monospace;">

<span style="font-family: courier new,monospace;">[11187.917601] usb 6-6.1: reset high speed USB device using ehci_hcd and address 7</span><br style="font-family: courier new,monospace;"><span style="font-family: courier new,monospace;">[11188.121242] usb 6-6.1: reset high speed USB device using ehci_hcd and address 7</span><br style="font-family: courier new,monospace;">

<span style="font-family: courier new,monospace;">[11188.192872] dvb-usb: found a &#39;Pinnacle PCTV DVB-T Flash Stick&#39; in warm state.</span><br style="font-family: courier new,monospace;"><span style="font-family: courier new,monospace;">[11188.192953] dvb-usb: will pass the complete MPEG2 transport stream to the software demuxer.</span><br style="font-family: courier new,monospace;">

<span style="font-family: courier new,monospace;">[11188.193214] DVB: registering new adapter (Pinnacle PCTV DVB-T Flash Stick)</span><br style="font-family: courier new,monospace;"><span style="font-family: courier new,monospace;">[11188.409625] DVB: registering frontend 2 (DiBcom 7000PC)...</span><br style="font-family: courier new,monospace;">

<span style="font-family: courier new,monospace;">[11188.528545] usb 6-6.1: reset high speed USB device using ehci_hcd and address 7</span><br style="font-family: courier new,monospace;"><span style="font-family: courier new,monospace;">[11188.592931] DiB0070: successfully identified</span><br style="font-family: courier new,monospace;">

<span style="font-family: courier new,monospace;">[11188.593049] input: IR-receiver inside an USB DVB receiver as /class/input/input8</span><br style="font-family: courier new,monospace;"><span style="font-family: courier new,monospace;">[11188.593088] dvb-usb: schedule remote query interval to 150 msecs.</span><br style="font-family: courier new,monospace;">

<span style="font-family: courier new,monospace;">[11188.593096] dvb-usb: Pinnacle PCTV DVB-T Flash Stick successfully initialized and connected.</span><br style="font-family: courier new,monospace;"><span style="font-family: courier new,monospace;">[11188.935863] usb 6-6.1: reset high speed USB device using ehci_hcd and address 7</span><br style="font-family: courier new,monospace;">

<span style="font-family: courier new,monospace;">[11189.103561] usb 6-6.1: reset high speed USB device using ehci_hcd and address 7</span><br style="font-family: courier new,monospace;"><span style="font-family: courier new,monospace;">[11189.271272] usb 6-6.1: reset high speed USB device using ehci_hcd and address 7</span><br style="font-family: courier new,monospace;">

<span style="font-family: courier new,monospace;">[11189.438981] usb 6-6.1: reset high speed USB device using ehci_hcd and address 7</span><br style="font-family: courier new,monospace;"><span style="font-family: courier new,monospace;">[11189.606693] usb 6-6.1: reset high speed USB device using ehci_hcd and address 7</span><br style="font-family: courier new,monospace;">

<span style="font-family: courier new,monospace;">[11189.774402] usb 6-6.1: reset high speed USB device using ehci_hcd and address 7</span><br style="font-family: courier new,monospace;"><span style="font-family: courier new,monospace;">[11189.942109] usb 6-6.1: reset high speed USB device using ehci_hcd and address 7</span><br style="font-family: courier new,monospace;">

<span style="font-family: courier new,monospace;">[11190.109815] usb 6-6.1: reset high speed USB device using ehci_hcd and address 7</span><br style="font-family: courier new,monospace;"><span style="font-family: courier new,monospace;">[11190.281524] usb 6-6.1: reset high speed USB device using ehci_hcd and address 7</span><br style="font-family: courier new,monospace;">

<span style="font-family: courier new,monospace;">[11190.449235] usb 6-6.1: reset high speed USB device using ehci_hcd and address 7</span><br style="font-family: courier new,monospace;"><span style="font-family: courier new,monospace;">[11190.616956] usb 6-6.1: reset high speed USB device using ehci_hcd and address 7</span><br style="font-family: courier new,monospace;">

<span style="font-family: courier new,monospace;">[11190.784907] usb 6-6.1: reset high speed USB device using ehci_hcd and address 7</span><br style="font-family: courier new,monospace;"><span style="font-family: courier new,monospace;">[11190.952376] usb 6-6.1: reset high speed USB device using ehci_hcd and address 7</span><br style="font-family: courier new,monospace;">

<span style="font-family: courier new,monospace;">[11191.120086] usb 6-6.1: reset high speed USB device using ehci_hcd and address 7</span><br style="font-family: courier new,monospace;"><span style="font-family: courier new,monospace;">[11191.287794] usb 6-6.1: reset high speed USB device using ehci_hcd and address 7</span><br style="font-family: courier new,monospace;">

<span style="font-family: courier new,monospace;">[11191.455505] usb 6-6.1: reset high speed USB device using ehci_hcd and address 7</span><br style="font-family: courier new,monospace;"><span style="font-family: courier new,monospace;">[11191.671129] usb 6-6.1: reset high speed USB device using ehci_hcd and address 7</span><br style="font-family: courier new,monospace;">

<span style="font-family: courier new,monospace;">[11191.838840] usb 6-6.1: reset high speed USB device using ehci_hcd and address 7</span><br style="font-family: courier new,monospace;"><span style="font-family: courier new,monospace;">[11192.006547] usb 6-6.1: reset high speed USB device using ehci_hcd and address 7</span><br style="font-family: courier new,monospace;">

<span style="font-family: courier new,monospace;">[11192.174269] usb 6-6.1: reset high speed USB device using ehci_hcd and address 7</span><br style="font-family: courier new,monospace;"><span style="font-family: courier new,monospace;">[11192.341974] usb 6-6.1: reset high speed USB device using ehci_hcd and address 7</span><br style="font-family: courier new,monospace;">

<span style="font-family: courier new,monospace;">[11192.509685] usb 6-6.1: reset high speed USB device using ehci_hcd and address 7</span><br style="font-family: courier new,monospace;"><span style="font-family: courier new,monospace;">[11192.677402] usb 6-6.1: reset high speed USB device using ehci_hcd and address 7</span><br style="font-family: courier new,monospace;">

<span style="font-family: courier new,monospace;">[11192.845100] usb 6-6.1: reset high speed USB device using ehci_hcd and address 7</span><br style="font-family: courier new,monospace;"><span style="font-family: courier new,monospace;">[11193.076709] usb 6-6.1: reset high speed USB device using ehci_hcd and address 7</span><br style="font-family: courier new,monospace;">

<span style="font-family: courier new,monospace;">[11193.244412] usb 6-6.1: reset high speed USB device using ehci_hcd and address 7</span><br style="font-family: courier new,monospace;"><span style="font-family: courier new,monospace;">[11193.412136] usb 6-6.1: reset high speed USB device using ehci_hcd and address 7</span><br style="font-family: courier new,monospace;">

<span style="font-family: courier new,monospace;">[11193.579840] usb 6-6.1: reset high speed USB device using ehci_hcd and address 7</span><br style="font-family: courier new,monospace;"><span style="font-family: courier new,monospace;">[11193.747549] usb 6-6.1: reset high speed USB device using ehci_hcd and address 7</span><br style="font-family: courier new,monospace;">

<span style="font-family: courier new,monospace;">[11193.915261] usb 6-6.1: reset high speed USB device using ehci_hcd and address 7</span><br style="font-family: courier new,monospace;"><span style="font-family: courier new,monospace;">[11194.082968] usb 6-6.1: reset high speed USB device using ehci_hcd and address 7</span><br style="font-family: courier new,monospace;">

<span style="font-family: courier new,monospace;">[11194.250687] usb 6-6.1: reset high speed USB device using ehci_hcd and address 7</span><br style="font-family: courier new,monospace;"><span style="font-family: courier new,monospace;">[11194.418390] usb 6-6.1: reset high speed USB device using ehci_hcd and address 7</span><br style="font-family: courier new,monospace;">

<span style="font-family: courier new,monospace;">[11194.586113] usb 6-6.1: reset high speed USB device using ehci_hcd and address 7</span><br style="font-family: courier new,monospace;"><span style="font-family: courier new,monospace;">[11194.753819] usb 6-6.1: reset high speed USB device using ehci_hcd and address 7</span><br style="font-family: courier new,monospace;">

<span style="font-family: courier new,monospace;">[11194.921537] usb 6-6.1: reset high speed USB device using ehci_hcd and address 7</span><br style="font-family: courier new,monospace;"><br><br>Note that this device is a USB key containing both 1GB of memory (since the USB storage messages shown) and the DVB-T adapter itself. The device seems to be based on same DIBComm 7000PC device, apparentlyt handled by dvb_usb_dib0700 driver (in dmesg you can see how 1.10 firmware file is loaded for it). The frontend is created succesfully, so.<br>

<br><br>However, when trying to scan channels I get the following result:<br><br><span style="font-family: courier new,monospace;">using &#39;/dev/dvb/adapter2/frontend0&#39; and &#39;/dev/dvb/adapter2/demux0&#39;</span><br style="font-family: courier new,monospace;">

<span style="font-family: courier new,monospace;">initial transponder 514000000 0 2 9 3 1 3 0</span><br style="font-family: courier new,monospace;"><span style="font-family: courier new,monospace;">initial transponder 570000000 0 2 9 3 1 3 0</span><br style="font-family: courier new,monospace;">

<span style="font-family: courier new,monospace;">initial transponder 794000000 0 2 9 3 1 3 0</span><br style="font-family: courier new,monospace;"><span style="font-family: courier new,monospace;">initial transponder 818000000 0 2 9 3 1 3 0</span><br style="font-family: courier new,monospace;">

<span style="font-family: courier new,monospace;">initial transponder 834000000 0 2 9 3 1 3 0</span><br style="font-family: courier new,monospace;"><span style="font-family: courier new,monospace;">initial transponder 842000000 0 2 9 3 1 3 0</span><br style="font-family: courier new,monospace;">

<span style="font-family: courier new,monospace;">initial transponder 850000000 0 2 9 3 1 3 0</span><br style="font-family: courier new,monospace;"><span style="font-family: courier new,monospace;">initial transponder 858000000 0 2 9 3 1 3 0</span><br style="font-family: courier new,monospace;">

<span style="font-family: courier new,monospace;">&gt;&gt;&gt; tune to: 514000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_2_3:FEC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_4:HIERARCHY_NONE</span><br style="font-family: courier new,monospace;">

<span style="font-family: courier new,monospace;">WARNING: filter timeout pid 0x0011</span><br style="font-family: courier new,monospace;"><span style="font-family: courier new,monospace;">WARNING: filter timeout pid 0x0000</span><br style="font-family: courier new,monospace;">

<span style="font-family: courier new,monospace;">WARNING: filter timeout pid 0x0010</span><br style="font-family: courier new,monospace;"><span style="font-family: courier new,monospace;">&gt;&gt;&gt; tune to: 570000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_2_3:FEC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_4:HIERARCHY_NONE</span><br style="font-family: courier new,monospace;">

<span style="font-family: courier new,monospace;">WARNING: filter timeout pid 0x0011</span><br style="font-family: courier new,monospace;"><span style="font-family: courier new,monospace;">WARNING: filter timeout pid 0x0000</span><br style="font-family: courier new,monospace;">

<span style="font-family: courier new,monospace;">WARNING: filter timeout pid 0x0010</span><br style="font-family: courier new,monospace;"><span style="font-family: courier new,monospace;">&gt;&gt;&gt; tune to: 794000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_2_3:FEC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_4:HIERARCHY_NONE</span><br style="font-family: courier new,monospace;">

<span style="font-family: courier new,monospace;">WARNING: filter timeout pid 0x0011</span><br style="font-family: courier new,monospace;"><span style="font-family: courier new,monospace;">WARNING: filter timeout pid 0x0000</span><br style="font-family: courier new,monospace;">

<span style="font-family: courier new,monospace;">WARNING: filter timeout pid 0x0010</span><br style="font-family: courier new,monospace;"><span style="font-family: courier new,monospace;">&gt;&gt;&gt; tune to: 818000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_2_3:FEC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_4:HIERARCHY_NONE</span><br style="font-family: courier new,monospace;">

<span style="font-family: courier new,monospace;">WARNING: filter timeout pid 0x0011</span><br style="font-family: courier new,monospace;"><span style="font-family: courier new,monospace;">WARNING: filter timeout pid 0x0000</span><br style="font-family: courier new,monospace;">

<span style="font-family: courier new,monospace;">WARNING: filter timeout pid 0x0010</span><br style="font-family: courier new,monospace;"><span style="font-family: courier new,monospace;">&gt;&gt;&gt; tune to: 834000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_2_3:FEC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_4:HIERARCHY_NONE</span><br style="font-family: courier new,monospace;">

<span style="font-family: courier new,monospace;">WARNING: filter timeout pid 0x0011</span><br style="font-family: courier new,monospace;"><span style="font-family: courier new,monospace;">WARNING: filter timeout pid 0x0000</span><br style="font-family: courier new,monospace;">

<span style="font-family: courier new,monospace;">WARNING: filter timeout pid 0x0010</span><br style="font-family: courier new,monospace;"><span style="font-family: courier new,monospace;">&gt;&gt;&gt; tune to: 842000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_2_3:FEC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_4:HIERARCHY_NONE</span><br style="font-family: courier new,monospace;">

<span style="font-family: courier new,monospace;">WARNING: filter timeout pid 0x0011</span><br style="font-family: courier new,monospace;"><span style="font-family: courier new,monospace;">WARNING: filter timeout pid 0x0000</span><br style="font-family: courier new,monospace;">

<span style="font-family: courier new,monospace;">WARNING: filter timeout pid 0x0010</span><br style="font-family: courier new,monospace;"><span style="font-family: courier new,monospace;">&gt;&gt;&gt; tune to: 850000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_2_3:FEC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_4:HIERARCHY_NONE</span><br style="font-family: courier new,monospace;">

<span style="font-family: courier new,monospace;">WARNING: filter timeout pid 0x0011</span><br style="font-family: courier new,monospace;"><span style="font-family: courier new,monospace;">WARNING: filter timeout pid 0x0000</span><br style="font-family: courier new,monospace;">

<span style="font-family: courier new,monospace;">WARNING: filter timeout pid 0x0010</span><br style="font-family: courier new,monospace;"><span style="font-family: courier new,monospace;">&gt;&gt;&gt; tune to: 858000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_2_3:FEC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_4:HIERARCHY_NONE</span><br style="font-family: courier new,monospace;">

<span style="font-family: courier new,monospace;">WARNING: filter timeout pid 0x0011</span><br style="font-family: courier new,monospace;"><span style="font-family: courier new,monospace;">WARNING: filter timeout pid 0x0000</span><br style="font-family: courier new,monospace;">

<span style="font-family: courier new,monospace;">WARNING: filter timeout pid 0x0010</span><br style="font-family: courier new,monospace;"><span style="font-family: courier new,monospace;">dumping lists (0 services)</span><br style="font-family: courier new,monospace;">

<span style="font-family: courier new,monospace;">Done.</span><br style="font-family: courier new,monospace;"><br><br>So, as you can see the device is apparently tunning fine, but no channels are detected. Note that this system has also a Nova-T 500 installed that detects perfectly all available channels, so it&#39;s not an antenna problem. Also, if I remove the antenna then I get (as expected) the usual &quot;tunning failed&quot; messages, as the card is not able to lock on the signal then.<br>

<br><br><br>Best regards, <br>&nbsp; Eduard Huguet<br><br></div>
</div><br></div>

------=_Part_120955_11831440.1223894665779--


--===============0261576134==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============0261576134==--
