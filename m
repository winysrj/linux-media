Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:61541 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751224Ab2AGIBp (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 7 Jan 2012 03:01:45 -0500
Received: by iaeh11 with SMTP id h11so3847009iae.19
        for <linux-media@vger.kernel.org>; Sat, 07 Jan 2012 00:01:44 -0800 (PST)
Date: Sat, 7 Jan 2012 02:01:36 -0600
From: Jonathan Nieder <jrnieder@gmail.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Patrick Boettcher <pboettcher@kernellabs.com>,
	"Igor M. Liplianin" <liplianin@me.by>, linux-media@vger.kernel.org
Subject: [PATCH 0/2] Re: [RFC/PATCH] [media] dw2102: use symbolic names for
 dw2102_table indices
Message-ID: <20120107080136.GA10247@elie.hsd1.il.comcast.net>
References: <20111222215356.GA4499@rotes76.wohnheim.uni-kl.de>
 <20111222234446.GB10497@elie.Belkin>
 <201112231820.03693.pboettcher@kernellabs.com>
 <20111223230045.GE21769@elie.Belkin>
 <4F06F512.9090704@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F06F512.9090704@redhat.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

(-cc: Eduard)
Mauro Carvalho Chehab wrote:

> This looks like a good idea to me. From time to time, when conflict rises,
> sometimes those dvb-usb tables with the magic numbers got unnoticed
> conflicts.
>
> So, I'm picking this one.

Yay. :)

> It should be noticed that this is a common constructor used inside the
> dvb-usb drivers. IMHO, an approach like that should be extended to the
> other drivers as well.

Here's a few.  Many more to go.

Jonathan Nieder (2):
  [media] a800: use symbolic names for a800_table indices
  [media] af9005, af9015: use symbolic names for USB id table indices

 drivers/media/dvb/dvb-usb/a800.c   |   21 ++-
 drivers/media/dvb/dvb-usb/af9005.c |   14 ++-
 drivers/media/dvb/dvb-usb/af9015.c |  316 +++++++++++++++++++++++++++---------
 3 files changed, 260 insertions(+), 91 deletions(-)
