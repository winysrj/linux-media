Return-path: <linux-media-owner@vger.kernel.org>
Received: from tex.lwn.net ([70.33.254.29]:59386 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750727AbcGJFQP (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 10 Jul 2016 01:16:15 -0400
Date: Sat, 9 Jul 2016 23:15:52 -0600
From: Jonathan Corbet <corbet@lwn.net>
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Ben Hutchings <ben@decadent.org.uk>,
	Daniel Vetter <daniel.vetter@ffwll.ch>,
	Jani Nikula <jani.nikula@intel.com>,
	Daniel Baluta <daniel.baluta@intel.com>,
	Danilo Cesar Lemes de Paula <danilo.cesar@collabora.co.uk>,
	linux-doc@vger.kernel.org
Subject: Re: [PATCH v2] doc-rst: add an option to ignore DocBooks when
 generating docs
Message-ID: <20160709231552.58d8535a@lwn.net>
In-Reply-To: <872c1d8d911f1d4ee48b2185554a63aa9026dc1a.1468080758.git.mchehab@s-opensource.com>
References: <872c1d8d911f1d4ee48b2185554a63aa9026dc1a.1468080758.git.mchehab@s-opensource.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat,  9 Jul 2016 13:12:45 -0300
Mauro Carvalho Chehab <mchehab@s-opensource.com> wrote:

> Sometimes, we want to do a partial build, instead of building
> everything. However, right now, if one wants to build just
> Sphinx books, it will build also the DocBooks.
> 
> Add an option to allow to ignore all DocBooks when building
> documentation.

Seems good, applied to the docs tree, thanks.

jon
