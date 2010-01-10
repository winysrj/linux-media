Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f227.google.com ([209.85.218.227]:62629 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752482Ab0AJNys (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 10 Jan 2010 08:54:48 -0500
Received: by bwz27 with SMTP id 27so12964039bwz.21
        for <linux-media@vger.kernel.org>; Sun, 10 Jan 2010 05:54:46 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4B48DC34.1080500@infradead.org>
References: <A69FA2915331DC488A831521EAE36FE40162D43370@dlee06.ent.ti.com>
	 <4B48DC34.1080500@infradead.org>
Date: Sun, 10 Jan 2010 08:54:46 -0500
Message-ID: <55a3e0ce1001100554l76a8b7ccl42afdbc37498410a@mail.gmail.com>
Subject: Re: building v4l-dvb - compilation error
From: Muralidharan Karicheri <mkaricheri@gmail.com>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Mauro,

I ran the build using my ubunto linux box at home and it has succeeded
the build.
>
>> make[2]: Leaving directory `/usr/src/kernels/2.6.9-55.0.12.EL-smp-i686'
>
> The minimum supported version by the backport is 2.6.16.
Hmm. Does that means, the build is using the kernel source code
natively available at /usr/src/kernel. Is there a way to force it use
a specific kernel source code?

-- 
Murali Karicheri
mkaricheri@gmail.com
