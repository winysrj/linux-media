Return-path: <mchehab@pedra>
Received: from ams-iport-2.cisco.com ([144.254.224.141]:60124 "EHLO
	ams-iport-2.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753687Ab1CNIIN (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 14 Mar 2011 04:08:13 -0400
Message-ID: <4D7DCCEB.9090106@cisco.com>
Date: Mon, 14 Mar 2011 09:08:11 +0100
From: "Martin Bugge (marbugge)" <marbugge@cisco.com>
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Daniel_Gl=F6ckner?= <daniel-gl@gmx.net>
CC: Hans Verkuil <hans.verkuil@cisco.com>, linux-media@vger.kernel.org
Subject: Re: [RFC] HDMI-CEC proposal, ver 2
References: <4D7A0929.6080705@cisco.com> <20110312004247.GA1397@minime.bse>
In-Reply-To: <20110312004247.GA1397@minime.bse>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Daniel and thank you,

On 03/12/2011 01:42 AM, Daniel Glöckner wrote:
> Hi Martin,
>
> On Fri, Mar 11, 2011 at 12:36:09PM +0100, Martin Bugge (marbugge) wrote:
>    
>> Not every tx status is applicable for all modes, see table 1.
>>
>> |-----------------------------------------------------|
>> |    Av link Mode     |  CEC  |   1   |   2   |   3   |
>> |-----------------------------------------------------|
>> |      Status         |       |       |       |       |
>> |-----------------------------------------------------|
>> |      TX_OK          |   a   |  n/a  |   a   |  n/a  |
>> |-----------------------------------------------------|
>> |  TX_ARB_LOST        |   a   |  n/a  |   a   |   a   |
>> |-----------------------------------------------------|
>> | TX_RETRY_TIMEOUT    |   a   |  n/a  |   a   |   a   |
>> |-----------------------------------------------------|
>> | TX_BROADCAST_REJECT |   a   |  n/a  |   a   |  n/a  |
>> |-----------------------------------------------------|
>>      
> TX_ARB_LOST is applicable to mode 1.
> Arbitration loss will also be caused by receivers detecting a bad pulse.
>
>    
You are correct, a typo.
However, it looks like also TX_OK will be used for Mode 3.
And maybe also TX_BROADCAST_REJECT.
In particular with reference to your link in below.
>> * AV link mode 1:
>>       In mode 1 the frame length is fixed to 21 bits (including the
>>       start sequence).
>>       Some of these bits (Qty 1 - 6) can be arbitrated by the
>>       receiver to signal supported formats/standards.
>>       conf:
>>           enable: true/false
>>           upstream_Qty: QTY bits 1-6
>>           downstream_Qty: QTY bits 1-6
>>               |------------------------------------------------|
>>               | Bits:     | 31 - 7 | 6 | 5 | 4 | 3 | 2 | 1 | 0 |
>>               |------------------------------------------------|
>>               | Qty bits  |   x    | x | 6 | 5 | 4 | 3 | 2 | 1 |
>>               |------------------------------------------------|
>>               Qty bits 1-6 mapping (x: not used)
>>      
> If the Linux system is a video source, it must stop arbitrating those
> Qty bits as soon as another video source wants to become active.
> As this includes the message where the new source announces itself,
> this can't be handled by reconfiguration after reception of the message.
>
> If the Linux system is a video sink, the announcement of a new source
> should not affect the Qty bits to arbitrate.
>
> And don't get me startet about systems capable of being a video source
> and sink at the same time, capturing their own signal until a new source
> becomes active...
>
>    
I assume this must be handled by logic in the driver if it supports this 
mode.
>> * AV link mode 1:
>>       Frame received/transmitted:
>>       head:
>>           |-------------------------------------------------|
>>           | Bits:       | 31 - 4 |  3  |   2  |   1  |  0   |
>>           |-------------------------------------------------|
>>           | head bits:  |    x   | DIR | /PAS | /NAS | /DES |
>>           |-------------------------------------------------|
>>       Qty: Quality bits 1 - 16;
>>           |---------------------------------------|
>>           | Bits:     | 31 - 16 | 15 | 14 - 1 | 0 |
>>           |---------------------------------------|
>>           | Qty bits  |    x    | 16 | 15 - 2 | 1 |
>>           |---------------------------------------|
>>           x: not used
>>      
> Is Qty-1 or Qty-16 the bit sent after /DES?
>
>    
Even though I find it a bit confusing in the standard, the plan
was to send Qty-1 just after the /DES bit.

It was an attempt to make the configuration and status the same.
Such that we could use the same bit masks.

>>       In blocking mode only:
>>          tx_status: tx status.
>>          tx_status_Qty: which Qty bits 1 - 6 bits was arbitrated
>>          during transmit.
>>      
> It may be interesting to know what other devices did to the /PAS and
> /DES bits when they were sent as 1.
>    

Maybe I should change this such that we actually send up the whole frame 
as tx_status.
In that way we will avoid the confusion of the Qty bit orders also.

But then this should apply to the configuration as well.

>    
>> * AV link mode 3: TBD. Chances are that nobody ever used this
>>       len: length of message in bits, maximum 96 bits.
>>       msg: the raw message received/transmitted. (without the start
>>       sequence).
>>       tx_status: tx status in blocking mode.
>>      
> Google turned up this:
> http://fmt.cs.utwente.nl/publications/files/111_heerink.pdf
> It suggests that at least Philips' variant of AV.link mode 3 - EasyLink -
> is even closer to CEC than mode 2.
>
>    
Yes I see that. However CEC don't have the start sequence (to 
differenciate between mode 1 - 3),
and the application id.
In addition can't I see that mode 3 describe the ACK and EOM bits.
It might be difficult to "force" easylink into the mode 3 as it is.

If we could use the application id it might be possible for the driver to
change behaviour.

Or we will end up with
#define AV_LINK_CAP_MODE_EASY_LINK   (1 << 4)
And so on, which might be ok also.

>    Daniel
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>    

Martin

