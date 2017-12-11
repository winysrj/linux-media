Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:24675 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751554AbdLKXgH (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 11 Dec 2017 18:36:07 -0500
From: Flavio Ceolin <flavio.ceolin@intel.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-kernel@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Petr Cvek <petr.cvek@tul.cz>,
        Sakari Ailus <sakari.ailus@iki.fi>,
        Niklas =?utf-8?Q?S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>,
        Julia Lawall <Julia.Lawall@lip6.fr>,
        Arnd Bergmann <arnd@arndb.de>,
        "open list\:MEDIA INPUT INFRASTRUCTURE \(V4L\/DVB\)"
        <linux-media@vger.kernel.org>
Subject: Re: [PATCH] media: pxa_camera: disable and unprepare the clock source on error
In-Reply-To: <4016874.2vIpU9bQLW@avalon>
References: <20171206163852.8532-1-flavio.ceolin@intel.com> <1880720.cnKARQTyeT@avalon> <878te9561h.fsf@faceolin-mobl2.amr.corp.intel.com> <4016874.2vIpU9bQLW@avalon>
Date: Mon, 11 Dec 2017 15:36:00 -0800
Message-ID: <87374g6dnj.fsf@faceolin-mobl2.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Laurent Pinchart <laurent.pinchart@ideasonboard.com> writes:

> Hi Flavio,
>
> On Monday, 11 December 2017 23:05:46 EET Flavio Ceolin wrote:
>> > On Wednesday, 6 December 2017 18:38:50 EET Flavio Ceolin wrote:
>> >> pxa_camera_probe() was not calling pxa_camera_deactivate(),
>> >> responsible to call clk_disable_unprepare(), on the failure path. This
>> >> was leading to unbalancing source clock.
>> >> 
>> >> Found by Linux Driver Verification project (linuxtesting.org).
>> > 
>> > Any chance I could sign you up for more work on this driver ? :-)
>> 
>> Definetely, this would be great :)
>
> Actually it looks like the work I thought was needed has already been 
> performed. The pxa-camera driver used to make use of the soc-camera framework, 
> which we are trying to remove, and occurrences of soc_camera in the code gave 
> me the wrong idea that the driver was still based on that framework. It seems 
> this isn't the case. Thank you for making me happy :-)

I'm glad to hear it :)

>
>> >> Signed-off-by: Flavio Ceolin <flavio.ceolin@intel.com>
>> > 
>> > Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
>> > 
>> > I expect Hans Verkuil to pick up the patch.
>> > 
>> >> ---
>> >> 
>> >>  drivers/media/platform/pxa_camera.c | 4 +++-
>> >>  1 file changed, 3 insertions(+), 1 deletion(-)
>> >> 
>> >> diff --git a/drivers/media/platform/pxa_camera.c
>> >> b/drivers/media/platform/pxa_camera.c index 9d3f0cb..7877037 100644
>> >> --- a/drivers/media/platform/pxa_camera.c
>> >> +++ b/drivers/media/platform/pxa_camera.c
>> >> @@ -2489,7 +2489,7 @@ static int pxa_camera_probe(struct platform_device
>> >> *pdev)
>> >> 	dev_set_drvdata(&pdev->dev, pcdev);
>> >>  	err = v4l2_device_register(&pdev->dev, &pcdev->v4l2_dev);
>> >>  	if (err)
>> >> -		goto exit_free_dma;
>> >> +		goto exit_deactivate;
>> >> 
>> >>  	pcdev->asds[0] = &pcdev->asd;
>> >>  	pcdev->notifier.subdevs = pcdev->asds;
>> >> @@ -2525,6 +2525,8 @@ static int pxa_camera_probe(struct platform_device
>> >> *pdev)
>> >> 	v4l2_clk_unregister(pcdev->mclk_clk);
>> >>  exit_free_v4l2dev:
>> >>  	v4l2_device_unregister(&pcdev->v4l2_dev);
>> >> +exit_deactivate:
>> >> +	pxa_camera_deactivate(pcdev);
>> >>  exit_free_dma:
>> >>  	dma_release_channel(pcdev->dma_chans[2]);
>> >>  exit_free_dma_u:
>
> -- 
> Regards,
>
> Laurent Pinchart

Regards,
Flavio Ceolin
