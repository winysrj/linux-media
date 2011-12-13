Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout-de.gmx.net ([213.165.64.23]:40383 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753692Ab1LMUIh (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 13 Dec 2011 15:08:37 -0500
Message-ID: <4EE7B0C1.7080606@gmx.de>
Date: Tue, 13 Dec 2011 21:08:33 +0100
From: Johannes Bauer <dfnsonfsduifb@gmx.de>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: Re: zc3xx webcam crashes on in-focus pictures
References: <4EE49B2B.8090502@gmx.de>	<20111211160452.101da395@tele>	<4EE50E2C.30705@gmx.de> <20111213121628.13df8dad@tele>
In-Reply-To: <20111213121628.13df8dad@tele>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Forgot to CC the list, here it goes...

Hi Jef,

Am 13.12.2011 11:32, schrieb Jean-Francois Moine:

> > So, I added controls to modify these registers in the version 2.14.5
> > I've just uploaded.
> >
> > The values may be modified by programs as 'v4l2ucp' (control only),
> > 'vlc' or my program 'svv'. Note that changing the register values works
> > only when capture is active (the values are reset at capture start
> > time).

Wow - you, Sir, are good! I am really impressed.

After installing the package, I saw that the values are initialized at
R7 = 0, R8 = 2. Sharpness is initialized to 2.

As soon as I changed R7 to 1, it worked perfectly. This also yielded a
perfect image quality (at some settings there was weird noise patterns).
>From 34..50 I could reproduce the bug again.

Also when I raised the sharpness to the max level of 3, the bug appeared
again.

So thank you again for your solution and my kudos again. Awesome! Also,
svv is a really neat tool, I'll surely use that in the future.

Best regards,
Joe


