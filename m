Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:51649 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752126AbZFWTLb (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 23 Jun 2009 15:11:31 -0400
Date: Tue, 23 Jun 2009 21:10:52 +0200
From: Daniel =?iso-8859-1?Q?Gl=F6ckner?= <daniel-gl@gmx.net>
To: "Karicheri, Muralidharan" <m-karicheri2@ti.com>
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: sub devices sharing same i2c address
Message-ID: <20090623191052.GA302@daniel.bse>
References: <A69FA2915331DC488A831521EAE36FE40139EDB7B2@dlee06.ent.ti.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <A69FA2915331DC488A831521EAE36FE40139EDB7B2@dlee06.ent.ti.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Jun 23, 2009 at 01:10:11PM -0500, Karicheri, Muralidharan wrote:
> I am having to switch between two sub devices that shares the same i2c
> address. First one is TVP5146 and the other is MT9T031. The second has
> a i2c switch and the evm has a data path switch.

You could try Rodolfo Giometti's i2c bus multiplexing code:
http://i2c.wiki.kernel.org/index.php/I2C_bus_multiplexing

It will create a new i2c_adapter for each output of the i2c switch
and the switch is handled transparently when accessing the devices.

  Daniel
