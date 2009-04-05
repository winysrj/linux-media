Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp4-g21.free.fr ([212.27.42.4]:60912 "EHLO smtp4-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750930AbZDERlm (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 5 Apr 2009 13:41:42 -0400
Date: Sun, 5 Apr 2009 19:36:25 +0200
From: Jean-Francois Moine <moinejf@free.fr>
To: Anders Blomdell <anders.blomdell@control.lth.se>
Cc: Erik =?ISO-8859-1?Q?Andr=E9n?= <erik.andren@gmail.com>,
	Andy Shevchenko <andy.shevchenko@gmail.com>,
	Thomas Kaiser <v4l@kaiser-linux.li>,
	Thomas Champagne <lafeuil@gmail.com>,
	Linux Media <linux-media@vger.kernel.org>,
	Richard Case <rich@racitup.com>
Subject: Re: topro 6800 driver
Message-ID: <20090405193625.57c3b1fd@free.fr>
In-Reply-To: <49D74485.8000004@control.lth.se>
References: <5ec8ebd50903271106n14f0e2b7m1495ef135be0cd90@mail.gmail.com>
	<49CD2868.9080502@kaiser-linux.li>
	<5ec8ebd50903311144h316c7e3bmd30ce2c3d5a268ee@mail.gmail.com>
	<49D4EAB2.4090206@control.lth.se>
	<49D66C83.6000700@control.lth.se>
	<49D67781.6030807@gmail.com>
	<49D74485.8000004@control.lth.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, 04 Apr 2009 13:29:09 +0200
Anders Blomdell <anders.blomdell@control.lth.se> wrote:
> >> Jean-Francois: feel free to add this to gspca if it lives up to
> >> your standards, otherwise tell me what needs to be changed.

Hi Anders,

Your driver seems fine, but, to add it to gspca, I need a full patch,
i.e the diff of the source, Kconfig, Makefile, webcam reference in
gspca.txt (linux/Documentation/..) and your SOB (signature).

You should also ask Mauro to add you as a maintainer with a diff of the
MAINTAINERS file from the last Linux kernel.

Cheers.

-- 
Ken ar c'hentañ	|	      ** Breizh ha Linux atav! **
Jef		|		http://moinejf.free.fr/
