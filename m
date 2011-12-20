Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:54034 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750755Ab1LTMLK (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 20 Dec 2011 07:11:10 -0500
Received: by eaad14 with SMTP id d14so208317eaa.19
        for <linux-media@vger.kernel.org>; Tue, 20 Dec 2011 04:11:09 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4EF04250.9020502@iki.fi>
References: <CA+kQy-XAL4Kz2+Ft68V8QBqM7pETdJd-WhGmmUxETXJ02kKJEg@mail.gmail.com>
 <4EF04250.9020502@iki.fi>
From: Jesper Krogh <jesper@rapanden.dk>
Date: Tue, 20 Dec 2011 09:10:47 -0300
Message-ID: <CA+kQy-VxNT43b5rkBHPV_jyHisfiFXP_isNpGmf7vnGLsA3njw@mail.gmail.com>
Subject: Re: Anysee E30 S2 plus
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Ok. I had my doubts on whether to include that or not - But here it is

/Jesper

[ 1053.784044] usb 1-6: new high speed USB device number 7 using ehci_hcd
[ 1054.556036] usb 1-6: device not accepting address 7, error -71
[ 1054.668043] usb 1-6: new high speed USB device number 8 using ehci_hcd
[ 1056.136482] usb 1-6: config 1 interface 0 altsetting 0 bulk
endpoint 0x1 has invalid maxpacket 64
[ 1056.136492] usb 1-6: config 1 interface 0 altsetting 0 bulk
endpoint 0x81 has invalid maxpacket 64
[ 1056.136501] usb 1-6: config 1 interface 0 altsetting 1 bulk
endpoint 0x1 has invalid maxpacket 64
[ 1056.136508] usb 1-6: config 1 interface 0 altsetting 1 bulk
endpoint 0x81 has invalid maxpacket 64
[ 1056.137448] dvb-usb: found a 'Anysee DVB USB2.0' in warm state.
[ 1056.137553] dvb-usb: will pass the complete MPEG2 transport stream
to the software demuxer.
[ 1056.137559] dvb-usb: will pass the complete MPEG2 transport stream
to the software demuxer.
[ 1056.137882] DVB: registering new adapter (Anysee DVB USB2.0)
[ 1056.141938] anysee: firmware version:1.3 hardware id:11
[ 1056.145212] Invalid probe, probably not a CX24116 device
[ 1056.145231] anysee: Unsupported Anysee version. Please report the
<linux-media@vger.kernel.org>.
[ 1056.145239] dvb-usb: no frontend was attached by 'Anysee DVB USB2.0'
[ 1056.145473] Registered IR keymap rc-anysee
[ 1056.145709] input: IR-receiver inside an USB DVB receiver as
/devices/pci0000:00/0000:00:1d.7/usb1/1-6/rc/rc1/input15
[ 1056.145858] rc1: IR-receiver inside an USB DVB receiver as
/devices/pci0000:00/0000:00:1d.7/usb1/1-6/rc/rc1
[ 1056.145866] dvb-usb: schedule remote query interval to 250 msecs.
[ 1056.145873] dvb-usb: Anysee DVB USB2.0 successfully initialized and
connected.

On Tue, Dec 20, 2011 at 5:07 AM, Antti Palosaari <crope@iki.fi> wrote:
> On 12/20/2011 03:04 AM, Jesper Krogh wrote:
>>
>> Hi
>>
>> I have a brand new Anysee E30 S2 plus, but with most recent
>> media_build.git - it is reported as the wrong model.
>>
>> I have attached a copy of my lsusb output.
>
>
> That don't help at all. You should look from system log what it says. Use
> dmesg command for that.
>
>
> Antti
>
>
> --
> http://palosaari.fi/
