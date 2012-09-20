Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wg0-f42.google.com ([74.125.82.42]:61996 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750819Ab2ITHKr (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 20 Sep 2012 03:10:47 -0400
Received: by wgbfm10 with SMTP id fm10so189562wgb.1
        for <linux-media@vger.kernel.org>; Thu, 20 Sep 2012 00:10:46 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20120920033206.GA9407@b20223-02.ap.freescale.net>
References: <1347957978.2529.4.camel@pizza.hi.pengutronix.de>
	<20120920033206.GA9407@b20223-02.ap.freescale.net>
Date: Thu, 20 Sep 2012 09:10:46 +0200
Message-ID: <CACKLOr0BATxZc3xwE44JJowTcOf1N4XT1oXGW9Gj0n0s-wSd_w@mail.gmail.com>
Subject: Re: [GIT PULL v2] Initial i.MX5/CODA7 support for the CODA driver
From: javier Martin <javier.martin@vista-silicon.com>
To: Richard Zhao <richard.zhao@freescale.com>
Cc: Philipp Zabel <p.zabel@pengutronix.de>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	linux-media@vger.kernel.org,
	=?ISO-8859-1?Q?Ezequiel_Garc=EDa?= <elezegarcia@gmail.com>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Richard,

On 20 September 2012 05:32, Richard Zhao <richard.zhao@freescale.com> wrote:
> why is it a request-pull?

After 5 version of Philipp's patches we have agreed they are good
enough to be merged; they don't break anything related to the old
codadx6 while provide support for the new coda7:
http://comments.gmane.org/gmane.linux.drivers.video-input-infrastructure/53627

The pull request is a way to tell Mauro this is ready to be merged in
his linux-media tree and making things easier for him.

Regards.
-- 
Javier Martin
Vista Silicon S.L.
CDTUC - FASE C - Oficina S-345
Avda de los Castros s/n
39005- Santander. Cantabria. Spain
+34 942 25 32 60
www.vista-silicon.com
