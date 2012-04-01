Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout-de.gmx.net ([213.165.64.22]:42145 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751146Ab2DAOml convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 1 Apr 2012 10:42:41 -0400
From: "Hans-Frieder Vogt" <hfvogt@gmx.net>
To: Michael =?iso-8859-1?q?B=FCsch?= <m@bues.ch>
Subject: Re: [GIT PULL FOR 3.5] AF9035/AF9033/TUA9001 => TerraTec Cinergy T Stick [0ccd:0093]
Date: Sun, 1 Apr 2012 16:42:34 +0200
Cc: Antti Palosaari <crope@iki.fi>, linux-media@vger.kernel.org
References: <4F75A7FE.8090405@iki.fi> <4F784A13.5000704@iki.fi> <20120401151153.637d2393@milhouse>
In-Reply-To: <20120401151153.637d2393@milhouse>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Message-Id: <201204011642.35087.hfvogt@gmx.net>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Michael,

Am Sonntag, 1. April 2012 schrieb Michael Büsch:
> On Sun, 01 Apr 2012 15:29:07 +0300
> 
> Antti Palosaari <crope@iki.fi> wrote:
> > buf[1] = msg[0].addr << 1;
> > Maybe you have given I2C address as a "8bit" format?
> 
> Uhh, the address is leftshifted by one.
> So I changed the i2c address from 0xC0 to 0x60.
> 
> The i2c write seems to work now. At least it doesn't complain anymore
> and it sorta seems to tune to the right frequency.
> But i2c read may be broken.
> I had to enable the commented read code, but it still fails to read
> the VCO calibration value:
> 
> [ 3101.940765] i2c i2c-8: Failed to read VCO calibration value (got 20)
> 
> It doesn't run into this check on the other af903x driver.
> So I suspect an i2c read issue here.

I would first uncomment the i2c read functionality in Antti's driver!

> 
> Attached: The patches.

Cheers,

Hans-Frieder Vogt                       e-mail: hfvogt <at> gmx .dot. net
