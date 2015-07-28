Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud3.xs4all.net ([194.109.24.30]:33450 "EHLO
	lb3-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754791AbbG1IyN (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 28 Jul 2015 04:54:13 -0400
Message-ID: <55B7432C.7090001@xs4all.nl>
Date: Tue, 28 Jul 2015 10:54:04 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Philipp Zabel <p.zabel@pengutronix.de>,
	Zahari Doychev <zahari.doychev@linux.com>
CC: linux-media@vger.kernel.org, mchehab@osg.samsung.com,
	k.debski@samsung.com, hans.verkuil@cisco.com
Subject: Re: [PATCH 1/2] [media] coda: fix sequence counter increment
References: <cover.1436361987.git.zahari.doychev@linux.com>	 <22a947a9955de80579174ba9232a597283e330eb.1436361987.git.zahari.doychev@linux.com> <1436370559.3079.80.camel@pengutronix.de>
In-Reply-To: <1436370559.3079.80.camel@pengutronix.de>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 07/08/2015 05:49 PM, Philipp Zabel wrote:
> Hi Zahari,
> 
> Am Mittwoch, den 08.07.2015, 15:37 +0200 schrieb Zahari Doychev:
>> The coda context queue sequence counter is incremented only if the vb2
>> source buffer payload is non zero. This makes possible to signal EOS
>> otherwise the condition in coda_buf_is_end_of_stream is never met or more
>> precisely buf->v4l2_buf.sequence == (ctx->qsequence - 1) never happens.
>>
>> Signed-off-by: Zahari Doychev <zahari.doychev@linux.com>
> 
> I think we should instead avoid calling coda_bitstream_queue with zero
> payload buffers altogether and dump them in coda_fill_bitstream already.

Philipp, is this still outstanding or did you fix this already according
to the suggestion you made above?

Just wondering whether to set this bug report to 'Rejected' or 'Changes
Requested'.

Regards,

	Hans
