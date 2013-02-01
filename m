Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qa0-f42.google.com ([209.85.216.42]:42728 "EHLO
	mail-qa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755309Ab3BAOTZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 1 Feb 2013 09:19:25 -0500
Received: by mail-qa0-f42.google.com with SMTP id cr7so294479qab.8
        for <linux-media@vger.kernel.org>; Fri, 01 Feb 2013 06:19:24 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <510BCE2F.1070100@googlemail.com>
References: <510A9A1E.9090801@googlemail.com>
	<CAGoCfiwQNBv1r5KgCzYFf7X1hP--fyQpqvRHCDtKFcSxwbJWpA@mail.gmail.com>
	<510ADB2F.4080901@googlemail.com>
	<510AF800.2090607@googlemail.com>
	<510BACD5.2070406@googlemail.com>
	<510BCE2F.1070100@googlemail.com>
Date: Fri, 1 Feb 2013 09:19:23 -0500
Message-ID: <CAGoCfix8XDzcgtCiL39Qna_QBx_=ZEKyMknzbsS3iTXS04_a8A@mail.gmail.com>
Subject: Re: WinTV-HVR-1400: scandvb (and kaffeine) fails to find any channels
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Chris Clayton <chris2553@googlemail.com>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Feb 1, 2013 at 9:16 AM, Chris Clayton <chris2553@googlemail.com> wrote:
> I've got some more diagnostics. I tuned on the 12c debugging in the cx23885
> driver and ran the scan again. Surprisingly, the scan found 22 channels on a
> single frequency (that carries the BBC channels). I've attached two files -
> the output from dvbscan and the kernel log covering the loading of the
> drivers and running the scan.
>
> I'm no kernel guru, but is it possible that the root cause of the scan
> failures is a timing problem which is being partially offset by the time
> taken to produce all the debug output?

w_scan does have some arguments that let you increase the timeout for
tuning.  You may wish to see if that has any effect.  Maybe the w_scan
timeout is just too short for that device.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
