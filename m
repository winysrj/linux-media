Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:63310 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933049Ab1JDVyg (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 4 Oct 2011 17:54:36 -0400
Received: by wwf22 with SMTP id 22so1508888wwf.1
        for <linux-media@vger.kernel.org>; Tue, 04 Oct 2011 14:54:35 -0700 (PDT)
Message-ID: <4e8b8099.95d1e30a.4bee.0501@mx.google.com>
Subject: Re: [PATCH] af9013 frontend tuner bus lock
From: Malcolm Priestley <tvboxspy@gmail.com>
To: Jason Hecker <jwhecker@gmail.com>
Cc: Josu Lazkano <josu.lazkano@gmail.com>,
	linux-media <linux-media@vger.kernel.org>
Date: Tue, 04 Oct 2011 22:54:28 +0100
In-Reply-To: <CAATJ+fvHQgVMVp1uwxxci61qdCdxG89qK0ja-=jo4JRyGW52cw@mail.gmail.com>
References: <4e83369f.5d6de30a.485b.ffffdc29@mx.google.com>
	 <CAL9G6WWK-Fas4Yx2q2gPpLvo5T2SxVVNFtvSXeD7j07JbX2srw@mail.gmail.com>
	 <CAATJ+fvHQgVMVp1uwxxci61qdCdxG89qK0ja-=jo4JRyGW52cw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, 2011-10-05 at 07:44 +1100, Jason Hecker wrote:
> I have had some luck with this patch.  I am still getting fouled
> recordings with tuner A but it's not consistent.  I have yet to
> ascertain if the problem occurs depending on the order of tuning to
> have both tuners recording different frquencies at the same time, ie
> Tuner B then Tuner A or vice versa.

Which Firmware are your using?

I am having some problems with firmware version:5.1.0
I have gone back to using firmware version:4.95.0 no problems at all.

> 
> Malcolm, did you say there was a MythTV tubing bug?  
Yes, sometimes tries to tune to same frequency as the other frontend for
a different channel.

> Do you have an
> URL for the bug if it has been reported?
No

> 
> I fear I might have a multi-layered problem - not only the Afatech
> tuners but perhaps some PCI issue too.  It doesn't help if MythTV
> isn't doing the right thing either.
> 
Yes, because it is also happening with other duo devices on Myth TV
0.24.1

So far Myth TV 0.23.0 on Kernel 2.6.35 seems consistently stable.

Regards

Malcolm

