Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vn0-f49.google.com ([209.85.216.49]:46958 "EHLO
	mail-vn0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754140AbbDJKm4 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 10 Apr 2015 06:42:56 -0400
MIME-Version: 1.0
In-Reply-To: <551D4220.7070303@xs4all.nl>
References: <1425825653-14768-1-git-send-email-prabhakar.csengg@gmail.com>
	<CAHG8p1AZMnV_ZLA1Ou=wejxwaHRObX1aAgO=xbXiwwEsJZ9EZA@mail.gmail.com>
	<551D4220.7070303@xs4all.nl>
Date: Fri, 10 Apr 2015 18:42:55 +0800
Message-ID: <CAHG8p1AezvQk1Z0tQzFKXZa3Qnd4+MV53F7VP69vwvXVYaqmkg@mail.gmail.com>
Subject: Re: [PATCH v4 00/17] media: blackfin: bfin_capture enhancements
From: Scott Jiang <scott.jiang.linux@gmail.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Lad Prabhakar <prabhakar.csengg@gmail.com>,
	LMML <linux-media@vger.kernel.org>,
	adi-buildroot-devel@lists.sourceforge.net,
	LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

>>
>> Hans, I tried to use v4l2-compliance but it failed to compile. Sorry
>> for telling you it have passed compilation because I forgot to use
>> blackfin toolchain.
>> ./configure --without-jpeg  --host=bfin-linux-uclibc --disable-libv4l
>>
>> The main problem is there is no argp.h in uClibc, how to disable checking this?
>>
>> checking for argp.h... no
>> configure: error: Cannot continue: argp.h not found
>>
>> Scott
>>
>
> Hi Scott,
>
> Can you try this patch for v4l-utils? It makes argp optional, and it should
> allow v4l2-compliance to compile with uclibc (unless there are more problems).
>
> I'm no autoconf guru, so I'm not certain if everything is correct, but it
> seemed to do its job when I remove argp.h from my system.
>

Yes, I can pass configure now. But there is another error when make

make[3]: Entering directory
`/home/scott/projects/git-kernel/v4l-utils/lib/libdvbv5'
  CC     libdvbv5_la-parse_string.lo
parse_string.c:26:19: error: iconv.h: No such file or directory
parse_string.c: In function 'dvb_iconv_to_charset':
parse_string.c:316: error: 'iconv_t' undeclared (first use in this function)

I tried to pass this library, while --without-libdvbv5 is not supported.

Scott
