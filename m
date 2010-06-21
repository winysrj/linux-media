Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:63273 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757415Ab0FUSoM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 21 Jun 2010 14:44:12 -0400
Received: by vws3 with SMTP id 3so1363915vws.19
        for <linux-media@vger.kernel.org>; Mon, 21 Jun 2010 11:44:11 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4C1FADF3.8040301@ventoso.org>
References: <AANLkTimtPb6A5Cd6mB2z3S5U2uZy0l4fkbVyyL3njizs@mail.gmail.com>
	<4C1F0DDC.4070307@ventoso.org>
	<AANLkTimnh1hG27aEdqktSHfXbIEOmirlG9ZJXDpVBQQQ@mail.gmail.com>
	<4C1FADF3.8040301@ventoso.org>
Date: Mon, 21 Jun 2010 14:44:10 -0400
Message-ID: <AANLkTik5CucpRF2sBRMZEBruww7UEUX-u1bpZ0VSHzIM@mail.gmail.com>
Subject: Re: [PATCH] af9005: use generic_bulk_ctrl_endpoint_response
From: Michael Krufky <mkrufky@kernellabs.com>
To: Luca Olivetti <luca@ventoso.org>
Cc: linux-media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Jun 21, 2010 at 2:22 PM, Luca Olivetti <luca@ventoso.org> wrote:
> Al 21/06/10 17:45, En/na Michael Krufky ha escrit:
>>
>> On Mon, Jun 21, 2010 at 2:59 AM, Luca Olivetti<luca@ventoso.org>  wrote:
>>>
>>> En/na Michael Krufky ha escrit:
>>>>
>>>> Could somebody please test this patch and confirm that it doesn't
>>>> break the af9005 support?
>>>>
>>>> This patch removes the af9005_usb_generic_rw function and uses the
>>>> dvb_usb_generic_rw function instead, using
>>>> generic_bulk_ctrl_endpoint_response to differentiate between the read
>>>> pipe and the write pipe.
>>>
>>> Unfortunately I cannot test it (my device is broken)[*].
>>> At the time I wrote my own rw function because I didn't find a way to
>>> send
>>> on a bulk endpoint and receiving on another one (i.e. I didn't know about
>>> generic_bulk_ctrl_endpoint/generic_bulk_ctrl_endpoint_response or they
>>> weren't available at the time).
>>>
>>> [*]Actually the tuner is broken, but the usb is working fine, so maybe I
>>> can
>>> give it a try.
>>
>>
>> Luca,
>>
>> That's OK -- I only added this "generic_bulk_ctrl_endpoint_response"
>> feature 4 months ago -- your driver predates that.  I am pushing this
>> patch to reduce the size of the kernel while using your driver to
>> demonstrate how to use the new feature.  I am already using it in an
>> out of tree driver that I plan to merge within the next few months or
>> so, but its always nice to optimize code that already exists with
>> small cleanups like this.
>>
>> You don't need the tuner in order to prove the patch -- if you can
>> simply confirm that you are able to both read and write successfully,
>> that would be enough to prove the patch.  After testing, please
>> provide an ack in this thread so that I may include that with my pull
>> request.
>
> I cloned your hg tree and had to modify a couple of #if otherwise it
> wouldn't compile (it choked on dvb_class->nodename and dvb_class->devnode),
> after that it built fine and apparently the usb communication still works:
>
> usb 8-2: new full speed USB device using uhci_hcd and address 2
> usb 8-2: New USB device found, idVendor=15a4, idProduct=9020
> usb 8-2: New USB device strings: Mfr=1, Product=2, SerialNumber=0
> usb 8-2: Product: DVBT
> usb 8-2: Manufacturer: Afatech
> usb 8-2: configuration #1 chosen from 1 choice
> dvb-usb: found a 'Afatech DVB-T USB1.1 stick' in cold state, will try to
> load a firmware
> usb 8-2: firmware: requesting af9005.fw
> dvb-usb: downloading firmware from file 'af9005.fw'
> dvb-usb: found a 'Afatech DVB-T USB1.1 stick' in warm state.
> dvb-usb: will use the device's hardware PID filter (table count: 32).
> DVB: registering new adapter (Afatech DVB-T USB1.1 stick)
> DVB: registering adapter 0 frontend 0 (AF9005 USB DVB-T)...
> input: IR-receiver inside an USB DVB receiver as
> /devices/pci0000:00/0000:00:1d.2/usb8/8-2/input/input12
> dvb-usb: schedule remote query interval to 200 msecs.
> dvb-usb: Afatech DVB-T USB1.1 stick successfully initialized and connected.
> MT2060: successfully identified (IF1 = 1224)
>
> Acked-by: Luca Olivetti <luca@ventoso.org>
>
> Bye
> --
> Luca

Thank you, Luca -- I'll add your ack now and send off a pull request.

Cheers,.

Mike Krufky
