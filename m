Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:57859 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752006AbbLAMkE (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 1 Dec 2015 07:40:04 -0500
Date: Tue, 1 Dec 2015 14:39:59 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Johannes Stezenbach <js@linuxtv.org>
Cc: linux-media@vger.kernel.org, mchehab@osg.samsung.com
Subject: Re: linuxtv.org downtime around Mon Nov 30 12:00 UTC
Message-ID: <20151201123958.GF17128@valkosipuli.retiisi.org.uk>
References: <20151129161145.GA25209@linuxtv.org>
 <20151130133546.GA6255@linuxtv.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20151130133546.GA6255@linuxtv.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Nov 30, 2015 at 02:35:46PM +0100, Johannes Stezenbach wrote:
> On Sun, Nov 29, 2015 at 05:11:45PM +0100, Johannes Stezenbach wrote:
> > the linuxtv.org server will move to a new, freshly installed
> > machine tomorrow.  Expect some downtime while we do the
> > final rsync and database export+import.  I'm planning
> > to start disabling services on the old server about
> > 30min before 12:00 UTC (13:00 CET) on Mon Nov 30.
> > If all goes well the new server will be available
> > soon after 12:00 UTC.  The IP address will not change.
> 
> Done.  The new ssh host key:
> RSA   SHA256:UY3VeEO8B/F7D/zghHGj46ioWcOqcpnGYCeEfVhTP1Q.
> ECDSA key fingerprint is SHA256:xUEF4X6LaZeXMNiRkmLWx7Wj4jnIPB8+UsDLC35t8ik.

For folks using OpenSSH prior version 7, the ECDSA key fingerprint (as in
#v4l) appears to be:

b8:92:8d:94:03:05:b8:88:53:34:e7:bf:69:f2:ff:c1

-- 
Regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
