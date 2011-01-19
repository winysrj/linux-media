Return-path: <mchehab@pedra>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:48862 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753400Ab1ASR5y (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 19 Jan 2011 12:57:54 -0500
Received: by ywl5 with SMTP id 5so400206ywl.19
        for <linux-media@vger.kernel.org>; Wed, 19 Jan 2011 09:57:53 -0800 (PST)
Subject: Re: [BUG] media: dvb: dib9000: buggy locking
From: Malcolm Priestley <tvboxspy@gmail.com>
To: linux-media@vger.kernel.org
In-Reply-To: <20110119131010.GA10321@albatros>
References: <20110119131010.GA10321@albatros>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 19 Jan 2011 17:57:45 +0000
Message-ID: <1295459865.2200.25.camel@tvboxspy>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Wed, 2011-01-19 at 16:10 +0300, Vasiliy Kulikov wrote:
> Hi,
> 
> I've noticed that locking in drivers/media/dvb/frontends/dib9000.c is
> not correct:
> 
> static int dib9000_fw_get_channel(...)
> {
>     ...
> 	DibAcquireLock(&state->platform.risc.mem_mbx_lock);
>     ...
> 
> error:
> 	DibReleaseLock(&state->platform.risc.mem_mbx_lock);
> 	return ret;
> }
> 
> #define DibAcquireLock(lock) do { if (mutex_lock_interruptible(lock) < 0) dprintk("could not get the lock"); } while (0)
> #define DibReleaseLock(lock) mutex_unlock(lock)
> 
> 
> 1) If mutex is not hold, then the critical section is not protected.
> 
> 2) If mutex was not hold, then the code tries to release not holded
> mutex.

I didn't think that was a problem, because most callers didn't have code
to handle the error. and would therefore hopefully just call again.

What I noticed in particular the lock is never released on error
condition as in...

static int dib9000_read_ber(struct dvb_frontend *fe, u32 * ber)
{
	struct dib9000_state *state = fe->demodulator_priv;
	u16 c[16];

	DibAcquireLock(&state->platform.risc.mem_mbx_lock);
	if (dib9000_fw_memmbx_sync(state, FE_SYNC_CHANNEL) < 0)
		return -EIO;               <----------the lock is never released.
	dib9000_risc_mem_read(state, FE_MM_R_FE_MONITOR, (u8 *) c, sizeof(c));
	DibReleaseLock(&state->platform.risc.mem_mbx_lock);

	*ber = c[10] << 16 | c[11];
	return 0;
}


