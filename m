Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:59823 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751516AbcBNRKz (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 14 Feb 2016 12:10:55 -0500
Subject: Re: PCTV 292e weirdness
To: Russel Winder <russel@winder.org.uk>,
	DVB_Linux_Media <linux-media@vger.kernel.org>
References: <1454523447.1970.15.camel@itzinteractive.com>
 <1455361477.1704.11.camel@winder.org.uk>
From: Antti Palosaari <crope@iki.fi>
Message-ID: <56C0B51C.6070009@iki.fi>
Date: Sun, 14 Feb 2016 19:10:52 +0200
MIME-Version: 1.0
In-Reply-To: <1455361477.1704.11.camel@winder.org.uk>
Content-Type: multipart/mixed;
 boundary="------------040409020504030501000102"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is a multi-part message in MIME format.
--------------040409020504030501000102
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit

I did some testing and I suspect changed firmware behavior after 4.0.11 
so that it goes totally power off when put into sleep and on that case 
firmware update is also lost.

One solution is to use firmware version to make decision if it needs to 
be uploaded everytime after the sleep(). Even better solution is to 
detect somehow if firmware upload is need by run-time, but that chip 
seems not to answer almost any command when it is put into deep sleep.

I have following firmwares:
4.0.2 (default firmware burned to chip rom)
4.0.4
4.0.11
4.0.19
4.0.25

It could be interesting to get missing ones... I attached script I used 
to extract firmwares from binary.

Antti

On 02/13/2016 01:04 PM, Russel Winder wrote:
>  From what I can see, this problem has gone away – hopefully
> permanently.
>
> As far as I can tell the only change is that there has been a firmware
> file update at git@github.com:OpenELEC/dvb-firmware.git that reverts
> 4.0.19 to 4.0.11
>
> On Wed, 2016-02-03 at 18:17 +0000, Russel Winder wrote:
>> I am fairly sure I didn't see this before, but then I am not sure I
>> have a new kernel, libdvbv5 or dvbtools. Also people are bad
>> witnesses.
>> However, if I plug the device in I can either scan with it or tune
>> it,
>> but only once thereafter it goes into "won't do anything so there"
>> mode. For example:
>>
>>
>>>> dvbv5-zap -c save_channels.conf "BBC NEWS"
>> using demux '/dev/dvb/adapter0/demux0'
>> reading channels from file 'save_channels.conf'
>> service has pid type 05:  7270
>> tuning to 490000000 Hz
>> video pid 501
>>    dvb_set_pesfilter 501
>> audio pid 502
>>    dvb_set_pesfilter 502
>>         (0x00)
>> Lock   (0x1f) Signal= -51.00dBm C/N= 23.50dB
>> 582 anglides:~/Repositories/Git/Git/Me-TV (git:master)
>>>> dvbv5-zap -c save_channels.conf "BBC NEWS"
>> using demux '/dev/dvb/adapter0/demux0'
>> reading channels from file 'save_channels.conf'
>> service has pid type 05:  7270
>> tuning to 490000000 Hz
>> video pid 501
>>    dvb_set_pesfilter 501
>> audio pid 502
>>    dvb_set_pesfilter 502
>>         (0x00) C/N= 23.50dB
>>         (0x00) Signal= -67.00dBm C/N= 23.50dB
>>         (0x00) Signal= -67.00dBm C/N= 23.50dB
>>         (0x00) Signal= -109.00dBm C/N= 23.50dB
>>         (0x00) Signal= -109.00dBm C/N= 23.50dB
>>         (0x00) Signal= -109.00dBm C/N= 23.50dB
>>         (0x00) Signal= -109.00dBm C/N= 23.50dB
>>         (0x00) Signal= -109.00dBm C/N= 23.50dB
>>         (0x00) Signal= -109.00dBm C/N= 23.50dB
>>         (0x00) Signal= -109.00dBm C/N= 23.50dB
>>         (0x00) Signal= -109.00dBm C/N= 23.50dB
>>
>>
>> If I use a PCTV 282e this does not happen. As far as I can tell there
>> has been no change of firmware either, and yet…
>>
>>

-- 
http://palosaari.fi/

--------------040409020504030501000102
Content-Type: text/x-python;
 name="si2168_extract_firmware.py"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="si2168_extract_firmware.py"

#!/usr/bin/env python
# Silicon Labs Si2168 firmware extractor.
# Copyright (C) 2015 Antti Palosaari <crope@iki.fi>
# Usage: si2168_extract_firmware.py binary_driver_name.sys

import sys
import struct
import md5

fread = file(sys.argv[1], 'rb')
binary = fread.read()
offset = 0

# Known firmware md5 and its version
fw_ver_tab = {
    'b2670d8ae5e3369fc71edbb98cdd8f6e' : '4.0.11',
    '8dfc2483d90282bbb05817fbbc282376' : '4.0.19',
    'c8e089c351e9834060e962356f8697b8' : '4.0.25',
}

while True:
    # Match 17-byte firmware header
    # 04 01 00 00 00 00 9a 41 05 1b af 33 02 1b 3e 7d 2a | A20 (not supported)
    # 08 05 00 xx xx xx xx xx xx 00 00 00 00 00 00 00 00 | B40
    offset = binary.find('\x08\x05\x00', offset)
    if offset == -1:
        print "Done"
        break

    if (binary[offset + 9:offset + 17] != '\x00\x00\x00\x00\x00\x00\x00\x00'):
        offset = offset + 1
        continue

    print "17-byte firmware found at 0x%x" % (offset)

    fw_filename = 'dvb-demod-si2168-b40-01.fw_' + str(offset)
    fw_write = open(fw_filename, 'wb')
    fw_md5 = md5.new()

    while True:
        fields = struct.unpack("B", binary[offset])
        fw_data_len = fields[0]
        # Firmware chunk first byte tells bytes to upload - 16 is max
        if fw_data_len > 16:
            print "Firmware upload len too large %d" % (fw_data_len)
            break

        # Check remaining (unused) bytes on firmware 17-byte chunk are all zero
        data_valid = True
        for x in range(offset + fw_data_len + 1, offset + 17):
            if (binary[x] != '\x00'):
                data_valid = False
                break

        if data_valid == False:
            break

        # Firmware chunk validated, write it to file
        fw_write.write(binary[offset + 0:offset + 17])
        fw_md5.update(binary[offset + 0:offset + 17])
        offset = offset + 17

    fw_write.close()

    if fw_md5.hexdigest() in fw_ver_tab:
        fw_ver = fw_ver_tab[fw_md5.hexdigest()]
    else:
        fw_ver = '<unknown>'

    print "Firmware md5 '%s'" % (fw_md5.hexdigest())
    print "Firmware version '%s'" % (fw_ver)
    print "Firmware stored to file '%s'" % (fw_filename)

    offset = offset + 1

fread.close()


--------------040409020504030501000102--
