Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout09.t-online.de ([194.25.134.84]:51927 "EHLO
	mailout09.t-online.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751839Ab2BEVKj (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 5 Feb 2012 16:10:39 -0500
Message-ID: <4F2EF045.10309@t-online.de>
Date: Sun, 05 Feb 2012 22:10:29 +0100
From: Knut Petersen <Knut_Petersen@t-online.de>
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
	linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
	mchehab@infradead.org
Subject: Re: [BUG] v3.2.1: circular locking dvb_device_open / videobuf_dvb_find_frontend
References: <4F170E93.5070604@t-online.de> <4F2E8537.9070308@t-online.de> <20120205164009.GA5677@kroah.com>
In-Reply-To: <20120205164009.GA5677@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am 05.02.2012 17:40, schrieb Greg KH:
> On Sun, Feb 05, 2012 at 02:33:43PM +0100, Knut Petersen wrote:
> Isn't it resolved in 3.3-rc2 already?

That problem is gone ... but TV reception is distorted in 3.3-rc2 now.
I´ll have a look into that tomorrow.

cu,
  knut

