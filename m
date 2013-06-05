Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-oa0-f45.google.com ([209.85.219.45]:49935 "EHLO
	mail-oa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752221Ab3FEKGU (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 5 Jun 2013 06:06:20 -0400
Received: by mail-oa0-f45.google.com with SMTP id j6so964348oag.32
        for <linux-media@vger.kernel.org>; Wed, 05 Jun 2013 03:06:19 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.64.1306051201340.19739@axis700.grange>
References: <1369394707-13049-1-git-send-email-sachin.kamat@linaro.org>
	<CAK9yfHyUqpF4d_cuwPo-fA5UuCQzfG4-ktyOA716CfN3QgtHLg@mail.gmail.com>
	<Pine.LNX.4.64.1306051201340.19739@axis700.grange>
Date: Wed, 5 Jun 2013 15:36:19 +0530
Message-ID: <CAK9yfHy++-0ufjVYb5peRA-d11X0is64Ycy0+ZuETWmFoWtYuQ@mail.gmail.com>
Subject: Re: [PATCH 1/2] [media] soc_camera: mt9t112: Remove empty function
From: Sachin Kamat <sachin.kamat@linaro.org>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 5 June 2013 15:32, Guennadi Liakhovetski <g.liakhovetski@gmx.de> wrote:
> Hi Sachin
>
> On Tue, 4 Jun 2013, Sachin Kamat wrote:
>
>> On 24 May 2013 16:55, Sachin Kamat <sachin.kamat@linaro.org> wrote:
>> > After the switch to devm_* functions, the 'remove' function does
>> > not do anything. Delete it.
>> >
>> > Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
>> > Cc: Kuninori Morimoto <morimoto.kuninori@renesas.com>
>> > ---
>> >  drivers/media/i2c/soc_camera/mt9t112.c |    6 ------
>> >  1 file changed, 6 deletions(-)
>
> [snip]
>
>> Gentle ping on this series  :)
>
> Both these patches are in my queue for 3.11.

Thanks Guennadi.

-- 
With warm regards,
Sachin
