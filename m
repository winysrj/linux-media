Return-path: <linux-media-owner@vger.kernel.org>
Received: from tex.lwn.net ([70.33.254.29]:35550 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751371AbbKKRMg (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 11 Nov 2015 12:12:36 -0500
Date: Wed, 11 Nov 2015 10:12:33 -0700
From: Jonathan Corbet <corbet@lwn.net>
To: Wang YanQing <udknight@gmail.com>
Cc: mchehab@osg.samsung.com, torvalds@linux-foundation.org,
	linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC] Documentation: dontdiff: remove media from dontdiff
Message-ID: <20151111101233.37c5eaf9@xps>
In-Reply-To: <20151029171539.GA5086@udknight>
References: <20151029171539.GA5086@udknight>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, 30 Oct 2015 01:15:39 +0800
Wang YanQing <udknight@gmail.com> wrote:

> media will hide all the changes in drivers/media.
> 
> Signed-off-by: Wang YanQing <udknight@gmail.com>
> ---
>  I don't know whether it is still acceptable to patch dontdiff,
>  so I add Linus to CC list.

As long as the file is there, its contents should make sense, so I've
applied this to the docs tree, thanks.

That said, the fact that it excludes a big driver subsystem and nobody
has said anything suggests it hasn't been used in some time, so we should
consider just deleting it.

jon
