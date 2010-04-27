Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.230]:33292 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756144Ab0D0QRR (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 27 Apr 2010 12:17:17 -0400
Message-ID: <4BD70DFB.6080303@maxwell.research.nokia.com>
Date: Tue, 27 Apr 2010 19:16:59 +0300
From: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>
CC: "Aguirre, Sergio" <saaguirre@ti.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: [PATCH] V4L: Events: Include slab.h explicitly
References: <1272380899-30398-1-git-send-email-saaguirre@ti.com> <A24693684029E5489D1D202277BE894454F77AEF@dlee02.ent.ti.com> <4BD70C45.7030408@redhat.com>
In-Reply-To: <4BD70C45.7030408@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Mauro Carvalho Chehab wrote:
> Aguirre, Sergio wrote:
>> Sakari,
>>
>> This patch is based on your event branch:
>>
>> http://gitorious.org/omap3camera/mainline/commits/event
>>
>> And is required on latest kernel to compile v4l2-event.c, to make use of kmalloc and other slab.h functions/defines.
> 
> 
> True.
> 
> Sakari,
> 
> Please, add this patch on your series before any Makefile entries that would try to compile
> the events interface (or just fold it to the patch that added v4l2-event.c).

Unfortunately the Makefile changes are in the same patch than the
missing linux/slab.h.

-- 
Sakari Ailus
sakari.ailus@maxwell.research.nokia.com
