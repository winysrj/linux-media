Return-path: <linux-media-owner@vger.kernel.org>
Received: from tex.lwn.net ([70.33.254.29]:39889 "EHLO vena.lwn.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932469AbcIAO4K (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 1 Sep 2016 10:56:10 -0400
Date: Thu, 1 Sep 2016 08:56:04 -0600
From: Jonathan Corbet <corbet@lwn.net>
To: Markus Heiser <markus.heiser@darmarit.de>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
        Jani Nikula <jani.nikula@intel.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH 0/3] doc-rst: generic way to build PDF of sub-folder
Message-ID: <20160901085604.7c22d39e@lwn.net>
In-Reply-To: <20160901085334.0574ef2e@lwn.net>
References: <1472052976-22541-1-git-send-email-markus.heiser@darmarit.de>
        <20160901085334.0574ef2e@lwn.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, 1 Sep 2016 08:53:34 -0600
Jonathan Corbet <corbet@lwn.net> wrote:

> > here is a small patch series which extends the method to build only sub-folders
> > to the targets "latexdocs" and "pdfdocs".  
> 
> Well this doesn't seem to break anything, so I went ahead and applied
> it :)

By that I mean I applied the first two, of course; I left the
media-specific one for Mauro.

jon
