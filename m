Return-path: <linux-media-owner@vger.kernel.org>
Received: from tex.lwn.net ([70.33.254.29]:38019 "EHLO vena.lwn.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753874AbcIHMOz (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 8 Sep 2016 08:14:55 -0400
Date: Thu, 8 Sep 2016 06:14:45 -0600
From: Jonathan Corbet <corbet@lwn.net>
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Markus Heiser <markus.heiser@darmarit.de>,
        linux-doc@vger.kernel.org,
        Jani Nikula <jani.nikula@linux.intel.com>
Subject: Re: [PATCH 00/47] Fix most of Sphinx warnings in nitpick mode
Message-ID: <20160908061445.06b49627@lwn.net>
In-Reply-To: <cover.1473334905.git.mchehab@s-opensource.com>
References: <cover.1473334905.git.mchehab@s-opensource.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu,  8 Sep 2016 09:03:22 -0300
Mauro Carvalho Chehab <mchehab@s-opensource.com> wrote:

> Please notice that patches 2 and 3 touches at Documentation/sphinx/parse-headers.pl.
> 
> If it is ok for you, I intend to merge those patches (except for patch 1)
> on my tree, including the two patches that touch at the parse-headers.pl
> script, as, currently, the only user for it is media. I'm also OK if you prefer
> to merge patches 2 and 3 on your tree instead.

Go ahead and keep them with the rest.

Acked-by: Jonathan Corbet <corbet@lwn.net>

jon
