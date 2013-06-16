Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bk0-f49.google.com ([209.85.214.49]:47608 "EHLO
	mail-bk0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754207Ab3FPVQt (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 16 Jun 2013 17:16:49 -0400
Received: by mail-bk0-f49.google.com with SMTP id mz10so885029bkb.22
        for <linux-media@vger.kernel.org>; Sun, 16 Jun 2013 14:16:47 -0700 (PDT)
Message-ID: <51BE2B3C.30102@gmail.com>
Date: Sun, 16 Jun 2013 23:16:44 +0200
From: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
MIME-Version: 1.0
To: Prabhakar Lad <prabhakar.csengg@gmail.com>,
	Sakari Ailus <sakari.ailus@iki.fi>,
	laurent.pinchart@ideasonboard.com
CC: s.nawrocki@samsung.com, linux-media@vger.kernel.org,
	kyungmin.park@samsung.com, a.hajda@samsung.com
Subject: Re: [RFC PATCH 2/2] davinci_vpfe: Clean up media entity after unregistering
 subdev
References: <20130611105032.GJ3103@valkosipuli.retiisi.org.uk> <1370947849-24314-1-git-send-email-sakari.ailus@iki.fi> <1370947849-24314-2-git-send-email-sakari.ailus@iki.fi> <CA+V-a8t2MUwEHZMvbb0mN+dy6bH6yt_mwirH6cgoTfZfh83cew@mail.gmail.com>
In-Reply-To: <CA+V-a8t2MUwEHZMvbb0mN+dy6bH6yt_mwirH6cgoTfZfh83cew@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On 06/12/2013 06:44 AM, Prabhakar Lad wrote:
> On Tue, Jun 11, 2013 at 4:20 PM, Sakari Ailus<sakari.ailus@iki.fi>  wrote:
>> media_entity_cleanup() frees the links array which will be accessed by
>> media_entity_remove_links() called by v4l2_device_unregister_subdev().
>>
>> Signed-off-by: Sakari Ailus<sakari.ailus@iki.fi>
>
> Acked-by: Lad, Prabhakar<prabhakar.csengg@gmail.com>

I have added these two patches to my tree for 3.11 (in branch for-v3.11-2).
Please let me know if you would like it to be handled differently.

Regards,
Sylwester
