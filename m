Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr12.xs4all.nl ([194.109.24.32]:4605 "EHLO
	smtp-vbr12.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752315Ab3LMMDc (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 13 Dec 2013 07:03:32 -0500
Message-ID: <52AAF759.9010107@xs4all.nl>
Date: Fri, 13 Dec 2013 13:02:33 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Sakari Ailus <sakari.ailus@iki.fi>
CC: linux-media@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>,
	David Cohen <dacohen@gmail.com>
Subject: Re: [RFCv2 PATCH 2/2] omap24xx/tcm825x: move to staging for future
 removal.
References: <1386851193-3845-1-git-send-email-hverkuil@xs4all.nl> <1386851193-3845-3-git-send-email-hverkuil@xs4all.nl> <20131213112930.GU30652@valkosipuli.retiisi.org.uk>
In-Reply-To: <20131213112930.GU30652@valkosipuli.retiisi.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 12/13/2013 12:29 PM, Sakari Ailus wrote:
> Hi Hans,
> 
> On Thu, Dec 12, 2013 at 01:26:33PM +0100, Hans Verkuil wrote:
>> From: Hans Verkuil <hans.verkuil@cisco.com>
>>
>> The omap24xx driver and the tcm825x sensor driver are the only two
>> remaining drivers to still use the old deprecated v4l2-int-device API.
>>
>> Nobody maintains these drivers anymore. But unfortunately the v4l2-int-device
>> API is used by out-of-tree drivers (MXC platform). This is a very bad situation
>> since as long as this deprecated API stays in the kernel there is no reason for
>> those out-of-tree drivers to convert.
>>
>> This patch moves v4l2-int-device and the two drivers that depend on it to
>> staging in preparation for their removal.
> 
> Do you think we should move these to staging instead of removing them right
> away? These drivers have never been in a usable state in the mainline
> kernel due to missing platform data. Currently they suffer from other
> problems, too. I'd be surprised if they compile.

They do compile, they are part of my daily build.

> 
> If I wanted to get them working again I'd start with this since it's not
> very far from the state where they used to work:
> 
> <URL:http://vihersipuli.retiisi.org.uk/cgi-bin/gitweb.cgi?p=~sailus/linux-omap/.git;a=summary>
> 
> The branch is n800-cam . Porting to up-to-date APIs can then be done, and I
> think David did some work to that end.
> 

I think I prefer to keep them in staging for at least one kernel release (3.14)
and drop them in 3.15.

Although if the consensus is to just drop them, then I won't object :-)

Regards,

	Hans
