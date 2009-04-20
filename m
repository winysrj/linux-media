Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:37002 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751212AbZDTSQQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 20 Apr 2009 14:16:16 -0400
Date: Mon, 20 Apr 2009 15:16:11 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Uri Shkolnik <urishk@yahoo.com>
Cc: LinuxML <linux-media@vger.kernel.org>
Subject: Re: Siano's patches
Message-ID: <20090420151611.5cca5b07@pedra.chehab.org>
In-Reply-To: <820462.425.qm@web110812.mail.gq1.yahoo.com>
References: <820462.425.qm@web110812.mail.gq1.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, 5 Apr 2009 07:19:59 -0700 (PDT)
Uri Shkolnik <urishk@yahoo.com> wrote:

> 
>  Hi Mauro,
>  
>  
>  Please note patches (1..19) series @ http://patchwork.kernel.org/project/linux-media/list/?submitter=uri
>  
>  I'll wait for reviews and commit for this series before submitting additional patches.

Uri,

I've finished reviewing and applying the patches. I had to skip some patches,
since they don't apply without some previous patches that I asked for changes.

Please re-submit those missing patches later.

I strongly suggest that you submit first all the patches that changes only
CodingStyle, and wait for my review before sending other patches (or otherwise
let them to happen only after merging all other patches).

In general, such patches won't generate discussions, provided
that checkpatch.pl doesn't complain, and that you manually review the results
of automatic tools like indent (that, in some cases, cause CodingStyle
regressions - such tool should be used with care).

The rationale is that patches that touches on CodingStyle replaces things on
almost everywhere. If a patch with CodingStyle changes got rejected by some
reason, the subsequent patches won't apply and will also be rejected.

Cheers,
Mauro
