Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp04.smtpout.orange.fr ([80.12.242.126]:27759 "EHLO
	smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754060AbbHDRIQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 4 Aug 2015 13:08:16 -0400
From: Robert Jarzmik <robert.jarzmik@free.fr>
To: Andrew Morton <akpm@linux-foundation.org>,
	Jens Axboe <axboe@kernel.dk>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	linux-kernel@vger.kernel.org, linux-media@vger.kernel.org
Subject: Re: [RFC PATCH v2] lib: scatterlist: add sg splitting function
References: <1438435033-7636-1-git-send-email-robert.jarzmik@free.fr>
	<20150803161939.2edd494eb64bc81ea8e91c16@linux-foundation.org>
Date: Tue, 04 Aug 2015 19:04:36 +0200
In-Reply-To: <20150803161939.2edd494eb64bc81ea8e91c16@linux-foundation.org>
	(Andrew Morton's message of "Mon, 3 Aug 2015 16:19:39 -0700")
Message-ID: <878u9rm1cr.fsf@belgarion.home>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Andrew Morton <akpm@linux-foundation.org> writes:

>>  include/linux/scatterlist.h |   5 ++
>>  lib/scatterlist.c           | 189 ++++++++++++++++++++++++++++++++++++++++++++
>>  2 files changed, 194 insertions(+)
>
> It's quite a bit of code for a fairly specialised thing.  How ugly
> would it be to put this in a new .c file and have subsystems select it
> in Kconfig?
I have no idea about the "ugliness", but why not ...

If nobody objects, and in order to submit a proper patch, there are decisions to
make :
 - what will be the scope of this new .c file ?
   - only sg_plit() ?
   - all sg specialized functions, ie. sg_lib.c ?
 - will include/linux/scatterlist.h have an "ifdefed" portion for what X.c
   offers ?
 - what naming for X.c and the config entry ?

What about adding this to lib/Makefile, and one ifdef to scatterlist.h ? :
     obj-$(CONFIG_SG_LIB) += sg_lib.o

Cheers.

-- 
Robert
