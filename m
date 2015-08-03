Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f180.google.com ([209.85.212.180]:38128 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752831AbbHCGYG (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 3 Aug 2015 02:24:06 -0400
Received: by wibxm9 with SMTP id xm9so99677916wib.1
        for <linux-media@vger.kernel.org>; Sun, 02 Aug 2015 23:24:05 -0700 (PDT)
Date: Mon, 3 Aug 2015 08:24:01 +0200
From: Zahari Doychev <zahari.doychev@linux.com>
To: Philipp Zabel <p.zabel@pengutronix.de>
Cc: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
	mchehab@osg.samsung.com, k.debski@samsung.com,
	hans.verkuil@cisco.com
Subject: Re: [PATCH 1/2] [media] coda: fix sequence counter increment
Message-ID: <20150803062400.GB3500@riot>
References: <cover.1436361987.git.zahari.doychev@linux.com>
 <22a947a9955de80579174ba9232a597283e330eb.1436361987.git.zahari.doychev@linux.com>
 <1436370559.3079.80.camel@pengutronix.de>
 <55B7432C.7090001@xs4all.nl>
 <1438079131.3193.41.camel@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1438079131.3193.41.camel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Jul 28, 2015 at 12:25:31PM +0200, Philipp Zabel wrote:
> Am Dienstag, den 28.07.2015, 10:54 +0200 schrieb Hans Verkuil:
> > On 07/08/2015 05:49 PM, Philipp Zabel wrote:
> > > Hi Zahari,
> > > 
> > > Am Mittwoch, den 08.07.2015, 15:37 +0200 schrieb Zahari Doychev:
> > >> The coda context queue sequence counter is incremented only if the vb2
> > >> source buffer payload is non zero. This makes possible to signal EOS
> > >> otherwise the condition in coda_buf_is_end_of_stream is never met or more
> > >> precisely buf->v4l2_buf.sequence == (ctx->qsequence - 1) never happens.
> > >>
> > >> Signed-off-by: Zahari Doychev <zahari.doychev@linux.com>
> > > 
> > > I think we should instead avoid calling coda_bitstream_queue with zero
> > > payload buffers altogether and dump them in coda_fill_bitstream already.
> > 
> > Philipp, is this still outstanding or did you fix this already according
> > to the suggestion you made above?
> 
> > Just wondering whether to set this bug report to 'Rejected' or 'Changes
> > Requested'.
> 
> Changes requested.

Ok, I will send a corected version of the patch.

regards
Zahari

> 
> Is this something I should do myself for coda patches in the future?
> 
> regards
> Philipp
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
