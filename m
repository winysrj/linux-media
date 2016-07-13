Return-path: <linux-media-owner@vger.kernel.org>
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:41650 "EHLO
	out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750838AbcGMB41 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 12 Jul 2016 21:56:27 -0400
Date: Wed, 13 Jul 2016 04:56:00 +0300
From: Andrey Utkin <andrey_utkin@fastmail.com>
To: Joe Perches <joe@perches.com>
Cc: Andrey Utkin <andrey.utkin@corp.bluecherry.net>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Bluecherry Maintainers <maintainers@bluecherrydvr.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	"David S. Miller" <davem@davemloft.net>,
	Kalle Valo <kvalo@codeaurora.org>,
	Jiri Slaby <jslaby@suse.com>,
	Geert Uytterhoeven <geert@linux-m68k.org>,
	Guenter Roeck <linux@roeck-us.net>,
	Kozlov Sergey <serjk@netup.ru>,
	Ezequiel Garcia <ezequiel@vanguardiasur.com.ar>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Krzysztof =?utf-8?Q?Ha=C5=82asa?= <khalasa@piap.pl>,
	linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
	devel@driverdev.osuosl.org, linux-pci@vger.kernel.org,
	kernel-mentors@selenic.com
Subject: Re: [PATCH v4] [media] pci: Add tw5864 driver
Message-ID: <20160713015600.GG5934@zver>
References: <20160711151714.5452-1-andrey.utkin@corp.bluecherry.net>
 <1468255253.8360.142.camel@perches.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1468255253.8360.142.camel@perches.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Jul 11, 2016 at 09:40:53AM -0700, Joe Perches wrote:
> Each of these blocks will start with the dev_<level> prefix
> and the subsequent lines will not have the same prefix

Yes. I have checked how it looks before submitting, but I didn't see
this as a problem. I don't mind changing that (anyway I have found few
micro-issues with checkpatch --strict and would like to resubmit), but
would like to hear some second opinion.

> It also might be better to issue something like a single
> line dev_warn referring to the driver code and just leave
> this comment in the driver sources.
> 
> Something like:
> 
> 	dev_warn(&pci_dev->dev,
> 		"This driver has known defects in video quality\n");

Things get complicated if you consider mainstream distros and their
years-behind kernels. The simplest way to preserve correspondence
between state of driver and such notice is to contain the notice in the
compiled driver. I hope the state of affairs will change to better
someday :)
