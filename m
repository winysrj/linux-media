Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:37384 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754417Ab2IBUGb (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 2 Sep 2012 16:06:31 -0400
Date: Sun, 2 Sep 2012 23:06:27 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Timo Kokkonen <timo.t.kokkonen@iki.fi>
Cc: linux-omap@vger.kernel.org, linux-media@vger.kernel.org
Subject: Re: [PATCHv3 9/9] ir-rx51: Add missing quote mark in Kconfig text
Message-ID: <20120902200626.GB6834@valkosipuli.retiisi.org.uk>
References: <1346349271-28073-1-git-send-email-timo.t.kokkonen@iki.fi>
 <1346349271-28073-10-git-send-email-timo.t.kokkonen@iki.fi>
 <20120901171650.GD6638@valkosipuli.retiisi.org.uk>
 <504373D5.6040006@iki.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <504373D5.6040006@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, Sep 02, 2012 at 05:57:25PM +0300, Timo Kokkonen wrote:
> On 09/01/12 20:16, Sakari Ailus wrote:
> > Moi,
> > 
> > On Thu, Aug 30, 2012 at 08:54:31PM +0300, Timo Kokkonen wrote:
> >> This trivial fix cures the following warning message:
> >>
> >> drivers/media/rc/Kconfig:275:warning: multi-line strings not supported
> >>
> >> Signed-off-by: Timo Kokkonen <timo.t.kokkonen@iki.fi>
> >> ---
> >>  drivers/media/rc/Kconfig | 2 +-
> >>  1 file changed, 1 insertion(+), 1 deletion(-)
> >>
> >> diff --git a/drivers/media/rc/Kconfig b/drivers/media/rc/Kconfig
> >> index 4a68014..1300655 100644
> >> --- a/drivers/media/rc/Kconfig
> >> +++ b/drivers/media/rc/Kconfig
> >> @@ -272,7 +272,7 @@ config IR_IGUANA
> >>  	   be called iguanair.
> >>  
> >>  config IR_RX51
> >> -	tristate "Nokia N900 IR transmitter diode
> >> +	tristate "Nokia N900 IR transmitter diode"
> >>  	depends on OMAP_DM_TIMER && LIRC
> >>  	---help---
> >>  	   Say Y or M here if you want to enable support for the IR
> > 
> > This should be combined with patch 1.
> > 
> 
> Actually I'd rather keep the patch 1 as is as it has already a purpose.
> Instead, I'd squash this into patch 3 as it already touches the Kconfig
> file and it has also the other trivial fixes combined in it.

Sounds good, that's actually a better place for it.

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
