Return-path: <linux-media-owner@vger.kernel.org>
Received: from impaqm5.telefonica.net ([213.4.138.21]:35161 "EHLO
	telefonica.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753396Ab2ECRDx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 3 May 2012 13:03:53 -0400
From: Jose Alberto Reguero <jareguero@telefonica.net>
To: Devin Heitmueller <dheitmueller@kernellabs.com>
Cc: Antti Palosaari <Antti.Palosaari@iki.fi>,
	linux-media <linux-media@vger.kernel.org>
Subject: Re: common DVB USB issues we has currently
Date: Thu, 03 May 2012 19:03:39 +0200
Message-ID: <1866189.GQUT4OxER7@jar7.dominio>
In-Reply-To: <CAGoCfiw9h8ZqAnrdpg3J8rtnna=JiXj6JYL-gU58xS2HmMuT_w@mail.gmail.com>
References: <4FA293AA.5000601@iki.fi> <CAGoCfiw9h8ZqAnrdpg3J8rtnna=JiXj6JYL-gU58xS2HmMuT_w@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Jueves, 3 de mayo de 2012 10:48:43 Devin Heitmueller escribi�:
> Hi Antti,
> 
> On Thu, May 3, 2012 at 10:18 AM, Antti Palosaari
> 
> > 1)
> > Current static structure is too limited as devices are more dynamics
> > nowadays. Driver should be able to probe/read from eeprom device
> > configuration.
> > 
> > Fixing all of those means rather much work - I think new version of DVB
> > USB
> > is needed.
> > 
> > http://www.mail-archive.com/linux-media@vger.kernel.org/msg44996.html
> 
> What does this link above have to do with problem #1?  Did you perhaps
> cut/paste the wrong link?
> 
> > 2)
> > Suspend/resume is not supported and crashes Kernel. I have no idea what is
> > wrong here and what is needed. But as it has been long term known problem
> > I
> > suspect it is not trivial.
> > 
> > http://www.spinics.net/lists/linux-media/msg10293.html
> 
> I doubt this is a dvb-usb problem, but rather something specific to
> the realtek parts (suspend/resume does work with other devices that
> rely on dvb-usb).
> 
> Cheers,
> 
> Devin

I have the resume problem with the terratec H7.

http://www.mail-archive.com/linux-media@vger.kernel.org/msg45590.html

Jose Alberto
