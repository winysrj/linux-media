Return-path: <linux-media-owner@vger.kernel.org>
Received: from ducie-dc1.codethink.co.uk ([185.25.241.215]:45210 "EHLO
	ducie-dc1.codethink.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753451AbaHLRWF (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 12 Aug 2014 13:22:05 -0400
Date: Tue, 12 Aug 2014 18:21:56 +0100
From: Ian Molton <ian.molton@codethink.co.uk>
To: linux-media@vger.kernel.org
Cc: source@mvista.com, source@cogentembedded.com,
	vbarinov@embeddedalley.com, laurent.pinchart@ideasonboard.com
Subject: rcar_vin: rcar_vin_get_formats()
Message-Id: <20140812182156.60bf2513ae5de5557bbdfa05@codethink.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

rcar_vin_get_formats()

Can anyone explain to me what on earth this function is trying to achieve? I'm finding it rather impenetrable, and it works for me on one driver (adv7180) but not with another (modified 7612 driver).

It appears that its doing some sort of magic with the builtin array of formats, to allow the 7180 driver to select a YUV mode?? but I cant for the life of me understand what. I'm fairly new to v4l2, so I dont really know whats legit and what isnt. particularly, the code appears to abuse one "code" to provide several (incompatible?) formats.

Help?

-- 
Ian Molton <ian.molton@codethink.co.uk>
