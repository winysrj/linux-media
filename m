Return-path: <linux-media-owner@vger.kernel.org>
Received: from ams-iport-3.cisco.com ([144.254.224.146]:26082 "EHLO
	ams-iport-3.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758307Ab2EVLJF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 22 May 2012 07:09:05 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Andy Walls <awalls@md.metrocast.net>
Subject: Re: Warning in cx24110: how to fix?
Date: Tue, 22 May 2012 13:08:15 +0200
Cc: "linux-media" <linux-media@vger.kernel.org>
References: <201205221127.16629.hverkuil@xs4all.nl> <74b696e9-3ff5-46f0-9d7d-e70ec02596b0@email.android.com>
In-Reply-To: <74b696e9-3ff5-46f0-9d7d-e70ec02596b0@email.android.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201205221308.15140.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue 22 May 2012 13:06:25 Andy Walls wrote:
> Hans Verkuil <hverkuil@xs4all.nl> wrote
> 
> >I'm getting this warning in the daily build:
> >
> >v4l-dvb-git/drivers/media/dvb/frontends/cx24110.c: In function
> >‘cx24110_read_ucblocks’:
> >v4l-dvb-git/drivers/media/dvb/frontends/cx24110.c:520:40: warning:
> >value computed is not used [-Wunused-value]
> >
> >It comes from this code:
> >
> >static int cx24110_read_ucblocks(struct dvb_frontend* fe, u32*
> >ucblocks)
> >{
> >        struct cx24110_state *state = fe->demodulator_priv;
> >
> >        if(cx24110_readreg(state,0x10)&0x40) {
> >            /* the RS error counter has finished one counting window */
> >           cx24110_writereg(state,0x10,0x60); /* select the byer reg */
> >                cx24110_readreg(state, 0x12) |
> >                        (cx24110_readreg(state, 0x13) << 8) |
> >                        (cx24110_readreg(state, 0x14) << 16);
> >           cx24110_writereg(state,0x10,0x70); /* select the bler reg */
> >                state->lastbler=cx24110_readreg(state,0x12)|
> >                        (cx24110_readreg(state,0x13)<<8)|
> >                        (cx24110_readreg(state,0x14)<<16);
> >        cx24110_writereg(state,0x10,0x20); /* start new count window */
> >        }
> >        *ucblocks = state->lastbler;
> >
> >        return 0;
> >}
> >
> >This is the offending code:
> >
> >                cx24110_readreg(state, 0x12) |
> >                        (cx24110_readreg(state, 0x13) << 8) |
> >                        (cx24110_readreg(state, 0x14) << 16);
> >
> >Is there a reason these registers are read without storing their value?
> >Or is it a bug?
> >
> >Regards,
> >
> >	Hans
> >--
> >To unsubscribe from this list: send the line "unsubscribe linux-media"
> >in
> >the body of a message to majordomo@vger.kernel.org
> >More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> I would guess the safest thing to do is still perform the registers reads.
> 
> Will adding a "(void)" cast to the beginning of the statement work?

Sure, that will work. But I just wonder if anyone actually knows *why* this
is done in this way. It would be nice to have a comment here describing the
reason (if there is one, of course).

Regards,

	Hans
