Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-oa0-f50.google.com ([209.85.219.50]:43189 "EHLO
	mail-oa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758317Ab3DDKO6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 4 Apr 2013 06:14:58 -0400
Received: by mail-oa0-f50.google.com with SMTP id n1so2541940oag.37
        for <linux-media@vger.kernel.org>; Thu, 04 Apr 2013 03:14:58 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.64.1304031229150.10531@axis700.grange>
References: <1363599836-15824-1-git-send-email-fabio.porcedda@gmail.com>
 <Pine.LNX.4.64.1303181108540.30957@axis700.grange> <CAHkwnC8yWYvcQbiTM+xfJMNeBzeY8Gv8A8SN3sROCKT2EtM0iw@mail.gmail.com>
 <Pine.LNX.4.64.1304031229150.10531@axis700.grange>
From: Fabio Porcedda <fabio.porcedda@gmail.com>
Date: Thu, 4 Apr 2013 12:14:37 +0200
Message-ID: <CAHkwnC99CqxTDOLznpbFKX9R3iT0LurKkBAa8iya54+hoVGyTQ@mail.gmail.com>
Subject: Re: [PATCH] [media] mx2_camera: use module_platform_driver_probe()
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: linux-media <linux-media@vger.kernel.org>,
	Fabio Estevam <fabio.estevam@freescale.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Apr 3, 2013 at 12:30 PM, Guennadi Liakhovetski
<g.liakhovetski@gmx.de> wrote:
> On Wed, 3 Apr 2013, Fabio Porcedda wrote:
>
>> On Mon, Mar 18, 2013 at 11:09 AM, Guennadi Liakhovetski
>> <g.liakhovetski@gmx.de> wrote:
>> > Hi Fabio
>> >
>> > On Mon, 18 Mar 2013, Fabio Porcedda wrote:
>> >
>> >> The commit 39793c6 "[media] mx2_camera: Convert it to platform driver"
>> >> used module_platform_driver() to make code smaller,
>> >> but since the driver used platform_driver_probe is more appropriate
>> >> to use module_platform_driver_probe().
>> >>
>> >> Signed-off-by: Fabio Porcedda <fabio.porcedda@gmail.com>
>> >> Cc: Fabio Estevam <fabio.estevam@freescale.com>
>> >> Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
>> >> Cc: Mauro Carvalho Chehab <mchehab@redhat.com>
>> >
>> > Thanks, will queue for 3.10.
>>
>> Thanks for taking it.
>> In which repository/branch is it?
>> This commit is not in linux-next or in
>> git://linuxtv.org/mchehab/media-next.git yet.
>
> Not yet. I'm preparing a branch locally to push to my repository on
> git.linuxtv.org. I'll do that within a day or two, if no objections
> emerge. Then I'll send a pull request to Mauro, then a couple of days
> later he'll pull from my tree, then patches will appear in -next.

Thanks.

Regards
Fabio Porcedda

> Thanks
> Guennadi
>
>>
>> Best regards
>> --
>> Fabio Porcedda
>>
>> > Guennadi
>> >
>> >> ---
>> >>  drivers/media/platform/soc_camera/mx2_camera.c | 3 +--
>> >>  1 file changed, 1 insertion(+), 2 deletions(-)
>> >>
>> >> diff --git a/drivers/media/platform/soc_camera/mx2_camera.c b/drivers/media/platform/soc_camera/mx2_camera.c
>> >> index ffba7d9..848dff9 100644
>> >> --- a/drivers/media/platform/soc_camera/mx2_camera.c
>> >> +++ b/drivers/media/platform/soc_camera/mx2_camera.c
>> >> @@ -1619,10 +1619,9 @@ static struct platform_driver mx2_camera_driver = {
>> >>       },
>> >>       .id_table       = mx2_camera_devtype,
>> >>       .remove         = mx2_camera_remove,
>> >> -     .probe          = mx2_camera_probe,
>> >>  };
>> >>
>> >> -module_platform_driver(mx2_camera_driver);
>> >> +module_platform_driver_probe(mx2_camera_driver, mx2_camera_probe);
>> >>
>> >>  MODULE_DESCRIPTION("i.MX27 SoC Camera Host driver");
>> >>  MODULE_AUTHOR("Sascha Hauer <sha@pengutronix.de>");
>> >> --
>> >> 1.8.2
>> >>
>> >
>> > ---
>> > Guennadi Liakhovetski, Ph.D.
>> > Freelance Open-Source Software Developer
>> > http://www.open-technology.de/
>>
>
> ---
> Guennadi Liakhovetski, Ph.D.
> Freelance Open-Source Software Developer
> http://www.open-technology.de/



--
Fabio Porcedda
