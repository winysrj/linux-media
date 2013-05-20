Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bk0-f49.google.com ([209.85.214.49]:38302 "EHLO
	mail-bk0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756485Ab3ETKzH (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 20 May 2013 06:55:07 -0400
Received: by mail-bk0-f49.google.com with SMTP id na10so3427197bkb.22
        for <linux-media@vger.kernel.org>; Mon, 20 May 2013 03:55:06 -0700 (PDT)
Message-ID: <519A0108.1090101@gmail.com>
Date: Mon, 20 May 2013 12:55:04 +0200
From: poma <pomidorabelisima@gmail.com>
MIME-Version: 1.0
To: debian@dct.mine.nu
CC: gennarone@gmail.com, linux-media@vger.kernel.org
Subject: Re: Kernel freezing with RTL2832U+R820T
References: <51898A55.8050005@dct.mine.nu> <5189B5E1.3050201@gmail.com> <51965C42.4060801@dct.mine.nu> <5196902E.5030801@gmail.com> <51972F64.3080009@dct.mine.nu>
In-Reply-To: <51972F64.3080009@dct.mine.nu>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 18.05.2013 09:36, Karsten Malcher wrote:
> Hi Gianluca,
> 
> the crash / freezing occurs before disconnect in normal operation.
> So the patch will not solve this problem.

Although media_build/backports allows you to build certain modules for
certain older *kernels*, it doesn't mean that these modules will work
tuneful within them. Therefore, I recommend the *recent* ones.
Take note of last Mauro's git pull[1]. ;)


poma


[1] http://www.spinics.net/lists/linux-media/msg63181.html


