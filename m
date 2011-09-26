Return-path: <linux-media-owner@vger.kernel.org>
Received: from devils.ext.ti.com ([198.47.26.153]:39966 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751099Ab1IZFe2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 26 Sep 2011 01:34:28 -0400
Message-ID: <4E800EEC.8080905@ti.com>
Date: Mon, 26 Sep 2011 11:04:36 +0530
From: Archit Taneja <archit@ti.com>
MIME-Version: 1.0
To: "Taneja, Archit" <archit@ti.com>
CC: "Hiremath, Vaibhav" <hvaibhav@ti.com>,
	"Valkeinen, Tomi" <tomi.valkeinen@ti.com>,
	"linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
	"Semwal, Sumit" <sumit.semwal@ti.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: [PATCH 2/5] [media]: OMAP_VOUT: CLEANUP: Remove redundant code
 from omap_vout_isr
References: <1316167233-1437-1-git-send-email-archit@ti.com> <1316167233-1437-3-git-send-email-archit@ti.com> <19F8576C6E063C45BE387C64729E739404EC941E8B@dbde02.ent.ti.com> <4E79C053.903@ti.com>
In-Reply-To: <4E79C053.903@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On Wednesday 21 September 2011 04:15 PM, Taneja, Archit wrote:
> Hi,
>
> On Wednesday 21 September 2011 03:35 PM, Hiremath, Vaibhav wrote:
>>
>>> -----Original Message-----
>>> From: Taneja, Archit
>>> Sent: Friday, September 16, 2011 3:31 PM
>>> To: Hiremath, Vaibhav
>>> Cc: Valkeinen, Tomi; linux-omap@vger.kernel.org; Semwal, Sumit; linux-
>>> media@vger.kernel.org; Taneja, Archit
>>> Subject: [PATCH 2/5] [media]: OMAP_VOUT: CLEANUP: Remove redundant code
>>> from omap_vout_isr
>>>
>>> Currently, there is a lot of redundant code is between DPI and VENC panels,
>>> this
>>> can be made common by moving out field/interlace specific code to a
>>> separate
>>> function called omapvid_handle_interlace_display(). There is no functional
>>> change made.
>>>
>>> Signed-off-by: Archit Taneja<archit@ti.com>
>>> ---
>>>    drivers/media/video/omap/omap_vout.c |  172 ++++++++++++++++-------------
>>> -----


>> [Hiremath, Vaibhav]
>> Have you tested TV out functionality?
>
> I haven't checked it yet to be totally honest. Its hard to find a VENC
> TV! I wanted to anyway get some kind of Ack from you before starting to
> test this. Since you also feel that this clean up is needed, I'll start
> testing this out :)

I tested the TV out functionality. It works fine. I have left the extra 
fid == 0 check so that the code is more clear. Will post out the new 
patch soon.

Archit
