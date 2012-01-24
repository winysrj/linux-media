Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:51948 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750854Ab2AXPQ3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 24 Jan 2012 10:16:29 -0500
Received: by vbbfc26 with SMTP id fc26so1262715vbb.19
        for <linux-media@vger.kernel.org>; Tue, 24 Jan 2012 07:16:28 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4F1EC725.7090204@iki.fi>
References: <44895934A66CD441A02DCF15DD759BA0011CAE69@SYDEXCHTMP2.au.fjanz.com>
	<4F1E9A78.7020203@iki.fi>
	<CAGoCfizF=aO-JTLLCAK=QgsPSVP13SzbB9j6wCFfVzGXc4hnfw@mail.gmail.com>
	<4F1EC725.7090204@iki.fi>
Date: Tue, 24 Jan 2012 10:16:28 -0500
Message-ID: <CAGoCfiwZ2_+rQgXxq9DF_veGZ8vqaZf2JtUSi8SyLW_pd6VFAA@mail.gmail.com>
Subject: Re: HVR 4000 hybrid card still producing multiple frontends for
 single adapter
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Antti Palosaari <crope@iki.fi>
Cc: "Hawes, Mark" <MARK.HAWES@au.fujitsu.com>,
	linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Jan 24, 2012 at 9:58 AM, Antti Palosaari <crope@iki.fi> wrote:
> So what was the actual benefit then just introduce one way more to implement
> same thing. As I sometime understood from Manu's talk there will not be
> difference if my device is based of DVB-T + DVB-C demod combination or just
> single chip that does same. Now there is devices that have same
> characteristics but different interface.

For one thing, you cannot use DVB-T and DVB-C at the same time if
they're on the same demod.  With many of the devices that have S/S2
and DVB-T, you can be using them both in parallel.  Having multiple
frontends actually makes sense since you don't want two applications
talking to the same frontend at the same time but operating on
different tuners/streams.

That said, there could be opportunities for consolidation if the
demods could not be used in parallel, but I believe that would require
a nontrivial restructuring of the core code and API.  In my opinion
the entry point for the kernel ABI should *never* have been the
demodulator but rather the bridge driver (where you can exercise
greater control over what can be used in parallel).

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
