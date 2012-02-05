Return-path: <linux-media-owner@vger.kernel.org>
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:34151 "EHLO
	out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752228Ab2BER4H (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 5 Feb 2012 12:56:07 -0500
Received: from compute6.internal (compute6.nyi.mail.srv.osa [10.202.2.46])
	by gateway1.nyi.mail.srv.osa (Postfix) with ESMTP id 31B4B20A67
	for <linux-media@vger.kernel.org>; Sun,  5 Feb 2012 12:56:06 -0500 (EST)
Date: Sun, 5 Feb 2012 08:40:09 -0800
From: Greg KH <greg@kroah.com>
To: Knut Petersen <Knut_Petersen@t-online.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
	linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
	mchehab@infradead.org
Subject: Re: [BUG] v3.2.1: circular locking dvb_device_open /
 videobuf_dvb_find_frontend
Message-ID: <20120205164009.GA5677@kroah.com>
References: <4F170E93.5070604@t-online.de>
 <4F2E8537.9070308@t-online.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F2E8537.9070308@t-online.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, Feb 05, 2012 at 02:33:43PM +0100, Knut Petersen wrote:
> Hi Linus!
> 
> The problem still exists in 3.2.4, but nobody seems to be interested ...

Isn't it resolved in 3.3-rc2 already?  If not, please work with the
linux-media developers.

thanks,

greg k-h
