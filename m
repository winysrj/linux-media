Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:46311 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752927AbaCAQTi (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 1 Mar 2014 11:19:38 -0500
Message-ID: <5312095E.9080308@iki.fi>
Date: Sat, 01 Mar 2014 18:22:54 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org
CC: k.debski@samsung.com, laurent.pinchart@ideasonboard.com
Subject: Re: [PATH v6 05/10] v4l: Add timestamp source flags, mask and document
 them
References: <1393679828-25878-1-git-send-email-sakari.ailus@iki.fi> <1393679828-25878-6-git-send-email-sakari.ailus@iki.fi> <5311E31F.904@xs4all.nl>
In-Reply-To: <5311E31F.904@xs4all.nl>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

Hans Verkuil wrote:
> Hi Sakari,
> 
> Don't worry, it's a very minor change:

I won't; I'm always happy to get comments. ;-) Thank you again.

> On 03/01/2014 02:17 PM, Sakari Ailus wrote:
>> Some devices do not produce timestamps that correspond to the end of the
>> frame. The user space should be informed on the matter. This patch achieves
>> that by adding buffer flags (and a mask) for timestamp sources since more
>> possible timestamping points are expected than just two.
>>
>> A three-bit mask is defined (V4L2_BUF_FLAG_TSTAMP_SRC_MASK) and two of the
>> eight possible values is are defined V4L2_BUF_FLAG_TSTAMP_SRC_EOF for end of
>> frame (value zero) V4L2_BUF_FLAG_TSTAMP_SRC_SOE for start of exposure (next
>> value).

I'll fix that soonish.

-- 
Sakari Ailus
sakari.ailus@iki.fi
