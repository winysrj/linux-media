Return-path: <linux-media-owner@vger.kernel.org>
Received: from pequod.mess.org ([80.229.237.210]:46866 "EHLO pequod.mess.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751133Ab3LKNRx (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 11 Dec 2013 08:17:53 -0500
Date: Wed, 11 Dec 2013 13:17:51 +0000
From: Sean Young <sean@mess.org>
To: Martin Kittel <linux@martin-kittel.de>
Cc: linux-media@vger.kernel.org
Subject: Re: Patch mceusb: fix invalid urb interval
Message-ID: <20131211131751.GA434@pequod.mess.org>
References: <loom.20131110T113621-661@post.gmane.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <loom.20131110T113621-661@post.gmane.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, Nov 10, 2013 at 10:50:45AM +0000, Martin Kittel wrote:
> Hi,
> 
> I had trouble getting my MCE remote control to work on my new Intel
> mainboard. It was working fine with older boards but with the new board
> there would be no reply from the remote just after the setup package was
> received during the init phase.
> I traced the problem down to the mceusb_dev_recv function where the received
> urb is resubmitted again. The problem is that my new board is so blazing
> fast that the initial urb was processed in less than a single 125
> microsecond interval, so the urb as it was received had urb->interval set to 0.
> As the urb is just resubmitted as it came in it now had an invalid interval
> set and was rejected.
> The patch just resets urb->interval to its initial value and adds some error
> diagnostics (which would have saved me a lot of time during my analysis).

What mceusb devices is this? Could you provide lsusb -vvv output please?

Also what usb hub are you using? Another user is reporting problems with an
xhci hub.


Sean
