Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:59118 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388012AbeGWTjj (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 23 Jul 2018 15:39:39 -0400
Date: Mon, 23 Jul 2018 15:36:57 -0300
From: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
To: Pavel Machek <pavel@ucw.cz>
Cc: pali.rohar@gmail.com, sre@kernel.org,
        kernel list <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        linux-omap@vger.kernel.org, tony@atomide.com, khilman@kernel.org,
        aaro.koskinen@iki.fi, ivo.g.dimitrov.75@gmail.com,
        patrikbachan@gmail.com, serge@hallyn.com, abcloriens@gmail.com,
        clayton@craftyguy.net, martijn@brixit.nl,
        sakari.ailus@linux.intel.com,
        Filip =?UTF-8?B?TWF0aWpldmnEhw==?= <filip.matijevic.pz@gmail.com>,
        mchehab@s-opensource.com, sakari.ailus@iki.fi,
        linux-media@vger.kernel.org, hans.verkuil@cisco.com
Subject: Re: [PATCH, libv4l]: Make libv4l2 usable on devices with complex
 pipeline
Message-ID: <20180723153649.73337c0f@coco.lan>
In-Reply-To: <20180719205344.GA12098@amd>
References: <20180708213258.GA18217@amd>
        <20180719205344.GA12098@amd>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Pavel,

Em Thu, 19 Jul 2018 22:53:44 +0200
Pavel Machek <pavel@ucw.cz> escreveu:

> On Sun 2018-07-08 23:32:58, Pavel Machek wrote:
> > 
> > Add support for opening multiple devices in v4l2_open(), and for
> > mapping controls between devices.
> > 
> > This is necessary for complex devices, such as Nokia N900.
> > 
> > Signed-off-by: Pavel Machek <pavel@ucw.cz>  
> 
> Ping?
> 
> There's a lot of work to do on libv4l2... timely patch handling would
> be nice.

As we're be start working at the new library in order to support
complex cameras, and I don't want to prevent you keeping doing your
work, IMHO the best way to keep doing it would be to create two
libv4l2 forks:

	- one to be used by you - meant to support N900 camera;
	- another one to be used by Google/Intel people that will
	  be working at the Complex camera.

This way, we can proceed with the development without causing
instability to v4l-utils. Once we have the projects done at the
separate repositories, we can work on merging them back upstream.

So, please send me, in priv, a .ssh key for me to add you an
account at linuxtv.org. I'll send you instructions about how to
use the new account.

Thanks,
Mauro
