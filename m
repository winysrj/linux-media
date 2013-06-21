Return-path: <linux-media-owner@vger.kernel.org>
Received: from tex.lwn.net ([70.33.254.29]:60373 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423404Ab3FURIP (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 21 Jun 2013 13:08:15 -0400
Date: Fri, 21 Jun 2013 11:08:08 -0600
From: Jonathan Corbet <corbet@lwn.net>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: lbyang@marvell.com, g.liakhovetski@gmx.de, mchehab@redhat.com,
	linux-media@vger.kernel.org, albert.v.wang@gmail.com
Subject: Re: [PATCH 0/7] marvell-ccic: update ccic driver to support some
 features
Message-ID: <20130621110808.230371a5@lwn.net>
In-Reply-To: <201306201723.46138.hverkuil@xs4all.nl>
References: <1370324144.26072.17.camel@younglee-desktop>
	<201306201723.46138.hverkuil@xs4all.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, 20 Jun 2013 17:23:46 +0200
Hans Verkuil <hverkuil@xs4all.nl> wrote:

> Can you ack this series? I don't see anything wrong with it, but neither am
> I a marvell-ccic expert.
> 
> I'd like to have your input before I merge this.

Sorry to force you to poke me; as you probably saw, I've had a look at
the series now.  Most of them already had my acks, and I've added one
more.  #1 needs some fixes; once that's done, I'm fine with it going in
as well.

Thanks,

jon
