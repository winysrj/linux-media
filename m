Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:46243 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754174Ab1JFCjP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 5 Oct 2011 22:39:15 -0400
Received: by iakk32 with SMTP id k32so2455955iak.19
        for <linux-media@vger.kernel.org>; Wed, 05 Oct 2011 19:39:14 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAL9G6WXX2eGmoT+ozv1F0JQdSV5JPwbB0vn70UL+ghgkLGsYQg@mail.gmail.com>
References: <4e83369f.5d6de30a.485b.ffffdc29@mx.google.com>
	<CAL9G6WWK-Fas4Yx2q2gPpLvo5T2SxVVNFtvSXeD7j07JbX2srw@mail.gmail.com>
	<CAATJ+fvHQgVMVp1uwxxci61qdCdxG89qK0ja-=jo4JRyGW52cw@mail.gmail.com>
	<4e8b8099.95d1e30a.4bee.0501@mx.google.com>
	<CAATJ+fvs5OXBS9VREpZM=tY+z+n97Pf42uJFqLXbh58GVZ_reA@mail.gmail.com>
	<CAL9G6WWUv+jKY7LkcJMpwMTvV+A-fzwHYJNgpbAkOiQfPoj5ng@mail.gmail.com>
	<CAATJ+fu2W=o_xhsoghK1756ZGCw2g0W_95iYC8OX04AK8jAHLg@mail.gmail.com>
	<CAL9G6WXX2eGmoT+ozv1F0JQdSV5JPwbB0vn70UL+ghgkLGsYQg@mail.gmail.com>
Date: Thu, 6 Oct 2011 13:39:14 +1100
Message-ID: <CAATJ+fve_qhaeCJuaJPva_2K=2PxF61_3aFVomZm4XsAEt8MaA@mail.gmail.com>
Subject: Re: [PATCH] af9013 frontend tuner bus lock
From: Jason Hecker <jwhecker@gmail.com>
To: Josu Lazkano <josu.lazkano@gmail.com>
Cc: Malcolm Priestley <tvboxspy@gmail.com>,
	linux-media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

> http://dl.dropbox.com/u/1541853/VID_20111006_004447.3gp

That looks very familiar!  Does it occur on tuner A or B?

> I get this I2C messages:
> # tail -f /var/log/messages
> Oct  5 20:16:44 htpc kernel: [  534.168957] af9013: I2C read failed reg:d330

As far as I know I never had any such messages.  Maybe though the
debugging isn't enabled properly.

> There are lots of ber and unc bits, I have connected the TV to the
> same wire and there is a good signal.

Yes, your TV might have a better receiver though - I have the same
problem, if my TV decoding is OK but the signal is weak then my DVB
cards have problems.  I have solved this signal problem by using
quad-shield cable and F-connectors and proper metal can splitters so
now everything gets a good signal.  I am pretty sure my issues are not
signal related because Tuner A is fine until tuner B is enabled and
tuner B always records a very low error signal (usually not even one
visible error).
