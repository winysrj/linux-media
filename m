Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.w1.samsung.com ([210.118.77.14]:8698 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753684AbaCLNo7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 12 Mar 2014 09:44:59 -0400
Received: from eucpsbgm2.samsung.com (unknown [203.254.199.245])
 by mailout4.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0N2B00K4FSUWDU00@mailout4.w1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 12 Mar 2014 13:44:56 +0000 (GMT)
Message-id: <532064CF.8040302@samsung.com>
Date: Wed, 12 Mar 2014 14:44:47 +0100
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
MIME-version: 1.0
To: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, laurent.pinchart@ideasonboard.com,
	ismael.luceno@corp.bluecherry.net, pete@sensoray.com,
	sakari.ailus@iki.fi, Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [REVIEWv3 PATCH 14/35] v4l2-ctrls: prepare for matrix support.
References: <1392631070-41868-1-git-send-email-hverkuil@xs4all.nl>
 <1392631070-41868-15-git-send-email-hverkuil@xs4all.nl>
 <20140312074221.73ee30b1@samsung.com> <53205155.7030003@xs4all.nl>
 <20140312100041.513e0a0e@samsung.com>
In-reply-to: <20140312100041.513e0a0e@samsung.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

On 12/03/14 14:00, Mauro Carvalho Chehab wrote:
[...]
> As I commented before: those complex API changes should ideally
> be discussed during our mini-summits, as it allows us to better
> understand the hole proposal and the taken approach.

We discussed this in a dedicated brainstorming meeting in Edinburgh,
with Sakari, Laurent, Andrzej. IIRC you didn't take part in that
discussions for some reason.
After we initially agreed on the API Hans started working on the
actual implementation. He put much effort and did a pretty good
job IMO. I guess we just need to refine any controversial aspects
that might be there and move forward with the API. :)

--
Regards,
Sylwester
