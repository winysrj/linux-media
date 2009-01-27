Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail6.sea5.speakeasy.net ([69.17.117.8]:58076 "EHLO
	mail6.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756815AbZA0SBf (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 27 Jan 2009 13:01:35 -0500
Date: Tue, 27 Jan 2009 10:01:33 -0800 (PST)
From: Trent Piepho <xyzzy@speakeasy.org>
To: Devin Heitmueller <devin.heitmueller@gmail.com>
cc: linux-media@vger.kernel.org, mkrufky@linuxtv.org,
	linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Dallas Texas ATSC scan file
In-Reply-To: <412bdbff0901270918w71c5e8c3k4600a527602a59fa@mail.gmail.com>
Message-ID: <Pine.LNX.4.58.0901270957550.17971@shell2.speakeasy.net>
References: <COL108-W41AFFE7632E1F6055B53F8D9CC0@phx.gbl>
 <19a3b7a80901270915k21729403w1f2f9be019ae9112@mail.gmail.com>
 <412bdbff0901270918w71c5e8c3k4600a527602a59fa@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, 27 Jan 2009, Devin Heitmueller wrote:
> These should not be committed.  For ATSC, there is a well known list
> of frequencies, and they should not vary by region.  Committing this
> will only result in confusion, since scanning the entire spectrum only
> takes a few minutes and the list of known transponders could change
> over time.

Most stations are now transmitting digital signals on temporary UHF
assignments and many of those will return to their analog VHF channels
after the digital switch over.  It was supposed to be next month, but now
it looks like it's been delayed yet again to June.
