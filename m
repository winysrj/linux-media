Return-path: <linux-media-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:42109 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753124AbcDXVzo (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 24 Apr 2016 17:55:44 -0400
Date: Sun, 24 Apr 2016 23:55:41 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>
Cc: sakari.ailus@iki.fi, sre@kernel.org, pali.rohar@gmail.com,
	linux-media@vger.kernel.org
Subject: Re: [RFC PATCH 00/24] Make Nokia N900 cameras working
Message-ID: <20160424215541.GA6338@amd>
References: <20160420081427.GZ32125@valkosipuli.retiisi.org.uk>
 <1461532104-24032-1-git-send-email-ivo.g.dimitrov.75@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1461532104-24032-1-git-send-email-ivo.g.dimitrov.75@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi!

> Those patch series make cameras on Nokia N900 partially working.
> Some more patches are needed, but I've already sent them for
> upstreaming so they are not part of the series:
> 
> https://lkml.org/lkml/2016/4/16/14
> https://lkml.org/lkml/2016/4/16/33
> 
> As omap3isp driver supports only one endpoint on ccp2 interface,
> but cameras on N900 require different strobe settings, so far
> it is not possible to have both cameras correctly working with
> the same board DTS. DTS patch in the series has the correct
> settings for the front camera. This is a problem still to be
> solved.
> 
> The needed pipeline could be made with:

Would you have similar pipeline for the back camera? Autofocus and
5MPx makes it more interesting. I understand that different dts will
be needed.

Thanks,
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
