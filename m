Return-path: <mchehab@pedra>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:49911 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756142Ab0KJVOi (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 10 Nov 2010 16:14:38 -0500
Received: by wwb39 with SMTP id 39so1209682wwb.1
        for <linux-media@vger.kernel.org>; Wed, 10 Nov 2010 13:14:37 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <AANLkTimE-MWjG0JRCenOA4xhammTMS_11uvh7E+qWrNe@mail.gmail.com>
References: <yanpj3usd6gfp0xwdbaxlkni.1289407954066@email.android.com>
	<AANLkTimE-MWjG0JRCenOA4xhammTMS_11uvh7E+qWrNe@mail.gmail.com>
Date: Wed, 10 Nov 2010 22:14:36 +0100
Message-ID: <AANLkTi=5dNVBHvEtLxcO52AynjCyJq=Dpi6NqMEjd0tb@mail.gmail.com>
Subject: Re: Bounty for the first Open Source driver for Kinect
From: Markus Rechberger <mrechberger@gmail.com>
To: Mohamed Ikbel Boulabiar <boulabiar@gmail.com>
Cc: Andy Walls <awalls@md.metrocast.net>,
	Antonio Ospite <ospite@studenti.unina.it>,
	linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Wed, Nov 10, 2010 at 9:54 PM, Mohamed Ikbel Boulabiar
<boulabiar@gmail.com> wrote:
> The bounty is already taken by that developer.
>
> But now, the Kinect thing is supported like a GPL userspace library.
> Maybe still need more work to be rewritten as a kernel module.
>

This should better remain in userspace and interface libv4l/libv4l2 no
need to make things more complicated than they have to be.

Markus
