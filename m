Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wg0-f44.google.com ([74.125.82.44]:55025 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752836Ab2HFUTG (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 6 Aug 2012 16:19:06 -0400
Received: by wgbdr13 with SMTP id dr13so3144781wgb.1
        for <linux-media@vger.kernel.org>; Mon, 06 Aug 2012 13:19:04 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <5020175D.3070601@iki.fi>
References: <500C5B9B.8000303@iki.fi>
	<CAOcJUbw-8zG-j7YobgKy7k5vp-k_trkaB5fYGz605KdUQHKTGQ@mail.gmail.com>
	<500F1DC5.1000608@iki.fi>
	<CAOcJUbzXoLx10o8oprxPM1TELFxyGE7_wodcWsBr8MX4OR0N_w@mail.gmail.com>
	<50200AC9.9080203@iki.fi>
	<CAGoCfixmre37ph46E6U9mJ+tyt+OL7+RbDwg+W6DkL01im2nCg@mail.gmail.com>
	<CAOcJUbwyNBEoPyE_6QZQ-6tbUsHFzurYBEavegQO1aVYNsQ_kA@mail.gmail.com>
	<5020175D.3070601@iki.fi>
Date: Tue, 7 Aug 2012 01:49:04 +0530
Message-ID: <CAHFNz9KQitRfmHPfY2-biSkCwF3GPSMsWOE_XC1p-S0YeQ2ZCA@mail.gmail.com>
Subject: Re: tda18271 driver power consumption
From: Manu Abraham <abraham.manu@gmail.com>
To: Antti Palosaari <crope@iki.fi>
Cc: Michael Krufky <mkrufky@linuxtv.org>,
	Devin Heitmueller <dheitmueller@kernellabs.com>,
	linux-media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Aug 7, 2012 at 12:43 AM, Antti Palosaari <crope@iki.fi> wrote:
..
 I ran thinking that recently when looked how to
> implement DVB SDR for V4L2 API...

If you try to fit an apple into an orange, you run into that sort of a problem.
If you are working with DVB, the Linux-DVB is the way to go, If you are
working with analog/webcams then V4L should be used. If you are mixing
both worlds, then you land into all sorts of nastiness.

You might need extensions to fit hardware needs as time passes by, but
still you have the same basic fundamental thing working in there ..

One comes across demodulators running on a DSP/FPGA or a DSP-FPGA
and so on ..

Regards,
Manu
