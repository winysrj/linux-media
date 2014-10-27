Return-path: <linux-media-owner@vger.kernel.org>
Received: from bar.sig21.net ([80.81.252.164]:44561 "EHLO bar.sig21.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751081AbaJ0QXE (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 27 Oct 2014 12:23:04 -0400
Date: Mon, 27 Oct 2014 17:22:52 +0100
From: Johannes Stezenbach <js@linuxtv.org>
To: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Michael Ira Krufky <mkrufky@linuxtv.org>,
	linux-media <linux-media@vger.kernel.org>,
	Richard Vollkommer <linux@hauppauge.com>,
	Devin Heitmueller <dheitmueller@kernellabs.com>
Subject: Re: [PATCH 1/3] xc5000: tuner firmware update
Message-ID: <20141027162252.GA9984@linuxtv.org>
References: <BLU437-SMTP74723F476D15D78EEEA959BA900@phx.gbl>
 <20141027094619.69851745.m.chehab@samsung.com>
 <CAOcJUbyK7Y5=fMfEGv5rhC3bPpeiiS3Mp1z+8cVfHoqy-opy5Q@mail.gmail.com>
 <20141027135727.297ba10a.m.chehab@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141027135727.297ba10a.m.chehab@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Oct 27, 2014 at 01:57:27PM -0200, Mauro Carvalho Chehab wrote:
> Em Mon, 27 Oct 2014 10:25:48 -0400
> Michael Ira Krufky <mkrufky@linuxtv.org> escreveu:
> 
> > I like the idea of supporting older firmware revisions if the new one
> > is not present, but, the established president for this sort of thing
> > has always been to replace older firmware with newer firmware without
> > backward compatibility support for older binaries.
> 
> No, we're actually adding backward support. There are some drivers
> already with it. See for example xc4000 (changeset da7bfa2c5df).
> 
> > Although the current driver can work with both old and new firmware
> > versions, this hasn't been the case in the past, and won't always be
> > the case with future firmware revisions.
> 
> Yeah, we did a very crap job breaking backward firmware compat in
> the past. We're not doing it anymore ;)
> 
> > Hauppauge has provided links to the new firmware for both the XC5000
> > and XC5000C chips along with licensing.  Maybe instead, we can just
> > upstream those into the linux-firmware packages for distribution.
> 
> Upstreaming to linux-firmware was done already for the previous firmwares.
> The firmwares at linux-firmware for xc5000 and xc5000c were merged back 
> there for 3.17 a few weeks ago.
> 
> Feel free to submit them a new version.
> 
> > I don't think supporting two different firmware versions is a good
> > idea for the case of the xc5000 driver.
> 
> Why not? It should work as-is with either version. We can always add
> some backward compat code if needed.

FWIW, Linus recently addressed the topic wrt wireless firmware:
http://article.gmane.org/gmane.linux.kernel.wireless.general/126794


HTH,
Johannes
