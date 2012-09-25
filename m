Return-path: <linux-media-owner@vger.kernel.org>
Received: from oyp.chewa.net ([91.121.6.101]:44792 "EHLO oyp.chewa.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753471Ab2IYT17 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 25 Sep 2012 15:27:59 -0400
Received: from leon.localnet (226.Red-80-33-141.staticIP.rima-tde.net [80.33.141.226])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	(Authenticated sender: remi)
	by oyp.chewa.net (Postfix) with ESMTPSA id 1F85020252
	for <linux-media@vger.kernel.org>; Tue, 25 Sep 2012 21:27:57 +0200 (CEST)
From: "=?iso-8859-1?q?R=E9mi?= Denis-Courmont" <remi@remlab.net>
To: linux-media@vger.kernel.org
Subject: Re: HVR 4000 and DVB-API
Date: Tue, 25 Sep 2012 22:27:55 +0300
References: <20120924095123.7db56ab3@tuxstudio>
In-Reply-To: <20120924095123.7db56ab3@tuxstudio>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Message-Id: <201209252227.55241@leon.remlab.net>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Le lundi 24 septembre 2012 10:51:23, Dominique Michel a écrit :
> The WinTV HVR-4000-HD is a multi-tuners TV card with 2 dvb tuners.
> It look like its driver doesn't have been updated to the new DVB-API.

Multi-standard frontends required DVB API version 5.5. That is found in kernel 
versions 3.2 and later. So you might need to update the kernel. If you already 
have, then well, you need to get someone to update the driver.

Also the application needs to be updated to support DVBv5.5 too. I don't know 
which versions of VDR support multi-standard frontends, if any as yet.

-- 
Rémi Denis-Courmont
http://www.remlab.net/
