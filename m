Return-path: <linux-media-owner@vger.kernel.org>
Received: from cdptpa-omtalb.mail.rr.com ([75.180.132.120]:40040 "EHLO
	cdptpa-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752559AbZBECzW (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 4 Feb 2009 21:55:22 -0500
Date: Wed, 4 Feb 2009 20:55:17 -0600
From: David Engel <david@istwok.net>
To: CityK <cityk@rogers.com>
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
	V4L <video4linux-list@redhat.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Michael Krufky <mkrufky@linuxtv.org>,
	Josh Borke <joshborke@gmail.com>,
	David Lonie <loniedavid@gmail.com>, linux-media@vger.kernel.org
Subject: Re: KWorld ATSC 115 all static
Message-ID: <20090205025517.GA3715@opus.istwok.net>
References: <7994.62.70.2.252.1232028088.squirrel@webmail.xs4all.nl> <496FE555.7090405@rogers.com> <496FFCE2.8010902@rogers.com> <200901171720.03890.hverkuil@xs4all.nl> <49737088.7060800@rogers.com> <20090202235820.GA9781@opus.istwok.net> <4987DE4E.2090902@rogers.com> <20090203172225.GA16385@opus.istwok.net> <4989149C.3080802@rogers.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4989149C.3080802@rogers.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Feb 03, 2009 at 11:07:56PM -0500, CityK wrote:
> David Engel wrote:
> > I will try it with MythTV.
> 
> Thanks David.

OK.  With Hans' v4l-dvb-kworld driver, MythTV works, but with a big
caveat.  I have to unload the saa7134-alsa, saa7134-dvb, saa7134 and
tuner-simple modules, reload them and then run tvtime before MythTV
works.  If I do things in any other order, MythTV doesn't report any
errors, but it only records static.  In addition, if I run MythTV
before running tvtime, tvtime only shows static too until I reload the
modules.  This pattern held for 3 reboots.

David
-- 
David Engel
david@istwok.net
