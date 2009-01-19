Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail7.sea5.speakeasy.net ([69.17.117.9]:50536 "EHLO
	mail7.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754769AbZASAi0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 18 Jan 2009 19:38:26 -0500
Date: Sun, 18 Jan 2009 16:38:24 -0800 (PST)
From: Trent Piepho <xyzzy@speakeasy.org>
To: Hans Verkuil <hverkuil@xs4all.nl>
cc: CityK <cityk@rogers.com>, Michael Krufky <mkrufky@linuxtv.org>,
	hermann pitton <hermann-pitton@arcor.de>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Josh Borke <joshborke@gmail.com>,
	David Lonie <loniedavid@gmail.com>, linux-media@vger.kernel.org
Subject: Re: KWorld ATSC 115 all static
In-Reply-To: <200901182011.11960.hverkuil@xs4all.nl>
Message-ID: <Pine.LNX.4.58.0901181304100.11165@shell2.speakeasy.net>
References: <7994.62.70.2.252.1232028088.squirrel@webmail.xs4all.nl>
 <200901171720.03890.hverkuil@xs4all.nl> <49737088.7060800@rogers.com>
 <200901182011.11960.hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, 18 Jan 2009, Hans Verkuil wrote:
> I've taken a look at Mike's workaround and that will indeed no longer
> work. I suspect that the core problem is related to the
> SAA7134_BOARD_KWORLD_ATSC110 case in saa7134_board_init2 in
> saa7134-cards.c. There the 'tuner is enabled', whatever that means. I'm
> beginning to suspect that this code should perhaps be executed before
> the tuner module is loaded. Does anyone know more about what is going
> on here? If my analysis is correct, then this should be executed

IIRC, some hybrid cards have the ability to power down or hold in reset the
analog and/or digital demod when they are not in use.

Since the module load order between tuner and the bridge can't be depended
on, there really should be another way to make sure all i2c devices are out
of reset before scanning for them.

If the demod is controlled by a bridge gpio, then just turn it on _before_
adding the I2C adapter.  Then the chip will be there when the scan happens.
Might need to check how long the demod takes to some out of reset and add a
delay.

If one I2C chip is controlled by another I2C chip on the same bus (e.g.,
analog demod controlled by a gpio on the digital demod), then there is
currently no way to scan for it.  Maybe if the i2c core gave us a "rescan"
function?  Not a bad idea really, other busses have this.

But I think trying to making scanning work with these complex inter-device
dependencies is just perpetuating the mistake of scanning for devices in
the first place.

Much better would be if the tuner driver would let us use i2c_new_device()
or an attach function like the dvb drivers use.  One of the reasons why I
think refactoring the hybrid tuners to use the v4l-style tuner module from
dvb style attachment was a move in the wrong direction.
