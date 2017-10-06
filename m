Return-path: <linux-media-owner@vger.kernel.org>
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:57215 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751334AbdJFKdx (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 6 Oct 2017 06:33:53 -0400
From: Edgar Thier <info@edgarthier.net>
Subject: Re: [PATCH] uvcvideo: Apply flags from device to actual properties
To: kieran.bingham@ideasonboard.com,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-media@vger.kernel.org
References: <ca483e75-4519-2bc3-eb11-db647fc60860@edgarthier.net>
 <1516233.pKQSzG3xyp@avalon>
 <e6c92808-82e7-05bc-28b4-370ca51aa2de@edgarthier.net>
 <bf6ced8e-6fbb-5054-bbf6-1186d52459b9@ideasonboard.com>
Message-ID: <b52942de-4195-c184-562e-1191b7e95999@edgarthier.net>
Date: Fri, 6 Oct 2017 12:33:50 +0200
MIME-Version: 1.0
In-Reply-To: <bf6ced8e-6fbb-5054-bbf6-1186d52459b9@ideasonboard.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Kieran,

> Rather than forward declaring the function ... Could you put the function higher
> in the module please?

Will do. Patch will come as a reply shortly.


>>> +	if (data == NULL)
>>> +		return -ENOMEM;
>>
>> This will set the callers 'flags' to -ENOMEM ? Is that desired?
>>
>> Of course removing the kmalloc will fix that anyway ...
> Perhaps we have to return an empty flags here, which is what we will return if
> the uvc_query_ctrl() fails anyway.

I wanted to keep the changes to a minimum. So I didn't touch the return values.
Are there any checks done for -ENOMEM et al? I didn't see any.

-Edgar
