Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:36646 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752719AbZEDLIn (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 4 May 2009 07:08:43 -0400
Date: Mon, 4 May 2009 07:08:41 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Magnus Damm <magnus.damm@gmail.com>,
	linux-media@vger.kernel.org, Hans Verkuil <hverkuil@xs4all.nl>,
	Paul Mundt <lethal@linux-sh.org>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [patch 3/3] mm: introduce follow_pfn()
Message-ID: <20090504110841.GA19646@infradead.org>
References: <20090501181449.GA8912@cmpxchg.org> <1241430874-12667-3-git-send-email-hannes@cmpxchg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1241430874-12667-3-git-send-email-hannes@cmpxchg.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, May 04, 2009 at 11:54:34AM +0200, Johannes Weiner wrote:
> Analoguous to follow_phys(), add a helper that looks up the PFN
> instead.  It also only allows IO mappings or PFN mappings.

A kerneldoc describing what it does and the limitations would be
extremly helpful.

