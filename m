Return-path: <mchehab@pedra>
Received: from chybek.jannau.net ([83.169.20.219]:39920 "EHLO
	chybek.jannau.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753715Ab1AJMfC (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 10 Jan 2011 07:35:02 -0500
Date: Mon, 10 Jan 2011 13:24:31 +0100
From: Janne Grunau <j@jannau.net>
To: Jarod Wilson <jarod@wilsonet.com>
Cc: Jason Gauthier <jgauthier@lastar.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Janne Grunau <j@jannau.net>
Subject: Re: Enable IR on hdpvr
Message-ID: <20110110122431.GD11621@jannau.net>
References: <65DE7931C559BF4DBEE42C3F8246249A0B686EB0@V-EXMAILBOX.ctg.com>
 <8AFBEFD7-69E3-4E71-B155-EA773C2FED43@wilsonet.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8AFBEFD7-69E3-4E71-B155-EA773C2FED43@wilsonet.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Mon, Jan 10, 2011 at 01:05:10AM -0500, Jarod Wilson wrote:
> 
> There's a bit more to it than just the one line change. Here's the patch we're
> carrying in the Fedora kernels to enable it:
> 
> http://wilsonet.com/jarod/lirc_misc/hdpvr-ir/hdpvr-ir-enable.patch
> 
> Janne, I've heard many success stories w/the hdpvr IR lately, and almost no reports
> of lockups, so I'm thinking a firmware update may have helped out here, and thus,
> maybe its time we just go ahead and push this patch along upstream? We still
> require someone to load lirc_zilog manually, so it seems like a fairly low-risk
> thing to do.

Ack, go ahead. I haven't checked IR for a long time.

Janne
