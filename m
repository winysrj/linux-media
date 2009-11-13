Return-path: <linux-media-owner@vger.kernel.org>
Received: from acorn.exetel.com.au ([220.233.0.21]:42211 "EHLO
	acorn.exetel.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754473AbZKMBVj (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 12 Nov 2009 20:21:39 -0500
Message-ID: <49001.64.213.30.2.1258075299.squirrel@webmail.exetel.com.au>
In-Reply-To: <829197380911121538xb7b8fc2y12e03d5c2492f80d@mail.gmail.com>
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
    <829197380911121538xb7b8fc2y12e03d5c2492f80d@mail.gmail.com>
Date: Fri, 13 Nov 2009 12:21:39 +1100 (EST)
Subject: Re: [XC3028] Terretec Cinergy T XS wrong firmware xc3028-v27.fw
From: "Robert Lowery" <rglowery@exemail.com.au>
To: "Devin Heitmueller" <dheitmueller@kernellabs.com>
Cc: "Florent NOUVELLON" <flonouvellon@gmail.com>,
	"Valerio Bontempi" <valerio.bontempi@gmail.com>,
	"Mauro Carvalho Chehab" <mchehab@infradead.org>,
	linux-media@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

> On Thu, Nov 12, 2009 at 6:33 PM, Florent NOUVELLON
> <flonouvellon@gmail.com> wrote:
>> Sorry about that mistake... That was an em28xx-new trick.
>>
>> So my question is simply :
>> Do you know how to disable compiling some drivers on v4l-dvb for faster
>> compiling ?
>
> Well, I typically disable firedtv because of the Ubuntu bug.  I
> wouldn't recommend compiling out drivers to improve compile
> performance (it's just too easy to screw up because of non-obvious
> dependencies).  If you are recompiling regularly, I would suggest
> installing ccache instead.

When I was bisecting a recent defect which required a dozen or so
recompiles + hitting lots of compile failures at each bisect, I just
edited v4l/.myconfig, setting everything to ":= n" except those modules
required by the dvb card I was testing as confirmed by the modules.dep
file.

I expect this method is not foolproof due to the non-obvious dependencies
Devin mentions above, but it worked for me and sped the process up by an
order of magnitude.

HTH

-Rob


