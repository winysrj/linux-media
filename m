Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:34797 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753668AbbHFPoT (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 6 Aug 2015 11:44:19 -0400
Message-ID: <1438875853.3223.5.camel@pengutronix.de>
Subject: Re: [PATCH] [media] v4l2: move tracepoint generation into separate
 file
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	linux-media@vger.kernel.org, kernel@pengutronix.de
Date: Thu, 06 Aug 2015 17:44:13 +0200
In-Reply-To: <20150806092321.0d2c36bc@gandalf.local.home>
References: <1438864682-29434-1-git-send-email-p.zabel@pengutronix.de>
	 <20150806092321.0d2c36bc@gandalf.local.home>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am Donnerstag, den 06.08.2015, 09:23 -0400 schrieb Steven Rostedt:
> On Thu,  6 Aug 2015 14:38:02 +0200
> Philipp Zabel <p.zabel@pengutronix.de> wrote:
> 
> > To compile videobuf2-core as a module, the vb2_* tracepoints must be
> > exported from the videodev module. Instead of exporting vb2 tracepoint
> > symbols from v4l2-ioctl.c, move the tracepoint generation into a separate
> > file. This patch fixes the following build error in the modpost stage,
> > introduced by 2091f5181c66 ("[media] videobuf2: add trace events"):
> > 
> >     ERROR: "__tracepoint_vb2_buf_done" undefined!
> >     ERROR: "__tracepoint_vb2_dqbuf" undefined!
> >     ERROR: "__tracepoint_vb2_qbuf" undefined!
> >     ERROR: "__tracepoint_vb2_buf_queue" undefined!
> > 
> 
> Suggested-by: Steven Rostedt <rostedt@goodmis.org>
> 
>  ;-)

Indeed, thank you.

regards
Philipp

