Return-path: <linux-media-owner@vger.kernel.org>
Received: from tropek.jajcus.net ([84.205.176.49]:38407 "EHLO
	tropek.jajcus.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757055Ab3IBTY6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 2 Sep 2013 15:24:58 -0400
Date: Mon, 2 Sep 2013 21:14:56 +0200
From: Jacek Konieczny <jajcus@jajcus.net>
To: Antti Palosaari <crope@iki.fi>
Cc: linux-media@vger.kernel.org,
	Torsten Seyffarth <t.seyffarth@gmx.de>,
	Jan Taegert <jantaegert@gmx.net>,
	Damien CABROL <cabrol.damien@free.fr>
Subject: Re: [PATCH] e4000: fix PLL calc error in 32-bit arch
Message-ID: <20130902211456.644ff520@lolek.nigdzie>
In-Reply-To: <5224BC2D.2040909@iki.fi>
References: <1378138669-22302-1-git-send-email-crope@iki.fi>
	<5224BC2D.2040909@iki.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 02 Sep 2013 19:26:21 +0300
Antti Palosaari <crope@iki.fi> wrote:

> Testers?
> 
> Here is tree:
> http://git.linuxtv.org/anttip/media_tree.git/shortlog/refs/heads/e4000_fix_3.11
> 
> I assume all of you have been running 32-bit arch as that bug is
> related to 32-bit overflow.

I have no device to test now. But, yes, I was using 32-bit arch.

Thanks to you and Damien for finding and fixing this.

Greets,
	Jacek
