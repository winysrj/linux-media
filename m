Return-path: <linux-media-owner@vger.kernel.org>
Received: from tex.lwn.net ([70.33.254.29]:60075 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759310AbcHDXKA (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 4 Aug 2016 19:10:00 -0400
Date: Thu, 4 Aug 2016 17:09:56 -0600
From: Jonathan Corbet <corbet@lwn.net>
To: Jani Nikula <jani.nikula@intel.com>
Cc: linux-doc@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@s-opensource.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Ben Hutchings <ben@decadent.org.uk>,
	Daniel Vetter <daniel.vetter@ffwll.ch>,
	Daniel Baluta <daniel.baluta@intel.com>,
	Danilo Cesar Lemes de Paula <danilo.cesar@collabora.co.uk>
Subject: Re: [PATCH] DocBook: use DOCBOOKS="" to ignore DocBooks instead of
 IGNORE_DOCBOOKS=1
Message-ID: <20160804170956.506d6ad3@lwn.net>
In-Reply-To: <1470300506-10151-1-git-send-email-jani.nikula@intel.com>
References: <872c1d8d911f1d4ee48b2185554a63aa9026dc1a.1468080758.git.mchehab@s-opensource.com>
	<1470300506-10151-1-git-send-email-jani.nikula@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu,  4 Aug 2016 11:48:26 +0300
Jani Nikula <jani.nikula@intel.com> wrote:

> Instead of a separate ignore flag, use the obvious DOCBOOKS="" to ignore
> all DocBook files.

Makes sense, applied.

Thanks,

jon
