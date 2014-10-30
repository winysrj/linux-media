Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:42622 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758928AbaJ3L2z (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 30 Oct 2014 07:28:55 -0400
Date: Thu, 30 Oct 2014 09:28:48 -0200
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Clemens Ladisch <clemens@ladisch.de>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	alsa-devel@alsa-project.org, Takashi Iwai <tiwai@suse.de>,
	stable@vger.kernel.org, Daniel Mack <zonque@gmail.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Eduard Gilmutdinov <edgilmutdinov@gmail.com>,
	Vlad Catoi <vladcatoi@gmail.com>,
	Mauro Carvalho Chehab <m.chehab@samsung.com>
Subject: Re: [alsa-devel] [PATCH 1/2] [media] sound: simplify au0828 quirk
 table
Message-ID: <20141030092848.1b41ab7d@recife.lan>
In-Reply-To: <54521DFD.5030402@ladisch.de>
References: <cover.1414666159.git.mchehab@osg.samsung.com>
	<63287e8b3f1e449376666b55f9174df7d827b5b0.1414666159.git.mchehab@osg.samsung.com>
	<54521DFD.5030402@ladisch.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Thu, 30 Oct 2014 12:16:13 +0100
Clemens Ladisch <clemens@ladisch.de> escreveu:

> Mauro Carvalho Chehab wrote:
> > Add a macro to simplify au0828 quirk table. That makes easier
> > to check it against the USB IDs at drivers/media/usb/au0828-card.c
> >
> > +++ b/sound/usb/quirks-table.h
> > ...
> > + * This should be kept in sync with drivers/media/usb/au0828-card.c
> 
> The file does not exist in that directory.  And when you want to
> keep two files in sync, you need such reminders in both of them.

Thanks for reviewing it. 

I'm sending an updated version with those fixes.

Regards,
Mauro
