Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f176.google.com ([209.85.212.176]:34018 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932227AbbKCVfT (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 3 Nov 2015 16:35:19 -0500
Received: by wikq8 with SMTP id q8so80388896wik.1
        for <linux-media@vger.kernel.org>; Tue, 03 Nov 2015 13:35:17 -0800 (PST)
MIME-Version: 1.0
Date: Tue, 3 Nov 2015 21:35:17 +0000
Message-ID: <CAMAAsr_Wf79Rcp7jt8crqGU+XTspQ=qURj2x8SOPvvJmxnyFjQ@mail.gmail.com>
Subject: Geniatech / Mygica T230
From: Mike Parkins <mike.bbcnews@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,
I can't get this dvb-t2 USB device to work despite the linuxtv site
claiming it is working since 3.19 kernel. I tried talking to the driver
team on IRC a few months ago and they said they would look at it but I have
recently pulled the linuxtv git tree and compiled it on my Linux Mint 4.09
kernel system and it has not changed. Below is the output of a typical
tuning attempt:

mp@Aurorabox ~ $ dvbv5-scan uk-CrystalPalace -I CHANNEL
Scanning frequency #1 490000000
Lock   (0x1f) C/N= 28.25dB
ERROR    dvb_read_sections: no data read on section filter
ERROR    error while reading the PMT table for service 0x11c0
ERROR    dvb_read_sections: no data read on section filter
ERROR    error while reading the PMT table for service 0x1200
ERROR    dvb_read_sections: no data read on section filter
ERROR    error while reading the PMT table for service 0x1240
ERROR    dvb_read_sections: no data read on section filter
ERROR    error while reading the PMT table for service 0x1280
ERROR    dvb_read_sections: no data read on section filter
ERROR    error while reading the PMT table for service 0x1600
ERROR    dvb_read_sections: no data read on section filter
ERROR    error while reading the PMT table for service 0x1640
ERROR    dvb_read_sections: no data read on section filter
ERROR    error while reading the PMT table for service 0x1680
ERROR    dvb_read_sections: no data read on section filter
ERROR    error while reading the PMT table for service 0x16c0
ERROR    dvb_read_sections: no data read on section filter
ERROR    error while reading the PMT table for service 0x1700
ERROR    dvb_read_sections: no data read on section filter
ERROR    error while reading the PMT table for service 0x1740
ERROR    dvb_read_sections: no data read on section filter
ERROR    error while reading the PMT table for service 0x1780
ERROR    dvb_read_sections: no data read on section filter
ERROR    error while reading the PMT table for service 0x1804
ERROR    dvb_read_sections: no data read on section filter
ERROR    error while reading the PMT table for service 0x1a40
ERROR    dvb_read_sections: no data read on section filter
ERROR    error while reading the PMT table for service 0x1a80
ERROR    dvb_read_sections: no data read on section filter
ERROR    error while reading the PMT table for service 0x1ac0
ERROR    dvb_read_sections: no data read on section filter
ERROR    error while reading the PMT table for service 0x1b00
ERROR    dvb_read_sections: no data read on section filter
ERROR    error while reading the PMT table for service 0x1c00
ERROR    dvb_read_sections: no data read on section filter
ERROR    error while reading the NIT table
ERROR    dvb_read_sections: no data read on section filter
ERROR    error while reading the SDT table
WARNING: no SDT table - storing channel(s) without their names
Storing Service ID 4164: '490.00MHz#4164'
Storing Service ID 4287: '490.00MHz#4287'
Storing Service ID 4288: '490.00MHz#4288'
Storing Service ID 4352: '490.00MHz#4352'
Storing Service ID 4416: '490.00MHz#4416'
Scanning frequency #2 514000000
Lock   (0x1f) Signal= -29.00dBm C/N= 21.50dB
ERROR    dvb_read_sections: no data read on section filter
ERROR    error while waiting for PAT table
Scanning frequency #3 545833000
Lock   (0x1f) Signal= -30.00dBm C/N= 31.00dB
ERROR    dvb_read_sections: no data read on section filter
ERROR    error while waiting for PAT table
Scanning frequency #4 506000000
Lock   (0x1f) Signal= -30.00dBm C/N= 28.50dB
ERROR    dvb_read_sections: no data read on section filter
ERROR    error while waiting for PAT table
Scanning frequency #5 482000000
Lock   (0x1f) Signal= -30.00dBm C/N= 21.75dB
ERROR    dvb_read_sections: no data read on section filter
ERROR    error while waiting for PAT table
Scanning frequency #6 529833000
Lock   (0x1f) Signal= -29.00dBm C/N= 21.75dB
ERROR    dvb_read_sections: no data read on section filter
ERROR    error while waiting for PAT table
Scanning frequency #7 538000000
Lock   (0x1f) Signal= -29.00dBm C/N= 16.50dB
ERROR    dvb_read_sections: no data read on section filter
ERROR    error while waiting for PAT table
Scanning frequency #8 570000000
Lock   (0x1f) Signal= -46.00dBm C/N= 26.50dB
ERROR    dvb_read_sections: no data read on section filter
ERROR    error while waiting for PAT table
Scanning frequency #9 586000000
Lock   (0x1f) Signal= -39.00dBm C/N= 26.25dB
ERROR    dvb_read_sections: no data read on section filter
ERROR    error while waiting for PAT table
mp@Aurorabox ~ $
