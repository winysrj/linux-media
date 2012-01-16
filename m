Return-path: <linux-media-owner@vger.kernel.org>
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:34310 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754152Ab2APR07 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 16 Jan 2012 12:26:59 -0500
Date: Mon, 16 Jan 2012 17:28:13 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Oliver Neukum <oneukum@suse.de>
Cc: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
	linux-input@vger.kernel.org, Jiri Kosina <jkosina@suse.cz>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [RFC PATCH 2/3] radio-keene: add a driver for the Keene FM
 Transmitter.
Message-ID: <20120116172813.39bd4da6@pyramind.ukuu.org.uk>
In-Reply-To: <201201161411.20514.oneukum@suse.de>
References: <1326716960-4424-1-git-send-email-hverkuil@xs4all.nl>
	<201201161344.37499.oneukum@suse.de>
	<201201161402.06027.hverkuil@xs4all.nl>
	<201201161411.20514.oneukum@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 16 Jan 2012 14:11:20 +0100
Oliver Neukum <oneukum@suse.de> wrote:

> Am Montag, 16. Januar 2012, 14:02:05 schrieb Hans Verkuil:
> > > > +/* Set frequency (if non-0), PA, mute and turn on/off the FM
> > > > transmitter. */ +static int keene_cmd_main(struct keene_device *radio,
> > > > unsigned freq, bool play) +{
> > > > +   unsigned short freq_send = freq ? (freq - 76 * 16000) / 800 : 0;
> > > > +   int ret;
> > > > +
> > > > +   radio->buffer[0] = 0x00;
> > > > +   radio->buffer[1] = 0x50;
> > > > +   radio->buffer[2] = (freq_send >> 8) & 0xff;
> > > > +   radio->buffer[3] = freq_send & 0xff;
> > > 
> > > Please use the endianness macro appropriate here
> > 
> > I don't see any endianness issues here, but perhaps I missed something.
> 
> You are doing the endianness conversion by hand. We have a nice macro

No - it's packing bytes into a buffer from a u16. That doesn't have a
macro.

Alan
