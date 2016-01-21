Return-path: <linux-media-owner@vger.kernel.org>
Received: from aer-iport-1.cisco.com ([173.38.203.51]:14347 "EHLO
	aer-iport-1.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759078AbcAUJJz (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 21 Jan 2016 04:09:55 -0500
Subject: Re: [v4l-utils 0/5] Misc build fixes
To: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
References: <1446584320-25016-1-git-send-email-thomas.petazzoni@free-electrons.com>
 <20160121095040.2b185fd0@free-electrons.com>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Laurent Pinchart <Laurent.pinchart@ideasonboard.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
From: Hans Verkuil <hansverk@cisco.com>
Message-ID: <56A09F03.2090201@cisco.com>
Date: Thu, 21 Jan 2016 10:04:03 +0100
MIME-Version: 1.0
In-Reply-To: <20160121095040.2b185fd0@free-electrons.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

They are already merged, so there is nothing to do :-)

Weird, you should have gotten an email from patchwork when I accepted these
patches.

Regards,

	Hans

On 01/21/16 09:50, Thomas Petazzoni wrote:
> Hello,
> 
> I didn't get any feedback about the below series of patches for
> v4l-utils, which was submitted 2 months ago. Anything needs to be
> changed/fixed in order to get the patches reviewed/applied ?
> 
> Thanks!
> 
> Thomas
> 
> On Tue,  3 Nov 2015 21:58:35 +0100, Thomas Petazzoni wrote:
>> Hello,
>>
>> Here is a small set of fixes against v4l-utils that we have
>> accumulated in the Buildroot project to fix a number of build
>> issues. Those build issues are related to linking with the musl C
>> library, or do linking with the libintl library when the gettext
>> functions are not provided by the C library (which is what happens the
>> uClibc C library is used).
>>
>> Thanks,
>>
>> Thomas
>>
>> Peter Seiderer (1):
>>   dvb/keytable: fix missing libintl linking
>>
>> Thomas Petazzoni (4):
>>   libv4lsyscall-priv.h: Use off_t instead of __off_t
>>   utils: Properly use ENABLE_NLS for locale related code
>>   utils/v4l2-compliance: Include <fcntl.h> instead of <sys/fcntl.h>
>>   libv4lsyscall-priv.h: Only define SYS_mmap2 if needed
>>
>>  lib/libv4l1/v4l1compat.c               |  3 +--
>>  lib/libv4l2/v4l2convert.c              |  5 ++---
>>  lib/libv4lconvert/libv4lsyscall-priv.h | 13 +++++--------
>>  utils/dvb/Makefile.am                  |  8 ++++----
>>  utils/dvb/dvb-fe-tool.c                |  2 ++
>>  utils/dvb/dvb-format-convert.c         |  2 ++
>>  utils/dvb/dvbv5-scan.c                 |  2 ++
>>  utils/dvb/dvbv5-zap.c                  |  2 ++
>>  utils/keytable/Makefile.am             |  1 +
>>  utils/keytable/keytable.c              |  2 ++
>>  utils/v4l2-compliance/v4l-helpers.h    |  2 +-
>>  11 files changed, 24 insertions(+), 18 deletions(-)
>>
> 
> 
> 
