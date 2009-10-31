Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f227.google.com ([209.85.218.227]:63334 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757846AbZJaQV0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 31 Oct 2009 12:21:26 -0400
Received: by bwz27 with SMTP id 27so4683876bwz.21
        for <linux-media@vger.kernel.org>; Sat, 31 Oct 2009 09:21:29 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4AEC2F03.6050205@gmail.com>
References: <4AEC2F03.6050205@gmail.com>
Date: Sat, 31 Oct 2009 12:21:28 -0400
Message-ID: <829197380910310921k42f9ae5fkafa6edc318e61bf6@mail.gmail.com>
Subject: Re: [linux-dvb] somebody messed something on xc2028 code?
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: linux-media@vger.kernel.org
Cc: linux-dvb@linuxtv.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, Oct 31, 2009 at 8:35 AM, Albert Comerma
<albert.comerma@gmail.com> wrote:
> Hi all, I just updated my ubuntu to karmic and found with surprise that with
> 2.6.31 kernel my device does not work... It seems to be related to the
> xc2028 code part since the kernel explosion happens when you try to tune the
> device, here it's my dmesg, any idea?
>
> Albert
>
> [ 1622.032196] usb 1-1: new high speed USB device using ehci_hcd and address
> 4
> [ 1622.166041] usb 1-1: configuration #1 chosen from 1 choice
> [ 1622.167341] dvb-usb: found a 'Pinnacle Expresscard 320cx' in cold state,
> will try to load a firmware
> [ 1622.167353] usb 1-1: firmware: requesting dvb-usb-dib0700-1.20.fw
> [ 1622.188465] dvb-usb: downloading firmware from file
> 'dvb-usb-dib0700-1.20.fw'
> [ 1622.396737] dib0700: firmware started successfully.
> [ 1622.900198] dvb-usb: found a 'Pinnacle Expresscard 320cx' in warm state.
> [ 1622.900308] dvb-usb: will pass the complete MPEG2 transport stream to the
> software demuxer.
> [ 1622.900759] DVB: registering new adapter (Pinnacle Expresscard 320cx)
> [ 1623.157839] DVB: registering adapter 0 frontend 0 (DiBcom 7000PC)...
> [ 1623.158165] xc2028 4-0061: creating new instance
> [ 1623.158173] xc2028 4-0061: type set to XCeive xc2028/xc3028 tuner
> [ 1623.158333] input: IR-receiver inside an USB DVB receiver as
> /devices/pci0000:00/0000:00:1a.7/usb1/1-1/input/input16
> [ 1623.158418] dvb-usb: schedule remote query interval to 50 msecs.
> [ 1623.158427] dvb-usb: Pinnacle Expresscard 320cx successfully initialized
> and connected.
> [ 1670.979678] CE: hpet increasing min_delta_ns to 15000 nsec
> [ 1753.316527] BUG: unable to handle kernel NULL pointer dereference at
> 00000008
> [ 1753.316543] IP: [<c03a8a13>] _request_firmware+0x1f3/0x250
> [ 1753.316562] *pde = 00000000
> [ 1753.316570] Oops: 0000 [#2] SMP
> [ 1753.316578] last sysfs file:
> /sys/devices/LNXSYSTM:00/device:00/PNP0C0A:00/power_supply/BAT0/charge_full
> [ 1753.316586] Modules linked in: tuner_xc2028 dvb_usb_dib0700 dib7000p
> dib7000m dvb_usb dvb_core dib3000mc dibx000_common dib0070 hidp binfmt_misc
> vboxnetflt vboxnetadp vboxdrv ppdev parport_pc snd_hda_codec_idt
> snd_hda_intel snd_hda_codec snd_hwdep snd_pcm_oss snd_mixer_oss snd_pcm arc4
> ecb snd_seq_dummy snd_seq_oss iwlagn bridge stp bnep snd_seq_midi iwlcore
> snd_rawmidi joydev iptable_nat snd_seq_midi_event mac80211 nf_nat snd_seq
> nf_conntrack_ipv4 nf_conntrack nf_defrag_ipv4 snd_timer snd_seq_device
> iptable_mangle snd sbp2 dell_wmi psmouse iptable_filter serio_raw ip_tables
> soundcore x_tables snd_page_alloc cfg80211 uvcvideo videodev v4l1_compat
> sdhci_pci sdhci led_class lp btusb dell_laptop dcdbas nvidia(P) parport
> usbhid dm_raid45 xor ohci1394 video output ieee1394 tg3 intel_agp agpgart
> [ 1753.316753]

This was actually a regression related to the dib7000 driver and any
tuner that uses request_firmware().  I checked in a fix for one board
that hit it.  It was introduced because 2.6.28 started using the first
parameter passed to request_firmware(), and the dib7000 driver was
sending null.

Can you clarify which bridge your device uses.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
