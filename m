Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-68.nebula.fi ([83.145.220.68]:35657 "EHLO
	smtp-68.nebula.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754300Ab1ILU20 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 12 Sep 2011 16:28:26 -0400
Date: Mon, 12 Sep 2011 23:28:23 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Enrico <ebutera@users.berlios.de>
Cc: linux-media@vger.kernel.org
Subject: Re: omap3isp as a wakeup source
Message-ID: <20110912202822.GB1845@valkosipuli.localdomain>
References: <CA+2YH7s-BH=4vN-DUZJXa9DKrwYsZORWq-YR9fK7JV9236ntMQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+2YH7s-BH=4vN-DUZJXa9DKrwYsZORWq-YR9fK7JV9236ntMQ@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Sep 12, 2011 at 04:50:42PM +0200, Enrico wrote:
> Hi,

Hi Enrico,

> While testing omap3isp+tvp5150 with latest Deepthy bt656 patches
> (kernel 3.1rc4) i noticed that yavta hangs very often when grabbing
> or, if not hanged, it grabs at max ~10fps.
> 
> Then i noticed that tapping on the (serial) console made it "unblock"
> for some frames, so i thought it doesn't prevent the cpu to go
> idle/sleep. Using the boot arg "nohlt" the problem disappear and it
> grabs at a steady 25fps.
> 
> In the code i found a comment that says the camera can't be a wakeup
> source but the camera powerdomain is instead used to decide to not go
> idle, so at this point i think the camera powerdomain is not enabled
> but i don't know how/where to enable it. Any ideas?

I can confirm this indeed is the case --- ISP can't wake up the system ---
but don't know how to prevent the system from going to sleep when using the
ISP.

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	jabber/XMPP/Gmail: sailus@retiisi.org.uk
