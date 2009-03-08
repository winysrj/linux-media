Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:36849 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752665AbZCHRDc (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 8 Mar 2009 13:03:32 -0400
Date: Sun, 8 Mar 2009 14:03:04 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Peter Baartz <baartzy@gmail.com>
Cc: linux-media@vger.kernel.org
Subject: Re: Kconfig changes in /hg/v4l-dvb caused dvb_usb_cxusb to stop
 building
Message-ID: <20090308140304.3cf9370a@caramujo.chehab.org>
In-Reply-To: <d18a06340903080108p3d06e2ajd2f4f1026f1eef40@mail.gmail.com>
References: <d18a06340903080108p3d06e2ajd2f4f1026f1eef40@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, 8 Mar 2009 19:08:43 +1000
Peter Baartz <baartzy@gmail.com> wrote:

> HI,
> 
> I have Dvico dual 4 DVB-T card (rev. 2), which  wants to use the
> module dvb_usb_cxusb.
> 
> When i attempt  build http://linuxtv.org/hg/v4l-dvb, make no longer
> builds cxusb...
> 
> The  Kconfig: commits appear to have caused this... i.e. cxusb build
> fine when using  "changeset 10834	277d533e87cd"  (it's just prior  to
> Kconfig: commits )  from hg/v4l-dvb.

Peter,

This seems to be caused by a bug at the out-of-tree building system. I'm
currently checking what's going wrong.

Cheers,
Mauro
