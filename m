Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-gh0-f174.google.com ([209.85.160.174]:50821 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755950Ab2GJP6P (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 10 Jul 2012 11:58:15 -0400
Received: by ghrr11 with SMTP id r11so138870ghr.19
        for <linux-media@vger.kernel.org>; Tue, 10 Jul 2012 08:58:15 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4FFC4F71.4000809@gmail.com>
References: <4FF4697C.8080602@nexusuk.org>
	<4FF46DC4.4070204@iki.fi>
	<4FF4911B.9090600@web.de>
	<4FF4931B.7000708@iki.fi>
	<gjggc9-dl4.ln1@wuwek.kopernik.gliwice.pl>
	<4FF5A350.9070509@iki.fi>
	<r8cic9-ht4.ln1@wuwek.kopernik.gliwice.pl>
	<4FF6B121.6010105@iki.fi>
	<9btic9-vd5.ln1@wuwek.kopernik.gliwice.pl>
	<835kc9-7p4.ln1@wuwek.kopernik.gliwice.pl>
	<4FF77C1B.50406@iki.fi>
	<l2smc9-pj4.ln1@wuwek.kopernik.gliwice.pl>
	<4FF97DF8.4080208@iki.fi>
	<n1aqc9-sp4.ln1@wuwek.kopernik.gliwice.pl>
	<4FFA996D.9010206@iki.fi>
	<scerc9-bm6.ln1@wuwek.kopernik.gliwice.pl>
	<4FFB2129.2070301@gmail.com>
	<hhvsc9-pte.ln1@wuwek.kopernik.gliwice.pl>
	<4FFC4F71.4000809@gmail.com>
Date: Tue, 10 Jul 2012 11:58:15 -0400
Message-ID: <CAGoCfizj8buVoMc8qOY-NxKa53KnXNnZLekpr6-wLU08PM5kEw@mail.gmail.com>
Subject: Re: pctv452e
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: poma <pomidorabelisima@gmail.com>
Cc: Marx <acc.for.news@gmail.com>, linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Jul 10, 2012 at 11:51 AM, poma <pomidorabelisima@gmail.com> wrote:
>> Is this pctv452e device known to have poor reception?

Traditionally speaking, these problems are usually not the hardware
itself - it tends to be crappy Linux drivers.  Somebody gets support
working for a chip on some product, and then somebody else does a
cut/paste of the code to make some other product work.  They see it
getting signal lock under optimal tuning conditions and declare
success.

Making any given device work *well* tends to be much harder than
making it work at all.

Want to rule out bad hardware design?  Drop it into a Windows machine
and see how it performs.  If it works fine under Windows but poorly
under Linux, then you definitely have a Linux driver problem.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
