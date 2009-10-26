Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:33788 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752009AbZJZPJ4 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 26 Oct 2009 11:09:56 -0400
Received: from lyakh (helo=localhost)
	by axis700.grange with local-esmtp (Exim 4.63)
	(envelope-from <g.liakhovetski@gmx.de>)
	id 1N2RCx-0001ql-R3
	for linux-media@vger.kernel.org; Mon, 26 Oct 2009 16:10:07 +0100
Date: Mon, 26 Oct 2009 16:10:07 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: soc-camera: current patch-stack
Message-ID: <Pine.LNX.4.64.0910261526520.4090@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi all

Under http://download.open-technology.de/soc-camera/20091026/ I've just 
uploaded my current soc-camera snapshot, which includes

- a couple of fixes, that have also been submitted to the mainline via my 
  hg-tree

- imagebus API

- sh_mobile_ceu_camera VBP error handling from Morimoto-san

- new driver for the RJ54N1CB0C camera sensor and its support for the 
  kfr2r09 board

- some auxiliary patches like adding a .private field to struct 
  soc_camera_link, fixing comment style, etc.

Most, if not all, these patches have been in some form posted on the list, 
others depend on the imagebus API, which will, probably, not be included 
in the mainline in its present form, so, those patches will change too. 
Therefore this patch-series is mostly for those, willing to have a look at 
it and play with it.

Based on 2.6.32-rc5.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
