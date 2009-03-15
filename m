Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail8.sea5.speakeasy.net ([69.17.117.10]:35599 "EHLO
	mail8.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751604AbZCOXqj (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 15 Mar 2009 19:46:39 -0400
Date: Sun, 15 Mar 2009 16:46:36 -0700 (PDT)
From: Trent Piepho <xyzzy@speakeasy.org>
To: Andy Walls <awalls@radix.net>
cc: Jean Delvare <khali@linux-fr.org>,
	Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: bttv, tvaudio and ir-kbd-i2c probing conflict
In-Reply-To: <1237145673.3314.47.camel@palomino.walls.org>
Message-ID: <Pine.LNX.4.58.0903151637370.28292@shell2.speakeasy.net>
References: <200903151344.01730.hverkuil@xs4all.nl>  <20090315181207.36d951ac@hyperion.delvare>
 <1237145673.3314.47.camel@palomino.walls.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, 15 Mar 2009, Andy Walls wrote:
> On Sun, 2009-03-15 at 18:12 +0100, Jean Delvare wrote:
>
> > This is the typical multifunction device problem. It isn't specifically
> > related to I2C,
>
> But the specific problem that Hans' brings up is precisely a Linux
> kernel I2C subsystem *software* prohibition on two i2c_clients binding
> to the same address on the same adapter.

For a lot of i2c devices, it would be difficult for two drivers to access
the device at the same time without some kind of locking.

If you take the reads and writes of one driver and then intersperse the
reads and writes of another driver, the resulting sequence from the i2c
device's point of view is completely broken.

But, I suppose there are some devices where if the drivers all use
i2c_smbus_read/write_byte/word_data or equivalent atomic transactions
with i2c_transfer(), then you could get away with two drivers talking to
the same chip.
