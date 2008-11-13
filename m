Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mAD9NcP2002654
	for <video4linux-list@redhat.com>; Thu, 13 Nov 2008 04:23:38 -0500
Received: from wf-out-1314.google.com (wf-out-1314.google.com [209.85.200.170])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mAD9NRPj021101
	for <video4linux-list@redhat.com>; Thu, 13 Nov 2008 04:23:27 -0500
Received: by wf-out-1314.google.com with SMTP id 25so804872wfc.6
	for <video4linux-list@redhat.com>; Thu, 13 Nov 2008 01:23:26 -0800 (PST)
Message-ID: <aec7e5c30811130123wdbfbf02o5e86b85b88ea94dc@mail.gmail.com>
Date: Thu, 13 Nov 2008 18:23:26 +0900
From: "Magnus Damm" <magnus.damm@gmail.com>
To: "Guennadi Liakhovetski" <g.liakhovetski@gmx.de>
In-Reply-To: <Pine.LNX.4.64.0811130853510.4620@axis700.grange>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20081113074219.6786.65651.sendpatchset@rx1.opensource.se>
	<Pine.LNX.4.64.0811130853510.4620@axis700.grange>
Cc: video4linux-list@redhat.com
Subject: Re: [PATCH] video: nv12/nv21 support for the sh_mobile_ceu driver
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

On Thu, Nov 13, 2008 at 5:03 PM, Guennadi Liakhovetski
<g.liakhovetski@gmx.de> wrote:
> On Thu, 13 Nov 2008, Magnus Damm wrote:
>
>> From: Magnus Damm <damm@igel.co.jp>
>>
>> This patch adds nv12/nv21 mode support to the SuperH Mobile CEU driver.
>> These modes are translated by the hardware, and added to the list of
>> available modes if the connected camera can output one of the supported
>> input modes. Other modes are just handled using data transfer as usual.
>>
>> The hardware also supports nv16/nv61 which is trivial to add on top of this.
>
> Heh, you realise, that you're walking on burning coal, don't you?:-) So,
> you'll appreciate, if I postpone this patch until the API reasonably
> stabilises, and it is very likely you'll have to redo this?

I realize that the ground is moving under me, but there's not so much
I can do about it. I've worked on this patch on and off the last
months, and I've been postponing the posting for too long time.

> Just a couple of points I came across while skipping over this patch:

Thanks for checking my code.

>> Signed-off-by: Magnus Damm <damm@igel.co.jp>
>> ---
>>
>>  Depends on the VYUY fourcc.
>>  I suspect that this change may conflict with at least 4 other patches. =)
>>
>>  drivers/media/video/sh_mobile_ceu_camera.c |  165 +++++++++++++++++++++++++---
>>  1 file changed, 150 insertions(+), 15 deletions(-)
>>
>> --- 0001/drivers/media/video/sh_mobile_ceu_camera.c
>> +++ work/drivers/media/video/sh_mobile_ceu_camera.c   2008-11-13 16:13:06.000000000 +0900
>> @@ -97,6 +97,10 @@ struct sh_mobile_ceu_dev {
>>       struct videobuf_buffer *active;
>>
>>       struct sh_mobile_ceu_info *pdata;
>> +
>> +     const struct soc_camera_data_format *camera_formats;
>> +     int camera_num_formats;
>> +     unsigned int camera_fourcc;
>
> These formats are assigned dynamically and are camera-dependent, right?

Yes.

> Even though SH camera host probably is not supposed to handle more than
> one camera at a time, I wouldn't do this. This is what I added a
> void *host_priv to struct soc_camera_device for - for host-private
> per-camera data (see patch 3/5 that still waits moderator's approval:-().

Yeah, keeping it together with the rest of the camera data makes
sense. I rather not do this at all though. =)

[snip]

>> @@ -314,6 +334,60 @@ static int sh_mobile_ceu_add_device(stru
>>               msleep(1);
>>
>>       pcdev->icd = icd;
>> +
>> +     /* check if we can enable NVxx modes and
>> +      * remember the last supported camera fourcc mode
>> +      */
>> +
>> +     format = NULL;
>> +     yuv_mode_possible = 0;
>> +     for (k = 0; k < icd->num_formats; k++) {
>> +             format = &icd->formats[k];
>> +
>> +             switch (format->fourcc) {
>> +             case V4L2_PIX_FMT_UYVY:
>> +             case V4L2_PIX_FMT_VYUY:
>> +             case V4L2_PIX_FMT_YUYV:
>> +             case V4L2_PIX_FMT_YVYU:
>> +                     yuv_mode_possible = 1;
>> +                     pcdev->camera_fourcc = format->fourcc;
>> +                     break;
>> +             }
>> +     }
>> +
>> +     /* override list with translated yuv formats if possible */
>> +     if (yuv_mode_possible && format) {
>> +             k = icd->num_formats + 2; /* camera formats + NV12 + NV21 */
>> +
>> +             fmt = kzalloc(sizeof(*icd->formats) * k, GFP_KERNEL);
>> +             if (fmt) {
>> +                     pcdev->camera_formats = icd->formats;
>> +                     pcdev->camera_num_formats = icd->num_formats;
>> +
>> +                     memcpy(fmt, icd->formats,
>> +                            icd->num_formats * sizeof(*fmt));
>
> No! Never write to icd->formats! And even less so in a host driver. It is
> for a reason it is marked "const".

I agree it's dirty as hell, but it was initially written for
pre-2.6.27. At that time I couldn't find any better way for a host to
export formats to user space. You remember me talking about bitmaps
some time ago - this ickiness is the reason why. =)

>> +
>> +                     icd->formats = fmt;
>
> And never overload it.

[snip]

> And never free it! Yes, I realise that you're freeing not the original
> ->formats data, but what you have assigned to it above.
>
> All in all - please, wait a bit, it shall all become clearer shortly.

Yes! I'm more than happy to wait a bit. I hope the patch at least
shows what I want to do. =)

Cheers,

/ magnus

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
