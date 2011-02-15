Return-path: <mchehab@pedra>
Received: from moutng.kundenserver.de ([212.227.17.8]:58808 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754524Ab1BOLu6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 15 Feb 2011 06:50:58 -0500
Message-ID: <4D5A6874.1080705@corscience.de>
Date: Tue, 15 Feb 2011 12:50:12 +0100
From: Thomas Weber <weber@corscience.de>
MIME-Version: 1.0
To: Sylwester Nawrocki <s.nawrocki@samsung.com>
CC: balbi@ti.com,
	Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>,
	linux-omap@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Hans Verkuil <hverkuil@xs4all.nl>, Tejun Heo <tj@kernel.org>,
	linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH resend] video: omap24xxcam: Fix compilation
References: <1297068547-10635-1-git-send-email-weber@corscience.de> <4D5A6353.7040907@maxwell.research.nokia.com> <20110215113717.GN2570@legolas.emea.dhcp.ti.com> <4D5A672A.7040000@samsung.com>
In-Reply-To: <4D5A672A.7040000@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Am 15.02.2011 12:44, schrieb Sylwester Nawrocki:
> Hi Felipe,
>
> On 02/15/2011 12:37 PM, Felipe Balbi wrote:
>> On Tue, Feb 15, 2011 at 01:28:19PM +0200, Sakari Ailus wrote:
>>> Thomas Weber wrote:
>>>> Add linux/sched.h because of missing declaration of TASK_NORMAL.
>>>>
>>>> This patch fixes the following error:
>>>>
>>>> drivers/media/video/omap24xxcam.c: In function
>>>> 'omap24xxcam_vbq_complete':
>>>> drivers/media/video/omap24xxcam.c:415: error: 'TASK_NORMAL' undeclared
>>>> (first use in this function)
>>>> drivers/media/video/omap24xxcam.c:415: error: (Each undeclared
>>>> identifier is reported only once
>>>> drivers/media/video/omap24xxcam.c:415: error: for each function it
>>>> appears in.)
>>>>
>>>> Signed-off-by: Thomas Weber <weber@corscience.de>
>>> Thanks, Thomas!
>> Are we using the same tree ? I don't see anything related to TASK_* on
> Please have a look at definition of macro wake_up. This where those
> TASK_* flags are used.
>
>> that function on today's mainline, here's a copy of the function:
>>
>>  387 static void omap24xxcam_vbq_complete(struct omap24xxcam_sgdma *sgdma,
>>  388                                      u32 csr, void *arg)
>>  389 {
>>  390         struct omap24xxcam_device *cam =
>>  391                 container_of(sgdma, struct omap24xxcam_device, sgdma);
>>  392         struct omap24xxcam_fh *fh = cam->streaming->private_data;
>>  393         struct videobuf_buffer *vb = (struct videobuf_buffer *)arg;
>>  394         const u32 csr_error = CAMDMA_CSR_MISALIGNED_ERR
>>  395                 | CAMDMA_CSR_SUPERVISOR_ERR | CAMDMA_CSR_SECURE_ERR
>>  396                 | CAMDMA_CSR_TRANS_ERR | CAMDMA_CSR_DROP;
>>  397         unsigned long flags;
>>  398 
>>  399         spin_lock_irqsave(&cam->core_enable_disable_lock, flags);
>>  400         if (--cam->sgdma_in_queue == 0)
>>  401                 omap24xxcam_core_disable(cam);
>>  402         spin_unlock_irqrestore(&cam->core_enable_disable_lock, flags);
>>  403 
>>  404         do_gettimeofday(&vb->ts);
>>  405         vb->field_count = atomic_add_return(2, &fh->field_count);
>>  406         if (csr & csr_error) {
>>  407                 vb->state = VIDEOBUF_ERROR;
>>  408                 if (!atomic_read(&fh->cam->in_reset)) {
>>  409                         dev_dbg(cam->dev, "resetting camera, csr 0x%x\n", csr);
>>  410                         omap24xxcam_reset(cam);
>>  411                 }
>>  412         } else
>>  413                 vb->state = VIDEOBUF_DONE;
>>  414         wake_up(&vb->done);
>>  415 }
>>
>> see that line 415 is where the function ends. My head is
>> 795abaf1e4e188c4171e3cd3dbb11a9fcacaf505
>>
> Cheers,
> Sylwester Nawrocki
> --

Hello Felipe,

in include/linux/wait.h

#define wake_up(x)            __wake_up(x, TASK_NORMAL, 1, NULL)

Regards,
Thomas
