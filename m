Return-path: <linux-media-owner@vger.kernel.org>
Received: from v-smtpgw1.han.skanova.net ([81.236.60.204]:40783 "EHLO
        v-smtpgw1.han.skanova.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725828AbeKOC0J (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 14 Nov 2018 21:26:09 -0500
Subject: Re: cec kernel oops with pulse8 usb cec adapter
To: Hans Verkuil <hverkuil@xs4all.nl>, Sean Young <sean@mess.org>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
References: <b067e063-641c-0498-4989-3edda5296f9a@mbox200.swipnet.se>
 <e2bb2b91-861b-8cdc-4ad4-939e50019214@xs4all.nl>
 <20181022085910.2gndxc75zcqkto5z@gofer.mess.org>
 <0574214e-3172-717f-bfa8-f9da7a370942@mbox200.swipnet.se>
 <45f7afaa-21a0-a1e8-61e9-b359226f0e8f@xs4all.nl>
From: Torbjorn Jansson <torbjorn.jansson@mbox200.swipnet.se>
Message-ID: <12693d8e-f65b-aa96-ba31-e7820d4f0bae@mbox200.swipnet.se>
Date: Wed, 14 Nov 2018 17:22:13 +0100
MIME-Version: 1.0
In-Reply-To: <45f7afaa-21a0-a1e8-61e9-b359226f0e8f@xs4all.nl>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 2018-11-14 14:23, Hans Verkuil wrote:
> On 11/14/18 14:00, Torbjorn Jansson wrote:
> 
> <snip>
> 
>> since there now is a patch that appears to be working and fixing this problem
>> i'd like to ask for some troubleshooting advice with another cec issue i have
>> that i haven't figured out why it is happening and exactly whats causing it.
>>
>> i'm not sure if it is a hardware issue or a software issue or both.
>>
>> this is what is happening:
>> i have a script that polls the tv for current status by running:
>> cec-ctl --to=0 --give-device-power-status
>> after a fresh reboot this works fine for a while then sometime later it stops
>> working and errors with:
>> -
>> # cec-ctl --to=0 --give-device-power-status
>> Driver Info:
>>           Driver Name                : pulse8-cec
>>           Adapter Name               : serio0
>>           Capabilities               : 0x0000003f
>>                   Physical Address
>>                   Logical Addresses
>>                   Transmit
>>                   Passthrough
>>                   Remote Control Support
>>                   Monitor All
>>           Driver version             : 4.18.16
>>           Available Logical Addresses: 1
>>           Physical Address           : 1.4.0.0
>>           Logical Address Mask       : 0x0800
>>           CEC Version                : 2.0
>>           Vendor ID                  : 0x000c03
>>           Logical Addresses          : 1 (Allow RC Passthrough)
>>
>>             Logical Address          : 11 (Playback Device 3)
>>               Primary Device Type    : Playback
>>               Logical Address Type   : Playback
>>               All Device Types       : Playback
>>               RC TV Profile          : None
>>               Device Features        :
>>                   None
>>
>>
>> Transmit from Playback Device 3 to TV (11 to 0):
>> CEC_MSG_GIVE_DEVICE_POWER_STATUS (0x8f)
>>           Sequence: 119437 Tx Timestamp: 865389.535s
>>           Tx, Error (1), Max Retries
>> -
>>
>> once this happens i can never get back any status and also running:
>> cec-ctl -M
>> gives me a lot of:
>> Transmitted by Playback Device 3 to TV (11 to 0):
>> CEC_MSG_GIVE_DEVICE_POWER_STATUS (0x8f)
>>           Tx, Error (1), Max Retries
>> once for every run of my status checking script.
>>
>> i know polling like this is not the best option and a better way would be to
>> listen for events and then take action when status changes but that's not
>> easily doable with what i need it for.
>>
>> anyway, once i start getting the above errors when i poll it will not give me
>> back any good status any more (everything errors out)
>>
>> also sending commands to tv to turn on or off like:
>> cec-ctl --to=0 --image-view-on
>> or
>> cec-ctl --to=0 --standby
>> doesn't work.
>>
>> BUT if i remove power to tv and wait for standby led to go out completely then
>> power it back on i can use above two commands to turn on/off the tv even when
>> they return errors and i still can't poll for current status.
>>
>> so even with the errors always returned at this stage the on/off commands still
>> gets sent and works.
>>
>> do you think this behavior is a sw or hw issue or both?
> 
> Does 'cec-ctl --to=0 --give-device-power-status' eventually fail even if the TV is
> on all the time? Or does it only fail if the TV goes to standby or has been in
> standby for a very long time?
> 

good question, tv will go to standby by itself after some time and i can't have 
the tv turned on for a few days in a row (not practical).
my gut feeling is that it happens after being in standby for a long time.
it may work fine for a day or two then it fails.

> This error ('Tx, Error (1), Max Retries') indicates that the pulse-eight returns
> transmit errors suggesting that the CEC line is locked (always high or low).
> 

I did some more testing and i was able to somehow trigger the error state by 
having one cec-ctl -M and one cec-ctl -S going at the same time but this is not 
consistent (tested several times and was only able to get it to fail like this 
once)
Also i tested to pull hdmi cable from tv when in error state and see if i could 
reach other devices, tested with cec-ctl -S and it did display a some of my 
other hdmi devices like amp & bd player.

So i guess my tv is to blame for locking up cec.
Maybe i'll just schedule something to cut power completely to tv during night 
for a few hours.


>>
>>
>> if i'm not mistaken i could unplug usb cable to pulse8 cec adapter and reinsert
>> to make it work properly again (no errors and correct response like a fresh start)
>> but i'm not 100% sure of this.
>> when i tried it now i get a new kernel oops:
>> -
>> [866129.392139] usb 7-2: USB disconnect, device number 3
>> [866129.409568] cdc_acm 7-2:1.1: acm_start_wb - usb_submit_urb(write bulk)
>> failed: -19
>> [866129.409576] cdc_acm 7-2:1.1: acm_start_wb - usb_submit_urb(write bulk)
>> failed: -19
>> [866129.409635] WARNING: CPU: 10 PID: 1571 at drivers/media/cec/cec-adap.c:1243
> 
> Not a kernel oops, just a warning. The pulse-eight driver has a small bug
> that causes this warning, but it does not affect the CEC behavior in any way.
> 
> I'll post a patch.
> 

Ok so nothing to worry about then.
