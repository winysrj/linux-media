Return-path: <linux-media-owner@vger.kernel.org>
Received: from pequod.mess.org ([80.229.237.210]:43830 "EHLO pequod.mess.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754515Ab3KCWKH (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 3 Nov 2013 17:10:07 -0500
Date: Sun, 3 Nov 2013 22:10:04 +0000
From: Sean Young <sean@mess.org>
To: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCHv2 06/29] iguanair: shut up a gcc warning on avr32 arch
Message-ID: <20131103221004.GA2248@pequod.mess.org>
References: <1383399097-11615-1-git-send-email-m.chehab@samsung.com>
 <1383399097-11615-7-git-send-email-m.chehab@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1383399097-11615-7-git-send-email-m.chehab@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, Nov 02, 2013 at 11:31:14AM -0200, Mauro Carvalho Chehab wrote:
> 	drivers/media/rc/iguanair.c: In function 'iguanair_set_tx_carrier':
> 	drivers/media/rc/iguanair.c:304: warning: 'sevens' may be used uninitialized in this function
> 
> This is clearly a gcc bug, but it doesn't hurt to add a default line
> at the switch to shut it up.

Mauro, I have a different way of solving this which also cleans up the code
a little. I'll send a patch shortly.

Sean
