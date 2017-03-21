Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pg0-f44.google.com ([74.125.83.44]:36520 "EHLO
        mail-pg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756464AbdCURo7 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 21 Mar 2017 13:44:59 -0400
Received: by mail-pg0-f44.google.com with SMTP id g2so96601453pge.3
        for <linux-media@vger.kernel.org>; Tue, 21 Mar 2017 10:44:24 -0700 (PDT)
Subject: Re: CEC button pass-through
To: Hans Verkuil <hverkuil@xs4all.nl>
References: <22e92133-6a64-ffaf-a41f-5ae9b19f24e5@nelint.com>
 <53fd17db-af5d-335b-0337-e5aeffd12305@xs4all.nl>
Cc: linux-media@vger.kernel.org
From: Eric Nelson <eric@nelint.com>
Message-ID: <7ad3b464-1813-5535-fffc-36589d72d86d@nelint.com>
Date: Tue, 21 Mar 2017 10:44:22 -0700
MIME-Version: 1.0
In-Reply-To: <53fd17db-af5d-335b-0337-e5aeffd12305@xs4all.nl>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On 03/21/2017 10:05 AM, Hans Verkuil wrote:
> On 03/21/2017 05:49 PM, Eric Nelson wrote:
>> Hi Hans,
>>
>> Thanks to your work and those of Russell King, I have an i.MX6
>> board up and running with the new CEC API, but I'm having
>> trouble with a couple of sets of remote control keys.
> 
> What is your exact setup? Your i.MX6 is hooked up to a TV? And you
> use the TV's remote control?
> 

Exactly. Custom i.MX6 board with a Samsung television and remote.

>> In particular, the directional keys 0x01-0x04 (Up..Right)
>> and the function keys 0x71-0x74 (F1-F4) don't appear
>> to be forwarded.
>>
>> Running cec-ctl with the "-m" or "-M" options shows that they're
>> simply not being received.
> 
> Other keys appear fine with cec-ctl -M?
> 

Yes. Most keys are working fine.

> Try to select CEC version 1.4 (use option --cec-version-1.4).
> 

Same result. I'm seeing most keys, including number keys:

Received from TV to Recording Device 1 (0 to 1):
CEC_MSG_USER_CONTROL_PRESSED (0x44):
ui-cmd: Number 1 (0x21)
Raw: 01 44 21
Received from TV to Recording Device 1 (0 to 1):
CEC_MSG_USER_CONTROL_RELEASED (0x45)
Raw: 01 45

But nothing from either the arrow or function keys.

> With CEC 2.0 you can set various RC profiles, and (very unlikely) perhaps
> your TV actually understands that.
> 
> The default CEC version cec-ctl selects is 2.0.
> 
> Note that the CEC framework doesn't do anything with the RC profiles
> at the moment.
> 

I don't have the 2.0 spec, so I'm not sure what messages to look for
in the logs from libCEC.

I have a complete log file here, and it shows messages to and from
the television, though in a pretty verbose form.

http://pastebin.com/qFrhkNZQ

>>
>> I'm not sure if I'm missing a flag somewhere to tell my television
>> that we support these keys, or if I'm missing something else.
>>
>> I'm using the --record option at the moment. Using --playback
>> seems to restrict the keys to an even smaller set (seems to
>> block numeric keys).
>>
>> Do you have any guidance about how to trace this?
> 
> cec-ctl -M monitors all messages, so it is weird you don't see them.
> 

Yep. Weird.
