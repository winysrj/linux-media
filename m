Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w2.samsung.com ([211.189.100.12]:29524 "EHLO
	usmailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750835Ab3K1MYQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 28 Nov 2013 07:24:16 -0500
Received: from uscpsbgm1.samsung.com
 (u114.gpu85.samsung.co.kr [203.254.195.114]) by mailout2.w2.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MWZ00H633SEBD60@mailout2.w2.samsung.com> for
 linux-media@vger.kernel.org; Thu, 28 Nov 2013 07:24:14 -0500 (EST)
Date: Thu, 28 Nov 2013 10:24:10 -0200
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
To: Gregor Jasny <gjasny@googlemail.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: libdvbv5: dvb_table_pat_init is leaking memory
Message-id: <20131128102410.45bbe3a2@samsung.com>
In-reply-to: <20131127204642.05ddaac5@samsung.com>
References: <CAJxGH09uZhZ0m4GcpAF4moURp18hPmBh5cOP_ZHoNxAaadL_XQ@mail.gmail.com>
 <20131127203121.78baf121@infradead.org> <20131127204642.05ddaac5@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Gregor,

Em Wed, 27 Nov 2013 20:46:42 -0200
Mauro Carvalho Chehab <m.chehab@samsung.com> escreveu:

> Em Wed, 27 Nov 2013 20:31:21 -0200
> Mauro Carvalho Chehab <mchehab@infradead.org> escreveu:
> 
> > Hi Gregor,
> > 
> > Em Wed, 27 Nov 2013 22:55:32 +0100
> > Gregor Jasny <gjasny@googlemail.com> escreveu:
> > 
> > > Hello,
> > > 
> > > Coverity noticed that dvb_table_pat_init leaks the reallocated memory
> > > stored in pat:
> > > http://git.linuxtv.org/v4l-utils.git/blob/HEAD:/lib/libdvbv5/descriptors/pat.c#l26
> > > 
> > > Mauro, could you please check?
> > 
> > On my tests with Valgrind, I'm not noticing any memory leak there, at
> > least on the very latest version I pushed today[1].

After a good resting night, I reviewed it, and it turns that memory leaks
can occur.

So, I re-worked the logic. I also fixed the other bugs pointed by Coverity
today. Could you please re-run the Coverity tests, to see if everything is
OK with the current version?

Thanks!
Mauro

