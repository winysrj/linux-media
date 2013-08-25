Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ea0-f172.google.com ([209.85.215.172]:36437 "EHLO
	mail-ea0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753799Ab3HYUSW (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 25 Aug 2013 16:18:22 -0400
Received: by mail-ea0-f172.google.com with SMTP id r16so1236074ead.31
        for <linux-media@vger.kernel.org>; Sun, 25 Aug 2013 13:18:20 -0700 (PDT)
Message-ID: <521A668A.6010909@gmail.com>
Date: Sun, 25 Aug 2013 22:18:18 +0200
From: Johannes Rohr <jorohr@gmail.com>
MIME-Version: 1.0
To: =?UTF-8?B?QmrDuHJuIE1vcms=?= <bjorn@mork.no>
CC: 719623@bugs.debian.org,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	linux-media@vger.kernel.org
Subject: Re: Bug#719623: linux-image-3.10-2-amd64: kernel panic on inserting
 DVB-T stick
References: <20130813191517.8235.17574.reportbug__30229.9182200388$1376421507$gmane$org@Erwin.babel> <87bo50brh0.fsf@nemi.mork.no>
In-Reply-To: <87bo50brh0.fsf@nemi.mork.no>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am 14.08.2013 10:34, schrieb Bjørn Mork:
> I took a quick look at the code and wonder if the problem is caused by
> an initial zero statistics message?  This is all just a wild guess, but
> if it is correct, then the attached untested patch might fix it...

I have just tested the patch against Debian's kernel sources linux-3.11~rc4

On first try, the kernel panic does not seem to occur with this kernel. 
So possible you solved it!

Thanks,

Johannes
>
>
> Bjørn
>

