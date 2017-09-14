Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtprelay.synopsys.com ([198.182.60.111]:38747 "EHLO
        smtprelay.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751330AbdINN2z (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 14 Sep 2017 09:28:55 -0400
Subject: Re: [PATCH] [media] cec: GIVE_PHYSICAL_ADDR should respond to
 unregistered device
To: Hans Verkuil <hansverk@cisco.com>,
        Jose Abreu <Jose.Abreu@synopsys.com>,
        <linux-media@vger.kernel.org>
References: <73019b13e5e8d727c37ec1b99f2e746aad0a7153.1505388690.git.joabreu@synopsys.com>
 <dfaad7d7-883f-38b4-d685-610ee0ce88b9@cisco.com>
CC: Hans Verkuil <hans.verkuil@cisco.com>,
        Joao Pinto <Joao.Pinto@synopsys.com>
From: Jose Abreu <Jose.Abreu@synopsys.com>
Message-ID: <ba11c0f5-e9b3-bf24-9a8e-004a7dd5ad88@synopsys.com>
Date: Thu, 14 Sep 2017 14:28:46 +0100
MIME-Version: 1.0
In-Reply-To: <dfaad7d7-883f-38b4-d685-610ee0ce88b9@cisco.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On 14-09-2017 14:10, Hans Verkuil wrote:
> On 09/14/17 13:33, Jose Abreu wrote:
>> Running CEC 1.4 compliance test we get the following error on test
>> 11.1.6.2: "ERROR: The DUT did not broadcast a
>> <Report Physical Address> message to the unregistered device."
>>
>> Fix this by letting GIVE_PHYSICAL_ADDR message respond to unregistered
>> device.
>>
>> With this fix we pass CEC 1.4 official compliance.
>>
>> Signed-off-by: Jose Abreu <joabreu@synopsys.com>
>> Cc: Hans Verkuil <hans.verkuil@cisco.com>
>> Cc: Joao Pinto <jpinto@synopsys.com>
>> ---
>>  drivers/media/cec/cec-adap.c | 7 +++++--
>>  1 file changed, 5 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/media/cec/cec-adap.c b/drivers/media/cec/cec-adap.c
>> index dd769e4..48482aa 100644
>> --- a/drivers/media/cec/cec-adap.c
>> +++ b/drivers/media/cec/cec-adap.c
>> @@ -1797,9 +1797,12 @@ static int cec_receive_notify(struct cec_adapter *adap, struct cec_msg *msg,
>>  	case CEC_MSG_GIVE_DEVICE_VENDOR_ID:
>>  	case CEC_MSG_ABORT:
>>  	case CEC_MSG_GIVE_DEVICE_POWER_STATUS:
>> -	case CEC_MSG_GIVE_PHYSICAL_ADDR:
>>  	case CEC_MSG_GIVE_OSD_NAME:
>>  	case CEC_MSG_GIVE_FEATURES:
>> +		if (from_unregistered)
> This should be (!adap->passthrough && from_unregistered)

Ok.

>
>> +			return 0;
> Actually, CEC_MSG_GIVE_DEVICE_VENDOR_ID and CEC_MSG_GIVE_FEATURES
> fall in the same category as CEC_MSG_GIVE_PHYSICAL_ADDR. I.e. these are
> directed messages but the reply is a broadcast message. All three can be
> sent by an unregistered device. It's a good idea to mention this here.
> I.e. something like:
>
> 		/* These messages reply with a directed message, so ignore if
> 		   the initiator is Unregistered */

Ok, but this comment applies to the remaining msgs, right? I
mean, GIVE_DEVICE_VENDOR_ID, GIVE_FEATURES and GIVE_PHYSICAL_ADDR
will still send a response if initiator is unregistered, correct?

>
>> +		/* Fall through */
>> +	case CEC_MSG_GIVE_PHYSICAL_ADDR:
>>  		/*
>>  		 * Skip processing these messages if the passthrough mode
>>  		 * is on.
>> @@ -1807,7 +1810,7 @@ static int cec_receive_notify(struct cec_adapter *adap, struct cec_msg *msg,
>>  		if (adap->passthrough)
>>  			goto skip_processing;
>>  		/* Ignore if addressing is wrong */
>> -		if (is_broadcast || from_unregistered)
>> +		if (is_broadcast)
>>  			return 0;
>>  		break;
>>  
>>
> Good catch, if you can make a v2 then I'll get this in for 4.14.
>
> Not bad, just one obscure compliance error!

Actually, I have at least one more fix which I don't know if it's
valid and I didn't manage to actually write it in a nice way.
This one is for CEC 2.0. My test equipment (which is certified)
in some tests sends msgs only with the opcode. As the received
msg length does not match the expected one CEC core is rejecting
the message and my compliance test is failling (test is 4.2.3).
Have you run this test? Did it pass?

Best regards,
Jose Miguel Abreu

>
> Regards,
>
> 	Hans
