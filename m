Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([85.220.165.71]:56551 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753474AbeE3Rsl (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 30 May 2018 13:48:41 -0400
Date: Wed, 30 May 2018 19:48:33 +0200
From: Philipp Zabel <pza@pengutronix.de>
To: Steve Longerbeam <steve_longerbeam@mentor.com>
Cc: Ian Arkver <ian.arkver.dev@gmail.com>,
        Steve Longerbeam <slongerbeam@gmail.com>,
        Krzysztof =?utf-8?Q?Ha=C5=82asa?= <khalasa@piap.pl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org
Subject: Re: [PATCH 4/6] media: imx-csi: Enable interlaced scan for field
 type alternate
Message-ID: <20180530174833.kk2yr3d6z666nf7y@pengutronix.de>
References: <1527292416-26187-1-git-send-email-steve_longerbeam@mentor.com>
 <1527292416-26187-5-git-send-email-steve_longerbeam@mentor.com>
 <1527490835.6846.1.camel@pengutronix.de>
 <b8a58843-35bd-1f74-2131-4987dcb4b42c@gmail.com>
 <09a689f5-faaf-2c31-0c9b-3ad3a743b450@mentor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <09a689f5-faaf-2c31-0c9b-3ad3a743b450@mentor.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, May 28, 2018 at 09:38:42AM -0700, Steve Longerbeam wrote:
> On 05/28/2018 12:59 AM, Ian Arkver wrote:
> > If your intent here is to de-interweave the two fields back to two
> > sequential fields, I don't believe the IDMAC operation would achieve
> > that. It's basically line stride doubling and a line offset for the
> > lines in the 2nd half of the incoming frame, right?
> 
> I agree, I'm not sure interlaced_scan will perform the inverse (turn an
> interlaced
> buffer into a sequential buffer). If the implementation involves a scan of
> two lines, second line with a memory offset equal to field size, and
> doubling
> the line stride to reach the next set of two lines, then running that
> operation
> on an interlaced buffer would not produce a sequential buffer.

You are both right, of course. What I was thinking of only works
with enabling interlaced_scan on an IDMAC read channel. On an IDMAC
write channel there is no way to turn an interlaced frame back into
consecutive fields.

regards
Philipp
