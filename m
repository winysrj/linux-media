Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtprelay0094.hostedemail.com ([216.40.44.94]:33989 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750912AbbHFNX0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 6 Aug 2015 09:23:26 -0400
Date: Thu, 6 Aug 2015 09:23:21 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Philipp Zabel <p.zabel@pengutronix.de>
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	linux-media@vger.kernel.org, kernel@pengutronix.de
Subject: Re: [PATCH] [media] v4l2: move tracepoint generation into separate
 file
Message-ID: <20150806092321.0d2c36bc@gandalf.local.home>
In-Reply-To: <1438864682-29434-1-git-send-email-p.zabel@pengutronix.de>
References: <1438864682-29434-1-git-send-email-p.zabel@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu,  6 Aug 2015 14:38:02 +0200
Philipp Zabel <p.zabel@pengutronix.de> wrote:

> To compile videobuf2-core as a module, the vb2_* tracepoints must be
> exported from the videodev module. Instead of exporting vb2 tracepoint
> symbols from v4l2-ioctl.c, move the tracepoint generation into a separate
> file. This patch fixes the following build error in the modpost stage,
> introduced by 2091f5181c66 ("[media] videobuf2: add trace events"):
> 
>     ERROR: "__tracepoint_vb2_buf_done" undefined!
>     ERROR: "__tracepoint_vb2_dqbuf" undefined!
>     ERROR: "__tracepoint_vb2_qbuf" undefined!
>     ERROR: "__tracepoint_vb2_buf_queue" undefined!
> 

Suggested-by: Steven Rostedt <rostedt@goodmis.org>

 ;-)

-- Steve

> Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
> ---
