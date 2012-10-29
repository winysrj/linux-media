Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ie0-f174.google.com ([209.85.223.174]:50353 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756724Ab2J2NHr (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 29 Oct 2012 09:07:47 -0400
Received: by mail-ie0-f174.google.com with SMTP id k13so6464945iea.19
        for <linux-media@vger.kernel.org>; Mon, 29 Oct 2012 06:07:46 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20121029094419.020a390b@redhat.com>
References: <1351370486-29040-1-git-send-email-mchehab@redhat.com>
	<1351370486-29040-36-git-send-email-mchehab@redhat.com>
	<CALF0-+VAVX=b9iEvQS88x5Ndr=7GGBuyi4k=18-2uJjwFL95HA@mail.gmail.com>
	<20121029094419.020a390b@redhat.com>
Date: Mon, 29 Oct 2012 10:07:46 -0300
Message-ID: <CALF0-+VVv7aAwe6R3in6RHEhBV62yXRA9gyqKumk4zR0kffhFA@mail.gmail.com>
Subject: Re: [PATCH 35/68] [media] pwc-if: must check vb2_queue_init() success
From: Ezequiel Garcia <elezegarcia@gmail.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Oct 29, 2012 at 8:44 AM, Mauro Carvalho Chehab
<mchehab@redhat.com> wrote:
> Em Mon, 29 Oct 2012 08:37:31 -0300
> Ezequiel Garcia <elezegarcia@gmail.com> escreveu:
>
>> On Sat, Oct 27, 2012 at 5:40 PM, Mauro Carvalho Chehab
>> <mchehab@redhat.com> wrote:
>> > drivers/media/usb/pwc/pwc-if.c: In function 'usb_pwc_probe':
>> > drivers/media/usb/pwc/pwc-if.c:1003:16: warning: ignoring return value of 'vb2_queue_init', declared with attribute warn_unused_result [-Wunused-result]
>> > In the past, it used to have a logic there at queue init that would
>> > BUG() on errors. This logic got removed. Drivers are now required
>> > to explicitly handle the queue initialization errors, or very bad
>> > things may happen.
>> >
>> > Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
>> > ---
>> >  drivers/media/usb/pwc/pwc-if.c | 6 +++++-
>> >  1 file changed, 5 insertions(+), 1 deletion(-)
>> >
>> > diff --git a/drivers/media/usb/pwc/pwc-if.c b/drivers/media/usb/pwc/pwc-if.c
>> > index e191572..5210239 100644
>> > --- a/drivers/media/usb/pwc/pwc-if.c
>> > +++ b/drivers/media/usb/pwc/pwc-if.c
>> > @@ -1000,7 +1000,11 @@ static int usb_pwc_probe(struct usb_interface *intf, const struct usb_device_id
>> >         pdev->vb_queue.buf_struct_size = sizeof(struct pwc_frame_buf);
>> >         pdev->vb_queue.ops = &pwc_vb_queue_ops;
>> >         pdev->vb_queue.mem_ops = &vb2_vmalloc_memops;
>> > -       vb2_queue_init(&pdev->vb_queue);
>> > +       rc = vb2_queue_init(&pdev->vb_queue);
>> > +       if (rc < 0) {
>> > +               PWC_ERROR("Oops, could not initialize vb2 queue.\n");
>> > +               goto err_free_mem;
>> > +       }
>> >
>> >         /* Init video_device structure */
>> >         memcpy(&pdev->vdev, &pwc_template, sizeof(pwc_template));
>> > --
>> > 1.7.11.7
>> >
>>
>> Weird, I thought this was already fixed...
>>
>> https://patchwork.kernel.org/patch/1467211/
>>
>> And even weirder...
>> now all my patches are marked as 'New' by patchwork...
>>
>> https://patchwork.kernel.org/project/linux-media/list/?submitter=37031&state=*
>>
>> (this must be the last name mess I did...)
>
> Nah, you're looking at the wrong place. you should be looking at patchwork.linuxtv.org.

Yeah... I don't know why da heck I was looking there!

Sorry for the noise ;-)

    Ezequiel
