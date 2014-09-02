Return-path: <linux-media-owner@vger.kernel.org>
Received: from 83-103-0-23.ip.fastwebnet.it ([83.103.0.23]:49153 "EHLO
	motoko.logossrl.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750751AbaIBG2G (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 2 Sep 2014 02:28:06 -0400
Received: from aika.logos.lan ([192.168.0.99])
	by motoko.logossrl.com with esmtpsa (UNKNOWN:DHE-RSA-AES256-GCM-SHA384:256)
	(Exim 4.80.1)
	(envelope-from <l.marcantonio@logossrl.com>)
	id 1XOhZT-0005Sk-De
	for linux-media@vger.kernel.org; Tue, 02 Sep 2014 08:28:03 +0200
Date: Tue, 2 Sep 2014 08:28:23 +0200
From: Lorenzo Marcantonio <l.marcantonio@logossrl.com>
To: linux-media@vger.kernel.org
Subject: Re: strange empia device
Message-ID: <20140902062822.GA2805@aika.logos.lan>
References: <20140825190109.GB3372@aika.discordia.loc>
 <5403358C.4070504@googlemail.com>
 <1409615932.1819.16.camel@palomino.walls.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1409615932.1819.16.camel@palomino.walls.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Sep 01, 2014 at 07:58:52PM -0400, Andy Walls wrote:
> A Merlin firmware of 16 kB strongly suggests that this chip has an
> integarted Conexant CX25843 (Merlin Audio + Thresher Video = Mako)
> Broadtcast A/V decoder core.  The chip might only have a Merlin
> integrated, but so far I've never encountered that.  It will be easy
> enough to tell, if the Thresher registers don't respond or only respond
> with junk.

However I strongly suspect that these drivers are for a whole *family*
of empia device. The oem ini by roxio talks about three different
parts... probably they give one sys file for everyone and the oem
customizes the ini.

In short the merlin fw may not be actually used for *this* part but only
for other empia devices/configurations.

Otherwise I wonder *why* a fscking 1.5MB of sys driver for a mostly dumb
capture device...

-- 
Lorenzo Marcantonio
Logos Srl
