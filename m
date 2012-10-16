Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:63727 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754244Ab2JPHUr (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 16 Oct 2012 03:20:47 -0400
Received: by mail-bk0-f46.google.com with SMTP id jk13so2792192bkc.19
        for <linux-media@vger.kernel.org>; Tue, 16 Oct 2012 00:20:45 -0700 (PDT)
Message-ID: <507D0ACB.6090802@googlemail.com>
Date: Tue, 16 Oct 2012 09:20:43 +0200
From: Gregor Jasny <gjasny@googlemail.com>
MIME-Version: 1.0
To: Wojciech Myrda <vojcek@tlen.pl>
CC: linux-media@vger.kernel.org
Subject: Re: [segfault] running ir-keytable with v4l-utils 0.8.9
References: <507B1879.9020100@tlen.pl>
In-Reply-To: <507B1879.9020100@tlen.pl>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

On 10/14/12 9:54 PM, Wojciech Myrda wrote:
> On my system I have just installed using bumped Gentoo ebuilds v4l-utils
> package
>
> [ebuild   R    ] media-libs/libv4l-0.8.9::bigvo  0 kB
> [ebuild   R    ] media-tv/v4l-utils-0.8.9::bigvo  USE="-qt4" 0 kB
>
> ebuilds used for bumbing to version 0.8.9:
> http://gentoo-portage.com/media-libs/libv4l/libv4l-0.8.8
> http://gentoo-portage.com/media-tv/v4l-utils/v4l-utils-0.8.8-r1
>
> However I experienced a segfault trying to run this command:
> ir-keytable --protocol=rc-6 --device
> /dev/input/by-id/usb-15c2_0038-event-if00

There seems to be some problems with options or file parsing. Valgrind 
is complaining, too. I'll have a look later.

Is this segfault a regression over an older v4l-utils version?

Thanks,
Gregor
