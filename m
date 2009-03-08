Return-path: <linux-media-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.229]:3848 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753325AbZCHSiI (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 8 Mar 2009 14:38:08 -0400
Received: by rv-out-0506.google.com with SMTP id g37so1303702rvb.1
        for <linux-media@vger.kernel.org>; Sun, 08 Mar 2009 11:38:06 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20090308140304.3cf9370a@caramujo.chehab.org>
References: <d18a06340903080108p3d06e2ajd2f4f1026f1eef40@mail.gmail.com>
	 <20090308140304.3cf9370a@caramujo.chehab.org>
Date: Sun, 8 Mar 2009 11:38:06 -0700
Message-ID: <a3ef07920903081138n25f00be1k282061ed17bf406@mail.gmail.com>
Subject: Re: Kconfig changes in /hg/v4l-dvb caused dvb_usb_cxusb to stop
	building
From: VDR User <user.vdr@gmail.com>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: Peter Baartz <baartzy@gmail.com>, linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, Mar 8, 2009 at 10:03 AM, Mauro Carvalho Chehab
<mchehab@infradead.org> wrote:
> This seems to be caused by a bug at the out-of-tree building system. I'm
> currently checking what's going wrong.

Yesterday I grabbed a fresh clone of v4l and compiled drivers for my
nexus-s.  Only that none of the required frontend modules were enabled
automatically as they should be when I selected AV7110.  I had to
manually go enable them by hand.  Luckily I knew which ones were
needed but I'm sure a ton of users have no clue.
