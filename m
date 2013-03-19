Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.9]:63044 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753967Ab3CSSAQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 19 Mar 2013 14:00:16 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Fabio Porcedda <fabio.porcedda@gmail.com>
Subject: Re: [PATCH 10/10] drivers: misc: use module_platform_driver_probe()
Date: Tue, 19 Mar 2013 17:59:27 +0000
Cc: Geert Uytterhoeven <geert@linux-m68k.org>,
	H Hartley Sweeten <hartleys@visionengravers.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
	"lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>,
	"linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
	"linux-fbdev@vger.kernel.org" <linux-fbdev@vger.kernel.org>,
	"Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
	"Hans-Christian Egtvedt" <hans-christian.egtvedt@atmel.com>,
	Grant Likely <grant.likely@secretlab.ca>
References: <1363266691-15757-1-git-send-email-fabio.porcedda@gmail.com> <201303191648.31527.arnd@arndb.de> <CAHkwnC9FL9W07=n6bWvcwiE058zcBZwqUwtRB-VVNpU0gv0mNw@mail.gmail.com>
In-Reply-To: <CAHkwnC9FL9W07=n6bWvcwiE058zcBZwqUwtRB-VVNpU0gv0mNw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201303191759.27762.arnd@arndb.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tuesday 19 March 2013, Fabio Porcedda wrote:
> On Tue, Mar 19, 2013 at 5:48 PM, Arnd Bergmann <arnd@arndb.de> wrote:
> > On Tuesday 19 March 2013, Geert Uytterhoeven wrote:
> >> Hmm, so we may have drivers that (now) work perfectly fine with
> >> module_platform_driver_probe()/platform_driver_probe(), but will start
> >> failing suddenly in the future?
> >
> > They will fail if someone changes the initialization order. That would
> > already break drivers before deferred probing support (and was the reason
> > we added feature in the first place), but now we can be much more liberal
> > with the order in which drivers are initialized, except when they are
> > using platform_driver_probe()
> >
> >> I guess we need a big fat WARN_ON(-EPROBE_DEFER) in
> >> platform_driver_probe() to catch these?
> >
> > Yes, very good idea.
> 
> If it's fine, I'll send a patch for that.

That would be cool, yes. I looked at it earlier (after sending my email above)
and couldn't find an easy way to do it though, because platform_drv_probe
does not know whether it is called from platform_driver_probe or not.

Maybe using something other than platform_driver_register would work here.

	Arnd
