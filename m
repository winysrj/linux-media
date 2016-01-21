Return-path: <linux-media-owner@vger.kernel.org>
Received: from down.free-electrons.com ([37.187.137.238]:55596 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751096AbcAUIun (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 21 Jan 2016 03:50:43 -0500
Date: Thu, 21 Jan 2016 09:50:40 +0100
From: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Laurent Pinchart <Laurent.pinchart@ideasonboard.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [v4l-utils 0/5] Misc build fixes
Message-ID: <20160121095040.2b185fd0@free-electrons.com>
In-Reply-To: <1446584320-25016-1-git-send-email-thomas.petazzoni@free-electrons.com>
References: <1446584320-25016-1-git-send-email-thomas.petazzoni@free-electrons.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

I didn't get any feedback about the below series of patches for
v4l-utils, which was submitted 2 months ago. Anything needs to be
changed/fixed in order to get the patches reviewed/applied ?

Thanks!

Thomas

On Tue,  3 Nov 2015 21:58:35 +0100, Thomas Petazzoni wrote:
> Hello,
> 
> Here is a small set of fixes against v4l-utils that we have
> accumulated in the Buildroot project to fix a number of build
> issues. Those build issues are related to linking with the musl C
> library, or do linking with the libintl library when the gettext
> functions are not provided by the C library (which is what happens the
> uClibc C library is used).
> 
> Thanks,
> 
> Thomas
> 
> Peter Seiderer (1):
>   dvb/keytable: fix missing libintl linking
> 
> Thomas Petazzoni (4):
>   libv4lsyscall-priv.h: Use off_t instead of __off_t
>   utils: Properly use ENABLE_NLS for locale related code
>   utils/v4l2-compliance: Include <fcntl.h> instead of <sys/fcntl.h>
>   libv4lsyscall-priv.h: Only define SYS_mmap2 if needed
> 
>  lib/libv4l1/v4l1compat.c               |  3 +--
>  lib/libv4l2/v4l2convert.c              |  5 ++---
>  lib/libv4lconvert/libv4lsyscall-priv.h | 13 +++++--------
>  utils/dvb/Makefile.am                  |  8 ++++----
>  utils/dvb/dvb-fe-tool.c                |  2 ++
>  utils/dvb/dvb-format-convert.c         |  2 ++
>  utils/dvb/dvbv5-scan.c                 |  2 ++
>  utils/dvb/dvbv5-zap.c                  |  2 ++
>  utils/keytable/Makefile.am             |  1 +
>  utils/keytable/keytable.c              |  2 ++
>  utils/v4l2-compliance/v4l-helpers.h    |  2 +-
>  11 files changed, 24 insertions(+), 18 deletions(-)
> 



-- 
Thomas Petazzoni, CTO, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com
