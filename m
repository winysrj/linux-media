Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:36221 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932326AbbG1KZi (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 28 Jul 2015 06:25:38 -0400
Message-ID: <1438079131.3193.41.camel@pengutronix.de>
Subject: Re: [PATCH 1/2] [media] coda: fix sequence counter increment
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Zahari Doychev <zahari.doychev@linux.com>,
	linux-media@vger.kernel.org, mchehab@osg.samsung.com,
	k.debski@samsung.com, hans.verkuil@cisco.com
Date: Tue, 28 Jul 2015 12:25:31 +0200
In-Reply-To: <55B7432C.7090001@xs4all.nl>
References: <cover.1436361987.git.zahari.doychev@linux.com>
		 <22a947a9955de80579174ba9232a597283e330eb.1436361987.git.zahari.doychev@linux.com>
	 <1436370559.3079.80.camel@pengutronix.de> <55B7432C.7090001@xs4all.nl>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am Dienstag, den 28.07.2015, 10:54 +0200 schrieb Hans Verkuil:
> On 07/08/2015 05:49 PM, Philipp Zabel wrote:
> > Hi Zahari,
> > 
> > Am Mittwoch, den 08.07.2015, 15:37 +0200 schrieb Zahari Doychev:
> >> The coda context queue sequence counter is incremented only if the vb2
> >> source buffer payload is non zero. This makes possible to signal EOS
> >> otherwise the condition in coda_buf_is_end_of_stream is never met or more
> >> precisely buf->v4l2_buf.sequence == (ctx->qsequence - 1) never happens.
> >>
> >> Signed-off-by: Zahari Doychev <zahari.doychev@linux.com>
> > 
> > I think we should instead avoid calling coda_bitstream_queue with zero
> > payload buffers altogether and dump them in coda_fill_bitstream already.
> 
> Philipp, is this still outstanding or did you fix this already according
> to the suggestion you made above?

> Just wondering whether to set this bug report to 'Rejected' or 'Changes
> Requested'.

Changes requested.

Is this something I should do myself for coda patches in the future?

regards
Philipp

