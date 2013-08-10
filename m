Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:44257 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1758703Ab3HJUP1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 10 Aug 2013 16:15:27 -0400
Date: Sat, 10 Aug 2013 23:15:23 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Oliver Neukum <oneukum@suse.de>
Cc: linux-media@vger.kernel.org
Subject: Re: camera always setting error bits at same resolutions
Message-ID: <20130810201522.GH16719@valkosipuli.retiisi.org.uk>
References: <1375280952.15881.2.camel@linux-fkkt.site>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1375280952.15881.2.camel@linux-fkkt.site>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Jul 31, 2013 at 04:29:12PM +0200, Oliver Neukum wrote:
> Hi,
> 
> I've got a new camera which perfectly works at some
> resolutions (640x480, 640x360, 160x120). At all other resolutions
> I get a black screen because all frames are dropped due to
> a set error bit "Payload dropped (error bit set)"
> Any idea how to debug it?

Hi Oliver,

Could you tell a bit more about your hardware, and which driver you're using.

-- 
Regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
