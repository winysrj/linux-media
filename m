Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f180.google.com ([209.85.212.180]:37121 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751283AbbEIUvt (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 9 May 2015 16:51:49 -0400
Received: by widdi4 with SMTP id di4so59804501wid.0
        for <linux-media@vger.kernel.org>; Sat, 09 May 2015 13:51:45 -0700 (PDT)
Message-ID: <554E7360.9060301@googlemail.com>
Date: Sat, 09 May 2015 22:51:44 +0200
From: Gregor Jasny <gjasny@googlemail.com>
MIME-Version: 1.0
To: Felix Janda <felix.janda@posteo.de>,
	Hans de Goede <hdegoede@redhat.com>
CC: linux-media@vger.kernel.org
Subject: Re: [PATCHv2 1/4] Use off_t and off64_t instead of __off_t and __off64_t
References: <20150125203557.GA11999@euler> <20150505093657.43acf519@recife.lan> <20150505190223.GA4948@euler>
In-Reply-To: <20150505190223.GA4948@euler>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

Due to complete lack of unit / integration tests I feel uncomfortable
merging this patch without the ACK of Hans de Goede.

On 05/05/15 21:02, Felix Janda wrote:
> Since _LARGEFILE64_SOURCE is 1, these types coincide if defined.

This statement is only partially true:

$ git grep _LARGEFILE64_SOURCE
lib/libv4l1/v4l1compat.c:#define _LARGEFILE64_SOURCE 1
lib/libv4l2/v4l2convert.c:#define _LARGEFILE64_SOURCE 1

So LARGEFILE64_SOURCE will be only defined within the wrappers.
But libv4lsyscall-priv.h / SYS_MMAP is also used elsewhere.

But I wonder why SYS_MMAP is there in the first place? Maybe because in
the LD_PRELOAD case the default mmap symbol resolves to our wrapper?
But in that case can't we gently ask the loader to give us the next
symbol in the chain via dlsym(RTLD_NEXT, "mmap")?

Thanks,
Gregor


