Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f220.google.com ([209.85.220.220]:46516 "EHLO
	mail-fx0-f220.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754697Ab0BATmx (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 1 Feb 2010 14:42:53 -0500
Received: by fxm20 with SMTP id 20so4637957fxm.21
        for <linux-media@vger.kernel.org>; Mon, 01 Feb 2010 11:42:51 -0800 (PST)
Message-ID: <4B672EB8.3010609@suse.cz>
Date: Mon, 01 Feb 2010 20:42:48 +0100
From: Jiri Slaby <jslaby@suse.cz>
MIME-Version: 1.0
To: Jiri Kosina <jkosina@suse.cz>
CC: Pekka Sarnila <pekka.sarnila@qvantel.com>,
	Pekka Sarnila <sarnila@adit.fi>, crope@iki.fi,
	linux-media@vger.kernel.org, pb@linuxtv.org, js@linuxtv.org
Subject: dvb-usb-remote woes [was: HID: ignore afatech 9016]
References: <alpine.LNX.2.00.1001132111570.30977@pobox.suse.cz> <1263415146-26321-1-git-send-email-jslaby@suse.cz> <alpine.LNX.2.00.1001260156010.30977@pobox.suse.cz> <4B5EFD69.4080802@adit.fi> <alpine.LNX.2.00.1001262344200.30977@pobox.suse.cz> <4B671C31.3040902@qvantel.com> <alpine.LNX.2.00.1002011928220.15395@pobox.suse.cz>
In-Reply-To: <alpine.LNX.2.00.1002011928220.15395@pobox.suse.cz>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 02/01/2010 07:28 PM, Jiri Kosina wrote:
> On Mon, 1 Feb 2010, Pekka Sarnila wrote:
>> Well short answer is: No, it does not work.

Hi, thanks for the input.

>> What I did:
>>
>> I pulled few days ago latest
>>
>>    git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux-2.6.git
>>
>> and compiled it. Everything works fine including the tv-stick and the
>> remote. However I get:
>>
>>   <3>af9015: command failed:255
>>   <3>dvb-usb: error while querying for an remote control event.

Yes, I saw this quite recently too. For me it appears when it is booted
up with the stick in. It's still to be fixed.

>> I applied the patch in your mail and recompiled. Remote does not work;
>> af9015.c gets no key presses. Instead that above message still comes.

Yeah, and that's the reason why it doesn't work.

>> Also removing the device or rmmod:ing dvb-usb-af9015.ko causes kernel oops.

Already fixed:
http://patchwork.kernel.org/patch/74095/

>> Analysis:
>>
>> When it works, the remote is recognized by the system as a HID-keyboard,
>> and thus it works as a normal USB-keyboard. dvb-usb-remote.c is not
>> participating at all (though it gives those errors).

Actually it is. But it fails to get status.

>> The remote is visible to the system as a usb interrupt end point.
>> Interrupt endpoint tells the system the polling interval (by endpoint
>> report). From the USB specs on the interval:
>>
>>   The USB System Software will use this information during configuration
>>   to determine a period that can be sustained. The period provided by
>>   the system may be shorter than that desired by the device up to the
>>   shortest period defined by the USB (125 µs microframe or 1 ms frame).
>>   The client software and device can depend only on the fact that the
>>   host will ensure that the time duration between two transaction
>>   attempts with the endpoint will be no longer than the desired period.
>>
>> As I understand it, in plain English it means that the polling interval
>> must not be longer than what the endpoint report says (in case of
>> full-speed endpoint 1 to 255 ms). This device in question, assuming it
>> gives the interval in full-speed mode even it really is high-speed
>> device, gives 16ms interval period.
>>
>> However af9015.c/dvb-usb-remote.c accesses it as if it was a bulk
>> endpoint and with 150ms interval. I did not look further on if this is
>> the only reason or the reason for it not to work. But at least it is in
>> clear contradiction of the USB-specs.

To what statement is it in contradiction? The statement above is for
interrupt transfers.

>> I suspect, to make it work, much of the code from hid-driver should be
>> copied to the device driver.

Which code? I see no code being copied.

>> However I think that would be exactly the
>> wrong way to go. I think the whole idea of making for every device a
>> separated driver ignoring the common code already in the kernel is bad
>> architecture.

Common code does not work well here. Don't you see weird key repetitions
and similar?

>> I have noticed more and more of this type of movement in
>> the driver development resulting the same thing done in hundred
>> different ways when common code could be used. Especially bad I think it
>> is in the cases where universal specification is available (albeit there
>> are many devices that do not follow the usb specs correctly).

In this case I suppose this is why dvb-usb-remote exists.

Maybe it can be handled better by a separate driver (still) as a part of
the HID layer nowadays.

Patrick, Johannes, why was not dvb-usb-remote implemented rather as a
part of the HID layer?

>> Also it is wrong idea that you could/should detect the type of remote
>> controller based on the tv-stick. E.g with Haupauge TV-NOVA nearly any
>> remote works ok (e.g my panasonic tv remote). Every generic ir-receiver
>> sends also the manufacturer and model codes. Remote ir-to-code
>> translates should be based on that (there is a kind of generic layer for
>> that in  linux kernel) and not on the tv-stick model at all (as in the
>> af9015 driver).

Sorry, I don't understand this paragraph. Could you rephrase?

>> BTW I now recall how I got Afateck remote work as should. The driver
>> loads ir-to-code translate table to the stick. I changed the codes to
>> what made more sense.

Why you didn't push this upstream?

>> One problem here is that current HID layer is very sparse in the
>> information it passes on, really only a code. It should also convey the
>> precice id of the device so upper layer would be better able to deal
>> with events. One of my hobbies is flight simulator flying. I use X-plane
>> (excellent program). There is also a linux version. But the linux
>> joystick driver is far from adequate for it (also some joysticks, yokes
>> and pedals or some of their controls didn't work at all). So I use a
>> special kernel for which I rewrote big parts of the HID-driver and
>> input-driver and wrote completely new joystick driver. Now it works
>> quite decently. One problem is the kernel->user joystick driver
>> interface, but it can not be changed since that's what X-plane (and
>> others use). One thing I got to change for that was that HID does less
>> model specific processing and passes more event info to higher layer
>> without breaking the old HID-devices (same with the input layer), so
>> that the joystick layer could do more intelligent processing. I fixed
>> also some bugs and one design omission in the HID driver (e.g. some
>> force feedback joysticks uses that HID-specification, in standard kernel
>> there is some ad-hoc code for that purpose).

Can't be HID bus with a specific driver used instead now?

-- 
js
suse labs
