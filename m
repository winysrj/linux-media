Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:42640 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759908AbaJ3Nhc (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 30 Oct 2014 09:37:32 -0400
Date: Thu, 30 Oct 2014 11:37:25 -0200
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Devin Heitmueller <dheitmueller@kernellabs.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
	Clemens Ladisch <clemens@ladisch.de>,
	Daniel Mack <zonque@gmail.com>,
	Eduard Gilmutdinov <edgilmutdinov@gmail.com>,
	Vlad Catoi <vladcatoi@gmail.com>, alsa-devel@alsa-project.org,
	stable@vger.kernel.org, Michael Krufky <mkrufky@linuxtv.org>
Subject: Re: [PATCH v2 2/2] [media] sound: Update au0828 quirks table
Message-ID: <20141030113725.08b3aa40@recife.lan>
In-Reply-To: <CAGoCfizkcdU1fgfLjFHwnH34HgpJBcznO+3RrqOMHpLUYKCNPg@mail.gmail.com>
References: <cover.1414668341.git.mchehab@osg.samsung.com>
	<678fa12fb8e75c6dc1e781a02e3ddbbba7e1a904.1414668341.git.mchehab@osg.samsung.com>
	<CAGoCfizkcdU1fgfLjFHwnH34HgpJBcznO+3RrqOMHpLUYKCNPg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Devin,

Em Thu, 30 Oct 2014 09:15:31 -0400
Devin Heitmueller <dheitmueller@kernellabs.com> escreveu:

> Hi Mauro,
> 
> > Syncronize it and put them on the same order as found at au0828
> > driver, as all the au0828 devices with analog TV need the
> > same quirks.
> 
> The MXL and Woodbury boards don't support analog under Linux, so
> probably shouldn't be included in the list of quirks.

True.
> 
> That said, the MXL and Woodbury versions of the PCBs were prototypes
> that never made it into production (and since the Auvitek chips are
> EOL, they never will).  I wouldn't object to a patch which removed the
> board profiles entirely in the interest of removing dead code.
> 
> It was certainly nice of Mike Krufky to work to get support into the
> open source driver before the product was released, but after four
> years it probably makes sense to remove the entries for products that
> never actually shipped.

Yeah, if nobody is using such devices, then we should get rid of them,
but I prefer to have this on a separate patch, in order to give
people the opportunity to complain.

So, if I'm understanding well, you're suggesting to add a patch
removing those 5 entries (and the corresponding quirks on alsa),
right?

	{ USB_DEVICE(0x2040, 0x7201),
		.driver_info = AU0828_BOARD_HAUPPAUGE_HVR950Q_MXL },
	{ USB_DEVICE(0x2040, 0x7211),
		.driver_info = AU0828_BOARD_HAUPPAUGE_HVR950Q_MXL },
	{ USB_DEVICE(0x2040, 0x7281),
		.driver_info = AU0828_BOARD_HAUPPAUGE_HVR950Q_MXL },
	{ USB_DEVICE(0x05e1, 0x0480),
		.driver_info = AU0828_BOARD_HAUPPAUGE_WOODBURY },
	{ USB_DEVICE(0x2040, 0x8200),
		.driver_info = AU0828_BOARD_HAUPPAUGE_WOODBURY },
	{ USB_DEVICE(0x2040, 0x7260),

Regards,
Mauro
