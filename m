Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lb0-f178.google.com ([209.85.217.178]:41559 "EHLO
	mail-lb0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751737AbbCKWi5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 11 Mar 2015 18:38:57 -0400
Received: by lbvp9 with SMTP id p9so12139740lbv.8
        for <linux-media@vger.kernel.org>; Wed, 11 Mar 2015 15:38:56 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CA+V-a8tqgrkcRpdSj-cZHwy3PdafPnqnPXXUm4b0qrkZA325Pw@mail.gmail.com>
References: <1425950282-30548-1-git-send-email-sakari.ailus@iki.fi>
 <1425950282-30548-2-git-send-email-sakari.ailus@iki.fi> <CA+V-a8tqgrkcRpdSj-cZHwy3PdafPnqnPXXUm4b0qrkZA325Pw@mail.gmail.com>
From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Date: Wed, 11 Mar 2015 22:38:26 +0000
Message-ID: <CA+V-a8sFQQNZq368xjGBmP77xw+T7cKqeQ=JGX=OEE1KpQBZag@mail.gmail.com>
Subject: Re: [PATCH 1/3] smiapp: Clean up smiapp_get_pdata()
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: linux-media <linux-media@vger.kernel.org>,
	laurent pinchart <laurent.pinchart@ideasonboard.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Mar 11, 2015 at 10:24 PM, Lad, Prabhakar
<prabhakar.csengg@gmail.com> wrote:
> Hi Sakari,
>
> Thanks for the patch.
>
> On Tue, Mar 10, 2015 at 1:18 AM, Sakari Ailus <sakari.ailus@iki.fi> wrote:
>> Don't set rval when it's not used (the function returns a pointer to struct
>> smiapp_platform_data).
>>
>> Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
>
> Tested-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
>
I meant :
Acked-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>

Cheers,
--Prabhakar Lad
