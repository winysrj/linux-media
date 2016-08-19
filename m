Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:43477 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754127AbcHSUnk (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 19 Aug 2016 16:43:40 -0400
Date: Fri, 19 Aug 2016 17:43:17 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Markus Heiser <markus.heiser@darmarit.de>
Cc: Jani Nikula <jani.nikula@intel.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        linux-doc@vger.kernel.org
Subject: Re: [PATCH 1/7] doc-rst: generic way to build only sphinx
 sub-folders
Message-ID: <20160819174317.3c0675a5@vento.lan>
In-Reply-To: <20160819174038.0fb5901a@vento.lan>
References: <1471097568-25990-1-git-send-email-markus.heiser@darmarit.de>
        <1471097568-25990-2-git-send-email-markus.heiser@darmarit.de>
        <20160818163514.43539c11@lwn.net>
        <09880F76-6FE1-48E6-B76D-DFC4F47182D7@darmarit.de>
        <8737m0udod.fsf@intel.com>
        <92FD7AE6-E093-439C-A2AC-5F39EC1F4BED@darmarit.de>
        <20160819174038.0fb5901a@vento.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Fri, 19 Aug 2016 17:40:38 -0300
Mauro Carvalho Chehab <mchehab@infradead.org> escreveu:

> Em Fri, 19 Aug 2016 17:52:07 +0200
> Markus Heiser <markus.heiser@darmarit.de> escreveu:
> 

> > After said this, what is your suggestion? For me its all equal, these 
> > are only my 2cent to this discussion :-)

Forgot to mention, but I noticed that, sometimes, the building system
doesn't get the cross-references right, and produces a PDF file
(or an HTML file) with no TOC tables. The output files are still
generated.

I didn't try to track the root case.

Thanks,
Mauro
