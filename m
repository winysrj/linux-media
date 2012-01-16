Return-path: <linux-media-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:50970 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752066Ab2APNJb (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 16 Jan 2012 08:09:31 -0500
From: Oliver Neukum <oneukum@suse.de>
To: Hans Verkuil <hverkuil@xs4all.nl>
Subject: Re: [RFC PATCH 2/3] radio-keene: add a driver for the Keene FM Transmitter.
Date: Mon, 16 Jan 2012 14:11:20 +0100
Cc: linux-media@vger.kernel.org, linux-input@vger.kernel.org,
	Jiri Kosina <jkosina@suse.cz>,
	Hans Verkuil <hans.verkuil@cisco.com>
References: <1326716960-4424-1-git-send-email-hverkuil@xs4all.nl> <201201161344.37499.oneukum@suse.de> <201201161402.06027.hverkuil@xs4all.nl>
In-Reply-To: <201201161402.06027.hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201201161411.20514.oneukum@suse.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am Montag, 16. Januar 2012, 14:02:05 schrieb Hans Verkuil:
> > > +/* Set frequency (if non-0), PA, mute and turn on/off the FM
> > > transmitter. */ +static int keene_cmd_main(struct keene_device *radio,
> > > unsigned freq, bool play) +{
> > > +   unsigned short freq_send = freq ? (freq - 76 * 16000) / 800 : 0;
> > > +   int ret;
> > > +
> > > +   radio->buffer[0] = 0x00;
> > > +   radio->buffer[1] = 0x50;
> > > +   radio->buffer[2] = (freq_send >> 8) & 0xff;
> > > +   radio->buffer[3] = freq_send & 0xff;
> > 
> > Please use the endianness macro appropriate here
> 
> I don't see any endianness issues here, but perhaps I missed something.

You are doing the endianness conversion by hand. We have a nice macro
for that that assures that special swapping cpu instructions will be used.

	Regards
		Oliver
