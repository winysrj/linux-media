Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtprelay0078.hostedemail.com ([216.40.44.78]:58732 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751010AbcHFUKR (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 6 Aug 2016 16:10:17 -0400
Message-ID: <1470514208.28648.17.camel@perches.com>
Subject: Re: [GIT PULL for v4.8-rc1] mailcap fixup for two entries
From: Joe Perches <joe@perches.com>
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Shuah Khan <shuah.kh@samsung.com>
Date: Sat, 06 Aug 2016 13:10:08 -0700
In-Reply-To: <20160806073536.2bd92a93@recife.lan>
References: <20160806073536.2bd92a93@recife.lan>
Content-Type: text/plain; charset="ISO-8859-1"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, 2016-08-06 at 07:35 -0300, Mauro Carvalho Chehab wrote:
> Hi Linus,
> 
> Please pull from my tree for a small fixup on my entry and Shuah's entry at
> .mailcap.
> 
> Basically, those entries were with a syntax that makes get_maintainer.pl to
> do the wrong thing.
> 
> Thanks!
> Mauro

.mailmap

The old entries were simply improper.

git shortlog wasn't doing the right thing either.

