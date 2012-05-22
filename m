Return-path: <linux-media-owner@vger.kernel.org>
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:33897 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756863Ab2EVMGo (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 22 May 2012 08:06:44 -0400
References: <201205221127.16629.hverkuil@xs4all.nl> <74b696e9-3ff5-46f0-9d7d-e70ec02596b0@email.android.com> <201205221308.15140.hverkuil@xs4all.nl>
In-Reply-To: <201205221308.15140.hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
Subject: Re: Warning in cx24110: how to fix?
From: Andy Walls <awalls@md.metrocast.net>
Date: Tue, 22 May 2012 08:06:51 -0400
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: linux-media <linux-media@vger.kernel.org>
Message-ID: <1bd26c7e-46ab-4fa1-a4f2-207787deccb2@email.android.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hans Verkuil <hverkuil@xs4all.nl> wrote:

>On Tue 22 May 2012 13:06:25 Andy Walls wrote:
>> Hans Verkuil <hverkuil@xs4all.nl> wrote
>> 
>> >I'm getting this warning in the daily build:
>> >
>> >v4l-dvb-git/drivers/media/dvb/frontends/cx24110.c: In function
>> >‘cx24110_read_ucblocks’:
>> >v4l-dvb-git/drivers/media/dvb/frontends/cx24110.c:520:40: warning:
>> >value computed is not used [-Wunused-value]
>> >
>> >It comes from this code:
>> >
>> >static int cx24110_read_ucblocks(struct dvb_frontend* fe, u32*
>> >ucblocks)
>> >{
>> >        struct cx24110_state *state = fe->demodulator_priv;
>> >
>> >        if(cx24110_readreg(state,0x10)&0x40) {
>> >            /* the RS error counter has finished one counting window
>*/
>> >           cx24110_writereg(state,0x10,0x60); /* select the byer reg
>*/
>> >                cx24110_readreg(state, 0x12) |
>> >                        (cx24110_readreg(state, 0x13) << 8) |
>> >                        (cx24110_readreg(state, 0x14) << 16);
>> >           cx24110_writereg(state,0x10,0x70); /* select the bler reg
>*/
>> >                state->lastbler=cx24110_readreg(state,0x12)|
>> >                        (cx24110_readreg(state,0x13)<<8)|
>> >                        (cx24110_readreg(state,0x14)<<16);
>> >        cx24110_writereg(state,0x10,0x20); /* start new count window
>*/
>> >        }
>> >        *ucblocks = state->lastbler;
>> >
>> >        return 0;
>> >}
>> >
>> >This is the offending code:
>> >
>> >                cx24110_readreg(state, 0x12) |
>> >                        (cx24110_readreg(state, 0x13) << 8) |
>> >                        (cx24110_readreg(state, 0x14) << 16);
>> >
>> >Is there a reason these registers are read without storing their
>value?
>> >Or is it a bug?
>> >
>> >Regards,
>> >
>> >	Hans
>> >--
>> >To unsubscribe from this list: send the line "unsubscribe
>linux-media"
>> >in
>> >the body of a message to majordomo@vger.kernel.org
>> >More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> 
>> I would guess the safest thing to do is still perform the registers
>reads.
>> 
>> Will adding a "(void)" cast to the beginning of the statement work?
>
>Sure, that will work. But I just wonder if anyone actually knows *why*
>this
>is done in this way. It would be nice to have a comment here describing
>the
>reason (if there is one, of course).
>
>Regards,
>
>	Hans


I wouldn't agonize over it.

Assume the reads have the side effect of reseting the "byer" (byte error rate?) counter before it rolls over. 

The likely case is that nothing bad will happpen if you don't read that register.  A worse case is that by not reading that register, the other measurment/count registers won't read properly.

Regards,
Andy
