Return-path: <linux-media-owner@vger.kernel.org>
Received: from bar.sig21.net ([80.81.252.164]:47920 "EHLO bar.sig21.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756539Ab3AOIUQ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 15 Jan 2013 03:20:16 -0500
Date: Tue, 15 Jan 2013 09:20:08 +0100
From: Johannes Stezenbach <js@linuxtv.org>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH RFCv10 00/15] DVB QoS statistics API
Message-ID: <20130115082008.GA30007@linuxtv.org>
References: <1358217061-14982-1-git-send-email-mchehab@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1358217061-14982-1-git-send-email-mchehab@redhat.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Jan 15, 2013 at 12:30:46AM -0200, Mauro Carvalho Chehab wrote:
> Add DVBv5 methods to retrieve QoS statistics.

According to http://en.wikipedia.org/wiki/Qos:
"Quality of service in computer network trafficking refers
to resource reservation control mechanisms"

I think it is misleading to use the term QoS for DVB, what
the patch series seems to be about is receiption or signal quality.


Johannes
