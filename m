Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud2.xs4all.net ([194.109.24.29]:41623 "EHLO
	lb3-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751254AbcGLJeY (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 12 Jul 2016 05:34:24 -0400
Subject: Re: [PATCHv2 3/5] pulse8-cec: new driver for the Pulse-Eight USB-CEC
 Adapter
To: Lars Op den Kamp <lars@opdenkamp.eu>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
References: <fd21234a-3ac4-44f5-1054-3430546596bb@xs4all.nl>
 <578369C5.5000402@opdenkamp.eu>
 <8e011716-5d38-3475-ff87-1737b331e26c@xs4all.nl>
 <5783722B.1080107@opdenkamp.eu>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <5784B997.2070100@xs4all.nl>
Date: Tue, 12 Jul 2016 11:34:15 +0200
MIME-Version: 1.0
In-Reply-To: <5783722B.1080107@opdenkamp.eu>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 07/11/16 12:17, Lars Op den Kamp wrote:
> Hi Hans,
> 
> On 11-07-16 12:02, Hans Verkuil wrote:
>> Hi Lars,
>>
>> On 07/11/2016 11:41 AM, Lars Op den Kamp wrote:
>>> Hi Hans,
>>>
>>> just did a quick scan of this patch.
>>>
>>> The code should work on any firmware >= v2 revision 8, though older
>>> versions may return 0 when the build date is requested. I believe I
>>> added that in v3. Might want to add a !=0 check before writing to the log.
>>>
>>> The CEC adapter has an "autonomous mode", used when it's not being
>>> controlled by our userspace application or this kernel driver. It'll
>>> respond to some basic CEC commands that allow the PC to be woken up by TV.
>>> If the adapter doesn't receive a MSGCODE_PING for 30 seconds when it's
>>> in "controlled mode", then it'll revert to autonomous mode and it'll
>>> reset all states internally.
>> Ah, that was rather obscure. Good to know.
>>
>> What I do now (and that seems to work) is that in the pulse8_setup I turn
>> off the autonomous mode and then write that new setting to the EEPROM. After
>> that it looks like the autonomous mode stays off. Is that correct?
> Correct, that'll work too, but I suggest you don't do that and update the eeprom values like we do in userspace. That'll allow the adapter to wake up the PC when the kernel module isn't running. Disabling autonomous mode will prevent that from working. You can only write to the eeprom once every 10 seconds by the way.
> 
>>
>> The autonomous mode really doesn't work well with the framework as it is
>> today.
>>
>> CEC framework support for 'wakeup on CEC command' is something that is planned
>> for the future.
> The autonomous mode is only really meant for waking up the PC, from S3 with the USB version and all modes with the internal version for Intel boards. It should be disabled as long as the userspace application or kernel module is running, by sending MSGCODE_SET_CONTROLLED 1 and then send a poll before the 30 second timeout times out. Then, when the kernel module stops using the module, when the system powers off or goes to standby, you send a MSGCODE_SET_CONTROLLED 0 and then close the connection. The adapter will then take over, allowing the TV to wake up the PC again.

Thank you for the information, very useful.

I've added this to the TODO file of the driver. I have made a pull request for
the driver in the current state. It will be in drivers/staging anyway, so it
doesn't have to be perfect initially. But it is very useful to 'show off' the
new API for kernel 4.8.

I'll work more on this driver so by the time it can be moved out of staging
it should have all this functionality built-in.

Regards,

	Hans
