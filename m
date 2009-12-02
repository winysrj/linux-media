Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ew0-f219.google.com ([209.85.219.219]:60539 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754646AbZLBXIi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 2 Dec 2009 18:08:38 -0500
Received: by ewy19 with SMTP id 19so826302ewy.21
        for <linux-media@vger.kernel.org>; Wed, 02 Dec 2009 15:08:43 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <loom.20091202T230047-299@post.gmane.org>
References: <1259695756.5239.2.camel@desktop>
	 <loom.20091202T230047-299@post.gmane.org>
Date: Wed, 2 Dec 2009 18:08:43 -0500
Message-ID: <37219a840912021508s75535fa6v83006d3bad0c301@mail.gmail.com>
Subject: Re: af9015: tuner id:179 not supported, please report!
From: Michael Krufky <mkrufky@kernellabs.com>
To: Bert Massop <bert.massop@gmail.com>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Dec 2, 2009 at 5:06 PM, Bert Massop <bert.massop@gmail.com> wrote:
> Jan Sundman <jan.sundman <at> aland.net> writes:
>
>>
>> Hi,
>>
>> I just received a usb DVB-T card and have been trying to get it to work
>> under Ubuntu 9.10, but to no avail. dmesg shows the following when
>> plugging in the card:
>>
>> [   35.280024] usb 2-1: new high speed USB device using ehci_hcd and
>> address 4
>> [   35.435978] usb 2-1: configuration #1 chosen from 1 choice
>> [   35.450176] af9015: tuner id:179 not supported, please report!
>> [   35.452891] Afatech DVB-T 2: Fixing fullspeed to highspeed interval:
>> 10 -> 7
>> [   35.453097] input: Afatech DVB-T 2
>> as /devices/pci0000:00/0000:00:13.2/usb2/2-1/2-1:1.1/input/input8
>> [   35.453141] generic-usb 0003:15A4:9016.0005: input,hidraw3: USB HID
>> v1.01 Keyboard [Afatech DVB-T 2] on usb-0000:00:13.2-1/input1
>>
>> lsusb shows:
>> Bus 002 Device 005: ID 15a4:9016
>>
>> and finally lsmod | grep dvb
>> dvb_usb_af9015         37152  0
>> dvb_usb                22892  1 dvb_usb_af9015
>> dvb_core              109716  1 dvb_usb
>>
>> While googling for an answer to my troubles I came across
>> http://ubuntuforums.org/showthread.php?t=606487&page=5 which hints that
>> the card may use the TDA18218HK tuner chip which does not seem to be
>> supported currently.
>>
>> Does anyone have any experience regarding this chip and know what to do
>> to get it working.
>>
>> Best regards,
>>
>> //Jan
>>
>>
>
> Hi Jan,
>
> As stated in the Ubuntuforums thread, there doesn't seem to be any support for
> this chip at the moment. I don't know how hard it is to code support for a
> specific tuner, but I'm looking into that right now.
>
> Hopefully some more experienced coders will join in writing something usable, as
> I don't think I will be able to do it myself.
>
> Please drop a message if anyone finds something useful.
>
> Best regards,
>
> Bert

The TDA18218 is not currently supported under Linux.  I have the
information needed to write a driver to support it, but I do not have
any devices that use it, nor any interest (as of now) to write the
driver on my own time.

For me, it would not be very difficult to get this done, as I have
done work to support a similar family of tuners -- TDA18271 /
TDA18211.  The TDA18218 tuner is not supported by the current driver.

In the past, I would have gone ahead and written a driver for the
sheer enjoyment of doing so... but nowadays, I actually have other
projects of a higher priority that need my attention instead.

If, in the future, any commercial entity has interest in seeing this
tuner silicon supported under Linux, they should contact me -- perhaps
my desire to write this driver can be increased ;-)

Regards,

Mike Krufky
kernellabs.com
