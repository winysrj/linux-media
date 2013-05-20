Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-oa0-f42.google.com ([209.85.219.42]:40099 "EHLO
	mail-oa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752584Ab3ETMCW (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 20 May 2013 08:02:22 -0400
Received: by mail-oa0-f42.google.com with SMTP id i10so7586302oag.15
        for <linux-media@vger.kernel.org>; Mon, 20 May 2013 05:02:22 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.64.1305201359390.25754@axis700.grange>
References: <1368436761-12183-1-git-send-email-sachin.kamat@linaro.org>
	<CAK9yfHxOpoNFoTV6LkqTJGAL_K4R7n5e4ke0Cw-WeceWZ6MK_Q@mail.gmail.com>
	<Pine.LNX.4.64.1305201359390.25754@axis700.grange>
Date: Mon, 20 May 2013 17:32:21 +0530
Message-ID: <CAK9yfHwQ3z5oWn8AOAbNR-4AyXU_UWpLxqjibXA1S=PB1F77uw@mail.gmail.com>
Subject: Re: [PATCH 1/2] [media] soc_camera/sh_mobile_csi2: Remove redundant platform_set_drvdata()
From: Sachin Kamat <sachin.kamat@linaro.org>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 20 May 2013 17:30, Guennadi Liakhovetski <g.liakhovetski@gmx.de> wrote:
> On Mon, 20 May 2013, Sachin Kamat wrote:
>
>> On 13 May 2013 14:49, Sachin Kamat <sachin.kamat@linaro.org> wrote:
>> > Commit 0998d06310 (device-core: Ensure drvdata = NULL when no
>> > driver is bound) removes the need to set driver data field to
>> > NULL.
>> >
>> > Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
>
> Thanks, both queued for 3.11.


Thanks Guennadi :)

-- 
With warm regards,
Sachin
