Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-68.nebula.fi ([83.145.220.68]:36124 "EHLO
	smtp-68.nebula.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752177Ab1KBMcb (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 2 Nov 2011 08:32:31 -0400
Date: Wed, 2 Nov 2011 14:32:27 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	=?iso-8859-1?Q?R=E9mi?= Denis-Courmont <remi@remlab.net>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [RFC] Monotonic clock usage in buffer timestamps
Message-ID: <20111102123227.GD22159@valkosipuli.localdomain>
References: <201111011324.36742.laurent.pinchart@ideasonboard.com>
 <b3e1d11fbdb6c1fe02954f7b2dd29b01@chewa.net>
 <201111011349.47132.laurent.pinchart@ideasonboard.com>
 <20111102091046.GA14955@minime.bse>
 <20111102101449.GC22159@valkosipuli.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111102101449.GC22159@valkosipuli.localdomain>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Nov 02, 2011 at 12:14:49PM +0200, Sakari Ailus wrote:
...
> Or just do the wall clock timestamps user space as they are typically
> critical in timing.

There was a rather important "not" missing in this sentence.

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	jabber/XMPP/Gmail: sailus@retiisi.org.uk
