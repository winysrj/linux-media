Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f227.google.com ([209.85.218.227]:39313 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754805AbZKLXi0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 12 Nov 2009 18:38:26 -0500
Received: by bwz27 with SMTP id 27so2853138bwz.21
        for <linux-media@vger.kernel.org>; Thu, 12 Nov 2009 15:38:30 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <664add070911121533t6efea606wb33c865b0ffa1f59@mail.gmail.com>
References: <ad6681df0911090313t17652362v2e92c465b60a92e4@mail.gmail.com>
	 <829197380911090935r1d0abbdcq49f2d76c8a1618f5@mail.gmail.com>
	 <ad6681df0911090956r12424564uf9384d53ee5c6ffa@mail.gmail.com>
	 <829197380911091040l46e40bf8t783bbdf3590b1244@mail.gmail.com>
	 <ad6681df0911100139u6ea649c7rcc8c2f840167d4bc@mail.gmail.com>
	 <829197380911100739k1b1a1c78t97c5a9dddae89b00@mail.gmail.com>
	 <ad6681df0911100749p13bc917al2390f85d471e2765@mail.gmail.com>
	 <829197380911100752yf4ff138rb3ecae613586f59f@mail.gmail.com>
	 <664add070911121523h3a0e126bm477e516a5bfc7e7@mail.gmail.com>
	 <664add070911121533t6efea606wb33c865b0ffa1f59@mail.gmail.com>
Date: Thu, 12 Nov 2009 18:38:30 -0500
Message-ID: <829197380911121538xb7b8fc2y12e03d5c2492f80d@mail.gmail.com>
Subject: Re: [XC3028] Terretec Cinergy T XS wrong firmware xc3028-v27.fw
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Florent NOUVELLON <flonouvellon@gmail.com>
Cc: Valerio Bontempi <valerio.bontempi@gmail.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Nov 12, 2009 at 6:33 PM, Florent NOUVELLON
<flonouvellon@gmail.com> wrote:
> Sorry about that mistake... That was an em28xx-new trick.
>
> So my question is simply :
> Do you know how to disable compiling some drivers on v4l-dvb for faster
> compiling ?

Well, I typically disable firedtv because of the Ubuntu bug.  I
wouldn't recommend compiling out drivers to improve compile
performance (it's just too easy to screw up because of non-obvious
dependencies).  If you are recompiling regularly, I would suggest
installing ccache instead.

Cheers,

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
