Return-path: <linux-media-owner@vger.kernel.org>
Received: from bear.ext.ti.com ([192.94.94.41]:34255 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751052Ab1I0HPW (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 27 Sep 2011 03:15:22 -0400
Message-ID: <4E81781B.7090602@ti.com>
Date: Tue, 27 Sep 2011 12:45:39 +0530
From: Archit Taneja <archit@ti.com>
MIME-Version: 1.0
To: "Valkeinen, Tomi" <tomi.valkeinen@ti.com>
CC: "Hiremath, Vaibhav" <hvaibhav@ti.com>,
	"linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
	"Semwal, Sumit" <sumit.semwal@ti.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: [PATCH v3 4/4] OMAP_VOUT: Don't trigger updates in omap_vout_probe
References: <1317038365-30650-1-git-send-email-archit@ti.com>	 <1317038365-30650-5-git-send-email-archit@ti.com>	 <1317103833.1991.6.camel@deskari>  <4E81750F.7060200@ti.com> <1317107261.1991.18.camel@deskari>
In-Reply-To: <1317107261.1991.18.camel@deskari>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tuesday 27 September 2011 12:37 PM, Valkeinen, Tomi wrote:
> On Tue, 2011-09-27 at 12:32 +0530, Archit Taneja wrote:
>> On Tuesday 27 September 2011 11:40 AM, Valkeinen, Tomi wrote:
>>> On Mon, 2011-09-26 at 17:29 +0530, Archit Taneja wrote:
>>>> Remove the code in omap_vout_probe() which calls display->driver->update() for
>>>> all the displays. This isn't correct because:
>>>>
>>>> - An update in probe doesn't make sense, because we don't have any valid content
>>>>     to show at this time.
>>>> - Calling update for a panel which isn't enabled is not supported by DSS2. This
>>>>     leads to a crash at probe.
>>>
>>> Calling update() on a disabled panel should not crash... Where is the
>>> crash coming from?
>>
>> you are right, the crash isn't coming from the updates. I see the crash
>> when we have 4 dss devices in our board file. The last display pointer
>> is corrupted in that case. I'm trying to figure out why.
>
> Could be totally unrelated, but does the V4L2 driver make sure that the
> used dss devices have a driver loaded?
>
> OMAPFB previously refused to start if all the devices do not have a
> driver, but nowadays it starts fine by skipping the devices without a
> driver.

The drivers were loaded in. The issue was something else totally. I 
assumed it was something related to update call.

In drivers/media/video/omap/omap_voutdef.h:

struct omap2video_device {
...
...
struct omap_dss_device *displays[MAX_DISPLAYS];
...
...
};

MAX_DISPLAYS is 3, so the 4th display pointer was getting messed up 
wherever we used it.

I guess we don't need this patch. We may want to set MAX_DISPLAYS to a 
higher number i guess, because we could theoretically register as many 
panels as we want, and set/unset them.

Thanks,
Archit

>
>   Tomi
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-omap" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

