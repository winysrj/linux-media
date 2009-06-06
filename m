Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-in-09.arcor-online.net ([151.189.21.49]:60691 "EHLO
	mail-in-09.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752606AbZFFX0Z (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 6 Jun 2009 19:26:25 -0400
Subject: Re: RFC: proposal for new i2c.h macro to initialize i2c address
	lists  on the fly
From: hermann pitton <hermann-pitton@arcor.de>
To: Jon Smirl <jonsmirl@gmail.com>
Cc: Hans Verkuil <hverkuil@xs4all.nl>, linux-i2c@vger.kernel.org,
	linux-media@vger.kernel.org
In-Reply-To: <9e4733910906061520o7b0b2858wf4530cf672b1adc9@mail.gmail.com>
References: <200906061500.49338.hverkuil@xs4all.nl>
	 <9e4733910906061520o7b0b2858wf4530cf672b1adc9@mail.gmail.com>
Content-Type: text/plain
Date: Sun, 07 Jun 2009 01:23:02 +0200
Message-Id: <1244330582.17786.12.camel@pc07.localdom.local>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

Am Samstag, den 06.06.2009, 18:20 -0400 schrieb Jon Smirl:
> On Sat, Jun 6, 2009 at 9:00 AM, Hans Verkuil<hverkuil@xs4all.nl> wrote:
> > Hi all,
> >
> > For video4linux we sometimes need to probe for a single i2c address.
> > Normally you would do it like this:
> 
> Why does video4linux need to probe to find i2c devices? Can't the
> address be determined by knowing the PCI ID of the board?

NO, are you dreaming ?

Even the m$ attempts over additional stuff, that _eventually_ conforms
to something in the eeprom are doomed.

That is also not about video4linux anymore, since decades now soon, but
about v4l-dvb.

For real interesting stuff it does not work anymore and never did.

You should have a look at real hardware.

Cheers,
Hermann


