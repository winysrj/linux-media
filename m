Return-path: <linux-media-owner@vger.kernel.org>
Received: from guitar.tcltek.co.il ([192.115.133.116]:36764 "EHLO
        mx.tkos.co.il" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732848AbeGKTos (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 11 Jul 2018 15:44:48 -0400
References: <20180711132251.13172-1-ezequiel@collabora.com> <20180711115505.5b93de93@coco.lan>
From: Baruch Siach <baruch@tkos.co.il>
To: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Cc: Ezequiel Garcia <ezequiel@collabora.com>,
        linux-media@vger.kernel.org, Hans Verkuil <hverkuil@xs4all.nl>,
        Peter Korsgaard <jacmet@sunsite.dk>,
        Peter Korsgaard <peter@korsgaard.com>
Subject: Re: [PATCH] libv4l: fixup lfs mismatch in preload libraries
In-reply-to: <20180711115505.5b93de93@coco.lan>
Date: Wed, 11 Jul 2018 22:38:56 +0300
Message-ID: <878t6h5zqn.fsf@tkos.co.il>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

Added Peter's updated address to Cc.

Mauro Carvalho Chehab writes:
> Em Wed, 11 Jul 2018 10:22:51 -0300
> Ezequiel Garcia <ezequiel@collabora.com> escreveu:
>
>> From: Peter Korsgaard <jacmet@sunsite.dk>
>> 
>> Ensure that the lfs variants are not transparently used instead of the !lfs
>> ones so both can be wrapped, independently of any custom CFLAGS/CPPFLAGS.
>> 
>> Without this patch, the following assembler errors appear
>> during cross-compiling with Buildroot:
>> 
>> /tmp/ccc3gdJg.s: Assembler messages:
>> /tmp/ccc3gdJg.s:67: Error: symbol `open64' is already defined
>> /tmp/ccc3gdJg.s:130: Error: symbol `mmap64' is already defined
>> 
>> Signed-off-by: Peter Korsgaard <jacmet@sunsite.dk>
>> Signed-off-by: Ezequiel Garcia <ezequiel@collabora.com>
>> ---
>>  lib/libv4l1/v4l1compat.c  | 3 +++
>>  lib/libv4l2/v4l2convert.c | 3 +++
>>  2 files changed, 6 insertions(+)
>> 
>> diff --git a/lib/libv4l1/v4l1compat.c b/lib/libv4l1/v4l1compat.c
>> index cb79629ff88f..e5c9e56261e2 100644
>> --- a/lib/libv4l1/v4l1compat.c
>> +++ b/lib/libv4l1/v4l1compat.c
>> @@ -19,6 +19,9 @@
>>  # Foundation, Inc., 51 Franklin Street, Suite 500, Boston, MA  02110-1335  USA
>>   */
>>  
>> +/* ensure we see *64 variants and they aren't transparently used */
>> +#undef _LARGEFILE_SOURCE
>> +#undef _FILE_OFFSET_BITS
>
> Hmm... shouldn't this be autodetected? I didn't check anything,
> but I would be expecting that different distros (and BSD) may be
> doing different things here, specially if they use different gcc
> versions or even different libc implementations.

See Peter's explanation here:

  http://lists.busybox.net/pipermail/buildroot/2017-December/210067.html

baruch

>>  #define _LARGEFILE64_SOURCE 1
>>  
>>  #include <config.h>
>> diff --git a/lib/libv4l2/v4l2convert.c b/lib/libv4l2/v4l2convert.c
>> index 7c9a04c086ed..13ca4cfb1b08 100644
>> --- a/lib/libv4l2/v4l2convert.c
>> +++ b/lib/libv4l2/v4l2convert.c
>> @@ -23,6 +23,9 @@
>>  /* prevent GCC 4.7 inlining error */
>>  #undef _FORTIFY_SOURCE
>>  
>> +/* ensure we see *64 variants and they aren't transparently used */
>> +#undef _LARGEFILE_SOURCE
>> +#undef _FILE_OFFSET_BITS
>>  #define _LARGEFILE64_SOURCE 1
>>  
>>  #ifdef ANDROID


-- 
     http://baruch.siach.name/blog/                  ~. .~   Tk Open Systems
=}------------------------------------------------ooO--U--Ooo------------{=
   - baruch@tkos.co.il - tel: +972.52.368.4656, http://www.tkos.co.il -
