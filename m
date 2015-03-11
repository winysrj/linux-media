Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-la0-f45.google.com ([209.85.215.45]:41571 "EHLO
	mail-la0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751076AbbCKWj0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 11 Mar 2015 18:39:26 -0400
Received: by labmn12 with SMTP id mn12so12059664lab.8
        for <linux-media@vger.kernel.org>; Wed, 11 Mar 2015 15:39:25 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CA+V-a8t=XxqjWcQCYwWKYbn3-BKcN2ZTZv_QkMvc-kQjUf7w6A@mail.gmail.com>
References: <1425950282-30548-1-git-send-email-sakari.ailus@iki.fi>
 <1425950282-30548-3-git-send-email-sakari.ailus@iki.fi> <CA+V-a8t=XxqjWcQCYwWKYbn3-BKcN2ZTZv_QkMvc-kQjUf7w6A@mail.gmail.com>
From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Date: Wed, 11 Mar 2015 22:38:55 +0000
Message-ID: <CA+V-a8uHPFnOOfHdRtjdvqWs21Ps=4k1vK6QWVQYy6OhYfLSFw@mail.gmail.com>
Subject: Re: [PATCH 2/3] smiapp: Read link-frequencies property from the
 endpoint node
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: linux-media <linux-media@vger.kernel.org>,
	laurent pinchart <laurent.pinchart@ideasonboard.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Mar 11, 2015 at 10:25 PM, Lad, Prabhakar
<prabhakar.csengg@gmail.com> wrote:
> Hi Sakari,
>
> Thanks for the patch.
>
> On Tue, Mar 10, 2015 at 1:18 AM, Sakari Ailus <sakari.ailus@iki.fi> wrote:
>> The documentation stated that the link-frequencies property belongs to the
>> endpoint node, not to the device's of_node. Fix this.
>>
>> There are no DT board descriptions using the driver yet, so a fix in the
>> driver is sufficient.
>>
>> Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
>
> Tested-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
>

I meant :
Acked-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>

Cheers,
--Prabhakar Lad
