Return-path: <mchehab@pedra>
Received: from mail-ew0-f46.google.com ([209.85.215.46]:50344 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754382Ab1ASNKQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 19 Jan 2011 08:10:16 -0500
Date: Wed, 19 Jan 2011 16:10:10 +0300
From: Vasiliy Kulikov <segoon@openwall.com>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: Patrick Boettcher <patrick.boettcher@dibcom.fr>,
	Olivier Grenie <olivier.grenie@dibcom.fr>,
	linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [BUG] media: dvb: dib9000: buggy locking
Message-ID: <20110119131010.GA10321@albatros>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi,

I've noticed that locking in drivers/media/dvb/frontends/dib9000.c is
not correct:

static int dib9000_fw_get_channel(...)
{
    ...
	DibAcquireLock(&state->platform.risc.mem_mbx_lock);
    ...

error:
	DibReleaseLock(&state->platform.risc.mem_mbx_lock);
	return ret;
}

#define DibAcquireLock(lock) do { if (mutex_lock_interruptible(lock) < 0) dprintk("could not get the lock"); } while (0)
#define DibReleaseLock(lock) mutex_unlock(lock)


1) If mutex is not hold, then the critical section is not protected.

2) If mutex was not hold, then the code tries to release not holded
mutex.


This locking "style" is used all over the driver.


Thanks,

-- 
Vasiliy Kulikov
http://www.openwall.com - bringing security into open computing environments
