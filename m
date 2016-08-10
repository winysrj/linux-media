Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga03.intel.com ([134.134.136.65]:48969 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752796AbcHJSOl (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 10 Aug 2016 14:14:41 -0400
From: Jani Nikula <jani.nikula@intel.com>
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
	Markus Heiser <markus.heiser@darmarit.de>
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org,
	Daniel Vetter <daniel.vetter@ffwll.ch>
Subject: Re: parts of media docs sphinx re-building every time?
In-Reply-To: <20160808142635.4d766f8c@recife.lan>
References: <8760rbp8zh.fsf@intel.com> <6D7865EB-9C40-4B8F-8D8F-3B28024624F3@darmarit.de> <20160808142635.4d766f8c@recife.lan>
Date: Wed, 10 Aug 2016 10:46:44 +0300
Message-ID: <87twetvzff.fsf@intel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 08 Aug 2016, Mauro Carvalho Chehab <mchehab@s-opensource.com> wrote:
> The goal of Documentation/sphinx/parse-headers.pl script is to generate
> such parsed headers, with the cross-references modified by an exceptions
> file at Documentation/media/*.h.rst.exceptions.

Would you be so kind as to state in a few lines what you want to
achieve? I can guess based on the current solution, but I'd like to hear
it from you. Please leave out rants about tools and languages etc. so we
can focus on the problem statement, and try to figure out the best
overall solution.

Thanks,
Jani.

-- 
Jani Nikula, Intel Open Source Technology Center
