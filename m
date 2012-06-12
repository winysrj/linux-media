Return-path: <linux-media-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:47364 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751916Ab2FLMqh (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 12 Jun 2012 08:46:37 -0400
Message-ID: <4FD73A27.5020009@codeaurora.org>
Date: Tue, 12 Jun 2012 18:16:31 +0530
From: Ravi Kumar V <kumarrav@codeaurora.org>
MIME-Version: 1.0
To: Jarod Wilson <jarod@redhat.com>, linux-media@vger.kernel.org,
	mchehab@redhat.com
Subject: NECX protocol STATE_TRAILER_SPACE
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Jardon,

I am writing IR receiver driver over GPIO line.
Trying to read the frame sent by Samsung remote.
I am sending interrupt events to rc frame work using 
ir_raw_event_store_edge()

I am able to see that above API is pushing previous pulse/space packet 
to rc framework when an interrupt is reported to it.
I am facing one issue with NEC decoder.

NECx protocol format has one start bit, 32 data bits and one stop bit

stop bit: pulse (562us) & space ( untill next key press event)

so i think here we should skip the STATE_TRAILER_SPACE event because the 
width of it is not fixed for some of NECx protocols like samsung remote.


         case STATE_TRAILER_PULSE:
                 if (!ev.pulse)
                         break;

                 if (!eq_margin(ev.duration, NEC_TRAILER_PULSE, NEC_UNIT
                         break;

                 data->state = STATE_TRAILER_SPACE;
                 IR_dprintk(1, "NEC (Ext) state set %d\n", data->state);
                 return 0;

         case STATE_TRAILER_SPACE:
                 if (ev.pulse)
                         break;

                 if (!geq_margin(ev.duration, NEC_TRAILER_SPACE, 
NEC_UNIT / 2))
                         break;

                 address     = bitrev8((data->bits >> 24) & 0xff);
                 not_address = bitrev8((data->bits >> 16) & 0xff);
                 command     = bitrev8((data->bits >>  8) & 0xff);
                 not_command = bitrev8((data->bits >>  0) & 0xff);

                 if ((command ^ not_command) != 0xff) {
                         IR_dprintk(1, "NEC checksum error: received 
0x%08x\n",
                                    data->bits);
                         send_32bits = true;
                 }


-- 
Sent by a consultant of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
