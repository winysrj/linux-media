Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail2.sea5.speakeasy.net ([69.17.117.4]:54597 "EHLO
	mail2.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752571AbZFHAXl (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 7 Jun 2009 20:23:41 -0400
Date: Sun, 7 Jun 2009 17:23:42 -0700 (PDT)
From: Trent Piepho <xyzzy@speakeasy.org>
To: Michael Stapelberg <michael+lm@stapelberg.de>
cc: linux-media@vger.kernel.org, dl6jv@chaoswelle.de
Subject: Re: [PATCH] bt8xx: Add support for the Conexant Fusion 878a / Twinhan
 VP 1025 DVB-S
In-Reply-To: <20090607202748.GM10731@mx01>
Message-ID: <Pine.LNX.4.58.0906071703570.32713@shell2.speakeasy.net>
References: <20090607202748.GM10731@mx01>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, 7 Jun 2009, Michael Stapelberg wrote:
> Add fefe:0001 to the list of identifiers for the bt8xx driver. The chip is
> named Conexant Fusion 878a, the card is a Twinhan VP 1025 DVB-S PCI.
>
> Please commit the attached patch.

You can remove Conexant Fusion from the board name.  All the boards for
that driver use that same chip.  Just use "Twinhan VP 1025 DVB-S".

Don't you need to add it to the list in bttv-cards.c in order to use the
card?
