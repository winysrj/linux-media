Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:40657 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751390AbaFFJq3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 6 Jun 2014 05:46:29 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Pawel Osciak <pawel@osciak.com>,
	LMML <linux-media@vger.kernel.org>,
	Nicolas Dufresne <nicolas.dufresne@collabora.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>
Subject: Re: [PATCH/RFC v2 2/2] v4l: vb2: Add fatal error condition flag
Date: Fri, 06 Jun 2014 11:46:58 +0200
Message-ID: <1435470.qABIAKhMXR@avalon>
In-Reply-To: <53918A8B.1040308@xs4all.nl>
References: <1401970991-4421-1-git-send-email-laurent.pinchart@ideasonboard.com> <2013428.7yG2aMynBj@avalon> <53918A8B.1040308@xs4all.nl>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On Friday 06 June 2014 11:31:55 Hans Verkuil wrote:
> On 06/06/2014 11:19 AM, Laurent Pinchart wrote:
> > Hi Pawel,
> > 
> > On Friday 06 June 2014 14:31:15 Pawel Osciak wrote:
> >> Hi Laurent,
> >> Thanks for the patch. Did you test this to work in fileio mode? Looks
> >> like it should, but would like to make sure.
> > 
> > No, I haven't tested it. The OMAP4 ISS driver, which is my test target for
> > this patch, doesn't support fileio mode. Adding VB2_READ would be easy,
> > but the driver requires configuring the format on the file handle used for
> > streaming, so I can't just run cat /dev/video*.
> 
> Just test with vivi.

But vivi doesn't call the new vb2_queue_error() function. I understand that 
your vivi rework would make that easier as you now have an error control. 
Should I hack something similar in the existing vivi driver ? Any pointer ?

-- 
Regards,

Laurent Pinchart

