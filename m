Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:38650 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750992AbaJAAib (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 30 Sep 2014 20:38:31 -0400
Date: Tue, 30 Sep 2014 21:38:26 -0300
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Gregor Jasny <gjasny@googlemail.com>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH 0/3] libdvbv5: Remove broken descriptor parsers
Message-ID: <20140930213826.67d0214f@concha.lan>
In-Reply-To: <1412090228-19996-1-git-send-email-gjasny@googlemail.com>
References: <1412090228-19996-1-git-send-email-gjasny@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Tue, 30 Sep 2014 17:17:05 +0200
Gregor Jasny <gjasny@googlemail.com> escreveu:

> Hello,
> 
> this patch series removes the service_list and service_location
> descriptors. It breaks API compatibility by removing the public
> header files but maintains ABI compatibility by providing stub
> implementations.
> 
> Thanks,
> Gregor
> 
> Gregor Jasny (3):
>   libdvbv5: Add todo file
>   libdvbv5: remove service_location descriptor
>   libdvbv5: remove service_list descriptor
> 
>  TODO.libdvbv5                                    |   3 +
>  doxygen_libdvbv5.cfg                             |   1 -
>  lib/include/libdvbv5/desc_service_list.h         | 119 -----------------------
>  lib/include/libdvbv5/desc_service_location.h     | 107 --------------------
>  lib/libdvbv5/Makefile.am                         |   5 +-
>  lib/libdvbv5/compat-soname.c                     |  44 +++++++++
>  lib/libdvbv5/descriptors.c                       |   8 --
>  lib/libdvbv5/descriptors/desc_service_list.c     |  56 -----------
>  lib/libdvbv5/descriptors/desc_service_location.c |  80 ---------------
>  9 files changed, 48 insertions(+), 375 deletions(-)
>  create mode 100644 TODO.libdvbv5
>  delete mode 100644 lib/include/libdvbv5/desc_service_list.h
>  delete mode 100644 lib/include/libdvbv5/desc_service_location.h
>  create mode 100644 lib/libdvbv5/compat-soname.c
>  delete mode 100644 lib/libdvbv5/descriptors/desc_service_list.c
>  delete mode 100644 lib/libdvbv5/descriptors/desc_service_location.c

For all three patches on this series:

Acked-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

Regards,
Mauro
> 


-- 

Cheers,
Mauro
