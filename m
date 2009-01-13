Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qy0-f11.google.com ([209.85.221.11]:59144 "EHLO
	mail-qy0-f11.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753923AbZAMR05 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 13 Jan 2009 12:26:57 -0500
Received: by qyk4 with SMTP id 4so140566qyk.13
        for <linux-media@vger.kernel.org>; Tue, 13 Jan 2009 09:26:56 -0800 (PST)
Message-ID: <412bdbff0901130926g546ea6calc4507643891c8a7e@mail.gmail.com>
Date: Tue, 13 Jan 2009 12:26:56 -0500
From: "Devin Heitmueller" <devin.heitmueller@gmail.com>
To: "Nicola Soranzo" <nsoranzo@tiscali.it>
Subject: Re: No audio with Hauppauge WinTV-HVR-900 (R2)
Cc: linux-media@vger.kernel.org, linux-dvb@linuxtv.org
In-Reply-To: <200901131823.23640.nsoranzo@tiscali.it>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200901072031.27852.nsoranzo@tiscali.it>
	 <20090108000530.1d4dbafa@pedra.chehab.org>
	 <200901110411.36991.nsoranzo@tiscali.it>
	 <200901131823.23640.nsoranzo@tiscali.it>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Jan 13, 2009 at 12:23 PM, Nicola Soranzo <nsoranzo@tiscali.it> wrote:
> Also, if I run
>
> sudo arecord -D hw:2 -f dat prova.wav
>
> arecord starts recording, but when I interrupt it with control-C I have a
> complete kernel crash (even the Caps-Lock key is dead). For what I can
> understand, the problem can be related to IRQ.
> Can somebody help me?

I am already debugging that exact same issue.  I am waiting for a PCI
serial card to show up (ordered last night), but as soon as it does I
will isolate the problem.

Devin

-- 
Devin J. Heitmueller
http://www.devinheitmueller.com
AIM: devinheitmueller
