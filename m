Return-path: <linux-media-owner@vger.kernel.org>
Received: from tichy.grunau.be ([85.131.189.73]:51976 "EHLO tichy.grunau.be"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757100AbZFIJoi (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 9 Jun 2009 05:44:38 -0400
Date: Tue, 9 Jun 2009 11:34:51 +0200
From: Janne Grunau <j@jannau.net>
To: Hubert Hafner <hubert.hafner@baerndorf.de>
Cc: linux-media@vger.kernel.org
Subject: Re: Haupauge Nova-T 500 2.6.28 regression dib0700
Message-ID: <20090609093451.GA18317@aniel.lan>
References: <65EB3BF45DAF40859841D6D9ECFB0C55@Vista>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <65EB3BF45DAF40859841D6D9ECFB0C55@Vista>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

cc-ed linux-media

On Mon, Jun 01, 2009 at 12:48:33PM +0200, Hubert Hafner wrote:
> 
> I've read your message on mail-archive.com on the linux-media section.
> 
> The same problem seems to be valid for the Haupauge Nova-TD (a dual
> receiver).  After a few minutes the ehci_hcd core is halted.
> 
> Have you got any ideas how to solve this?  I've read setting URB to 1
> (?) should solve this issue - but where to set this parameter and did
> it work out?

There's a patch on the linux-media list. Search for a thread with
"dib0700 Nova-TD-Stick problem" as subject.

> disable_rc_polling does not solve the problem. At least at my Ubuntu
> Server 8.10 with kernel 2.6.27-7.

Seems to be different problem than. At least kernel 2.6.27.x works here
without problems.

Janne
