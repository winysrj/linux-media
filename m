Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-px0-f103.google.com ([209.85.216.103]:45995 "EHLO
	mail-px0-f103.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751219AbZETNF1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 20 May 2009 09:05:27 -0400
Received: by pxi1 with SMTP id 1so112553pxi.33
        for <linux-media@vger.kernel.org>; Wed, 20 May 2009 06:05:28 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <!~!UENERkVCMDkAAQACAAAAAAAAAAAAAAAAABgAAAAAAAAAJf2pBr8u1U+Z+cArRcz8PAKHAAAQAAAAzAGSQvKgtEem5YzUY4sYkAEAAAAA@tv-numeric.com>
References: <!~!UENERkVCMDkAAQACAAAAAAAAAAAAAAAAABgAAAAAAAAAJf2pBr8u1U+Z+cArRcz8PMKAAAAQAAAACtixxRYhkEeDGBNeWWfFCAEAAAAA@tv-numeric.com>
	 <!~!UENERkVCMDkAAQACAAAAAAAAAAAAAAAAABgAAAAAAAAAJf2pBr8u1U+Z+cArRcz8PAKHAAAQAAAAzAGSQvKgtEem5YzUY4sYkAEAAAAA@tv-numeric.com>
Date: Wed, 20 May 2009 09:05:28 -0400
Message-ID: <829197380905200605x49be3048u303109f56ab737c3@mail.gmail.com>
Subject: Re: RE : Hauppauge Nova-TD-500 vs. T-500
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Thierry Lelegard <thierry.lelegard@tv-numeric.com>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, May 20, 2009 at 8:51 AM, Thierry Lelegard
<thierry.lelegard@tv-numeric.com> wrote:
> I have a few more informations.
>
> 1) Sorry for those who don't like top posting, but the initial
> description is really too long for good readability of answers.
>
> 2) Since the TD-500 contains two aerial inputs instead of one for
> the T-500, I plugged in two antenna cables. Then, after some tests,
> I realized that this was a source of trouble:
> - Two antenna cables => lots of errors (mostly garbage sometimes,
>  depending on the frequency).
> - Top input only => still many errors but much better on both tuners.
> - Bottom input only => got nothing on both tuners.
>
> So, from now on, I use only one antenna cable, in the top aerial input.
> Maybe this could be clarified somewhere (unless it is already but I missed it).
>
> 3) There are still many uncorrectable errors (TS packets with "transport
> error indicator" set) in the input. The amount of uncorrectable errors is
> approximately 0.1% (depending on the frequency), while I do not have any
> with the T-500 using the same antenna.
>
> These errors occurs in groups of +/- 50 consecutive packets with TEI set.
> Sometimes, in the middle of packets with errors, one packet has TEI clear
> but it is still erroneous (invalid PID in this context for instance).
>
> Note: I forgot to mention in the initial post that I set the following option:
>    options dvb_usb_dib0700 force_lna_activation=1
>
> 4) There is apparently a minor but annoying problem in the driver concerning
> the ioctl FE_GET_INFO. Its usage requires opening the frontend device in
> O_RDWR mode with the TD-500.
>
> Comparison of T-500 vs. TD-500.
>
> a) After boot, before the first tuning, if we open the frontend in O_RDONLY
>   more, the ioctl FE_GET_INFO succeeds with the TD-500 and the T-500.
>
> b) While another process uses the frontend for packet reception, the ioctl
>   FE_GET_INFO succeeds with the TD-500 and the T-500, with frontend in
>   O_RDONLY mode.
>
> c) After the frontend has been used for packet reception but no other process
>   uses it any longer, the ioctl FE_GET_INFO fails with errno "no such device"
>   with TD-500 frontend in O_RDONLY mode. However, the ioctl FE_GET_INFO succeeds
>   with TD-500 frontend in O_RDWR mode. With the T-500, the ioctl FE_GET_INFO
>   succeeds in O_RDONLY mode.
>
>   Using O_RDWR mode for a simple ioctl FE_GET_INFO is a problem since it
>   fails with "device busy" when another process is using it in O_RDWR mode
>   for tuning and reception, which is normal.
>
>   I see here two inconsistencies and one "annoying feature":
>   - Inconsistent behaviour of ioctl FE_GET_INFO in O_RDONLY mode before and
>     after the first tuning.
>   - Incorrect error "no such device" because /dev/dvb/adapter0/frontend0
>     is still there and useable in O_RDWR mode.
>   - Obligation to use O_RDWR mode for reading the characteristics of a device.
>
> -Thierry
>
>
>
>> -----Message d'origine-----
>> De : linux-media-owner@vger.kernel.org
>> [mailto:linux-media-owner@vger.kernel.org] De la part de
>> Thierry Lelegard
>> Envoyé : lundi 18 mai 2009 16:33
>> À : linux-media@vger.kernel.org
>> Objet : Hauppauge Nova-TD-500 vs. T-500
>>
>>
>> Hello,
>>
>> Like many others, I have some problems with the Hauppauge Nova-TD-500.
>>
>> I have been running a Fedora system with one Hauppauge Nova-T-500
>> (-T-, with one input connector, not -TD-) quite successfully
>> for 2 years.
>> I just built another Fedora system and ordered two T-500 but
>> I actually
>> received two TD-500 (the one with two input connectors).
>>
>> So, I now have another Fedora box with two Hauppauge Nova-TD-500
>> and it does not work quite well.
>>
>> The two systems (the first one with one T-500 and the second one with
>> two TD-500) are running the same O/S version, same drivers,
>> same firmware:
>>
>> - Fedora 10, up-to-date as of 2009-05-17
>> - Kernel 2.6.27.21-170.2.56.fc10.i686
>> - Latest V4L-DVB mercurial tree, same date
>> - Firmware dvb-usb-dib0700-1.20.fw
>>
>> You will find below some outputs of dmesg, lspci, etc for the two
>> systems.
>>
>> I use custom signal monitoring applications, no TV watching apps.
>> The same application is used in both systems, same antenna input
>> (roof antenna and wall socket, not the small antenna that comes
>> with the cards). The application continuously reads the complete
>> transport stream for analysis. From time to time, it tunes to
>> some frequency, then another, etc.
>>
>> With the two TD-500, the 4 adapters are created under /dev/dvb. Using
>> them works more or less. As far as I tested now, I do not have any
>> reported error, no error message. But the input is "not good": many
>> packets are corrupted. This does not happen all the time. Sometimes,
>> the input is "reasonably correct" (a few packets seems incorrect)
>> and sometimes it is a mess (most packets are incorrect, the result
>> of the analysis report many non-existing PIDs, weird content, etc).
>>
>> I guess that most of you will say "most probably an application pb"...
>> But the same application is working fine with:
>>
>> 1) Linux + Hauppauge Nova-T-500
>> 2) Linux + Hauppauge Nova-T Stick
>> 3) Linux + Pinnacle PCTV stick 72e
>> 4) Windows + the two above sticks
>> 4) Windows + Terratec Cinergy T USB XE Rev 2 (not supported on Linux)
>>
>> Of course, on Windows, the input module is a custom DirectShow capture
>> filter instead of Linux DVB API but the rest of the
>> application is identical.
>>
>> Another weird behaviour: After running the monitoring application,
>> ioctl (frontend_fd, FE_GET_INFO, ...) returns "No such device" errno.
>> Example:
>>
>> 1) Run tool to get dvb device info, ie. ioctl FE_GET_INFO, right
>>    after system boot:
>>
>> /dev/dvb/adapter0 (DiBcom 7000PC, DVB-T)
>>
>>   Status:
>>
>>   Bit error rate ......................... 2,097,151 (0%)
>>   Signal/noise ratio ............................. 0 (0%)
>>   Signal strength ................................ 0 (0%)
>>   Uncorrected blocks ............................. 0
>>   Frequencies:
>>     Current ...................................... 0 Hz
>>     Min ................................. 45,000,000 Hz
>>     Max ................................ 860,000,000 Hz
>>     Step .................................... 62,500 Hz
>>     Tolerance .................................... 0 Hz
>>   Spectral inversion .......................... auto
>>   Bandwidth .................................. 8-MHz
>>   FEC (high priority) .......................... 1/2
>>   FEC (low priority) ........................... 1/2
>>   Constellation ............................... QPSK
>>   Transmission mode ............................. 2K
>>   Guard interval .............................. 1/32
>>   Hierarchy ................................... none
>>
>> 2) Run monitoring application. OK, with corrupted packets.
>> 3) Run previous tool doing ioctl FE_GET_INFO:
>> error getting info on /dev/dvb/adapter0/frontend0: No such device
>> Note: this error is reported by ioctl, opening the device is OK.
>> 4) # ls -l /dev/dvb/adapter0/frontend0
>> crw-rw----+ 1 tlelegard video 212, 3 2009-05-18 15:59
>> /dev/dvb/adapter0/frontend0
>> 5) Run monitoring application. OK, with corrupted packets.
>>
>>
>> Is there any new development regarding TD-500 ?
>> Any test I could make ?
>>
>> Thanks in advance for your assistance.
>> -Thierry
>>
>>
>> -----------------------------------------------------------------
>> dmesg - one T-500
>> -----------------------------------------------------------------
>>
>> # dmesg | grep -i -e dvb -e dib
>> dib0700: loaded with support for 9 different device-types
>> dvb-usb: found a 'Hauppauge Nova-T 500 Dual DVB-T' in cold
>> state, will try to load a firmware
>> firmware: requesting dvb-usb-dib0700-1.20.fw
>> dvb-usb: downloading firmware from file 'dvb-usb-dib0700-1.20.fw'
>> dib0700: firmware started successfully.
>> dvb-usb: found a 'Hauppauge Nova-T 500 Dual DVB-T' in warm state.
>> dvb-usb: will pass the complete MPEG2 transport stream to the
>> software demuxer.
>> DVB: registering new adapter (Hauppauge Nova-T 500 Dual DVB-T)
>> DVB: registering adapter 0 frontend 0 (DiBcom 3000MC/P)...
>> dvb-usb: will pass the complete MPEG2 transport stream to the
>> software demuxer.
>> DVB: registering new adapter (Hauppauge Nova-T 500 Dual DVB-T)
>> DVB: registering adapter 1 frontend 0 (DiBcom 3000MC/P)...
>> dvb-usb: Hauppauge Nova-T 500 Dual DVB-T successfully
>> initialized and connected.
>> usbcore: registered new interface driver dvb_usb_dib0700
>> #
>>
>> -----------------------------------------------------------------
>> dmesg - two TD-500
>> -----------------------------------------------------------------
>>
>> # dmesg | grep -i -e dvb -e dib
>> dib0700: loaded with support for 9 different device-types
>> dvb-usb: found a 'Hauppauge Nova-TD-500 (84xxx)' in cold
>> state, will try to load a firmware
>> firmware: requesting dvb-usb-dib0700-1.20.fw
>> dvb-usb: downloading firmware from file 'dvb-usb-dib0700-1.20.fw'
>> dib0700: firmware started successfully.
>> dvb-usb: found a 'Hauppauge Nova-TD-500 (84xxx)' in warm state.
>> dvb-usb: will pass the complete MPEG2 transport stream to the
>> software demuxer.
>> DVB: registering new adapter (Hauppauge Nova-TD-500 (84xxx))
>> DVB: registering adapter 0 frontend 0 (DiBcom 7000PC)...
>> DiB0070: successfully identified
>> dvb-usb: will pass the complete MPEG2 transport stream to the
>> software demuxer.
>> DVB: registering new adapter (Hauppauge Nova-TD-500 (84xxx))
>> DVB: registering adapter 1 frontend 0 (DiBcom 7000PC)...
>> DiB0070: successfully identified
>> input: IR-receiver inside an USB DVB receiver as
>> /devices/pci0000:00/0000:00:1e.0/0000:05:04.2/usb3/3-1/input/input6
>> dvb-usb: schedule remote query interval to 50 msecs.
>> dvb-usb: Hauppauge Nova-TD-500 (84xxx) successfully
>> initialized and connected.
>> dvb-usb: found a 'Hauppauge Nova-TD-500 (84xxx)' in cold
>> state, will try to load a firmware
>> firmware: requesting dvb-usb-dib0700-1.20.fw
>> dvb-usb: downloading firmware from file 'dvb-usb-dib0700-1.20.fw'
>> dib0700: firmware started successfully.
>> dvb-usb: found a 'Hauppauge Nova-TD-500 (84xxx)' in warm state.
>> dvb-usb: will pass the complete MPEG2 transport stream to the
>> software demuxer.
>> DVB: registering new adapter (Hauppauge Nova-TD-500 (84xxx))
>> DVB: registering adapter 2 frontend 0 (DiBcom 7000PC)...
>> DiB0070: successfully identified
>> dvb-usb: will pass the complete MPEG2 transport stream to the
>> software demuxer.
>> DVB: registering new adapter (Hauppauge Nova-TD-500 (84xxx))
>> DVB: registering adapter 3 frontend 0 (DiBcom 7000PC)...
>> DiB0070: successfully identified
>> input: IR-receiver inside an USB DVB receiver as
>> /devices/pci0000:00/0000:00:1e.0/0000:05:05.2/usb4/4-1/input/input7
>> dvb-usb: schedule remote query interval to 50 msecs.
>> dvb-usb: Hauppauge Nova-TD-500 (84xxx) successfully
>> initialized and connected.
>> usbcore: registered new interface driver dvb_usb_dib0700
>> #
>>
>> -----------------------------------------------------------------
>> lspci - one T-500
>> -----------------------------------------------------------------
>>
>> # lspci
>> ....
>> 0c:02.0 USB Controller: VIA Technologies, Inc. VT82xxxxx UHCI
>> USB 1.1 Controller (rev 61)
>> 0c:02.1 USB Controller: VIA Technologies, Inc. VT82xxxxx UHCI
>> USB 1.1 Controller (rev 61)
>> 0c:02.2 USB Controller: VIA Technologies, Inc. USB 2.0 (rev 63)
>> #
>>
>> -----------------------------------------------------------------
>> lspci - two TD-500
>> -----------------------------------------------------------------
>>
>> # lspci
>> 05:04.0 USB Controller: VIA Technologies, Inc. VT82xxxxx UHCI
>> USB 1.1 Controller (rev 62)
>> 05:04.2 USB Controller: VIA Technologies, Inc. USB 2.0 (rev 65)
>> 05:05.0 USB Controller: VIA Technologies, Inc. VT82xxxxx UHCI
>> USB 1.1 Controller (rev 62)
>> 05:05.2 USB Controller: VIA Technologies, Inc. USB 2.0 (rev 65)
>> #
>>
>> -----------------------------------------------------------------
>> lspci -vv - one T-500
>> -----------------------------------------------------------------
>>
>> # lspci -vv -s 0c:02
>> 0c:02.0 USB Controller: VIA Technologies, Inc. VT82xxxxx UHCI
>> USB 1.1 Controller (rev 61) (prog-if 00 [UHCI])
>>         Subsystem: VIA Technologies, Inc. VT82xxxxx UHCI USB
>> 1.1 Controller
>>         Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV+
>> VGASnoop- ParErr- Stepping- SERR+ FastB2B- DisINTx-
>>         Status: Cap+ 66MHz- UDF- FastB2B- ParErr-
>> DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
>>         Latency: 64, Cache Line Size: 64 bytes
>>         Interrupt: pin A routed to IRQ 18
>>         Region 4: I/O ports at bcc0 [size=32]
>>         Capabilities: [80] Power Management version 2
>>                 Flags: PMEClk+ DSI- D1+ D2+ AuxCurrent=0mA
>> PME(D0+,D1+,D2+,D3hot+,D3cold-)
>>                 Status: D0 PME-Enable- DSel=0 DScale=0 PME-
>>         Kernel driver in use: uhci_hcd
>>
>> 0c:02.1 USB Controller: VIA Technologies, Inc. VT82xxxxx UHCI
>> USB 1.1 Controller (rev 61) (prog-if 00 [UHCI])
>>         Subsystem: VIA Technologies, Inc. VT82xxxxx UHCI USB
>> 1.1 Controller
>>         Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV+
>> VGASnoop- ParErr- Stepping- SERR+ FastB2B- DisINTx-
>>         Status: Cap+ 66MHz- UDF- FastB2B- ParErr-
>> DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
>>         Latency: 64, Cache Line Size: 64 bytes
>>         Interrupt: pin B routed to IRQ 19
>>         Region 4: I/O ports at bce0 [size=32]
>>         Capabilities: [80] Power Management version 2
>>                 Flags: PMEClk+ DSI- D1+ D2+ AuxCurrent=0mA
>> PME(D0+,D1+,D2+,D3hot+,D3cold-)
>>                 Status: D0 PME-Enable- DSel=0 DScale=0 PME-
>>         Kernel driver in use: uhci_hcd
>>
>> 0c:02.2 USB Controller: VIA Technologies, Inc. USB 2.0 (rev
>> 63) (prog-if 20 [EHCI])
>>         Subsystem: VIA Technologies, Inc. USB 2.0
>>         Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV+
>> VGASnoop- ParErr- Stepping- SERR+ FastB2B- DisINTx-
>>         Status: Cap+ 66MHz- UDF- FastB2B- ParErr-
>> DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
>>         Latency: 64, Cache Line Size: 64 bytes
>>         Interrupt: pin C routed to IRQ 16
>>         Region 0: Memory at f3afff00 (32-bit,
>> non-prefetchable) [size=256]
>>         Capabilities: [80] Power Management version 2
>>                 Flags: PMEClk+ DSI- D1+ D2+ AuxCurrent=0mA
>> PME(D0+,D1+,D2+,D3hot+,D3cold-)
>>                 Status: D0 PME-Enable- DSel=0 DScale=0 PME-
>>         Kernel driver in use: ehci_hcd
>>
>> #
>>
>> -----------------------------------------------------------------
>> lspci -vv - two TD-500
>> -----------------------------------------------------------------
>>
>> # lspci -vv -s 05:04
>> 05:04.0 USB Controller: VIA Technologies, Inc. VT82xxxxx UHCI
>> USB 1.1 Controller (rev 62) (prog-if 00 [UHCI])
>>         Subsystem: VIA Technologies, Inc. VT82xxxxx UHCI USB
>> 1.1 Controller
>>         Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV+
>> VGASnoop- ParErr- Stepping- SERR+ FastB2B- DisINTx-
>>         Status: Cap+ 66MHz- UDF- FastB2B- ParErr-
>> DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
>>         Latency: 64, Cache Line Size: 64 bytes
>>         Interrupt: pin A routed to IRQ 16
>>         Region 4: I/O ports at ccc0 [size=32]
>>         Capabilities: [80] Power Management version 2
>>                 Flags: PMEClk+ DSI- D1+ D2+ AuxCurrent=0mA
>> PME(D0+,D1+,D2+,D3hot+,D3cold-)
>>                 Status: D0 PME-Enable- DSel=0 DScale=0 PME-
>>         Kernel driver in use: uhci_hcd
>>
>> 05:04.2 USB Controller: VIA Technologies, Inc. USB 2.0 (rev
>> 65) (prog-if 20 [EHCI])
>>         Subsystem: VIA Technologies, Inc. USB 2.0
>>         Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV+
>> VGASnoop- ParErr- Stepping- SERR+ FastB2B- DisINTx-
>>         Status: Cap+ 66MHz- UDF- FastB2B- ParErr-
>> DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
>>         Latency: 64, Cache Line Size: 64 bytes
>>         Interrupt: pin C routed to IRQ 18
>>         Region 0: Memory at f9dffe00 (32-bit,
>> non-prefetchable) [size=256]
>>         Capabilities: [80] Power Management version 2
>>                 Flags: PMEClk+ DSI- D1+ D2+ AuxCurrent=0mA
>> PME(D0+,D1+,D2+,D3hot+,D3cold-)
>>                 Status: D0 PME-Enable- DSel=0 DScale=0 PME-
>>         Kernel driver in use: ehci_hcd
>>
>> #
>>
>> -----------------------------------------------------------------
>> ls /dev/dvb - one T-500
>> -----------------------------------------------------------------
>>
>> # ls -lR /dev/dvb
>> /dev/dvb:
>> total 0
>> drwxr-xr-x 2 root root 120 2009-05-12 15:53 adapter0
>> drwxr-xr-x 2 root root 120 2009-05-12 15:53 adapter1
>>
>> /dev/dvb/adapter0:
>> total 0
>> crw-rw----+ 1 tlelegard video 212, 0 2009-05-12 15:53 demux0
>> crw-rw----+ 1 tlelegard video 212, 1 2009-05-12 15:53 dvr0
>> crw-rw----+ 1 tlelegard video 212, 3 2009-05-12 15:53 frontend0
>> crw-rw----+ 1 tlelegard video 212, 2 2009-05-12 15:53 net0
>>
>> /dev/dvb/adapter1:
>> total 0
>> crw-rw----+ 1 tlelegard video 212, 4 2009-05-12 15:53 demux0
>> crw-rw----+ 1 tlelegard video 212, 5 2009-05-12 15:53 dvr0
>> crw-rw----+ 1 tlelegard video 212, 7 2009-05-12 15:53 frontend0
>> crw-rw----+ 1 tlelegard video 212, 6 2009-05-12 15:53 net0
>> #
>>
>> -----------------------------------------------------------------
>> ls /dev/dvb - two TD-500
>> -----------------------------------------------------------------
>>
>> # ls -lR /dev/dvb
>> /dev/dvb:
>> total 0
>> drwxr-xr-x 2 root root 120 2009-05-18 15:59 adapter0
>> drwxr-xr-x 2 root root 120 2009-05-18 15:59 adapter1
>> drwxr-xr-x 2 root root 120 2009-05-18 15:59 adapter2
>> drwxr-xr-x 2 root root 120 2009-05-18 15:59 adapter3
>>
>> /dev/dvb/adapter0:
>> total 0
>> crw-rw----+ 1 tlelegard video 212, 0 2009-05-18 15:59 demux0
>> crw-rw----+ 1 tlelegard video 212, 1 2009-05-18 15:59 dvr0
>> crw-rw----+ 1 tlelegard video 212, 3 2009-05-18 15:59 frontend0
>> crw-rw----+ 1 tlelegard video 212, 2 2009-05-18 15:59 net0
>>
>> /dev/dvb/adapter1:
>> total 0
>> crw-rw----+ 1 tlelegard video 212, 4 2009-05-18 15:59 demux0
>> crw-rw----+ 1 tlelegard video 212, 5 2009-05-18 15:59 dvr0
>> crw-rw----+ 1 tlelegard video 212, 7 2009-05-18 15:59 frontend0
>> crw-rw----+ 1 tlelegard video 212, 6 2009-05-18 15:59 net0
>>
>> /dev/dvb/adapter2:
>> total 0
>> crw-rw----+ 1 tlelegard video 212,  8 2009-05-18 15:59 demux0
>> crw-rw----+ 1 tlelegard video 212,  9 2009-05-18 15:59 dvr0
>> crw-rw----+ 1 tlelegard video 212, 11 2009-05-18 15:59 frontend0
>> crw-rw----+ 1 tlelegard video 212, 10 2009-05-18 15:59 net0
>>
>> /dev/dvb/adapter3:
>> total 0
>> crw-rw----+ 1 tlelegard video 212, 12 2009-05-18 15:59 demux0
>> crw-rw----+ 1 tlelegard video 212, 13 2009-05-18 15:59 dvr0
>> crw-rw----+ 1 tlelegard video 212, 15 2009-05-18 15:59 frontend0
>> crw-rw----+ 1 tlelegard video 212, 14 2009-05-18 15:59 net0
>> #
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe
>> linux-media" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

Thierry,

Regarding the FE_GET_INFO failing if opening the frontend in O_RDONLY,
I believe I tracked down that problem late last night.  Assuming
you're using the latest tip, it's a bug I exposed during the xc5000
patch series.  There was a bug in the dvb_frontend logic where the
fepriv->exit was not being set properly when shutting down the thread
(which I fixed), however it exposed a second issue where the
fepriv->exit is not cleared at the appropriate time.  The flag does
gets cleared automatically if you open the frontend in O_RDWR because
the frontend thread gets recreated.  However, if you open in O_RDONLY,
the flag gets checked but it's in the incorrect state.

To fix around the issue, try the following:

open v4l/dvb_frontend.c then go to line 671.  Right after the call to
"fepriv->thread = NULL", add the following:

fepriv->exit = 0;

I'm going to do some more testing tonight and then submit a PULL
request for the above.  Really the locking scheme for shutting down
the thread should probably be rethought  - but the above should
address the immediate edge case you are seeing.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
