Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-oa0-f54.google.com ([209.85.219.54]:64170 "EHLO
	mail-oa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756324Ab3KFKKl (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 6 Nov 2013 05:10:41 -0500
Received: by mail-oa0-f54.google.com with SMTP id n16so1945814oag.27
        for <linux-media@vger.kernel.org>; Wed, 06 Nov 2013 02:10:40 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <2965670.TUVZegLOBr@avalon>
References: <1382065635-27855-1-git-send-email-sachin.kamat@linaro.org>
	<1382065635-27855-2-git-send-email-sachin.kamat@linaro.org>
	<2965670.TUVZegLOBr@avalon>
Date: Wed, 6 Nov 2013 15:40:40 +0530
Message-ID: <CAK9yfHwnp9PW5UAOQrHnAdLBux-Lb_A79bdf_r9358qK9Eq0vw@mail.gmail.com>
Subject: Re: [PATCH 2/6] [media] mt9p031: Include linux/of.h header
From: Sachin Kamat <sachin.kamat@linaro.org>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-media <linux-media@vger.kernel.org>, hans.verkuil@cisco.com,
	Mauro Carvalho Chehab <m.chehab@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 6 November 2013 06:58, Laurent Pinchart
<laurent.pinchart@ideasonboard.com> wrote:
> Hi Sachin,
>
> Thank you for the patch, and sorry for the late reply.
>
> On Friday 18 October 2013 08:37:11 Sachin Kamat wrote:
>> 'of_match_ptr' is defined in linux/of.h. Include it explicitly to avoid
>> build breakage in the future.
>>
>> Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
>> Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
>
> Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
>
> I've taken the patch in my tree and will push it upstream.

Thanks Laurent.

-- 
With warm regards,
Sachin
