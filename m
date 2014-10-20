Return-path: <linux-media-owner@vger.kernel.org>
Received: from tex.lwn.net ([70.33.254.29]:42157 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751180AbaJTPOm (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 20 Oct 2014 11:14:42 -0400
Date: Mon, 20 Oct 2014 11:14:39 -0400
From: Jonathan Corbet <corbet@lwn.net>
To: Randy Dunlap <rdunlap@infradead.org>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	linux-media <linux-media@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Vincent Palatin <vpalatin@chromium.org>
Subject: Re: [PATCH] DocBook: fix media build error
Message-ID: <20141020111439.0e641848@lwn.net>
In-Reply-To: <544475D5.6080903@infradead.org>
References: <544475D5.6080903@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, 19 Oct 2014 19:39:17 -0700
Randy Dunlap <rdunlap@infradead.org> wrote:

> Fix media DocBook build errors by making the orderedlist balanced.

That definitely makes things work better.  Will send upward if need be.

Thanks,

jon
