Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:64765 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753487Ab1JGWqK (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 7 Oct 2011 18:46:10 -0400
Received: by eyg7 with SMTP id 7so1622899eyg.19
        for <linux-media@vger.kernel.org>; Fri, 07 Oct 2011 15:46:08 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4e8f6b0b.c90fe30a.4a1d.26bb@mx.google.com>
References: <4e83369f.5d6de30a.485b.ffffdc29@mx.google.com>
	<CAL9G6WWK-Fas4Yx2q2gPpLvo5T2SxVVNFtvSXeD7j07JbX2srw@mail.gmail.com>
	<CAATJ+fvHQgVMVp1uwxxci61qdCdxG89qK0ja-=jo4JRyGW52cw@mail.gmail.com>
	<4e8b8099.95d1e30a.4bee.0501@mx.google.com>
	<CAATJ+fvs5OXBS9VREpZM=tY+z+n97Pf42uJFqLXbh58GVZ_reA@mail.gmail.com>
	<CAL9G6WWUv+jKY7LkcJMpwMTvV+A-fzwHYJNgpbAkOiQfPoj5ng@mail.gmail.com>
	<CAATJ+fu2W=o_xhsoghK1756ZGCw2g0W_95iYC8OX04AK8jAHLg@mail.gmail.com>
	<4e8f6b0b.c90fe30a.4a1d.26bb@mx.google.com>
Date: Sat, 8 Oct 2011 09:46:07 +1100
Message-ID: <CAATJ+fvQA4zAcGq+D0+k+OHb8Xsrda5=DATWXbzEO5z=0rWZfw@mail.gmail.com>
Subject: Re: [PATCH] af9013 Extended monitoring in set_frontend.
From: Jason Hecker <jwhecker@gmail.com>
To: Malcolm Priestley <tvboxspy@gmail.com>
Cc: Josu Lazkano <josu.lazkano@gmail.com>,
	linux-media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

> Try this patch, it should stop start up corruption on the same frontend.

Thanks.  I'll try it today.

Have you been able to reproduce any of the corruption issues I and
others are having?

I noticed last night some recordings on the same card had different
levels of corruption depending on the order of tuning

Tuner A then tuner B : Tuner A was heavily corrupted.  Tuner B was a fine.
Tuner B then tuner A: Tuner A had a small corruption every few seconds
and the show was watchable, Tuner B was fine.
