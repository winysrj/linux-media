Return-path: <mchehab@pedra>
Received: from smtp.nokia.com ([147.243.128.26]:63620 "EHLO mgw-da02.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751963Ab1A1KwW (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 28 Jan 2011 05:52:22 -0500
Message-ID: <4D42A033.9030906@maxwell.research.nokia.com>
Date: Fri, 28 Jan 2011 12:53:39 +0200
From: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
	alsa-devel@alsa-project.org, broonie@opensource.wolfsonmicro.com,
	clemens@ladisch.de
Subject: Re: [PATCH v8 03/12] media: Entities, pads and links
References: <1296131437-29954-1-git-send-email-laurent.pinchart@ideasonboard.com> <1296131437-29954-4-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1296131437-29954-4-git-send-email-laurent.pinchart@ideasonboard.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Laurent,

Thanks for the patches!

I've got one comment that I should have made long time ago... Pads are
inputs or outputs... or: are they sinks or sources? I recall that it was
agreed on some occasion that sink and source are much less ambiguous and
they should be used instead.

So we'd have MEDIA_PAD_FL_{SINK,SOURCE}, for example. Currently the
source and documentation is using input/output and source/sink
interchangeably. I think sink and source should be used all the time.

What do you think?

Regards,

-- 
Sakari Ailus
sakari.ailus@maxwell.research.nokia.com
