Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f175.google.com ([209.85.212.175]:61820 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932068Ab3FQIIC (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 17 Jun 2013 04:08:02 -0400
Received: by mail-wi0-f175.google.com with SMTP id m6so1988005wiv.2
        for <linux-media@vger.kernel.org>; Mon, 17 Jun 2013 01:08:01 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <51BE2B3C.30102@gmail.com>
References: <20130611105032.GJ3103@valkosipuli.retiisi.org.uk>
 <1370947849-24314-1-git-send-email-sakari.ailus@iki.fi> <1370947849-24314-2-git-send-email-sakari.ailus@iki.fi>
 <CA+V-a8t2MUwEHZMvbb0mN+dy6bH6yt_mwirH6cgoTfZfh83cew@mail.gmail.com> <51BE2B3C.30102@gmail.com>
From: Prabhakar Lad <prabhakar.csengg@gmail.com>
Date: Mon, 17 Jun 2013 13:37:40 +0530
Message-ID: <CA+V-a8vx5+XWDrUYfPEk4BEDopQHy7ST_C4Yy9_qCiFdaU7oPw@mail.gmail.com>
Subject: Re: [RFC PATCH 2/2] davinci_vpfe: Clean up media entity after
 unregistering subdev
To: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
Cc: Sakari Ailus <sakari.ailus@iki.fi>,
	laurent.pinchart@ideasonboard.com, s.nawrocki@samsung.com,
	linux-media@vger.kernel.org, kyungmin.park@samsung.com,
	a.hajda@samsung.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sylwester,

On Mon, Jun 17, 2013 at 2:46 AM, Sylwester Nawrocki
<sylvester.nawrocki@gmail.com> wrote:
> Hi,
>
>
> On 06/12/2013 06:44 AM, Prabhakar Lad wrote:
>>
>> On Tue, Jun 11, 2013 at 4:20 PM, Sakari Ailus<sakari.ailus@iki.fi>  wrote:
>>>
>>> media_entity_cleanup() frees the links array which will be accessed by
>>> media_entity_remove_links() called by v4l2_device_unregister_subdev().
>>>
>>> Signed-off-by: Sakari Ailus<sakari.ailus@iki.fi>
>>
>>
>> Acked-by: Lad, Prabhakar<prabhakar.csengg@gmail.com>
>
>
> I have added these two patches to my tree for 3.11 (in branch for-v3.11-2).
> Please let me know if you would like it to be handled differently.
>
I am fine with it.

Regards,
--Prabhakar Lad
