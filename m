Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qg0-f50.google.com ([209.85.192.50]:48421 "EHLO
	mail-qg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753104AbaLTQuk (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 20 Dec 2014 11:50:40 -0500
Received: by mail-qg0-f50.google.com with SMTP id z60so1865293qgd.23
        for <linux-media@vger.kernel.org>; Sat, 20 Dec 2014 08:50:39 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CACsaVZ+=GXgjGHRxF_itKrmdWh-D9EkusChoFZ4VHWquBzYt5A@mail.gmail.com>
References: <CACsaVZ+=GXgjGHRxF_itKrmdWh-D9EkusChoFZ4VHWquBzYt5A@mail.gmail.com>
From: Kyle Sanderson <kyle.leet@gmail.com>
Date: Sat, 20 Dec 2014 08:50:19 -0800
Message-ID: <CACsaVZJnrxE=-u5wD9j3_baCoWB3q28Lm9-_WQRkiEtqBux55g@mail.gmail.com>
Subject: Re: [BUG] Hauppage HVR-2250 - No Free Sequences
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

[891338.817585] s5h1411_readreg: readreg error (ret == -5)
[891338.817591] saa7164_cmd_send() No free sequences
[891338.817594] saa7164_api_i2c_read() error, ret(1) = 0xc
[891338.817597] s5h1411_readreg: readreg error (ret == -5)
[891338.817602] saa7164_cmd_send() No free sequences
[891338.817604] saa7164_api_i2c_write() error, ret(1) = 0xc
[891338.817607] s5h1411_writereg: writereg error 0x19 0xf7 0x0000, ret == -5)
[891338.817611] saa7164_cmd_send() No free sequences
[891338.817613] saa7164_api_i2c_write() error, ret(1) = 0xc
[891338.817615] s5h1411_writereg: writereg error 0x19 0xf7 0x0001, ret == -5)
[891338.817619] saa7164_cmd_send() No free sequences
[891338.817621] saa7164_api_i2c_write() error, ret(1) = 0xc
[891338.817624] s5h1411_writereg: writereg error 0x19 0xf5 0x0001, ret == -5)
[891338.817628] saa7164_cmd_send() No free sequences
[891338.817630] saa7164_api_i2c_write() error, ret(1) = 0xc
[891338.817634] __tda18271_write_regs: [3-0060|S] ERROR: idx = 0x5,
len = 1, i2c_transfer returned: -5
[891338.817637] tda18271_init: [3-0060|S] error -5 on line 832
[891338.817640] tda18271_tune: [3-0060|S] error -5 on line 910
[891338.817643] tda18271_set_params: [3-0060|S] error -5 on line 985
[891338.817647] saa7164_cmd_send() No free sequences
[891338.817649] saa7164_api_i2c_write() error, ret(1) = 0xc
[891338.817651] s5h1411_writereg: writereg error 0x19 0xf5 0x0000, ret == -5)
[891338.817655] saa7164_cmd_send() No free sequences
[891338.817657] saa7164_api_i2c_write() error, ret(1) = 0xc
[891338.817659] s5h1411_writereg: writereg error 0x19 0xf7 0x0000, ret == -5)
[891338.817663] saa7164_cmd_send() No free sequences
[891338.817664] saa7164_api_i2c_write() error, ret(1) = 0xc
[891338.817667] s5h1411_writereg: writereg error 0x19 0xf7 0x0001, ret == -5)
[891338.846673] saa7164_cmd_send() No free sequences
[891338.846678] saa7164_api_i2c_read() error, ret(1) = 0xc
[891338.846682] s5h1411_readreg: readreg error (ret == -5)
[891338.846686] saa7164_cmd_send() No free sequences


Definitely out of ideas at this point. Any tips?
Kyle.

