Return-path: <mchehab@gaivota>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:56876 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751346Ab0LQGBP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 17 Dec 2010 01:01:15 -0500
Received: by wyb28 with SMTP id 28so300812wyb.19
        for <linux-media@vger.kernel.org>; Thu, 16 Dec 2010 22:01:13 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <AANLkTi=_Wc-A2f2emjXrP1bwWF4T+esJfLkdeNXqDr74@mail.gmail.com>
References: <AANLkTi=_Wc-A2f2emjXrP1bwWF4T+esJfLkdeNXqDr74@mail.gmail.com>
Date: Fri, 17 Dec 2010 17:01:13 +1100
Message-ID: <AANLkTinUQiUnET8K8xR_m8EVc9h6-vev1cKRe=F+yh6S@mail.gmail.com>
Subject: Re: Leadtek DTV2000DS - no channel lock
From: Matthew Rowles <rowlesmr@gmail.com>
To: linux-media@vger.kernel.org,
	Discussion about MythTV <mythtv-users@mythtv.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

On 15 December 2010 14:34, Matthew Rowles <rowlesmr@gmail.com> wrote:
> Hi all.
>
> I have 2 Leadtek DTV2000DS PCI tuners  in my mythtv pc.
> This is a AF9015 + AF9013  + NXP TDA18211 based PCI card.
> The tuner is detected as TDA18271.  (see
> http://linuxtv.org/wiki/index.php/DVB-T_PCI_Cards#Leadtek)
>
> My issue is that I can't lock onto any channel.
>
>
> My PC is:
> MB: Asus M4A87TD-USB3 AM3
> CPU: AMD Athlon II X2 250 3 GHz
> RAM: Kingston 2 Gb single PC10666 (1333 MHz)
> PSU: Zalman ZM500-HP 500 W
> Storage: 2x WD 1Tb Caviar Blue 7200 RPM SATAII
> OS disc: Kingston 64 Gb SSD SNV425-S2
> GPU: 512Mb Winfast NVidia 8400GS
> Remote: Hauppauge MCE remote
>
> I am running Mythbuntu 10.04, updated to the 2.6.32-26-generic kernel.
> MythTV is currently at version 0.24.
>
>
>
> w_scan shows that channels exist, but cannot lock on to them. It fails
> with either "no signal" or " __tune_to_transponder:1733: ERROR:
> FE_READ_STATUS failed: 121 Remote I/O error"
>
> Scanning in Mythtv 0.24 shows a signal strength of ~65-70% and gives
> me approx. 28 channels (Melbourne, Australia), but I can't lock on to
> any to watch them.
>
>
>
> http://linuxtv.org/wiki/index.php/Leadtek_WinFast_DTV2000DS#Making_it_work_in_Ubuntu
> has some recent updates dealing with different sample freqs and i2c
> fixes. As far as I know, I've applied them all.
>
> The output of uname, dmesg and w_scan is given below. I've inspected
> the output of compiling the V4L drivers
> (http://linuxtv.org/hg/v4l-dvb/rev/abd3aac6644e) and I can't see any
> error messages. I did a make clean before compiling.
>
>
> Are there any suggestions on what I can do from here?
>
>
> Some other questions:
>
> * What does the " __tune_to_transponder:1733: ERROR: FE_READ_STATUS
> failed: 121 Remote I/O error" error mean?
> * Are there any suggestions on cleaning before making? ie, how to do
> it? I just ran "$make clean"
> * Any other logs to inspect? (I've seen /var/log/messages and syslog
> mentioned elsewhere)
> * Blow everything away and start again? (I'm 95% sure I still have the
> V4L drivers I originally downloaded in late September, when I put this
> together) ( I don't really want to have to do this, but will if I have
> to...)
> * Try a newer kernel? dmesg does warn that the driver has been
> backported to an older kernel.
>
>
> Thanks
>
>
> Matthew
>
>
>
>
> ******************************************************
> $uname -a
> Linux matthew-desktop 2.6.32-26-generic #48-Ubuntu SMP Wed Nov 24
> 09:00:03 UTC 2010 i686 GNU/Linux
>
> ******************************************************
>
> $dmesg (after a cold start; grepped for dvb, af901 and tda18271)
> [    3.851105] WARNING: You're using an experimental version of the
> DVB stack. As the driver
> [    3.851107]          is backported to an older kernel, it doesn't
> offer enough quality for
> [    3.851108]          its usage in production.
> [    3.851109]          Use it with care.
> [    4.495703] dvb-usb: found a 'Leadtek WinFast DTV2000DS' in cold
> state, will try to load a firmware
> [    4.495709] usb 4-1: firmware: requesting dvb-usb-af9015.fw
> [    4.505186] dvb-usb: downloading firmware from file 'dvb-usb-af9015.fw'
> [    4.588950] dvb-usb: found a 'Leadtek WinFast DTV2000DS' in warm state.
> [    4.588994] dvb-usb: will pass the complete MPEG2 transport stream
> to the software demuxer.
> [    4.589344] DVB: registering new adapter (Leadtek WinFast DTV2000DS)
> [    4.623460] af9013: firmware version:5.1.0
> [    4.628354] DVB: registering adapter 0 frontend 0 (Afatech AF9013 DVB-T)...
> [    4.644423] tda18271 0-00c0: creating new instance
> [    4.650848] TDA18271HD/C2 detected @ 0-00c0
> [    4.937877] dvb-usb: will pass the complete MPEG2 transport stream
> to the software demuxer.
> [    4.938338] DVB: registering new adapter (Leadtek WinFast DTV2000DS)
> [    5.660964] af9013: found a 'Afatech AF9013 DVB-T' in warm state.
> [    5.663592] af9013: firmware version:5.1.0
> [    5.674971] DVB: registering adapter 1 frontend 0 (Afatech AF9013 DVB-T)...
> [    5.675104] tda18271 1-00c0: creating new instance
> [    5.680074] TDA18271HD/C2 detected @ 1-00c0
> [    5.992172] input: IR-receiver inside an USB DVB receiver as
> /devices/pci0000:00/0000:00:14.4/0000:02:06.2/usb4/4-1/input/input5
> [    5.992215] dvb-usb: schedule remote query interval to 150 msecs.
> [    5.992218] dvb-usb: Leadtek WinFast DTV2000DS successfully
> initialized and connected.
> [    6.562561] dvb-usb: found a 'Leadtek WinFast DTV2000DS' in cold
> state, will try to load a firmware
> [    6.562565] usb 5-1: firmware: requesting dvb-usb-af9015.fw
> [    6.563871] dvb-usb: downloading firmware from file 'dvb-usb-af9015.fw'
> [    6.636225] dvb-usb: found a 'Leadtek WinFast DTV2000DS' in warm state.
> [    6.636273] dvb-usb: will pass the complete MPEG2 transport stream
> to the software demuxer.
> [    6.636725] DVB: registering new adapter (Leadtek WinFast DTV2000DS)
> [    6.639709] af9013: firmware version:5.1.0
> [    6.644592] DVB: registering adapter 2 frontend 0 (Afatech AF9013 DVB-T)...
> [    6.644730] tda18271 2-00c0: creating new instance
> [    6.651093] TDA18271HD/C2 detected @ 2-00c0
> [    6.961757] dvb-usb: will pass the complete MPEG2 transport stream
> to the software demuxer.
> [    6.962169] DVB: registering new adapter (Leadtek WinFast DTV2000DS)
> [    7.685218] af9013: found a 'Afatech AF9013 DVB-T' in warm state.
> [    7.687843] af9013: firmware version:5.1.0
> [    7.699234] DVB: registering adapter 3 frontend 0 (Afatech AF9013 DVB-T)...
> [    7.699371] tda18271 3-00c0: creating new instance
> [    7.704366] TDA18271HD/C2 detected @ 3-00c0
> [    8.012146] input: IR-receiver inside an USB DVB receiver as
> /devices/pci0000:00/0000:00:14.4/0000:02:07.2/usb5/5-1/input/input6
> [    8.012194] dvb-usb: schedule remote query interval to 150 msecs.
> [    8.012196] dvb-usb: Leadtek WinFast DTV2000DS successfully
> initialized and connected.
> [    8.149433] usbcore: registered new interface driver dvb_usb_af9015
>
>
> ******************************************************
>
> $w_scan -c AU
> w_scan version 20091230 (compiled for DVB API 5.1)
> using settings for AUSTRALIA
> DVB aerial
> DVB-T AU
> frontend_type DVB-T, channellist 3
> output format vdr-1.6
> Info: using DVB adapter auto detection.
>        /dev/dvb/adapter1/frontend0 -> DVB-T "Afatech AF9013 DVB-T": good :-)
> Using DVB-T frontend (adapter /dev/dvb/adapter1/frontend0)
> -_-_-_-_ Getting frontend capabilities-_-_-_-_
> Using DVB API 5.2
> frontend Afatech AF9013 DVB-T supports
> INVERSION_AUTO
> QAM_AUTO
> TRANSMISSION_MODE_AUTO
> GUARD_INTERVAL_AUTO
> HIERARCHY_AUTO
> FEC_AUTO
> -_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_
> Scanning 7MHz frequencies...
> 177500: (time: 00:01) (time: 00:03) signal ok:
>        QAM_AUTO f = 177500 kHz I999B7C999D999T999G999Y999
>        updating transponder:
>           (QAM_AUTO f = 177500 kHz I999B7C999D999T999G999Y999)
>        to (QAM_64   f = 177500 kHz I999B7C34D0T8G16Y0)
> 177625: skipped (already known transponder)
> 184500: (time: 00:17)
> 184625: (time: 00:20)
> 191500: (time: 00:22) (time: 00:25) signal ok:
>        QAM_AUTO f = 191500 kHz I999B7C999D999T999G999Y999
>        updating transponder:
>           (QAM_AUTO f = 191500 kHz I999B7C999D999T999G999Y999)
>        to (QAM_64   f = 191625 kHz I999B7C34D0T8G16Y0)
> 191625: skipped (already known transponder)
> 198500: (time: 00:39)
> 198625: (time: 00:42)
> 205500: (time: 00:45)
> 205625: (time: 00:48)
> 212500: (time: 00:50)
> 212625: (time: 00:53)
> 219500: (time: 00:56) (time: 00:58) signal ok:
>        QAM_AUTO f = 219500 kHz I999B7C999D999T999G999Y999
>        updating transponder:
>           (QAM_AUTO f = 219500 kHz I999B7C999D999T999G999Y999)
>        to (QAM_64   f = 219500 kHz I999B7C34D0T8G16Y0)
> 219625: skipped (already known transponder)
> 226500: (time: 01:12) (time: 01:15) signal ok:
>        QAM_AUTO f = 226500 kHz I999B7C999D999T999G999Y999
>        updating transponder:
>           (QAM_AUTO f = 226500 kHz I999B7C999D999T999G999Y999)
>        to (QAM_64   f = 226500 kHz I999B7C34D0T8G16Y0)
> 226625: skipped (already known transponder)
> 480500: (time: 01:28)
>
> <SNIP>
>
> 529625: (time: 02:09)
> 536500: (time: 02:11) (time: 02:14) signal ok:
>        QAM_AUTO f = 536500 kHz I999B7C999D999T999G999Y999
>        updating transponder:
>           (QAM_AUTO f = 536500 kHz I999B7C999D999T999G999Y999)
>        to (QAM_64   f = 536625 kHz I999B7C23D0T8G8Y0)
> 536625: skipped (already known transponder)
> 543500: (time: 02:28)
>
> <SNIP>
>
> 816500: (time: 06:07)
> 816625: (time: 06:10)
> tune to: QAM_64   f = 177500 kHz I999B7C34D0T8G16Y0
> (time: 06:13) ----------no signal----------
> tune to: QAM_64   f = 177500 kHz I999B7C34D0T8G16Y0  (no signal)
> (time: 06:14) __tune_to_transponder:1733: ERROR: FE_READ_STATUS
> failed: 121 Remote I/O error
> tune to: QAM_64   f = 191625 kHz I999B7C34D0T8G16Y0
> (time: 06:14) ----------no signal----------
> tune to: QAM_64   f = 191625 kHz I999B7C34D0T8G16Y0  (no signal)
> (time: 06:15) ----------no signal----------
> tune to: QAM_64   f = 219500 kHz I999B7C34D0T8G16Y0
> (time: 06:17) ----------no signal----------
> tune to: QAM_64   f = 219500 kHz I999B7C34D0T8G16Y0  (no signal)
> (time: 06:18) __tune_to_transponder:1733: ERROR: FE_READ_STATUS
> failed: 121 Remote I/O error
> tune to: QAM_64   f = 226500 kHz I999B7C34D0T8G16Y0
> (time: 06:18) ----------no signal----------
> tune to: QAM_64   f = 226500 kHz I999B7C34D0T8G16Y0  (no signal)
> (time: 06:19) __tune_to_transponder:1733: ERROR: FE_READ_STATUS
> failed: 121 Remote I/O error
> tune to: QAM_64   f = 536625 kHz I999B7C23D0T8G8Y0
> (time: 06:20) ----------no signal----------
> tune to: QAM_64   f = 536625 kHz I999B7C23D0T8G8Y0  (no signal)
> (time: 06:21) ----------no signal----------
>
> ERROR: Sorry - i couldn't get any working frequency/transponder
>  Nothing to scan!!
>


I've had another bash at this, and I think that the 4.95.0 firmware
makes it work. Or at least, one of the 4 tuners is working.

More to report later (perhaps)
