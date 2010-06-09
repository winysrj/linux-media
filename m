Return-path: <linux-media-owner@vger.kernel.org>
Received: from poutre.nerim.net ([62.4.16.124]:61396 "EHLO poutre.nerim.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752994Ab0FIRjJ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 9 Jun 2010 13:39:09 -0400
Date: Wed, 9 Jun 2010 19:39:07 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Wolfram Sang <w.sang@pengutronix.de>
Cc: Linux I2C <linux-i2c@vger.kernel.org>,
	LMML <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: [PATCH 2/2] V4L/DVB: Use custom I2C probing function mechanism
Message-ID: <20100609193907.521cd4a8@hyperion.delvare>
In-Reply-To: <20100609150540.GB31319@pengutronix.de>
References: <20100608100100.35bdae0f@hyperion.delvare>
	<20100609150540.GB31319@pengutronix.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Wolfram,

On Wed, 9 Jun 2010 17:05:40 +0200, Wolfram Sang wrote:
> Hi Jean,
> 
> On Tue, Jun 08, 2010 at 10:01:00AM +0200, Jean Delvare wrote:
> > Now that i2c-core offers the possibility to provide custom probing
> > function for I2C devices, let's make use of it.
> > 
> > Signed-off-by: Jean Delvare <khali@linux-fr.org>
> > Acked-by: Mauro Carvalho Chehab <mchehab@redhat.com>
> 
> If this custom function is in i2c-core, maybe it should be documented?

What kind of documentation would you expect for a one-line function?
Where, and aimed at who?

Patch welcome ;)

-- 
Jean Delvare
