Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:38292 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752540AbZBOMgu (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 15 Feb 2009 07:36:50 -0500
From: Oliver Endriss <o.endriss@gmx.de>
Reply-To: linux-media@vger.kernel.org
To: linux-media@vger.kernel.org
Subject: Re: [BUG] changeset 9029 (http://linuxtv.org/hg/v4l-dvb/rev/aa3e5cc1d833)
Date: Sun, 15 Feb 2009 13:36:16 +0100
Cc: e9hack <e9hack@googlemail.com>, obi@linuxtv.org,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	linux-dvb@linuxtv.org
References: <4986507C.1050609@googlemail.com>
In-Reply-To: <4986507C.1050609@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902151336.17202@orion.escape-edv.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

e9hack wrote:
> Hi,
> 
> this change set is wrong. The affected functions cannot be called from an interrupt
> context, because they may process large buffers. In this case, interrupts are disabled for
> a long time. Functions, like dvb_dmx_swfilter_packets(), could be called only from a
> tasklet. This change set does hide some strong design bugs in dm1105.c and au0828-dvb.c.
> 
> Please revert this change set and do fix the bugs in dm1105.c and au0828-dvb.c (and other
> files).

@Mauro:

This changeset _must_ be reverted! It breaks all kernels since 2.6.27
for applications which use DVB and require a low interrupt latency.

It is a very bad idea to call the demuxer to process data buffers with
interrupts disabled!

FYI, a LIRC problem was reported here:
  http://vdrportal.de/board/thread.php?postid=786366#post786366

and it has been verified that changeset
  http://linuxtv.org/hg/v4l-dvb/rev/aa3e5cc1d833
causes the problem:
  http://vdrportal.de/board/thread.php?postid=791813#post791813

Please revert this changeset immediately and submit a fix to the stable
kernels >= 2.6.27.

CU
Oliver

-- 
----------------------------------------------------------------
VDR Remote Plugin 0.4.0: http://www.escape-edv.de/endriss/vdr/
----------------------------------------------------------------
