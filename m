Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx3.mail.elte.hu ([157.181.1.138]:39306 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752044AbZCOHNu (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 15 Mar 2009 03:13:50 -0400
Date: Sun, 15 Mar 2009 08:13:22 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
	LMML <linux-media@vger.kernel.org>,
	"Rafael J. Wysocki" <rjw@sisk.pl>
Subject: [build failure] Re: [GIT PATCHES for 2.6.29-rc8] V4L/DVB fixes
Message-ID: <20090315071322.GA5337@elte.hu>
References: <20090313134333.563c0565@pedra.chehab.org> <20090315071106.GA4979@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090315071106.GA4979@elte.hu>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


* Ingo Molnar <mingo@elte.hu> wrote:

> FYI, latest upstream (2.6.29-rc8) fails to build with the 
> attached config:
> 
>   MODPOST 531 modules
> ERROR: "dibusb_dib3000mc_frontend_attach" 
> [drivers/media/dvb/dvb-usb/dvb-usb-dibusb-mc.ko] undefined!
> ERROR: "dibusb_dib3000mc_tuner_attach" 
> [drivers/media/dvb/dvb-usb/dvb-usb-dibusb-mc.ko] undefined!
> ERROR: "dibusb_dib3000mc_frontend_attach" 
> [drivers/media/dvb/dvb-usb/dvb-usb-a800.ko] undefined!
> ERROR: "dibusb_dib3000mc_tuner_attach" 
> [drivers/media/dvb/dvb-usb/dvb-usb-a800.ko] undefined!

Note, the tree i tried is post-rc8: v2.6.29-rc8-90-g326d851.

It already includes the latest V4L/DVB fixes.

	Ingo
