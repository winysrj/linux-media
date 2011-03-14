Return-path: <mchehab@pedra>
Received: from moutng.kundenserver.de ([212.227.17.9]:63160 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751272Ab1CNQWN (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 14 Mar 2011 12:22:13 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 2/7] davinci: eliminate use of IO_ADDRESS() on sysmod
Date: Mon, 14 Mar 2011 17:21:51 +0100
Cc: Manjunath Hadli <manjunath.hadli@ti.com>,
	LMML <linux-media@vger.kernel.org>,
	Kevin Hilman <khilman@deeprootsystems.com>,
	Sekhar Nori <nsekhar@ti.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	dlos <davinci-linux-open-source@linux.davincidsp.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>
References: <1300110947-16229-1-git-send-email-manjunath.hadli@ti.com>
In-Reply-To: <1300110947-16229-1-git-send-email-manjunath.hadli@ti.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201103141721.52033.arnd@arndb.de>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Monday 14 March 2011, Manjunath Hadli wrote:
> Current devices.c file has a number of instances where
> IO_ADDRESS() is used for system module register
> access. Eliminate this in favor of a ioremap()
> based access.
> 
> Consequent to this, a new global pointer davinci_sysmodbase
> has been introduced which gets initialized during
> the initialization of each relevant SoC
> 
> Signed-off-by: Manjunath Hadli <manjunath.hadli@ti.com>

The change looks good, it's definitely a step in the right
direction.

Acked-by: Arnd Bergmann <arnd@arndb.de>


I think you can go even further:

* A straightforward change would be to move davinci_sysmodbase
  into a local variable of the davinci_setup_mmc function,
  which I believe is the only user. Then you can ioremap
  and iounmap it directly there.

* If you need to access sysmod in multiple places, a nicer
  way would be to make the virtual address pointer static,
  and export the accessor functions for it, rather than
  having a global pointer.

	Arnd
