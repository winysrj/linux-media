Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qa0-f43.google.com ([209.85.216.43]:40638 "EHLO
	mail-qa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750885AbaKBIpx (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 2 Nov 2014 03:45:53 -0500
Received: by mail-qa0-f43.google.com with SMTP id j7so7060019qaq.16
        for <linux-media@vger.kernel.org>; Sun, 02 Nov 2014 01:45:52 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CACsaVZLs6-iypj1ZU13iVqBdNWY63NCt3f_+SqdpaLjqupPiNQ@mail.gmail.com>
References: <CACsaVZLs6-iypj1ZU13iVqBdNWY63NCt3f_+SqdpaLjqupPiNQ@mail.gmail.com>
From: Kyle Sanderson <kyle.leet@gmail.com>
Date: Sun, 2 Nov 2014 01:45:32 -0700
Message-ID: <CACsaVZKJm-oxOKCsiqp-w4TGCiL91okjyi7d3F0O1i0E47KCeg@mail.gmail.com>
Subject: Re: Hauppage HVR-2250 - No Free Sequences
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

[    9.327707] saa7164 driver loaded
[    9.328739] ACPI: PCI Interrupt Link [LN4A] enabled at IRQ 19
[    9.329585] CORE saa7164[0]: subsystem: 0070:8851, board: Hauppauge
WinTV-HVR2250 [card=7,autodetected]
[    9.329592] saa7164[0]/0: found at 0000:05:00.0, rev: 129, irq: 19,
latency: 0, mmio: 0xfe800000
[    9.460023] saa7164_downloadfirmware() no first image
[    9.460034] saa7164_downloadfirmware() Waiting for firmware upload
(NXP7164-2010-03-10.1.fw)
[    9.684071] saa7164_downloadfirmware() firmware read 4019072 bytes.
[    9.684076] saa7164_downloadfirmware() firmware loaded.
[    9.684077] Firmware file header part 1:
[    9.684080]  .FirmwareSize = 0x0
[    9.684081]  .BSLSize = 0x0
[    9.684083]  .Reserved = 0x3d538
[    9.684084]  .Version = 0x3
[    9.684086] saa7164_downloadfirmware() SecBootLoader.FileSize = 4019072
[    9.684092] saa7164_downloadfirmware() FirmwareSize = 0x1fd6
[    9.684094] saa7164_downloadfirmware() BSLSize = 0x0
[    9.684096] saa7164_downloadfirmware() Reserved = 0x0
[    9.684098] saa7164_downloadfirmware() Version = 0x1661c00
[   16.496685] saa7164_downloadimage() Image downloaded, booting...
[   16.600015] saa7164_downloadimage() Image booted successfully.
[   16.600040] starting firmware download(2)
[   19.166683] saa7164_downloadimage() Image downloaded, booting...
[   21.130015] saa7164_downloadimage() Image booted successfully.
[   21.130040] firmware download complete.
[   21.177186] tveeprom 1-0000: Hauppauge model 88061, rev C4F2, serial#
[   21.177193] tveeprom 1-0000: MAC address is 00:0d:fe:xx:xx:xx
[   21.177196] tveeprom 1-0000: tuner model is NXP 18271C2_716x (idx
152, type 4)
[   21.177200] tveeprom 1-0000: TV standards NTSC(M) ATSC/DVB Digital
(eeprom 0x88)
[   21.177203] tveeprom 1-0000: audio processor is SAA7164 (idx 43)
[   21.177205] tveeprom 1-0000: decoder processor is SAA7164 (idx 40)
[   21.177208] tveeprom 1-0000: has radio, has IR receiver, has no IR
transmitter
[   21.177210] saa7164[0]: Hauppauge eeprom: model=88061
[   21.544594] tda18271 2-0060: creating new instance
[   21.549445] TDA18271HD/C2 detected @ 2-0060
[   21.781995] DVB: registering new adapter (saa7164)
[   21.782011] saa7164 0000:05:00.0: DVB: registering adapter 0
frontend 0 (Samsung S5H1411 QAM/8VSB Frontend)...
[   22.071439] tda18271 3-0060: creating new instance
[   22.075732] TDA18271HD/C2 detected @ 3-0060
[   22.298139] tda18271: performing RF tracking filter calibration
[   24.573984] tda18271: RF tracking filter calibration complete
[   24.578058] DVB: registering new adapter (saa7164)
[   24.578074] saa7164 0000:05:00.0: DVB: registering adapter 1
frontend 0 (Samsung S5H1411 QAM/8VSB Frontend)...
[   24.579110] saa7164[0]: registered device video0 [mpeg]
[   24.809340] saa7164[0]: registered device video1 [mpeg]
[   25.020165] saa7164[0]: registered device vbi0 [vbi]
[   25.020333] saa7164[0]: registered device vbi1 [vbi]

Kernel: 3.12.21-gentoo-r1

On Fri, Oct 31, 2014 at 8:55 AM, Kyle Sanderson <kyle.leet@gmail.com> wrote:
> Hi All,
>
> So I've been using my tuner for a couple years now with tvheadend,
> works great :-). However, eventually I encounter something like this
> in my dmesg
>
> [585870.001641] saa7164_cmd_send() No free sequences
> [585870.001645] saa7164_api_i2c_write() error, ret(1) = 0xc
> [585870.001650] tda10048_writereg: writereg error (ret == -5)
> [585870.024809] saa7164_cmd_send() No free sequences
> [585870.024820] saa7164_api_i2c_read() error, ret(1) = 0xc
> [585870.024826] tda10048_readreg: readreg error (ret == -5)
> [585870.024838] saa7164_cmd_send() No free sequences
> [585870.024843] saa7164_api_i2c_read() error, ret(1) = 0xc
> [585870.024848] tda10048_readreg: readreg error (ret == -5)
> [585870.024856] saa7164_cmd_send() No free sequences
> [585870.024861] saa7164_api_i2c_write() error, ret(1) = 0xc
> [585870.024866] tda10048_writereg: writereg error (ret == -5)
> [585870.024878] saa7164_cmd_send() No free sequences
> [585870.024883] saa7164_api_i2c_write() error, ret(1) = 0xc
>
> The result is the card stops accepting commands; won't tune to other
> frequencies. Rebooting the box seems to resolve it. The time before
> that starts occurring though varies wildly, usually when it's stormy
> and the ATSC antenna starts cutting in and out (reflection off of the
> tree).
>
> Is there another way I can get around doing that? would rmmod/insmod work?
>
> Looking on the Hauppage site it looks like they're still developing
> drivers for it ( ftp://ftp.hauppauge.com/Support/HVR2250/ ). From
> google-ing around, it looks like people are still using the firmware
> that Steven Toth ripped in 2011.
>
> Any tips? I've tried a couple horrible kernel patches but didn't get anywhere.
> Kyle.
