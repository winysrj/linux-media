Return-path: <linux-media-owner@vger.kernel.org>
Received: from out5.smtp.messagingengine.com ([66.111.4.29]:35770 "EHLO
	out5.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756449Ab1JQWdV (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 17 Oct 2011 18:33:21 -0400
Date: Mon, 17 Oct 2011 15:31:36 -0700
From: Greg KH <greg@kroah.com>
To: Piotr Chmura <chmooreck@poczta.onet.pl>
Cc: Stefan Richter <stefanr@s5r6.in-berlin.de>,
	Greg KH <gregkh@suse.de>,
	Devin Heitmueller <dheitmueller@kernellabs.com>,
	Mauro Carvalho Chehab <maurochehab@gmail.com>,
	Patrick Dickey <pdickeybeta@gmail.com>,
	LMML <linux-media@vger.kernel.org>, devel@driverdev.osuosl.org
Subject: Re: [PATCH 0/7] Staging submission: PCTV 74e drivers and some
 cleanup (was: Staging submission: PCTV 80e and PCTV 74e drivers)
Message-ID: <20111017223136.GA20939@kroah.com>
References: <4E7F1FB5.5030803@gmail.com>
 <CAGoCfixneQG=S5wy2qZZ50+PB-QNTFx=GLM7RYPuxfXtUy6Ecg@mail.gmail.com>
 <4E7FF0A0.7060004@gmail.com>
 <CAGoCfizyLgpEd_ei-SYEf6WWs5cygQJNjKPNPOYOQUqF773D4Q@mail.gmail.com>
 <20110927094409.7a5fcd5a@stein>
 <20110927174307.GD24197@suse.de>
 <20110927213300.6893677a@stein>
 <4E99F2F6.9000307@poczta.onet.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E99F2F6.9000307@poczta.onet.pl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, Oct 15, 2011 at 10:54:14PM +0200, Piotr Chmura wrote:
> [PATCH 1/7] pull as102 driver fromhttp://kernellabs.com/hg/~dheitmueller/v4l-dvb-as102-2/
> with the only change needed to compile it in git tree[1]: usb_buffer_alloc()
> to usb_alloc_coherent() and usb_buffer_free() to usb_free_coherent()
> 
> [PATCH 2/7] as102: add new device nBox DVB-T Dongle
> adds new device working on this driver
> 
> 
> Next patches i made basing on Mauro Carvalho Chehab comments from previous pull try [2].
> 
> [PATCH 3/7] as102: cleanup - get rid off typedefs
> [PATCH 4/7] as102: cleanup - formatting code
> [PATCH 5/7] as102: cleanup - set __attribute__(packed) instead of pragma(pack)
> [PATCH 6/7] as102: cleanup - delete vim comments
> [PATCH 7/7] as102: cleanup - get rid of unnecessary defines (WIN32, LINUX)

Mauro, care to take these and move them under your newly-created
drivers/staging/media/ directory?

thanks,

greg k-h
