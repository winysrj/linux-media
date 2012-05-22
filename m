Return-path: <linux-media-owner@vger.kernel.org>
Received: from ams-iport-1.cisco.com ([144.254.224.140]:34188 "EHLO
	ams-iport-1.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751924Ab2EVJ2I convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 22 May 2012 05:28:08 -0400
Received: from cobaltpc1.localnet (dhcp-10-54-92-43.cisco.com [10.54.92.43])
	by ams-core-1.cisco.com (8.14.3/8.14.3) with ESMTP id q4M9S3ni030117
	for <linux-media@vger.kernel.org>; Tue, 22 May 2012 09:28:03 GMT
From: Hans Verkuil <hverkuil@xs4all.nl>
To: "linux-media" <linux-media@vger.kernel.org>
Subject: Warning in cx24110: how to fix?
Date: Tue, 22 May 2012 11:27:16 +0200
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201205221127.16629.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I'm getting this warning in the daily build:

v4l-dvb-git/drivers/media/dvb/frontends/cx24110.c: In function ‘cx24110_read_ucblocks’:
v4l-dvb-git/drivers/media/dvb/frontends/cx24110.c:520:40: warning: value computed is not used [-Wunused-value]

It comes from this code:

static int cx24110_read_ucblocks(struct dvb_frontend* fe, u32* ucblocks)
{
        struct cx24110_state *state = fe->demodulator_priv;

        if(cx24110_readreg(state,0x10)&0x40) {
                /* the RS error counter has finished one counting window */
                cx24110_writereg(state,0x10,0x60); /* select the byer reg */
                cx24110_readreg(state, 0x12) |
                        (cx24110_readreg(state, 0x13) << 8) |
                        (cx24110_readreg(state, 0x14) << 16);
                cx24110_writereg(state,0x10,0x70); /* select the bler reg */
                state->lastbler=cx24110_readreg(state,0x12)|
                        (cx24110_readreg(state,0x13)<<8)|
                        (cx24110_readreg(state,0x14)<<16);
                cx24110_writereg(state,0x10,0x20); /* start new count window */
        }
        *ucblocks = state->lastbler;

        return 0;
}

This is the offending code:

                cx24110_readreg(state, 0x12) |
                        (cx24110_readreg(state, 0x13) << 8) |
                        (cx24110_readreg(state, 0x14) << 16);

Is there a reason these registers are read without storing their value?
Or is it a bug?

Regards,

	Hans
