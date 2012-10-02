Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ie0-f174.google.com ([209.85.223.174]:35141 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750979Ab2JBB6k (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 1 Oct 2012 21:58:40 -0400
Received: by ieak13 with SMTP id k13so13690148iea.19
        for <linux-media@vger.kernel.org>; Mon, 01 Oct 2012 18:58:39 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1349139145-22113-1-git-send-email-crope@iki.fi>
References: <1349139145-22113-1-git-send-email-crope@iki.fi>
Date: Mon, 1 Oct 2012 21:58:39 -0400
Message-ID: <CAGoCfiwfTkTs1DPa0cWHLOgGcgS0Df3h7zZ=4YW51dr_AS78nQ@mail.gmail.com>
Subject: Re: [PATCH RFC] em28xx: PCTV 520e switch tda18271 to tda18271c2dd
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Antti Palosaari <crope@iki.fi>
Cc: linux-media@vger.kernel.org, Michael Krufky <mkrufky@linuxtv.org>,
	Mauro Carvalho Chehab <mchehab@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Oct 1, 2012 at 8:52 PM, Antti Palosaari <crope@iki.fi> wrote:
> New drxk firmware download does not work with tda18271. Actual
> reason is more drxk driver than tda18271. Anyhow, tda18271c2dd
> will work as it does not do as much I/O during attach than tda18271.
>
> Root of cause is tuner I/O during drx-k asynchronous firmware
> download. request_firmware_nowait()... :-/

This seems like it's just changing the timing of the initialization
process, which isn't really any better than the "msleep(2000)".  It's
just dumb luck that it happens to work on the developer's system.

Don't get me wrong, I agree with Michael that this whole situation is
ridiculous, but I don't see why swapping out the entire driver is a
reasonable fix.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
