Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:11999 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752408AbcHQMuf (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 17 Aug 2016 08:50:35 -0400
From: Jani Nikula <jani.nikula@intel.com>
To: Markus Heiser <markus.heiser@darmarit.de>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: Markus Heiser <markus.heiser@darmarIT.de>,
	Jonathan Corbet <corbet@lwn.net>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH 0/3] doc-rst: parseheaders directive
In-Reply-To: <1471013324-18914-1-git-send-email-markus.heiser@darmarit.de>
References: <1471013324-18914-1-git-send-email-markus.heiser@darmarit.de>
Date: Wed, 17 Aug 2016 15:50:11 +0300
Message-ID: <87eg5ntv98.fsf@intel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, 12 Aug 2016, Markus Heiser <markus.heiser@darmarit.de> wrote:
> this series imlpements a new directive ".. parseheaders::" as a replacement for
> the media/Makefile, suggested by Jani [1].

Thanks for doing this work. I didn't do a thorough review, but at a high
level I think it is what we want.

>   doc-rst: parseheaders directive (inital)

I think this patch will break bisect, because it changes the perl script
before its users are converted.

BR,
Jani.

-- 
Jani Nikula, Intel Open Source Technology Center
