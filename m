Return-path: <linux-media-owner@vger.kernel.org>
Received: from na3sys009aog102.obsmtp.com ([74.125.149.69]:54389 "EHLO
	na3sys009aog102.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751741Ab2F1GHK convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 28 Jun 2012 02:07:10 -0400
Received: by ggnp1 with SMTP id p1so1832959ggn.32
        for <linux-media@vger.kernel.org>; Wed, 27 Jun 2012 23:07:09 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4F671CA3.6080107@ti.com>
References: <1331110876-11895-1-git-send-email-archit@ti.com>
 <79CD15C6BA57404B839C016229A409A831810EAA@DBDE01.ent.ti.com>
 <4F6312E4.5000404@ti.com> <4F631FDF.8070308@ti.com> <79CD15C6BA57404B839C016229A409A83181EB1F@DBDE01.ent.ti.com>
 <4F671CA3.6080107@ti.com>
From: "Semwal, Sumit" <sumit.semwal@ti.com>
Date: Thu, 28 Jun 2012 11:36:48 +0530
Message-ID: <CAB2ybb-6EEU0Ry-zzyM+_n+7w3jGvVhXvPeWsjRpOFX9fXg4NQ@mail.gmail.com>
Subject: Re: [PATCH] omap_vout: Set DSS overlay_info only if paddr is non zero
To: Archit Taneja <a0393947@ti.com>
Cc: "Hiremath, Vaibhav" <hvaibhav@ti.com>,
	"Taneja, Archit" <archit@ti.com>,
	"Valkeinen, Tomi" <tomi.valkeinen@ti.com>,
	"linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Mar 19, 2012 at 5:16 PM, Archit Taneja <a0393947@ti.com> wrote:
> On Monday 19 March 2012 02:15 PM, Hiremath, Vaibhav wrote:
>>
>> On Fri, Mar 16, 2012 at 16:41:27, Taneja, Archit wrote:
>>>
>>> Hi,
>>>
>>> On Friday 16 March 2012 03:46 PM, Archit Taneja wrote:
>>>>
>>>> On Monday 12 March 2012 03:34 PM, Hiremath, Vaibhav wrote:
>>>>>
>>>>> On Wed, Mar 07, 2012 at 14:31:16, Taneja, Archit wrote:
>>>>>>
>>>>>> The omap_vout driver tries to set the DSS overlay_info using
>>>>>> set_overlay_info()
>>>>>> when the physical address for the overlay is still not configured.
>>>>>> This happens
>>>>>> in omap_vout_probe() and vidioc_s_fmt_vid_out().
>>>>>>
>>>>>> The calls to omapvid_init(which internally calls set_overlay_info())
>>>>>> are removed
>>>>>> from these functions. They don't need to be called as the
>>>>>> omap_vout_device
>>>>>> struct anyway maintains the overlay related changes made. Also,
>>>>>> remove the
>>>>>> explicit call to set_overlay_info() in vidioc_streamon(), this was
>>>>>> used to set
>>>>>> the paddr, this isn't needed as omapvid_init() does the same thing
>>>>>> later.
>>>>>>
>>>>>> These changes are required as the DSS2 driver since 3.3 kernel
>>>>>> doesn't let you
>>>>>> set the overlay info with paddr as 0.
>>>>>>
>>>>>> Signed-off-by: Archit Taneja<archit@ti.com>
>>>>>> ---
>>>>>> drivers/media/video/omap/omap_vout.c | 36
>>>>>> ++++-----------------------------
>>>>>> 1 files changed, 5 insertions(+), 31 deletions(-)
>>>>>>
>>>>>> diff --git a/drivers/media/video/omap/omap_vout.c
>>>>>> b/drivers/media/video/omap/omap_vout.c
>>>>>> index 1fb7d5b..dffcf66 100644
>>>>>> --- a/drivers/media/video/omap/omap_vout.c
>>>>>> +++ b/drivers/media/video/omap/omap_vout.c
>>>>>> @@ -1157,13 +1157,6 @@ static int vidioc_s_fmt_vid_out(struct file
>>>>>> *file, void *fh,
>>>>>> /* set default crop and win */
>>>>>> omap_vout_new_format(&vout->pix,&vout->fbuf,&vout->crop,&vout->win);
>>>>>>
>>>>>> - /* Save the changes in the overlay strcuture */
>>>>>> - ret = omapvid_init(vout, 0);
>>>>>> - if (ret) {
>>>>>> - v4l2_err(&vout->vid_dev->v4l2_dev, "failed to change mode\n");
>>>>>> - goto s_fmt_vid_out_exit;
>>>>>> - }
>>>>>> -
>>>>>> ret = 0;
>>>>>>
>>>>>> s_fmt_vid_out_exit:
>>>>>> @@ -1664,20 +1657,6 @@ static int vidioc_streamon(struct file *file,
>>>>>> void *fh, enum v4l2_buf_type i)
>>>>>>
>>>>>> omap_dispc_register_isr(omap_vout_isr, vout, mask);
>>>>>>
>>>>>> - for (j = 0; j<  ovid->num_overlays; j++) {
>>>>>> - struct omap_overlay *ovl = ovid->overlays[j];
>>>>>> -
>>>>>> - if (ovl->manager&&  ovl->manager->device) {
>>>>>> - struct omap_overlay_info info;
>>>>>> - ovl->get_overlay_info(ovl,&info);
>>>>>> - info.paddr = addr;
>>>>>> - if (ovl->set_overlay_info(ovl,&info)) {
>>>>>> - ret = -EINVAL;
>>>>>> - goto streamon_err1;
>>>>>> - }
>>>>>> - }
>>>>>> - }
>>>>>> -
>>>>>
>>>>>
>>>>> Have you checked for build warnings? I am getting build warnings
>>>>>
>>>>> CC drivers/media/video/omap/omap_vout.o
>>>>> CC drivers/media/video/omap/omap_voutlib.o
>>>>> CC drivers/media/video/omap/omap_vout_vrfb.o
>>>>> drivers/media/video/omap/omap_vout.c: In function 'vidioc_streamon':
>>>>> drivers/media/video/omap/omap_vout.c:1619:25: warning: unused variable
>>>>> 'ovid'
>>>>> drivers/media/video/omap/omap_vout.c:1615:15: warning: unused variable
>>>>> 'j'
>>>>> LD drivers/media/video/omap/omap-vout.o
>>>>> LD drivers/media/video/omap/built-in.o
>>>>>
>>>>> Can you fix this and submit the next version?
>>>
>>>
>>> I applied the patch on the current mainline kernel, it doesn't give any
>>> build warnings. Even after applying the patch, 'j and ovid' are still
>>> used in vidioc_streamon().
>>>
>>> Can you check if it was applied correctly?
>>>
>>
>> Archit,
>>
>> I could able to trace what's going on here,
>>
>> I am using "v4l_for_linus" branch, which has one missing patch,
>>
>> commit aaa874a985158383c4b394c687c716ef26288741
>> Author: Tomi Valkeinen<tomi.valkeinen@ti.com>
>> Date:   Tue Nov 15 16:37:53 2011 +0200
>>
>>     OMAPDSS: APPLY: rewrite overlay enable/disable
>>
>>
>> So, I do not have below changes,
>>
>> @@ -1686,6 +1681,16 @@ static int vidioc_streamon(struct file *file, void
>> *fh, enum v4l2_buf_type i)
>>         if (ret)
>>                 v4l2_err(&vout->vid_dev->v4l2_dev, "failed to change
>> mode\n");
>>
>> +       for (j = 0; j<  ovid->num_overlays; j++) {
>> +               struct omap_overlay *ovl = ovid->overlays[j];
>> +
>> +               if (ovl->manager&&  ovl->manager->device) {
>>
>> +                       ret = ovl->enable(ovl);
>> +                       if (ret)
>> +                               goto streamon_err1;
>> +               }
>> +       }
>> +
>>
>> This explains why I am seeing these warnings. Let me give pull request
>> based on master branch.
>
>
> Okay. Thanks for looking into this.
>
> Archit

Hi Vaibhav,

This patch has been outstanding since March, and we have received
reports from various users. Could you please push it ASAP to Mauro for
the upcoming -rc?

Or Did I miss a pull request from you containing this?

Thanks and best regards,
~Sumit.

>
>>
>>
>> Thanks,
>> Vaibhav
>>
>>> Regards,
>>> Archit
>>>
>>>>
>>>> Will fix this and submit.
>>>>
>>>> Archit
>>>>
>>>>>
>>>>> Thanks,
>>>>> Vaibhav
>>>>>
>>>>>> /* First save the configuration in ovelray structure */
>>>>>> ret = omapvid_init(vout, addr);
>>>>>> if (ret)
>>>>>> @@ -2071,11 +2050,12 @@ static int __init
>>>>>> omap_vout_create_video_devices(struct platform_device *pdev)
>>>>>> }
>>>>>> video_set_drvdata(vfd, vout);
>>>>>>
>>>>>> - /* Configure the overlay structure */
>>>>>> - ret = omapvid_init(vid_dev->vouts[k], 0);
>>>>>> - if (!ret)
>>>>>> - goto success;
>>>>>> + dev_info(&pdev->dev, ": registered and initialized"
>>>>>> + " video device %d\n", vfd->minor);
>>>>>> + if (k == (pdev->num_resources - 1))
>>>>>> + return 0;
>>>>>>
>>>>>> + continue;
>>>>>> error2:
>>>>>> if (vout->vid_info.rotation_type == VOUT_ROT_VRFB)
>>>>>> omap_vout_release_vrfb(vout);
>>>>>> @@ -2085,12 +2065,6 @@ error1:
>>>>>> error:
>>>>>> kfree(vout);
>>>>>> return ret;
>>>>>> -
>>>>>> -success:
>>>>>> - dev_info(&pdev->dev, ": registered and initialized"
>>>>>> - " video device %d\n", vfd->minor);
>>>>>> - if (k == (pdev->num_resources - 1))
>>>>>> - return 0;
>>>>>> }
>>>>>>
>>>>>> return -ENODEV;
>>>>>> --
>>>>>> 1.7.5.4
>>>>>>
>>>>>>
>>>>>
>>>>>
>>>>
>>>>
>>>
>>>
>>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
