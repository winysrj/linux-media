Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:58710 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751013AbaAJJeb (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 10 Jan 2014 04:34:31 -0500
Date: Fri, 10 Jan 2014 11:33:57 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Tom <Bassai_Dai@gmx.net>
Cc: linux-media@vger.kernel.org, laurent.pinchart@ideasonboard.com
Subject: Re: CCDC won't become idle!
Message-ID: <20140110093357.GC9997@valkosipuli.retiisi.org.uk>
References: <loom.20140109T161322-713@post.gmane.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <loom.20140109T161322-713@post.gmane.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Tom,

On Thu, Jan 09, 2014 at 03:19:00PM +0000, Tom wrote:
> Hello,
> 
> sorry for questioning this issue again, but by all the articles I found I
> never got clear reason for the idle problem of the ccdc.
> 
> With my camera its a kind of randomly problem. I grab images with the yavta
> tool. I configured it to wait for pressing ENTER before giving the STREAMON
> command. So now sometimes all works fine. I grab my images and they are as I
> imagined. But sometimes I get the ccdc won't become idle error. I really
> don't understand what this error causes. 
> 
> Are there any clear reasons what this problem causes?

What kind of board/sensor do you have?

I think Laurent made recently some changes to make the problem slightly less
bad. But I think the reason why it's there is still unknown, and there could
be several reasons actually.

One could be noise in vertical sync signal which could cause line counting
to go awry.

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
