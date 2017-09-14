Return-path: <linux-media-owner@vger.kernel.org>
Received: from aer-iport-1.cisco.com ([173.38.203.51]:60306 "EHLO
        aer-iport-1.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751277AbdINNKL (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 14 Sep 2017 09:10:11 -0400
Subject: Re: [PATCH] [media] cec: GIVE_PHYSICAL_ADDR should respond to
 unregistered device
To: Jose Abreu <Jose.Abreu@synopsys.com>, linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>,
        Joao Pinto <Joao.Pinto@synopsys.com>
References: <73019b13e5e8d727c37ec1b99f2e746aad0a7153.1505388690.git.joabreu@synopsys.com>
From: Hans Verkuil <hansverk@cisco.com>
Message-ID: <dfaad7d7-883f-38b4-d685-610ee0ce88b9@cisco.com>
Date: Thu, 14 Sep 2017 15:10:09 +0200
MIME-Version: 1.0
In-Reply-To: <73019b13e5e8d727c37ec1b99f2e746aad0a7153.1505388690.git.joabreu@synopsys.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 09/14/17 13:33, Jose Abreu wrote:
> Running CEC 1.4 compliance test we get the following error on test
> 11.1.6.2: "ERROR: The DUT did not broadcast a
> <Report Physical Address> message to the unregistered device."
> 
> Fix this by letting GIVE_PHYSICAL_ADDR message respond to unregistered
> device.
> 
> With this fix we pass CEC 1.4 official compliance.
> 
> Signed-off-by: Jose Abreu <joabreu@synopsys.com>
> Cc: Hans Verkuil <hans.verkuil@cisco.com>
> Cc: Joao Pinto <jpinto@synopsys.com>
> ---
>  drivers/media/cec/cec-adap.c | 7 +++++--
>  1 file changed, 5 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/media/cec/cec-adap.c b/drivers/media/cec/cec-adap.c
> index dd769e4..48482aa 100644
> --- a/drivers/media/cec/cec-adap.c
> +++ b/drivers/media/cec/cec-adap.c
> @@ -1797,9 +1797,12 @@ static int cec_receive_notify(struct cec_adapter *adap, struct cec_msg *msg,
>  	case CEC_MSG_GIVE_DEVICE_VENDOR_ID:
>  	case CEC_MSG_ABORT:
>  	case CEC_MSG_GIVE_DEVICE_POWER_STATUS:
> -	case CEC_MSG_GIVE_PHYSICAL_ADDR:
>  	case CEC_MSG_GIVE_OSD_NAME:
>  	case CEC_MSG_GIVE_FEATURES:
> +		if (from_unregistered)

This should be (!adap->passthrough && from_unregistered)

> +			return 0;

Actually, CEC_MSG_GIVE_DEVICE_VENDOR_ID and CEC_MSG_GIVE_FEATURES
fall in the same category as CEC_MSG_GIVE_PHYSICAL_ADDR. I.e. these are
directed messages but the reply is a broadcast message. All three can be
sent by an unregistered device. It's a good idea to mention this here.
I.e. something like:

		/* These messages reply with a directed message, so ignore if
		   the initiator is Unregistered */

> +		/* Fall through */
> +	case CEC_MSG_GIVE_PHYSICAL_ADDR:
>  		/*
>  		 * Skip processing these messages if the passthrough mode
>  		 * is on.
> @@ -1807,7 +1810,7 @@ static int cec_receive_notify(struct cec_adapter *adap, struct cec_msg *msg,
>  		if (adap->passthrough)
>  			goto skip_processing;
>  		/* Ignore if addressing is wrong */
> -		if (is_broadcast || from_unregistered)
> +		if (is_broadcast)
>  			return 0;
>  		break;
>  
> 

Good catch, if you can make a v2 then I'll get this in for 4.14.

Not bad, just one obscure compliance error!

Regards,

	Hans
