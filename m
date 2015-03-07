Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:33885 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752822AbbCGXUp (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 7 Mar 2015 18:20:45 -0500
Date: Sun, 8 Mar 2015 01:20:40 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-media@vger.kernel.org
Subject: Re: [GIT PULL for v4.1] smiapp DT u64 property workaround removal
Message-ID: <20150307232040.GF6539@valkosipuli.retiisi.org.uk>
References: <20150307220634.GD6539@valkosipuli.retiisi.org.uk>
 <1573085.ZVIDUf0yP4@avalon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1573085.ZVIDUf0yP4@avalon>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

On Sun, Mar 08, 2015 at 01:15:38AM +0200, Laurent Pinchart wrote:
> > Sakari Ailus (2):
> >       Revert "[media] smiapp: Don't compile of_read_number() if CONFIG_OF
> > isn't defined"
> >       smiapp: Use of_property_read_u64_array() to read a 64-bit number array
> 
> Won't this cause a bisection breakage if CONFIG_OF isn't enabled ?

Technically you're right: it does "break" bisect if smiapp is compiled in on
a non-DT platform. Such a platform is not supported in a mainline kernel so
I don't think this is a really major issue.

I could combine the patches if you think this is an issue.

-- 
Regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
