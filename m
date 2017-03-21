Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud3.xs4all.net ([194.109.24.22]:57908 "EHLO
        lb1-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S933051AbdCUSqm (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 21 Mar 2017 14:46:42 -0400
Subject: Re: CEC button pass-through
To: Eric Nelson <eric@nelint.com>
References: <22e92133-6a64-ffaf-a41f-5ae9b19f24e5@nelint.com>
 <53fd17db-af5d-335b-0337-e5aeffd12305@xs4all.nl>
 <7ad3b464-1813-5535-fffc-36589d72d86d@nelint.com>
 <67b5e8a1-8a79-27e2-8e5f-1c58a4adc0d8@nelint.com>
Cc: linux-media@vger.kernel.org
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <4cacc06e-8573-53fc-39a9-551b426fdcfb@xs4all.nl>
Date: Tue, 21 Mar 2017 19:46:36 +0100
MIME-Version: 1.0
In-Reply-To: <67b5e8a1-8a79-27e2-8e5f-1c58a4adc0d8@nelint.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 03/21/2017 07:23 PM, Eric Nelson wrote:
> Hi Hans,
> 
> On 03/21/2017 10:44 AM, Eric Nelson wrote:
>> On 03/21/2017 10:05 AM, Hans Verkuil wrote:
>>> On 03/21/2017 05:49 PM, Eric Nelson wrote:
> 
> <snip>
> 
>>> With CEC 2.0 you can set various RC profiles, and (very unlikely) perhaps
>>> your TV actually understands that.
>>>
>>> The default CEC version cec-ctl selects is 2.0.
>>>
>>> Note that the CEC framework doesn't do anything with the RC profiles
>>> at the moment.
>>>
>>
>> I don't have the 2.0 spec, so I'm not sure what messages to look for
>> in the logs from libCEC.
>>
>> I have a complete log file here, and it shows messages to and from
>> the television, though in a pretty verbose form.
>>
>> http://pastebin.com/qFrhkNZQ
>>
> 
> I think this is the culprit:
> cec-uinput: L8: << 10:8e:00
> 
> 
> The 1.3 spec says this about the 8E message:
> 
> "If Menu State indicates activated, TV enters ‘Device Menu Active’
> state and forwards those Remote control commands, shown in
> Table 26, to the initiator. If deactivated, TV enters ‘Device Menu Inactive’
> state and stops forwarding remote control commands".
> 
> In section 13.12.2, it also says this:
> 
> "The TV may initiate a device’s menu by sending a <Menu Request>
> [“Activate”] command. It may subsequently remove the menu by sending
> a <Menu Request> [“Deactivate”] message. The TV may also query a
> devices menu status by sending a <Menu Request> [“Query”]. The
> menu device shall always respond with a <Menu Status> command
> when it receives a <Menu Request>."
> 

That sounds plausible. When you tested with my CEC framework, did you also
run the cec-follower utility? That emulates a CEC follower.

Note: you really need to use the --cec-version-1.4 option when configuring
the i.MX6 CEC adapter since support for <Menu Request> is only enabled with
CEC version 1.4. It is no longer supported with 2.0.

Regards,

	Hans
