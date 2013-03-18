Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:36566 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932837Ab3CRVRq (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 18 Mar 2013 17:17:46 -0400
Date: Mon, 18 Mar 2013 18:17:39 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: Devin Heitmueller <dheitmueller@kernellabs.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Frank =?UTF-8?B?U2Now6RmZXI=?= <fschaefer.oss@googlemail.com>
Subject: Re: [PATCH 0/3] em28xx: add support for two buses on em2874 and
 upper
Message-ID: <20130318181739.7bccd1d4@redhat.com>
In-Reply-To: <CAGoCfiwB9BT2mDQqu2cwsRM-0eraqyxdY0V3fnH+S2RSNiGSdQ@mail.gmail.com>
References: <1362480928-20382-1-git-send-email-mchehab@redhat.com>
	<CAGoCfiwB9BT2mDQqu2cwsRM-0eraqyxdY0V3fnH+S2RSNiGSdQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Tue, 5 Mar 2013 10:43:10 -0500
Devin Heitmueller <dheitmueller@kernellabs.com> escreveu:

> 2013/3/5 Mauro Carvalho Chehab <mchehab@redhat.com>:
> > The em2874 chips and upper have 2 buses. On all known devices, bus 0 is
> > currently used only by eeprom, and bus 1 for the rest. Add support to
> > register both buses.
> 
> Did you add a mutex to ensure that both buses cannot be used at the
> same time?  Because using the bus requires you to toggle a register
> (thus you cannot be using both busses at the same time), you cannot
> rely on the existing i2c adapter lock anymore.
> 
> You don't want a situation where something is actively talking on bus
> 0, and then something else tries to talk on bus 1, flips the register
> bit and then the thread talking on bus 0 starts failing.

Good point. The I2C mutex won't solve for this case. I'll add a mutex
there at the xfer function on a separate patch.

Cheers,
Mauro
