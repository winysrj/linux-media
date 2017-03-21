Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f179.google.com ([209.85.192.179]:33715 "EHLO
        mail-pf0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1757233AbdCUSXg (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 21 Mar 2017 14:23:36 -0400
Received: by mail-pf0-f179.google.com with SMTP id o190so1494283pfo.0
        for <linux-media@vger.kernel.org>; Tue, 21 Mar 2017 11:23:35 -0700 (PDT)
Subject: Re: CEC button pass-through
To: Hans Verkuil <hverkuil@xs4all.nl>
References: <22e92133-6a64-ffaf-a41f-5ae9b19f24e5@nelint.com>
 <53fd17db-af5d-335b-0337-e5aeffd12305@xs4all.nl>
 <7ad3b464-1813-5535-fffc-36589d72d86d@nelint.com>
Cc: linux-media@vger.kernel.org
From: Eric Nelson <eric@nelint.com>
Message-ID: <67b5e8a1-8a79-27e2-8e5f-1c58a4adc0d8@nelint.com>
Date: Tue, 21 Mar 2017 11:23:33 -0700
MIME-Version: 1.0
In-Reply-To: <7ad3b464-1813-5535-fffc-36589d72d86d@nelint.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On 03/21/2017 10:44 AM, Eric Nelson wrote:
> On 03/21/2017 10:05 AM, Hans Verkuil wrote:
>> On 03/21/2017 05:49 PM, Eric Nelson wrote:

<snip>

>> With CEC 2.0 you can set various RC profiles, and (very unlikely) perhaps
>> your TV actually understands that.
>>
>> The default CEC version cec-ctl selects is 2.0.
>>
>> Note that the CEC framework doesn't do anything with the RC profiles
>> at the moment.
>>
> 
> I don't have the 2.0 spec, so I'm not sure what messages to look for
> in the logs from libCEC.
> 
> I have a complete log file here, and it shows messages to and from
> the television, though in a pretty verbose form.
> 
> http://pastebin.com/qFrhkNZQ
> 

I think this is the culprit:
cec-uinput: L8: << 10:8e:00


The 1.3 spec says this about the 8E message:

"If Menu State indicates activated, TV enters ‘Device Menu Active’
state and forwards those Remote control commands, shown in
Table 26, to the initiator. If deactivated, TV enters ‘Device Menu Inactive’
state and stops forwarding remote control commands".

In section 13.12.2, it also says this:

"The TV may initiate a device’s menu by sending a <Menu Request>
[“Activate”] command. It may subsequently remove the menu by sending
a <Menu Request> [“Deactivate”] message. The TV may also query a
devices menu status by sending a <Menu Request> [“Query”]. The
menu device shall always respond with a <Menu Status> command
when it receives a <Menu Request>."
