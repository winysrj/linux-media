Return-path: <linux-media-owner@vger.kernel.org>
Received: from skinbark.wpsintrax.se ([83.145.49.220]:24042 "EHLO
	skinbark.wpsintrax.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751715Ab2KLJLm (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 12 Nov 2012 04:11:42 -0500
Received: from localhost (localhost [127.0.0.1])
	by skinbark.wpsintrax.se (Postfix) with ESMTP id EBDA177C08E
	for <linux-media@vger.kernel.org>; Mon, 12 Nov 2012 10:04:20 +0100 (CET)
Received: from skinbark.wpsintrax.se ([127.0.0.1])
	by localhost (skinbark.wpsintrax.se [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id hGSZPhligYhZ for <linux-media@vger.kernel.org>;
	Mon, 12 Nov 2012 10:04:20 +0100 (CET)
Received: from tor.valhalla.alchemy.lu (vodsl-10483.vo.lu [85.93.207.243])
	by skinbark.wpsintrax.se (Postfix) with ESMTPA id 6284F77C07F
	for <linux-media@vger.kernel.org>; Mon, 12 Nov 2012 10:04:20 +0100 (CET)
Date: Mon, 12 Nov 2012 10:04:18 +0100
From: Joakim Hernberg <jbh@alchemy.lu>
To: linux-media@vger.kernel.org
Subject: ir rremote support for TeVii S471
Message-ID: <20121112100418.2fc61630@tor.valhalla.alchemy.lu>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

First of all, thanks a lot for adding the S471 support to the kernel.
It appears to work very well on 3.6 which is what I'm running.

I am trying to get the included ir remote working.  Tried the
enable_885_ir=1 module parameter (for cx23885) to no effect.

Any ideas?

-- 

   Joakim
