Return-path: <linux-media-owner@vger.kernel.org>
Received: from tex.lwn.net ([70.33.254.29]:57432 "EHLO vena.lwn.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S934195AbcIFMTV (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 6 Sep 2016 08:19:21 -0400
Date: Tue, 6 Sep 2016 06:19:09 -0600
From: Jonathan Corbet <corbet@lwn.net>
To: Markus Heiser <markus.heiser@darmarit.de>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
        Jani Nikula <jani.nikula@intel.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        linux-doc@vger.kernel.org
Subject: Re: [PATCH 1/3] doc-rst:c-domain: fix sphinx version
 incompatibility
Message-ID: <20160906061909.36aa2986@lwn.net>
In-Reply-To: <1472657372-21039-2-git-send-email-markus.heiser@darmarit.de>
References: <1472657372-21039-1-git-send-email-markus.heiser@darmarit.de>
        <1472657372-21039-2-git-send-email-markus.heiser@darmarit.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, 31 Aug 2016 17:29:30 +0200
Markus Heiser <markus.heiser@darmarit.de> wrote:

> +            if major >= 1 and minor < 4:
> +                # indexnode's tuple changed in 1.4
> +                # https://github.com/sphinx-doc/sphinx/commit/e6a5a3a92e938fcd75866b4227db9e0524d58f7c
> +                self.indexnode['entries'].append(
> +                    ('single', indextext, targetname, ''))
> +            else:
> +                self.indexnode['entries'].append(
> +                    ('single', indextext, targetname, '', None))

So this doesn't seem right.  We'll get the four-entry tuple behavior with
1.3 and the five-entry behavior with 1.4...but what happens when 2.0
comes out?

Did you want maybe:

	if major == 1 and minor < 4:

?

(That will fail on 0.x, but we've already stated that we don't support
below 1.2).

jon
