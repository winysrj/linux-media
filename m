Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:35722 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751222AbZCHSvy (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 8 Mar 2009 14:51:54 -0400
Date: Sun, 8 Mar 2009 15:51:25 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: VDR User <user.vdr@gmail.com>
Cc: Peter Baartz <baartzy@gmail.com>, linux-media@vger.kernel.org
Subject: Re: Kconfig changes in /hg/v4l-dvb caused dvb_usb_cxusb to stop
 building
Message-ID: <20090308155125.5f8afe07@caramujo.chehab.org>
In-Reply-To: <a3ef07920903081138n25f00be1k282061ed17bf406@mail.gmail.com>
References: <d18a06340903080108p3d06e2ajd2f4f1026f1eef40@mail.gmail.com>
	<20090308140304.3cf9370a@caramujo.chehab.org>
	<a3ef07920903081138n25f00be1k282061ed17bf406@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, 8 Mar 2009 11:38:06 -0700
VDR User <user.vdr@gmail.com> wrote:

> On Sun, Mar 8, 2009 at 10:03 AM, Mauro Carvalho Chehab
> <mchehab@infradead.org> wrote:
> > This seems to be caused by a bug at the out-of-tree building system. I'm
> > currently checking what's going wrong.
> 
> Yesterday I grabbed a fresh clone of v4l and compiled drivers for my
> nexus-s.  Only that none of the required frontend modules were enabled
> automatically as they should be when I selected AV7110.  I had to
> manually go enable them by hand.  Luckily I knew which ones were
> needed but I'm sure a ton of users have no clue.

Hopefully, it should be fixed right now. I did a one-line change at the scripts
that does the .config initialization. At least, on my tests, everything seems
to be fine right now with -hg.


Cheers,
Mauro
