Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:16505 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754079Ab0D0RAX (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 27 Apr 2010 13:00:23 -0400
Message-ID: <4BD71118.4010409@redhat.com>
Date: Tue, 27 Apr 2010 13:30:16 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
CC: "Aguirre, Sergio" <saaguirre@ti.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: [PATCH] V4L: Events: Include slab.h explicitly
References: <1272380899-30398-1-git-send-email-saaguirre@ti.com> <A24693684029E5489D1D202277BE894454F77AEF@dlee02.ent.ti.com> <4BD70C45.7030408@redhat.com> <4BD70DFB.6080303@maxwell.research.nokia.com>
In-Reply-To: <4BD70DFB.6080303@maxwell.research.nokia.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Sakari Ailus wrote:
> Mauro Carvalho Chehab wrote:
>> Aguirre, Sergio wrote:
>>> Sakari,
>>>
>>> This patch is based on your event branch:
>>>
>>> http://gitorious.org/omap3camera/mainline/commits/event
>>>
>>> And is required on latest kernel to compile v4l2-event.c, to make use of kmalloc and other slab.h functions/defines.
>>
>> True.
>>
>> Sakari,
>>
>> Please, add this patch on your series before any Makefile entries that would try to compile
>> the events interface (or just fold it to the patch that added v4l2-event.c).
> 
> Unfortunately the Makefile changes are in the same patch than the
> missing linux/slab.h.
> 
So, you'll need to fold his patch, or breaking the Makefile changes into another, otherwise, you'll
break git bisect.

-- 

Cheers,
Mauro
