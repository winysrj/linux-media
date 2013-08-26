Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:54641 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752113Ab3HZVqp (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 26 Aug 2013 17:46:45 -0400
Date: Tue, 27 Aug 2013 00:46:11 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Tom <Bassai_Dai@gmx.net>
Cc: linux-media@vger.kernel.org
Subject: Re: media-ctl: line 1: syntax error: "(" unexpected
Message-ID: <20130826214611.GC2835@valkosipuli.retiisi.org.uk>
References: <loom.20130821T143312-331@post.gmane.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <loom.20130821T143312-331@post.gmane.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Tom,

On Wed, Aug 21, 2013 at 12:40:42PM +0000, Tom wrote:
> Hello,
> 
> I got the media-ctl tool from http://git.ideasonboard.org/git/media-ctl.git
> and compiled and build it successfully. But when try to run it I get this error:
> 
> sudo ./media-ctl -r -l "ov3640 3-003c":0->"OMAP3 ISP CCDC":0[1], "OMAP3 ISP
> CCDC":1->"OMAP3 ISP CCDC output":0[1]

You're missing single quotes around the argument to -l option. Looks like
the string will reach media-ctl altogether w/o quotes and as several command
line arguments, and both are bad. Entity names need to be quoted if they
contain spaces.

-- 
Regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
