Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtprelay.synopsys.com ([198.182.47.9]:49614 "EHLO
        smtprelay.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751131AbdINPad (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 14 Sep 2017 11:30:33 -0400
Subject: Re: [PATCH] [media] cec: GIVE_PHYSICAL_ADDR should respond to
 unregistered device
To: Hans Verkuil <hverkuil@xs4all.nl>,
        Jose Abreu <Jose.Abreu@synopsys.com>,
        <linux-media@vger.kernel.org>
References: <73019b13e5e8d727c37ec1b99f2e746aad0a7153.1505388690.git.joabreu@synopsys.com>
 <dfaad7d7-883f-38b4-d685-610ee0ce88b9@cisco.com>
 <ba11c0f5-e9b3-bf24-9a8e-004a7dd5ad88@synopsys.com>
 <a5966cfe-395f-63e5-83d9-4d02fe3c7225@xs4all.nl>
CC: Hans Verkuil <hans.verkuil@cisco.com>,
        Joao Pinto <Joao.Pinto@synopsys.com>
From: Jose Abreu <Jose.Abreu@synopsys.com>
Message-ID: <3cbebb68-84d5-c1cc-df84-a0ccb8862cce@synopsys.com>
Date: Thu, 14 Sep 2017 16:30:28 +0100
MIME-Version: 1.0
In-Reply-To: <a5966cfe-395f-63e5-83d9-4d02fe3c7225@xs4all.nl>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On 14-09-2017 16:09, Hans Verkuil wrote:
> On 09/14/17 15:28, Jose Abreu wrote:
>
>> Actually, I have at least one more fix which I don't know if it's
>> valid and I didn't manage to actually write it in a nice way.
>> This one is for CEC 2.0. My test equipment (which is certified)
>> in some tests sends msgs only with the opcode. As the received
>> msg length does not match the expected one CEC core is rejecting
>> the message and my compliance test is failling (test is 4.2.3).
> In the HDMI 1.4 spec in CEC 7.3 (Frame Validation) it says that a follower
> should ignore frames that are too small.
>
> At the same time unsupported opcodes should result in a Feature Abort.
>
> If you don't send a properly formed message, then it's not clear to me
> what should happen. Which opcode failed?

Hmm, yeah, the spec confirms. The failing opcodes are the ones
that have arguments, the test equipment is just sending the
header plus opcode. Anyway, for this failing test the MOI for
this equipment is not approved so I will probably carry this fix
only locally and send it upstream only if the MOI gets approved.

>
>> Have you run this test? Did it pass?
> No, we haven't. Never got around to that.

Ok. I can say that CEC 1.4 + CEC 2.0 all pass compliance with
this patch and with my local fix + my test app!

Best regards,
Jose Miguel Abreu

>
> Regards,
>
> 	Hans
>
>> Best regards,
>> Jose Miguel Abreu
>>
>>> Regards,
>>>
>>> 	Hans
