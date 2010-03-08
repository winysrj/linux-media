Return-path: <linux-media-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:54707 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754022Ab0CHLIX (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 8 Mar 2010 06:08:23 -0500
Date: Mon, 8 Mar 2010 12:08:21 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Matthew Garrett <mjg@redhat.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Input <linux-input@vger.kernel.org>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Platform Driver x86 <platform-driver-x86@vger.kernel.org>
Subject: Re: [PATCH] Input: scancode in get/set_keycodes should be unsigned
In-Reply-To: <20100228061310.GA765@core.coreip.homeip.net>
Message-ID: <alpine.LNX.2.00.1003081207510.17799@pobox.suse.cz>
References: <20100228061310.GA765@core.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, 27 Feb 2010, Dmitry Torokhov wrote:

> The HID layer has some scan codes of the form 0xffbc0000 for logitech
> devices which do not work if scancode is typed as signed int, so we need
> to switch to unsigned int instead. While at it keycode being signed does
> not make much sense either.
> 
> Signed-off-by: Dmitry Torokhov <dtor@mail.ru>
> ---
> 
> Guys,
> 
> I was originally going to switch all platfrom drivers to use sparse
> keymap libary to eliminate at least one subsystem from this patch but
> it takes longer than I anticipated so here is mechanical conversion.
> I'd really like to make get/set keycodes usable for HID so I'd like
> to get this patch in before .34-rc1, could I get some ACKs please?

Sorry for late response, I have been offline for the whole past week.

	Acked-by: Jiri Kosina <jkosina@suse.cz>

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
