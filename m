Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtprelay0243.hostedemail.com ([216.40.44.243]:39479 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753963AbbHCP4H (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 3 Aug 2015 11:56:07 -0400
Received: from smtprelay.hostedemail.com (10.5.19.251.rfc1918.com [10.5.19.251])
	by smtpgrave06.hostedemail.com (Postfix) with ESMTP id 7A4391734F1
	for <linux-media@vger.kernel.org>; Mon,  3 Aug 2015 15:50:24 +0000 (UTC)
Date: Mon, 3 Aug 2015 11:50:20 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Philipp Zabel <p.zabel@pengutronix.de>
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Pawel Osciak <pawel@osciak.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Kamil Debski <kamil@wypas.org>, linux-media@vger.kernel.org,
	kernel@pengutronix.de
Subject: Re: [PATCH v3 3/3] [media] videobuf2: add trace events
Message-ID: <20150803115020.32063d67@gandalf.local.home>
In-Reply-To: <1438070000.3193.2.camel@pengutronix.de>
References: <1436536166-3307-1-git-send-email-p.zabel@pengutronix.de>
	<1436536166-3307-3-git-send-email-p.zabel@pengutronix.de>
	<55B4C1FD.80201@xs4all.nl>
	<1437995577.3239.20.camel@pengutronix.de>
	<1438070000.3193.2.camel@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, 28 Jul 2015 09:53:20 +0200
Philipp Zabel <p.zabel@pengutronix.de> wrote:


> I tried this yesterday and failed to figure out a satisfactory way to do
> it since the vb2 trace point macros reuse the v4l2 enum definitions and
> __print_symbolic/flags macros. The alternative would be to just export
> the vb2 trace points from videodev.

Or do what some other drivers do, which is to make a separate file to
hold the creation of the tracepoints, and have it included in whatever
needs it. Export them if there's more than one module.

drivers/media/v4l2-core/v4l2-trace.c:

#define CREATE_TRACE_POINTS
#include "v4l2-trace.h"


See fs/xfs/xfs_trace.c as an example.

-- Steve