On Sat, Dec 6, 2014 at 11:07 AM, Kyle Sanderson <kyle.leet@gmail.com> wrote:
> [1627538.860627] s5h1411_readreg: readreg error (ret == -5)
> [1627538.860633] saa7164_cmd_send() No free sequences
> [1627538.860636] saa7164_api_i2c_read() error, ret(1) = 0xc
> [1627538.860639] s5h1411_readreg: readreg error (ret == -5)
> [1627538.860647] saa7164_cmd_send() No free sequences
> [1627538.860649] saa7164_api_i2c_write() error, ret(1) = 0xc
> [1627538.860652] s5h1411_writereg: writereg error 0x19 0xf7 0x0000, ret == -5)
> [1627538.860656] saa7164_cmd_send() No free sequences
> [1627538.860658] saa7164_api_i2c_write() error, ret(1) = 0xc
> [1627538.860661] s5h1411_writereg: writereg error 0x19 0xf7 0x0001, ret == -5)
> [1627538.860665] saa7164_cmd_send() No free sequences
> [1627538.860666] saa7164_api_i2c_write() error, ret(1) = 0xc
> [1627538.860669] s5h1411_writereg: writereg error 0x19 0xf5 0x0001, ret == -5)
> [1627538.860675] saa7164_cmd_send() No free sequences
> [1627538.860676] saa7164_api_i2c_write() error, ret(1) = 0xc
> [1627538.860681] __tda18271_write_regs: [2-0060|M] ERROR: idx = 0x5,
> len = 1, i2
>                                                  c_transfer returned:
> -5
> [1627538.860685] tda18271_init: [2-0060|M] error -5 on line 832
> [1627538.860688] tda18271_tune: [2-0060|M] error -5 on line 910
> [1627538.860691] tda18271_set_params: [2-0060|M] error -5 on line 985
> [1627538.860695] saa7164_cmd_send() No free sequences
> [1627538.860696] saa7164_api_i2c_write() error, ret(1) = 0xc
> [1627538.860699] s5h1411_writereg: writereg error 0x19 0xf5 0x0000, ret == -5)
> [1627538.860703] saa7164_cmd_send() No free sequences
> [1627538.860704] saa7164_api_i2c_write() error, ret(1) = 0xc
> [1627538.860707] s5h1411_writereg: writereg error 0x19 0xf7 0x0000, ret == -5)
> [1627538.860710] saa7164_cmd_send() No free sequences
> [1627538.860712] saa7164_api_i2c_write() error, ret(1) = 0xc
> [1627538.860714] s5h1411_writereg: writereg error 0x19 0xf7 0x0001, ret == -5)
> [1627538.878939] saa7164_cmd_send() No free sequences
> [1627538.878942] saa7164_api_i2c_read() error, ret(1) = 0xc
> [1627538.878944] s5h1411_readreg: readreg error (ret == -5)
> [1627538.878947] saa7164_cmd_send() No free sequences
> [1627538.878949] saa7164_api_i2c_read() error, ret(1) = 0xc
> [1627538.878951] s5h1411_readreg: readreg error (ret == -5)
> [1627538.929029] saa7164_cmd_send() No free sequences
> [1627538.929031] saa7164_api_i2c_read() error, ret(1) = 0xc
> [1627538.929033] s5h1411_readreg: readreg error (ret == -5)
> [1627538.929037] saa7164_cmd_send() No free sequences
> [1627538.929038] saa7164_api_i2c_read() error, ret(1) = 0xc
> [1627538.929040] s5h1411_readreg: readreg error (ret == -5)
> [1627538.979118] saa7164_cmd_send() No free sequences
> [1627538.979120] saa7164_api_i2c_read() error, ret(1) = 0xc
> [1627538.979123] s5h1411_readreg: readreg error (ret == -5)
> [1627538.979126] saa7164_cmd_send() No free sequences
> [1627538.979128] saa7164_api_i2c_read() error, ret(1) = 0xc
> [1627538.979129] s5h1411_readreg: readreg error (ret == -5)
> [1627539.029207] saa7164_cmd_send() No free sequences
> [1627539.029210] saa7164_api_i2c_read() error, ret(1) = 0xc
> [1627539.029212] s5h1411_readreg: readreg error (ret == -5)
> [1627539.029215] saa7164_cmd_send() No free sequences
> [1627539.029217] saa7164_api_i2c_read() error, ret(1) = 0xc
> [1627539.029219] s5h1411_readreg: readreg error (ret == -5)
> [1627539.079296] saa7164_cmd_send() No free sequences
> [1627539.079298] saa7164_api_i2c_read() error, ret(1) = 0xc
> [1627539.079300] s5h1411_readreg: readreg error (ret == -5)
> [1627539.079304] saa7164_cmd_send() No free sequences
> [1627539.079306] saa7164_api_i2c_read() error, ret(1) = 0xc
> [1627539.079307] s5h1411_readreg: readreg error (ret == -5)
> [1627539.129385] saa7164_cmd_send() No free sequences
> [1627539.129387] saa7164_api_i2c_read() error, ret(1) = 0xc
> [1627539.129389] s5h1411_readreg: readreg error (ret == -5)
> [1627539.129392] saa7164_cmd_send() No free sequences
> [1627539.129394] saa7164_api_i2c_read() error, ret(1) = 0xc
> [1627539.129396] s5h1411_readreg: readreg error (ret == -5)
> [1627539.179501] saa7164_cmd_send() No free sequences
> [1627539.179505] saa7164_api_i2c_read() error, ret(1) = 0xc
> [1627539.179508] s5h1411_readreg: readreg error (ret == -5)
> [1627539.179512] saa7164_cmd_send() No free sequences
> [1627539.179514] saa7164_api_i2c_read() error, ret(1) = 0xc
> [1627539.179515] s5h1411_readreg: readreg error (ret == -5)
>
> On Sun, Nov 2, 2014 at 1:45 AM, Kyle Sanderson <kyle.leet@gmail.com> wrote:
>> [    9.327707] saa7164 driver loaded
>> [    9.328739] ACPI: PCI Interrupt Link [LN4A] enabled at IRQ 19
>> [    9.329585] CORE saa7164[0]: subsystem: 0070:8851, board: Hauppauge
>> WinTV-HVR2250 [card=7,autodetected]
>> [    9.329592] saa7164[0]/0: found at 0000:05:00.0, rev: 129, irq: 19,
>> latency: 0, mmio: 0xfe800000
>> [    9.460023] saa7164_downloadfirmware() no first image
>> [    9.460034] saa7164_downloadfirmware() Waiting for firmware upload
>> (NXP7164-2010-03-10.1.fw)
>> [    9.684071] saa7164_downloadfirmware() firmware read 4019072 bytes.
>> [    9.684076] saa7164_downloadfirmware() firmware loaded.
>> [    9.684077] Firmware file header part 1:
>> [    9.684080]  .FirmwareSize = 0x0
>> [    9.684081]  .BSLSize = 0x0
>> [    9.684083]  .Reserved = 0x3d538
>> [    9.684084]  .Version = 0x3
>> [    9.684086] saa7164_downloadfirmware() SecBootLoader.FileSize = 4019072
>> [    9.684092] saa7164_downloadfirmware() FirmwareSize = 0x1fd6
>> [    9.684094] saa7164_downloadfirmware() BSLSize = 0x0
>> [    9.684096] saa7164_downloadfirmware() Reserved = 0x0
>> [    9.684098] saa7164_downloadfirmware() Version = 0x1661c00
>> [   16.496685] saa7164_downloadimage() Image downloaded, booting...
>> [   16.600015] saa7164_downloadimage() Image booted successfully.
>> [   16.600040] starting firmware download(2)
>> [   19.166683] saa7164_downloadimage() Image downloaded, booting...
>> [   21.130015] saa7164_downloadimage() Image booted successfully.
>> [   21.130040] firmware download complete.
>> [   21.177186] tveeprom 1-0000: Hauppauge model 88061, rev C4F2, serial#
>> [   21.177193] tveeprom 1-0000: MAC address is 00:0d:fe:xx:xx:xx
>> [   21.177196] tveeprom 1-0000: tuner model is NXP 18271C2_716x (idx
>> 152, type 4)
>> [   21.177200] tveeprom 1-0000: TV standards NTSC(M) ATSC/DVB Digital
>> (eeprom 0x88)
>> [   21.177203] tveeprom 1-0000: audio processor is SAA7164 (idx 43)
>> [   21.177205] tveeprom 1-0000: decoder processor is SAA7164 (idx 40)
>> [   21.177208] tveeprom 1-0000: has radio, has IR receiver, has no IR
>> transmitter
>> [   21.177210] saa7164[0]: Hauppauge eeprom: model=88061
>> [   21.544594] tda18271 2-0060: creating new instance
>> [   21.549445] TDA18271HD/C2 detected @ 2-0060
>> [   21.781995] DVB: registering new adapter (saa7164)
>> [   21.782011] saa7164 0000:05:00.0: DVB: registering adapter 0
>> frontend 0 (Samsung S5H1411 QAM/8VSB Frontend)...
>> [   22.071439] tda18271 3-0060: creating new instance
>> [   22.075732] TDA18271HD/C2 detected @ 3-0060
>> [   22.298139] tda18271: performing RF tracking filter calibration
>> [   24.573984] tda18271: RF tracking filter calibration complete
>> [   24.578058] DVB: registering new adapter (saa7164)
>> [   24.578074] saa7164 0000:05:00.0: DVB: registering adapter 1
>> frontend 0 (Samsung S5H1411 QAM/8VSB Frontend)...
>> [   24.579110] saa7164[0]: registered device video0 [mpeg]
>> [   24.809340] saa7164[0]: registered device video1 [mpeg]
>> [   25.020165] saa7164[0]: registered device vbi0 [vbi]
>> [   25.020333] saa7164[0]: registered device vbi1 [vbi]
>>
>> Kernel: 3.12.21-gentoo-r1
>>
>> On Fri, Oct 31, 2014 at 8:55 AM, Kyle Sanderson <kyle.leet@gmail.com> wrote:
>>> Hi All,
>>>
>>> So I've been using my tuner for a couple years now with tvheadend,
>>> works great :-). However, eventually I encounter something like this
>>> in my dmesg
>>>
>>> [585870.001641] saa7164_cmd_send() No free sequences
>>> [585870.001645] saa7164_api_i2c_write() error, ret(1) = 0xc
>>> [585870.001650] tda10048_writereg: writereg error (ret == -5)
>>> [585870.024809] saa7164_cmd_send() No free sequences
>>> [585870.024820] saa7164_api_i2c_read() error, ret(1) = 0xc
>>> [585870.024826] tda10048_readreg: readreg error (ret == -5)
>>> [585870.024838] saa7164_cmd_send() No free sequences
>>> [585870.024843] saa7164_api_i2c_read() error, ret(1) = 0xc
>>> [585870.024848] tda10048_readreg: readreg error (ret == -5)
>>> [585870.024856] saa7164_cmd_send() No free sequences
>>> [585870.024861] saa7164_api_i2c_write() error, ret(1) = 0xc
>>> [585870.024866] tda10048_writereg: writereg error (ret == -5)
>>> [585870.024878] saa7164_cmd_send() No free sequences
>>> [585870.024883] saa7164_api_i2c_write() error, ret(1) = 0xc
>>>
>>> The result is the card stops accepting commands; won't tune to other
>>> frequencies. Rebooting the box seems to resolve it. The time before
>>> that starts occurring though varies wildly, usually when it's stormy
>>> and the ATSC antenna starts cutting in and out (reflection off of the
>>> tree).
>>>
>>> Is there another way I can get around doing that? would rmmod/insmod work?
>>>
>>> Looking on the Hauppage site it looks like they're still developing
>>> drivers for it ( ftp://ftp.hauppauge.com/Support/HVR2250/ ). From
>>> google-ing around, it looks like people are still using the firmware
>>> that Steven Toth ripped in 2011.
>>>
>>> Any tips? I've tried a couple horrible kernel patches but didn't get anywhere.
>>> Kyle.
