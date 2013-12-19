Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qc0-f179.google.com ([209.85.216.179]:35409 "EHLO
	mail-qc0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753473Ab3LSTMu (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 19 Dec 2013 14:12:50 -0500
Received: by mail-qc0-f179.google.com with SMTP id i8so1354528qcq.10
        for <linux-media@vger.kernel.org>; Thu, 19 Dec 2013 11:12:49 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <52B33D24.1060705@iki.fi>
References: <1387231688-8647-1-git-send-email-crope@iki.fi>
	<1387231688-8647-7-git-send-email-crope@iki.fi>
	<52B2BA92.8080706@xs4all.nl>
	<52B323F0.2050701@iki.fi>
	<CAGoCfiz1kWHXPC-b-Exw=AYrNeOzaCgSvr3+zLuf12g5gyYJxA@mail.gmail.com>
	<52B33D24.1060705@iki.fi>
Date: Thu, 19 Dec 2013 14:12:49 -0500
Message-ID: <CAGoCfiyW_T==jST24Jhuw0khJtJ42EL-Gu6-pVFuW_oou=necA@mail.gmail.com>
Subject: Re: [PATCH RFC v3 6/7] rtl2832_sdr: convert to SDR API
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Antti Palosaari <crope@iki.fi>
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <m.chehab@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

> I think I could add some lock quite easily. I remember when I implemented
> cxd2820r DVB-T/T2/C demod driver and at the time it implements 2 frontends,
> one for DVB-T/T2 and one for DVB-C. I used shared lock to prevent access
> only for single fe at time. I think same solution works in that case too.

Locking between v4l and dvb is more problematic because of known bugs
related to the dvb_frontend deferring the shutdown of the tuner.  As a
result there is a race condition if you try to close the DVB device
and then immediately open the V4L device (which would be a common use
case if using an application like MythTV when switching from digital
to analog mode).

You can't simply add a lock because the V4L side will get hit with
-EBUSY because the DVB frontend hasn't completely shutdown yet.

Unfortunately it's one of those cases where it "seems" easy until you
start scoping out the edge cases and race conditions.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
