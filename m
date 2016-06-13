Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:39798 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423745AbcFMPir (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 13 Jun 2016 11:38:47 -0400
Subject: Re: [PATCH] media: s5p-mfc fix memory leak in s5p_mfc_remove()
To: Javier Martinez Canillas <javier@dowhile0.org>
References: <1465436115-13880-1-git-send-email-shuahkh@osg.samsung.com>
 <CABxcv=nT_zp2BkvSV04sqaXmZGnQz=z-cGURDJwUW7hthD6-Fw@mail.gmail.com>
Cc: Kyungmin Park <kyungmin.park@samsung.com>,
	Kamil Debski <k.debski@samsung.com>, jtp.park@samsung.com,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	Shuah Khan <shuahkh@osg.samsung.com>
From: Shuah Khan <shuahkh@osg.samsung.com>
Message-ID: <575ED37E.4010204@osg.samsung.com>
Date: Mon, 13 Jun 2016 09:38:38 -0600
MIME-Version: 1.0
In-Reply-To: <CABxcv=nT_zp2BkvSV04sqaXmZGnQz=z-cGURDJwUW7hthD6-Fw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 06/13/2016 07:42 AM, Javier Martinez Canillas wrote:
> Hello Shuah,
> 
> On Wed, Jun 8, 2016 at 9:35 PM, Shuah Khan <shuahkh@osg.samsung.com> wrote:
>> s5p_mfc_remove() fails to release encoder and decoder video devices.
>>
>> Signed-off-by: Shuah Khan <shuahkh@osg.samsung.com>
>> ---
>>  drivers/media/platform/s5p-mfc/s5p_mfc.c | 2 ++
>>  1 file changed, 2 insertions(+)
>>
>> diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc.c b/drivers/media/platform/s5p-mfc/s5p_mfc.c
>> index 274b4f1..af61f54 100644
>> --- a/drivers/media/platform/s5p-mfc/s5p_mfc.c
>> +++ b/drivers/media/platform/s5p-mfc/s5p_mfc.c
>> @@ -1317,7 +1317,9 @@ static int s5p_mfc_remove(struct platform_device *pdev)
>>         destroy_workqueue(dev->watchdog_workqueue);
>>
>>         video_unregister_device(dev->vfd_enc);
>> +       video_device_release(dev->vfd_enc);
>>         video_unregister_device(dev->vfd_dec);
>> +       video_device_release(dev->vfd_dec);
>>         v4l2_device_unregister(&dev->v4l2_dev);
>>         s5p_mfc_release_firmware(dev);
>>         vb2_dma_contig_cleanup_ctx(dev->alloc_ctx[0]);
>> --
> 
> Can you please do the remove operations in the inverse order of their
> counterparts? IOW to do the release for both encoder and decoder after
> their unregistration.
> 

I considered that. No problem. I will move both release after the
video_unregister_device(dev->vfd_dec), releasing enc first and then
the dec

> 
> Reviewed-by: Javier Martinez Canillas <javier@osg.samsung.com>
> 

thanks,
-- Shuah

