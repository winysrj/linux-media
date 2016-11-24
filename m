Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:39223 "EHLO
        mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S966250AbcKXPtP (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 24 Nov 2016 10:49:15 -0500
Received: from eucas1p2.samsung.com (unknown [182.198.249.207])
 by mailout3.w1.samsung.com
 (Oracle Communications Messaging Server 7.0.5.31.0 64bit (built May  5 2014))
 with ESMTP id <0OH5002YTL9VCM30@mailout3.w1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 24 Nov 2016 15:49:07 +0000 (GMT)
Subject: Re: [PATCH v4l-utils v7 6/7] mediactl: libv4l2subdev: add support for
 comparing mbus formats
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: linux-media@vger.kernel.org, sakari.ailus@linux.intel.com,
        hverkuil@xs4all.nl, mchehab@kernel.org, m.szyprowski@samsung.com,
        s.nawrocki@samsung.com
From: Jacek Anaszewski <j.anaszewski@samsung.com>
Message-id: <a9a61524-4162-8930-a943-7356bc385564@samsung.com>
Date: Thu, 24 Nov 2016 16:49:04 +0100
MIME-version: 1.0
In-reply-to: <20161124143642.GS16630@valkosipuli.retiisi.org.uk>
Content-type: text/plain; charset=windows-1252; format=flowed
Content-transfer-encoding: 7bit
References: <1476282922-11544-1-git-send-email-j.anaszewski@samsung.com>
 <1476282922-11544-7-git-send-email-j.anaszewski@samsung.com>
 <CGME20161124143650epcas5p3290a3fb266d9a3062da1f0963dfeadf3@epcas5p3.samsung.com>
 <20161124143642.GS16630@valkosipuli.retiisi.org.uk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 11/24/2016 03:36 PM, Sakari Ailus wrote:
> Hi Jacek,
>
> On Wed, Oct 12, 2016 at 04:35:21PM +0200, Jacek Anaszewski wrote:
>> This patch adds a function for checking whether two mbus formats
>> are compatible.
>
> Compatible doesn't in general case mean the same as... the same.
>
> On parallel busses a 10-bit source can be connected to an 8-bit sink-for
> instance.
>
> How about moving this to the plugin, and if someone else needs it, then we
> move it out later?

This is a good idea, as I am checking not all fields of
v4l2_mbus_framefmt, but only those which matter during Exynos4 media
devuce pipeline format negotiation.

-- 
Best regards,
Jacek Anaszewski
