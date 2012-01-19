Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:19829 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750848Ab2ASLRL (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 19 Jan 2012 06:17:11 -0500
Message-ID: <4F17FBB1.20608@redhat.com>
Date: Thu, 19 Jan 2012 09:17:05 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Patrick Boettcher <pboettcher@kernellabs.com>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH 2/2] [media] dvb_frontend: Require FE_HAS_PARAMETERS for
 get_frontend()
References: <201201181450.14089.pboettcher@kernellabs.com> <1326909085-14256-1-git-send-email-mchehab@redhat.com> <1326909085-14256-2-git-send-email-mchehab@redhat.com> <201201191107.25039.pboettcher@kernellabs.com>
In-Reply-To: <201201191107.25039.pboettcher@kernellabs.com>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 19-01-2012 08:07, Patrick Boettcher escreveu:
> Hi Mauro,
> 
> On Wednesday 18 January 2012 18:51:25 Mauro Carvalho Chehab wrote:
>> Calling get_frontend() before having either the frontend locked
>> or the network signaling carriers locked won't work. So, block
>> it at the DVB core.
> 
> I like the idea and also the implementation.
> 
> But before merging this needs more comments from other on the list. 

Agreed.

> Even though it does not break anything for any current frontend-driver 
> it is important to have a wider base agreeing on that. Especially from 
> some other frontend-driver-writers.
> 
> For example I could imagine that a frontend HAS_LOCK, but is still not 
> able to report the parameters (USB-firmware-based frontends might be 
> poorly implemented). 

Yes, I understand. The description for "HAS_LOCK" is currently too generic,
as it says "everything" is locked. If HAS_PARAMETERS can happen after that, 
then the description for HAS_LOCK need to be changed to something like:

	"Indicates that the frontend is ready to tune and zap into a channel.
	 Note: The network detected parameters might not yet be locked. Please
	 see FE_HAS_PARAMETERS if you need to call FE_GET_FRONTEND/FE_GET_PROPERTY."

A change like that could speed up zapping, as, for zap, HAS_PARAMETERS is not
needed.

Looking inside the ISDB-T devices:

In the specific case of mb86a20s (an ISDB-T frontend), the locks are inside
a state machine. After the frame sync (state 7), it tests for TMCC. After TMCC 
is locked (state 8), it waits for a while to rise the TS output lock (state 9). 

So, at least on devices based on it, HAS_PARAMETERS will always happen before
HAS_LOCK.

At the Siano driver, the firmware API has only two lock's: RF and Demod. 
The Demod lock probably means both HAS_PARAMETERS and HAS_LOCK. So, Demod
lock will probably mean HAS_PARAMETERS | HAS_LOCK. Interesting enough, with
Siano, one frontend call will return the entire TMCC table, plus the per-layer
frontend statistics, including a measure for the TMCC carrier errors.

At dib8000, the locks seem to be independent, but maybe there are some hardware
requirements that require TMCC demod to happen, before rising the TS locks, 
but you're the one that knows most about DibCom drivers ;)

>>@@ -207,8 +202,12 @@ static void dvb_frontend_add_event(struct dvb_frontend *fe, fe_status_t status)
>>  
>>  	dprintk ("%s\n", __func__);
>>  
>> -	if ((status & FE_HAS_LOCK) && has_get_frontend(fe))
>> -		dtv_get_frontend(fe, &fepriv->parameters_out);
>> +	/* FE_HAS_LOCK implies that the frontend has parameters */
>> +	if (status & FE_HAS_LOCK)
>> +		status |= FE_HAS_PARAMETERS;
>> +

The above code should be replaced by pushing the FE_HAS_PARAMETERS
lock flag into the frontends that implement get_frontend().
This way, each lock can be independently implemented. Also,
by not rising it on devices that don't implement get_frontend()
will allow scan tools to decide to not rely on the demod to
retrieve the network parameters.

I didn't write such patch because I was too lazy ;) Seriously,
It is better to do push that flag to the drivers on a separate
patch, as it would be easier for review. I'll only write such
thing after having some discussions about that. Writing such
patch will give the opportunity to review each driver's logic
and put FE_HAS_PARAMETERS into the right place.

> 
> And so on...
> 
> regards,
> 
> --
> Patrick Boettcher
> 
> Kernel Labs Inc.
> http://www.kernellabs.com/
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

