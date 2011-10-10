Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:45906 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750953Ab1JJVG5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 10 Oct 2011 17:06:57 -0400
Received: by iabz25 with SMTP id z25so763640iab.19
        for <linux-media@vger.kernel.org>; Mon, 10 Oct 2011 14:06:56 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1318278450.16238.15.camel@localhost>
References: <4e83369f.5d6de30a.485b.ffffdc29@mx.google.com>
	<CAL9G6WWK-Fas4Yx2q2gPpLvo5T2SxVVNFtvSXeD7j07JbX2srw@mail.gmail.com>
	<CAATJ+fvHQgVMVp1uwxxci61qdCdxG89qK0ja-=jo4JRyGW52cw@mail.gmail.com>
	<4e8b8099.95d1e30a.4bee.0501@mx.google.com>
	<CAATJ+fvs5OXBS9VREpZM=tY+z+n97Pf42uJFqLXbh58GVZ_reA@mail.gmail.com>
	<CAL9G6WWUv+jKY7LkcJMpwMTvV+A-fzwHYJNgpbAkOiQfPoj5ng@mail.gmail.com>
	<CAATJ+fu2W=o_xhsoghK1756ZGCw2g0W_95iYC8OX04AK8jAHLg@mail.gmail.com>
	<4e8f6b0b.c90fe30a.4a1d.26bb@mx.google.com>
	<CAATJ+fvQA4zAcGq+D0+k+OHb8Xsrda5=DATWXbzEO5z=0rWZfw@mail.gmail.com>
	<CAL9G6WWMw3npqjt0WHGhyjaW5Mu=1jA5Y_QduSr3KudZTKLgBw@mail.gmail.com>
	<4e904f71.ce66e30a.69f3.ffff9870@mx.google.com>
	<CAATJ+fstZmoctKrv8Owv53-oEPOn6C8d5FOwMAmLL=7R8UwYzg@mail.gmail.com>
	<4E93481F.8010205@iki.fi>
	<1318278450.16238.15.camel@localhost>
Date: Tue, 11 Oct 2011 08:06:56 +1100
Message-ID: <CAATJ+fub_tmoXxxPKU1vBnRNT=7MEUTn0T=_+iP2koj7N4MBrA@mail.gmail.com>
Subject: Re: [PATCH] af9013 Extended monitoring in set_frontend.
From: Jason Hecker <jwhecker@gmail.com>
To: Malcolm Priestley <tvboxspy@gmail.com>
Cc: Antti Palosaari <crope@iki.fi>,
	Josu Lazkano <josu.lazkano@gmail.com>,
	linux-media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

> Playing with Kaffeine or Mplayer all the devices are fine on the same
> system.

Right, admittedly most of my testing has been done with MythTV.  I
recall about a month ago I could also get corruption with mplayer.

> At the moment, I am going step by step what Myth TV is sending to the
> devices.

Great.  If you want I can replicate your tests here to see what I get.

Antti, my AF9015 chips are integrated on PCI so I can't swap cables
(alas, if only this was my problem!)

Cheers
Jason
