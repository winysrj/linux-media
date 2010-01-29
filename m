Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:23587 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751011Ab0A2Pk7 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 29 Jan 2010 10:40:59 -0500
Message-ID: <4B630179.3080006@redhat.com>
Date: Fri, 29 Jan 2010 13:40:41 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Jean Delvare <khali@linux-fr.org>
CC: LMML <linux-media@vger.kernel.org>, Daro <ghost-rider@aster.pl>,
	Roman Kellner <muzungu@gmx.net>
Subject: Re: [PATCH] saa7134: Fix IR support of some ASUS TV-FM 7135 variants
References: <20100127120211.2d022375@hyperion.delvare>
In-Reply-To: <20100127120211.2d022375@hyperion.delvare>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Jean Delvare wrote:
> From: Jean Delvare <khali@linux-fr.org>
> Subject: saa7134: Fix IR support of some ASUS TV-FM 7135 variants
> 
> Some variants of the ASUS TV-FM 7135 are handled as the ASUSTeK P7131
> Analog (card=146). However, by the time we find out, some
> card-specific initialization is missed. In particular, the fact that
> the IR is GPIO-based. Set it when we change the card type.
> 
> We also have to move the initialization of IR until after the card
> number has been changed. I hope that this won't cause any problem.

Hi Jean,

Moving the initialization will likely cause regressions. The reason why there
are two init codes there were due to the way the old i2c code used to work.
This got fixed after the i2c rework, but it caused regressions on that time.

The proper way would be to just muve the IR initialization on this board
from init1 to init2, instead of changing it for all other devices.

cheers,
Mauro
