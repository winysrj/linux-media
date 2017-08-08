Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud9.xs4all.net ([194.109.24.30]:41124 "EHLO
        lb3-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750818AbdHHILP (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 8 Aug 2017 04:11:15 -0400
Subject: Re: [PATCH 2/2] cec: fix remote control passthrough
To: Sean Young <sean@mess.org>
References: <20170807133124.30682-1-hverkuil@xs4all.nl>
 <20170807133124.30682-3-hverkuil@xs4all.nl>
 <20170807205803.awtowjuiujlzt3nf@gofer.mess.org>
Cc: linux-media@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <ff2a26c2-d500-f3cb-832f-27939b638b65@xs4all.nl>
Date: Tue, 8 Aug 2017 10:11:13 +0200
MIME-Version: 1.0
In-Reply-To: <20170807205803.awtowjuiujlzt3nf@gofer.mess.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 07/08/17 22:58, Sean Young wrote:
> On Mon, Aug 07, 2017 at 03:31:24PM +0200, Hans Verkuil wrote:
>> From: Hans Verkuil <hans.verkuil@cisco.com>
>>
>> The 'Press and Hold' operation was not correctly implemented, in
>> particular the requirement that the repeat doesn't start until
>> the second identical keypress arrives. The REP_DELAY value also
>> had to be adjusted (see the comment in the code) to achieve the
>> desired behavior.
> 
> I'm afraid I've caused some confusion; I had not read your last message
> about autorepeat on irc correctly, when I said "exactly".
> 
> So if the input layer has not received a key up event after a key down
> event, after REP_DELAY it will generate another key down event every
> REP_PERIOD. So for example, here I'm holding a button on a rc-5 device
> for some time. Comments on lines with parentheses.
> 
> # ir-keytable -t
> Testing events. Please, press CTRL-C to abort.
> 1502138577.703695: event type EV_MSC(0x04): scancode = 0x1e11
> (each time a driver receives something, scancode is reported.)
> 1502138577.703695: event type EV_KEY(0x01) key_down: KEY_VOLUMEDOWN(0x0072)
> 1502138577.703695: event type EV_SYN(0x00).
> 1502138577.817682: event type EV_MSC(0x04): scancode = 0x1e11
> 1502138577.817682: event type EV_SYN(0x00).
> (rc-5 repeats the command after 115ms).
> 1502138577.930676: event type EV_MSC(0x04): scancode = 0x1e11
> 1502138577.930676: event type EV_SYN(0x00).
> 1502138578.044682: event type EV_MSC(0x04): scancode = 0x1e11
> 1502138578.044682: event type EV_SYN(0x00).
> 1502138578.181690: event type EV_MSC(0x04): scancode = 0x1e11
> 1502138578.181690: event type EV_SYN(0x00).
> 1502138578.205667: event type EV_KEY(0x01) key_down: KEY_VOLUMEDOWN(0x0072)
> (this is 500ms after the initial key down, so this key down is generated
> by the input layer).
> 1502138578.205667: event type EV_SYN(0x00).
> 1502138578.333667: event type EV_KEY(0x01) key_down: KEY_VOLUMEDOWN(0x0072)
> (this is 500 + 125 ms, so another key down event generated by input layer).
> 1502138578.333667: event type EV_SYN(0x00).
> 1502138578.437662: event type EV_KEY(0x01) key_up: KEY_VOLUMEDOWN(0x0072)
> 1502138578.437662: event type EV_SYN(0x00).
> (key up generated by rc-core after 250ms after last scancode received)
> 
> So I think the autorepeat can do exactly what you want, without cec
> having any special code for it.

It comes close, but not quite, to what I need. It has more to do with the
CEC peculiarities than the rc code.

Specifically the CEC spec strongly recommends that the first reported key
press is always handled as a single non-repeating key press. Only if a second
identical key press is received within 550 ms will the 'Press and Hold' feature
kick in and will the key start repeating. This until a Release message is
received, a different key press is received or nothing is received for 550 ms.

Effectively the REP_DELAY is equal to the time between the first and second
key press message, and it immediately switches to repeat mode once the second
key press is received.

This code models this behavior exactly.

Regards,

	Hans

> 
> On a side note, here you can see that for rc-5 the IR_KEYPRESS_TIMEOUT
> should be 115ms (with a little extra margin). 
> 
> My apologies.
> 
> Sean
> 
>>
>> The 'enabled_protocols' field was also never set, fix that too. Since
>> CEC is a fixed protocol the driver has to set this field.
>>
>> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
>> ---
>>  drivers/media/cec/cec-adap.c | 56 ++++++++++++++++++++++++++++++++++++++++----
>>  drivers/media/cec/cec-core.c | 13 ++++++++++
>>  include/media/cec.h          |  5 ++++
>>  3 files changed, 69 insertions(+), 5 deletions(-)
>>
>> diff --git a/drivers/media/cec/cec-adap.c b/drivers/media/cec/cec-adap.c
>> index 1a021828c8d4..6a2f38f000e8 100644
>> --- a/drivers/media/cec/cec-adap.c
>> +++ b/drivers/media/cec/cec-adap.c
>> @@ -1766,6 +1766,9 @@ static int cec_receive_notify(struct cec_adapter *adap, struct cec_msg *msg,
>>  	int la_idx = cec_log_addr2idx(adap, dest_laddr);
>>  	bool from_unregistered = init_laddr == 0xf;
>>  	struct cec_msg tx_cec_msg = { };
>> +#ifdef CONFIG_MEDIA_CEC_RC
>> +	int scancode;
>> +#endif
>>  
>>  	dprintk(2, "%s: %*ph\n", __func__, msg->len, msg->msg);
>>  
>> @@ -1854,11 +1857,9 @@ static int cec_receive_notify(struct cec_adapter *adap, struct cec_msg *msg,
>>  		 */
>>  		case 0x60:
>>  			if (msg->len == 2)
>> -				rc_keydown(adap->rc, RC_TYPE_CEC,
>> -					   msg->msg[2], 0);
>> +				scancode = msg->msg[2];
>>  			else
>> -				rc_keydown(adap->rc, RC_TYPE_CEC,
>> -					   msg->msg[2] << 8 | msg->msg[3], 0);
>> +				scancode = msg->msg[2] << 8 | msg->msg[3];
>>  			break;
>>  		/*
>>  		 * Other function messages that are not handled.
>> @@ -1871,11 +1872,54 @@ static int cec_receive_notify(struct cec_adapter *adap, struct cec_msg *msg,
>>  		 */
>>  		case 0x56: case 0x57:
>>  		case 0x67: case 0x68: case 0x69: case 0x6a:
>> +			scancode = -1;
>>  			break;
>>  		default:
>> -			rc_keydown(adap->rc, RC_TYPE_CEC, msg->msg[2], 0);
>> +			scancode = msg->msg[2];
>> +			break;
>> +		}
>> +
>> +		/* Was repeating, but keypress timed out */
>> +		if (adap->rc_repeating && !adap->rc->keypressed) {
>> +			adap->rc_repeating = false;
>> +			adap->rc_last_scancode = -1;
>> +		}
>> +		/* Different keypress from last time, ends repeat mode */
>> +		if (adap->rc_last_scancode != scancode) {
>> +			rc_keyup(adap->rc);
>> +			adap->rc_repeating = false;
>> +		}
>> +		/* We can't handle this scancode */
>> +		if (scancode < 0) {
>> +			adap->rc_last_scancode = scancode;
>> +			break;
>> +		}
>> +
>> +		/* Send key press */
>> +		rc_keydown(adap->rc, RC_TYPE_CEC, scancode, 0);
>> +
>> +		/* When in repeating mode, we're done */
>> +		if (adap->rc_repeating)
>> +			break;
>> +
>> +		/*
>> +		 * We are not repeating, but the new scancode is
>> +		 * the same as the last one, and this second key press is
>> +		 * within 550 ms (the 'Follower Safety Timeout') from the
>> +		 * previous key press, so we now enable the repeating mode.
>> +		 */
>> +		if (adap->rc_last_scancode == scancode &&
>> +		    msg->rx_ts - adap->rc_last_keypress < 550 * NSEC_PER_MSEC) {
>> +			adap->rc_repeating = true;
>>  			break;
>>  		}
>> +		/*
>> +		 * Not in repeating mode, so avoid triggering repeat mode
>> +		 * by calling keyup.
>> +		 */
>> +		rc_keyup(adap->rc);
>> +		adap->rc_last_scancode = scancode;
>> +		adap->rc_last_keypress = msg->rx_ts;
>>  #endif
>>  		break;
>>  
>> @@ -1885,6 +1929,8 @@ static int cec_receive_notify(struct cec_adapter *adap, struct cec_msg *msg,
>>  			break;
>>  #ifdef CONFIG_MEDIA_CEC_RC
>>  		rc_keyup(adap->rc);
>> +		adap->rc_repeating = false;
>> +		adap->rc_last_scancode = -1;
>>  #endif
>>  		break;
>>  
>> diff --git a/drivers/media/cec/cec-core.c b/drivers/media/cec/cec-core.c
>> index 52f085ba104a..018a95cae6b0 100644
>> --- a/drivers/media/cec/cec-core.c
>> +++ b/drivers/media/cec/cec-core.c
>> @@ -276,9 +276,11 @@ struct cec_adapter *cec_allocate_adapter(const struct cec_adap_ops *ops,
>>  	adap->rc->input_id.version = 1;
>>  	adap->rc->driver_name = CEC_NAME;
>>  	adap->rc->allowed_protocols = RC_BIT_CEC;
>> +	adap->rc->enabled_protocols = RC_BIT_CEC;
>>  	adap->rc->priv = adap;
>>  	adap->rc->map_name = RC_MAP_CEC;
>>  	adap->rc->timeout = MS_TO_NS(100);
>> +	adap->rc_last_scancode = -1;
>>  #endif
>>  	return adap;
>>  }
>> @@ -310,6 +312,17 @@ int cec_register_adapter(struct cec_adapter *adap,
>>  			adap->rc = NULL;
>>  			return res;
>>  		}
>> +		/*
>> +		 * The REP_DELAY for CEC is really the time between the initial
>> +		 * 'User Control Pressed' message and the second. The first
>> +		 * keypress is always seen as non-repeating, the second
>> +		 * (provided it has the same UI Command) will start the 'Press
>> +		 * and Hold' (aka repeat) behavior. By setting REP_DELAY to the
>> +		 * same value as REP_PERIOD the expected CEC behavior is
>> +		 * reproduced.
>> +		 */
>> +		adap->rc->input_dev->rep[REP_DELAY] =
>> +			adap->rc->input_dev->rep[REP_PERIOD];
>>  	}
>>  #endif
>>  
>> diff --git a/include/media/cec.h b/include/media/cec.h
>> index 224a6e225c52..be3b243a0d5e 100644
>> --- a/include/media/cec.h
>> +++ b/include/media/cec.h
>> @@ -187,6 +187,11 @@ struct cec_adapter {
>>  
>>  	u32 tx_timeouts;
>>  
>> +#ifdef CONFIG_MEDIA_CEC_RC
>> +	bool rc_repeating;
>> +	int rc_last_scancode;
>> +	u64 rc_last_keypress;
>> +#endif
>>  #ifdef CONFIG_CEC_NOTIFIER
>>  	struct cec_notifier *notifier;
>>  #endif
>> -- 
>> 2.13.2
