Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:57422 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751531Ab1JHNKc (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 8 Oct 2011 09:10:32 -0400
Received: by wwf22 with SMTP id 22so7150527wwf.1
        for <linux-media@vger.kernel.org>; Sat, 08 Oct 2011 06:10:31 -0700 (PDT)
Message-ID: <4e904bc5.83c9e30a.6332.ffff8e1c@mx.google.com>
Subject: Re: [PATCH] af9013 Extended monitoring in set_frontend.
From: Malcolm Priestley <tvboxspy@gmail.com>
To: Jason Hecker <jwhecker@gmail.com>
Cc: Josu Lazkano <josu.lazkano@gmail.com>,
	linux-media <linux-media@vger.kernel.org>
Date: Sat, 08 Oct 2011 14:10:22 +0100
In-Reply-To: <CAATJ+fvQA4zAcGq+D0+k+OHb8Xsrda5=DATWXbzEO5z=0rWZfw@mail.gmail.com>
References: <4e83369f.5d6de30a.485b.ffffdc29@mx.google.com>
	 <CAL9G6WWK-Fas4Yx2q2gPpLvo5T2SxVVNFtvSXeD7j07JbX2srw@mail.gmail.com>
	 <CAATJ+fvHQgVMVp1uwxxci61qdCdxG89qK0ja-=jo4JRyGW52cw@mail.gmail.com>
	 <4e8b8099.95d1e30a.4bee.0501@mx.google.com>
	 <CAATJ+fvs5OXBS9VREpZM=tY+z+n97Pf42uJFqLXbh58GVZ_reA@mail.gmail.com>
	 <CAL9G6WWUv+jKY7LkcJMpwMTvV+A-fzwHYJNgpbAkOiQfPoj5ng@mail.gmail.com>
	 <CAATJ+fu2W=o_xhsoghK1756ZGCw2g0W_95iYC8OX04AK8jAHLg@mail.gmail.com>
	 <4e8f6b0b.c90fe30a.4a1d.26bb@mx.google.com>
	 <CAATJ+fvQA4zAcGq+D0+k+OHb8Xsrda5=DATWXbzEO5z=0rWZfw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, 2011-10-08 at 09:46 +1100, Jason Hecker wrote:
> > Try this patch, it should stop start up corruption on the same frontend.
> 
> Thanks.  I'll try it today.
> 
> Have you been able to reproduce any of the corruption issues I and
> others are having?
Yes , I left it recording various programmes overnight, but the symptoms
come and go.

> 
> I noticed last night some recordings on the same card had different
> levels of corruption depending on the order of tuning
> 
> Tuner A then tuner B : Tuner A was heavily corrupted.  Tuner B was a fine.
> Tuner B then tuner A: Tuner A had a small corruption every few seconds
> and the show was watchable, Tuner B was fine.

It seems like a lagging effect, as if the devices firmware is slowing
down.


