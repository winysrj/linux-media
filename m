Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f181.google.com ([209.85.128.181]:32895 "EHLO
        mail-wr0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751446AbdG0N7d (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 27 Jul 2017 09:59:33 -0400
Date: Thu, 27 Jul 2017 14:59:26 +0100
From: Rui Miguel Silva <rmfrfs@gmail.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: Johan Hovold <johan@kernel.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-media@vger.kernel.org, linux-leds@vger.kernel.org,
        jacek.anaszewski@gmail.com, laurent.pinchart@ideasonboard.com,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org
Subject: Re: [PATCH 1/2] staging: greybus: light: Don't leak memory for no
 gain
Message-ID: <20170727135926.GB28452@arch-late.localdomain>
References: <20170718184107.10598-1-sakari.ailus@linux.intel.com>
 <20170718184107.10598-2-sakari.ailus@linux.intel.com>
 <20170725123031.GB27516@localhost>
 <20170726150356.GA21301@arch-late.localdomain>
 <20170726183207.GB29978@amd>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170726183207.GB29978@amd>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,
On Wed, Jul 26, 2017 at 08:32:08PM +0200, Pavel Machek wrote:
> Hi!
> 
> > On Tue, Jul 25, 2017 at 02:30:31PM +0200, Johan Hovold wrote:
> > > [ +CC: Rui and Greg ]
> > 
> > Thanks Johan. I only got this because of you.
> 
> > > >  	return ret;
> > > >  }
> > > 
> > > And while it's fine to take this through linux-media, it would still be
> > > good to keep the maintainers on CC.
> > 
> > Sakari, if you could resend the all series to the right lists and
> > maintainers for proper review that would be great.
> > 
> > I did not get 0/2 and 2/2 patches.
> 
> 0/2 and 2/2 were unrelated to the memory leak, IIRC. Let me google it
> for you...
> 
> https://www.mail-archive.com/linux-media@vger.kernel.org/msg115840.html
> 
> This is memory leak and the driver is in staging. Acked-by

Yeah, I will not Ack a patch that never hit my inbox, sorry.

>or fixing > it yourself would be appropriate response, asking
> for resending of the series... not quite so.

Sure, if Sakari do not send a new version already taking in
account Johan comments, which I agree. I will fix it myself when
possible.

---
Cheers,
	Rui
