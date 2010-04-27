Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.233]:43648 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753933Ab0D0UXw (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 27 Apr 2010 16:23:52 -0400
Message-ID: <4BD747C3.4060609@maxwell.research.nokia.com>
Date: Tue, 27 Apr 2010 23:23:31 +0300
From: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>
CC: "Aguirre, Sergio" <saaguirre@ti.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: [PATCH] V4L: Events: Include slab.h explicitly
References: <1272380899-30398-1-git-send-email-saaguirre@ti.com> <A24693684029E5489D1D202277BE894454F77AEF@dlee02.ent.ti.com> <4BD70C45.7030408@redhat.com> <4BD70DFB.6080303@maxwell.research.nokia.com> <4BD71118.4010409@redhat.com>
In-Reply-To: <4BD71118.4010409@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

Mauro Carvalho Chehab wrote:
> Sakari Ailus wrote:
>> Mauro Carvalho Chehab wrote:
>>> Aguirre, Sergio wrote:
>>>> Sakari,
>>>>
>>>> This patch is based on your event branch:
>>>>
>>>> http://gitorious.org/omap3camera/mainline/commits/event
>>>>
>>>> And is required on latest kernel to compile v4l2-event.c, to make use of kmalloc and other slab.h functions/defines.
>>>
>>> True.
>>>
>>> Sakari,
>>>
>>> Please, add this patch on your series before any Makefile entries that would try to compile
>>> the events interface (or just fold it to the patch that added v4l2-event.c).
>>
>> Unfortunately the Makefile changes are in the same patch than the
>> missing linux/slab.h.
>>
> So, you'll need to fold his patch, or breaking the Makefile changes into another, otherwise, you'll
> break git bisect.

Did you receive my new pull request? It has this change included in the
fourth patch.

Regards,

-- 
Sakari Ailus
sakari.ailus@maxwell.research.nokia.com
