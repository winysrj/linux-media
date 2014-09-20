Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr15.xs4all.nl ([194.109.24.35]:3196 "EHLO
	smtp-vbr15.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750751AbaITJO2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 20 Sep 2014 05:14:28 -0400
Message-ID: <541D4568.2020605@xs4all.nl>
Date: Sat, 20 Sep 2014 11:14:16 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: James Harper <james@ejbdigital.com.au>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: [PATCH 1/3] vb2: fix VBI/poll regression
References: <1411203375-15310-1-git-send-email-hverkuil@xs4all.nl> <1411203375-15310-2-git-send-email-hverkuil@xs4all.nl> <fc1bd2008429476abaf3e3fab719fe52@SIXPR04MB304.apcprd04.prod.outlook.com>
In-Reply-To: <fc1bd2008429476abaf3e3fab719fe52@SIXPR04MB304.apcprd04.prod.outlook.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 09/20/2014 11:08 AM, James Harper wrote:
>>
>> The recent conversion of saa7134 to vb2 unconvered a poll() bug that
>> broke the teletext applications alevt and mtt. These applications
>> expect that calling poll() without having called VIDIOC_STREAMON will
>> cause poll() to return POLLERR. That did not happen in vb2.
>>
>> This patch fixes that behavior. It also fixes what should happen when
>> poll() is called when STREAMON is called but no buffers have been
>> queued. In that case poll() will also return POLLERR, but only for
>> capture queues since output queues will always return POLLOUT
>> anyway in that situation.
>>
>> This brings the vb2 behavior in line with the old videobuf behavior.
>>
> 
> What (mis)behaviour would this cause in userspace application?

If an app would rely on poll to return POLLERR to do the initial STREAMON
(seen in e.g. alevt) or to do the initial QBUF (I'm not aware of any apps
that do that, but they may exist), then that will currently fail with vb2
because poll() will just wait indefinitely in those cases.

Regards,

	Hans
