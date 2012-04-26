Return-path: <linux-media-owner@vger.kernel.org>
Received: from tex.lwn.net ([70.33.254.29]:60075 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758735Ab2DZUI0 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 26 Apr 2012 16:08:26 -0400
Date: Thu, 26 Apr 2012 14:08:24 -0600
From: Jonathan Corbet <corbet@lwn.net>
To: Chris Ball <cjb@laptop.org>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH 1/2] marvell-cam: Build fix: mcam->platform assignment
Message-ID: <20120426140824.446c8b0b@lwn.net>
In-Reply-To: <87ehra9s02.fsf@laptop.org>
References: <87ehra9s02.fsf@laptop.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, 26 Apr 2012 16:07:25 -0400
Chris Ball <cjb@laptop.org> wrote:

> It seems that this driver has never been buildable upstream, because it
> was merged with this line included:
> 
>        mcam->platform = MHP_Armada610;

Yes, that was from a badly cherry-picked change a while back.  I sent in a
fix (the same as yours) about a week ago :)

Thanks,

jon
