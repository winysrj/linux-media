Return-path: <linux-media-owner@vger.kernel.org>
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:42284 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752803AbaLTOv3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 20 Dec 2014 09:51:29 -0500
Date: Sat, 20 Dec 2014 14:51:20 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Frank =?iso-8859-1?Q?Sch=E4fer?= <fschaefer.oss@googlemail.com>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	"linux-media@vger.kernel.org >> Linux Media Mailing List"
	<linux-media@vger.kernel.org>
Subject: Re: [PATCH 1/8] [media] em28xx: fix em28xx-input removal
Message-ID: <20141220145119.GH11285@n2100.arm.linux.org.uk>
References: <20141220124448.GG11285@n2100.arm.linux.org.uk>
 <E1Y2JPH-0006UN-SW@rmk-PC.arm.linux.org.uk>
 <549583AA.9040204@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <549583AA.9040204@googlemail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, Dec 20, 2014 at 03:11:54PM +0100, Frank Schäfer wrote:
> Hi Russel,

I guess you won't mind if I mis-spell your name too...

> I'd prefer to keep the button initialization related stuff together in
> em28xx_init_buttons() and do the cancel_delayed_work_sync() only if we
> have buttons (dev->num_button_polling_addresses).
> That's how we already do it with the IR work struct (see
> em28xx_ir_suspend()).

Provided all places that touch buttons_query_work are properly updated
that's fine, but to me that is fragile and asking for trouble.  It's far
better to ensure that everything is properly initialised so you don't
have to remember to conditionalise every single reference to a work
struct.

In any case, delayed work struct initialisation is cheap - it doesn't
involve any additional memory, it only initialises the various members
of the struct (and the lockdep information for the static key) so there
really is no argument against always initialising delayed works or normal
works, timers, etc to avoid these kinds of bugs.

Anything to keep the code simple is a good thing.

-- 
FTTC broadband for 0.8mile line: currently at 9.5Mbps down 400kbps up
according to speedtest.net.
