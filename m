Return-path: <linux-media-owner@vger.kernel.org>
Received: from tex.lwn.net ([70.33.254.29]:47791 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752077AbcHIPWD (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 9 Aug 2016 11:22:03 -0400
Date: Tue, 9 Aug 2016 09:21:08 -0600
From: Jonathan Corbet <corbet@lwn.net>
To: Markus Heiser <markus.heiser@darmarit.de>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	linux-doc@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCH 0/3] doc-rst: more generic way to build only sphinx
 sub-folders
Message-ID: <20160809092108.266f37c2@lwn.net>
In-Reply-To: <1470662100-6927-1-git-send-email-markus.heiser@darmarit.de>
References: <1470662100-6927-1-git-send-email-markus.heiser@darmarit.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon,  8 Aug 2016 15:14:57 +0200
Markus Heiser <markus.heiser@darmarit.de> wrote:

> this is my approach for a more generic way to build only sphinx sub-folders, we
> discussed in [1]. The last patch adds a minimal conf.py to the gpu folder, if
> you don't want to patch the gpu folder drop it.

I haven't had a chance to really mess with this yet, but it seems like a
reasonable solution.  Mauro, does it give you what you need?

Thanks,

jon
