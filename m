Return-path: <linux-media-owner@vger.kernel.org>
Received: from tichy.grunau.be ([85.131.189.73]:50435 "EHLO tichy.grunau.be"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756492AbZICVdT (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 3 Sep 2009 17:33:19 -0400
Date: Thu, 3 Sep 2009 23:33:50 +0200
From: Janne Grunau <j@jannau.net>
To: Jarod Wilson <jarod@redhat.com>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH] hdpvr: fix i2c device registration on latest kernel
Message-ID: <20090903213349.GG7962@aniel.lan>
References: <200909031559.40207.jarod@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200909031559.40207.jarod@redhat.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Sep 03, 2009 at 03:59:40PM -0400, Jarod Wilson wrote:
> The i2c changes in 2.6.31 lead to the hdpvr driver oops'ing on load
> at the moment. These changes remedy that, and after some related changes
> in the lirc_zilog driver, IR is working again as well.
> 
> This patch is against http://hg.jannau.net/hdpvr/, which contains
> multiple related patches also required for properly enabling the IR
> part on the hdpvr. Tested on 2.6.30.5 and 2.6.31-rc8.

Thanks, pushed to that tree. I'll prepare a merge request for all the
hdpvr i2c/ir changes over the weekend.

Janne
