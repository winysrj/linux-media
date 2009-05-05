Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41180 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751438AbZEET3h (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 5 May 2009 15:29:37 -0400
Date: Tue, 5 May 2009 12:24:42 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: magnus.damm@gmail.com, linux-media@vger.kernel.org,
	hverkuil@xs4all.nl, lethal@linux-sh.org, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [patch 1/3] mm: introduce follow_pte()
Message-Id: <20090505122442.6271c7da.akpm@linux-foundation.org>
In-Reply-To: <1241430874-12667-1-git-send-email-hannes@cmpxchg.org>
References: <20090501181449.GA8912@cmpxchg.org>
	<1241430874-12667-1-git-send-email-hannes@cmpxchg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon,  4 May 2009 11:54:32 +0200
Johannes Weiner <hannes@cmpxchg.org> wrote:

> A generic readonly page table lookup helper to map an address space
> and an address from it to a pte.

umm, OK.

Is there actually some point to these three patches?  If so, what is it?
