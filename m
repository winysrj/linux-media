Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f218.google.com ([209.85.220.218]:35303 "EHLO
	mail-fx0-f218.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751984AbZJZXb1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 26 Oct 2009 19:31:27 -0400
Received: by fxm18 with SMTP id 18so12544557fxm.37
        for <linux-media@vger.kernel.org>; Mon, 26 Oct 2009 16:31:31 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <8d0bb7650910261544i4ebed975rf81ec6bc38076927@mail.gmail.com>
References: <8d0bb7650910261544i4ebed975rf81ec6bc38076927@mail.gmail.com>
Date: Mon, 26 Oct 2009 23:23:50 +0000
Message-ID: <a413d4880910261623x44d106f4h167a7dab80a4a3f8@mail.gmail.com>
Subject: Re: Hauppage HVR-2250 Tuning problems
From: Another Sillyname <anothersname@googlemail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

2009/10/26 dan <danwalkeriv@gmail.com>:
> I can't seem to get my HVR-2250 (rev. 88061) card to tune any
> channels.  I have Comcast digital cable, and my VIZIO VL370M
> television is able to tune all of the QAM channels, so I know that the
> signal is present and is usable (in theory).  I have tried scanning
> for channels in Mythbuntu 9.10 RC (2.6.31 kernel), with MythTV, scan,
> dvbscan and scte65scan, without finding any channels.  I have tried
> installing the saa7164 drivers from the kernellabs repository and also
> the linuxtv repository, with the same results.
>
> The channel scanner in MythTV has two bars at the top of the screen to
> indicate signal strength and signal-to-noise ratio, and they both stay
> at 0% during the channel scan.  The scanner will say "locked" for a
> particular channel, but then it will show a message saying that it
> timed and without finding any channels.  I have already set the
> timeout to the maximum allowed by the software.
>
> scte65 scan get the closest to giving some kind of output.  I run it
> with this command:
>
> $ ./scte65scan -f1 -n1 ./us-Cable-Standard-center-frequencies-QAM256 >
> channels.conf
>
> At some point it  gives the following output:
>
> tuning 741000000hz..locked...PID 0x1ffc found
> Collecting data (may take up to 2 minutes)
>
> but then it basically just hangs indefinitely until I kill it, and
> channels.conf is always empty afterward.
>
> I do have a couple of errors show up in dmesg, but I'm not sure if
> they're relevant.  Just in case it's helpful, here is the output from
> dmesg.
>
> [   14.266956] saa7164 driver loaded
> [   14.267518] saa7164 0000:01:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
> [   14.267621] CORE saa7164[0]: subsystem: 0070:8891, board: Hauppauge
> WinTV-HVR2250 [card=7,autodetected]
> [   14.267627] saa7164[0]/0: found at 0000:01:00.0, rev: 129, irq: 16,
> latency: 0, mmio: 0xe4000000
> [   14.267633] saa7164 0000:01:00.0: setting latency timer to 64
> [   14.267637] IRQ 16/saa7164[0]: IRQF_DISABLED is not guaranteed on shared IRQs
> [   14.460016] saa7164_downloadfirmware() no first image
> [   14.460029] saa7164_downloadfirmware() Waiting for firmware upload
> (v4l-saa7164-1.0.3.fw)
> [   14.460035] saa7164 0000:01:00.0: firmware: requesting v4l-saa7164-1.0.3.fw
> [   16.075415] saa7164_downloadfirmware() firmware read 3978608 bytes.
> [   16.075417] saa7164_downloadfirmware() firmware loaded.
> [   16.075425] saa7164_downloadfirmware() SecBootLoader.FileSize = 3978608
> [   16.075431] saa7164_downloadfirmware() FirmwareSize = 0x1fd6
> [   16.075433] saa7164_downloadfirmware() BSLSize = 0x0
> [   16.075434] saa7164_downloadfirmware() Reserved = 0x0
> [   16.075435] saa7164_downloadfirmware() Version = 0x51cc1
> [   23.351830] saa7164_downloadimage() Image downloaded, booting...
> [   23.460015] saa7164_downloadimage() Image booted successfully.
> [   25.840015] saa7164_downloadimage() Image downloaded, booting...
> [   27.260019] saa7164_downloadimage() Image booted successfully.
> [   27.302513] saa7164[0]: Hauppauge eeprom: model=88061
> [   28.539398] saa7164_api_i2c_read() error, ret(2) = 0x13
> [   28.542913] saa7164_api_i2c_read() error, ret(2) = 0x13
> [   28.543201] DVB: registering new adapter (saa7164)
> [   32.148177] DVB: registering new adapter (saa7164)
>
> I have done some searching online, and that's what led me to scan,
> dvbscan and scte65scan, but none of the suggestions I've found so far
> seem to help.  Does anyone have any suggestions as to where I can go
> from here?  Could there be something wrong with the card itself?  Are
> there any diagnostics I could run?
>
> Thanks in advance for any help that anyone can offer.
>
> --dan
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

Dan

I've got the 2200 version of this device and I do not get any error
messages during the load.

Steven Toth wrote the driver and has a status page here...

http://www.steventoth.net/blog/products/hvr-2250/

you may want to contact him directly, keeping in mind he does this out
of love and doesn't get paid for support :) (Although Hauppauge should
pay him something for the amount of work he does on their products
IMHO).

Good Luck
