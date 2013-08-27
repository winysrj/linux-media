Return-path: <linux-media-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:49044 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752925Ab3H0Nwi (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 27 Aug 2013 09:52:38 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gldv-linux-media@m.gmane.org>)
	id 1VEJhF-0004fb-1k
	for linux-media@vger.kernel.org; Tue, 27 Aug 2013 15:52:37 +0200
Received: from exchange.muehlbauer.de ([194.25.158.132])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Tue, 27 Aug 2013 15:52:37 +0200
Received: from Bassai_Dai by exchange.muehlbauer.de with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Tue, 27 Aug 2013 15:52:37 +0200
To: linux-media@vger.kernel.org
From: Tom <Bassai_Dai@gmx.net>
Subject: Re: yavta tool -> Unable to start streaming: Invalid argument (22).
Date: Tue, 27 Aug 2013 13:52:12 +0000 (UTC)
Message-ID: <loom.20130827T155006-201@post.gmane.org>
References: <loom.20130827T114744-43@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Tom <Bassai_Dai <at> gmx.net> writes:

I solved the problem by myself. The problem was that the size of the image
which I gave yavta did not correspond to the format size of the video device
which I configured with media-ctl

Regards, Tom




