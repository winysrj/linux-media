Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:21189 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932318AbbDHNyA (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 8 Apr 2015 09:54:00 -0400
Message-ID: <552532C2.2040806@linux.intel.com>
Date: Wed, 08 Apr 2015 16:53:06 +0300
From: Sakari Ailus <sakari.ailus@linux.intel.com>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: linux-media@vger.kernel.org
Subject: Re: [PATCH 1/1] media: Correctly notify about the failed
 pipeline validation
References: <1423748591-19402-1-git-send-email-sakari.ailus@linux.intel.com> <4424832.AmZfJ0mdjq@avalon>
In-Reply-To: <4424832.AmZfJ0mdjq@avalon>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

Laurent Pinchart wrote:
> Hello Sakari,
>
> Thank you for the patch.
>
> On Thursday 12 February 2015 15:43:11 Sakari Ailus wrote:
>> On the place of the source entity name, the sink entity name was printed.
>>
>> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
>
> Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
>
> and applied to my tree. It's a bit late for v4.1, can it wait for v4.2 ?

Thanks!

v4.2 is fine. This is just a bug fix in a debug print. I wouldn't bother 
with stable or v4.1.

-- 
Sakari Ailus
sakari.ailus@linux.intel.com
