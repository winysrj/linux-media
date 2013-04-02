Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.w1.samsung.com ([210.118.77.14]:27970 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757055Ab3DBRaS (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 2 Apr 2013 13:30:18 -0400
Received: from eucpsbgm2.samsung.com (unknown [203.254.199.245])
 by mailout4.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MKN00HEW1Y3WJB0@mailout4.w1.samsung.com> for
 linux-media@vger.kernel.org; Tue, 02 Apr 2013 18:30:16 +0100 (BST)
Message-id: <515B15A7.3040209@samsung.com>
Date: Tue, 02 Apr 2013 19:30:15 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
MIME-version: 1.0
To: Rob Herring <robherring2@gmail.com>
Cc: LMML <linux-media@vger.kernel.org>,
	Grant Likely <grant.likely@secretlab.ca>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans Verkuil <hverkuil@xs4all.nl>
Subject: Re: [GIT PULL FOR 3.10] Media DT bindings and V4L2 OF parsing library
References: <5155D1EE.1020201@samsung.com> <5155F7F6.4070400@gmail.com>
In-reply-to: <5155F7F6.4070400@gmail.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 03/29/2013 09:22 PM, Rob Herring wrote:
> On 03/29/2013 12:39 PM, Sylwester Nawrocki wrote:
>> > Mauro,
>> > 
>> > This includes two patches adding device tree support at the V4L2 API.
>> > I added Rob and Grant at Cc in case they still wanted to comment on
>> > those patches. Not sure what the exact policy is but I guess we need
>> > an explicit DT maintainer's Ack on stuff like this.
>
> Bindings regularly go in without Grant's or my ack simply because there
> are too many to keep up with and it really requires knowledge of the
> particular h/w being described.

OK, I suspected the high volume of patches might be of an issue. Anyway,
I find the devicetree mailing list one of the most interesting, since
the discussions there are fairly diverse, touching various subsystems.

> I've skimmed thru this one on several versions and nothing concerning
> jumps out. So I think it is good to go in.

Thanks, it's now queued in the media tree for 3.10.

--

Regards,
Sylwester
