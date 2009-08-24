Return-path: <linux-media-owner@vger.kernel.org>
Received: from ns01.unsolicited.net ([69.10.132.115]:3623 "EHLO
	ns01.unsolicited.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753124AbZHXRkX (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 24 Aug 2009 13:40:23 -0400
Message-ID: <4A92CB24.4060300@unsolicited.net>
Date: Mon, 24 Aug 2009 18:17:24 +0100
From: David <david@unsolicited.net>
MIME-Version: 1.0
To: Markus Schuss <chaos.tugraz@gmail.com>
CC: linux-media@vger.kernel.org
Subject: Re: Technotrend TT-Connect S-2400
References: <4A90CA6B.4080303@gmail.com>
In-Reply-To: <4A90CA6B.4080303@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Markus Schuss wrote:
> Hi,
>
> i have some problems getting a technotrend tt-connect s-2400 usb dvb-s
> card to work. the problem is not unknown (as mentioned at
> http://lkml.org/lkml/2009/5/23/95) but i have no idea how to fix this.
> (any help according to the remote of this card would also be appreciated)
This breakage was caused by USB changes introduced in 2.6.27, and it's
still broken as of 2.6.30. The 2.6.31rc should have the fix, and I have
a patch for 2.6.30 if you want it.

David
