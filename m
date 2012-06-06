Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailmxout15.mailmx.agnat.pl ([193.239.45.95]:35511 "EHLO
	mailmxout15.mailmx.agnat.pl" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756520Ab2FFRjj (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 6 Jun 2012 13:39:39 -0400
Message-ID: <D97F21569FF045CD872858C23EBB78B0@laptop2>
From: "Janusz Uzycki" <janusz.uzycki@elproma.com.pl>
To: "Guennadi Liakhovetski" <g.liakhovetski@gmx.de>
Cc: "Linux Media Mailing List" <linux-media@vger.kernel.org>,
	"Laurent Pinchart" <laurent.pinchart@ideasonboard.com>
References: <1E539FC23CF84B8A91428720570395E0@laptop2> <Pine.LNX.4.64.1101241720001.17567@axis700.grange> <AD14536027B946D6B4504D4F43E352A5@laptop2> <Pine.LNX.4.64.1101262045550.3989@axis700.grange> <F95361ABAE1D4A70A10790A798004482@laptop2> <Pine.LNX.4.64.1101271809030.8916@axis700.grange> <8026191608244DB98F002E983C866149@laptop2> <Pine.LNX.4.64.1102011420540.6673@axis700.grange> <18BE1662A1F04B6C8B39AA46440A3FBB@laptop2> <Pine.LNX.4.64.1102011532360.6673@axis700.grange> <2F2263A44E0F466F898DD3E2F1D19F12@laptop2> <Pine.LNX.4.64.1102081427500.1393@axis700.grange> <CEA83F28AF7C47E7B83AE1DBFFBC8514@laptop2> <Pine.LNX.4.64.1206051651220.2145@axis700.grange> <151B1A2540C945E48D7AAE0A8FC2DDEE@laptop2> <Pine.LNX.4.64.1206061614250.12739@axis700.grange>
Subject: Re: SH7724, VOU, PAL mode
Date: Wed, 6 Jun 2012 19:39:27 +0200
MIME-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="ISO-8859-1";
	reply-type=original
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

>> This is why "v4l2-ctl -s 5" used before my simple test program (modified
>> capture example with mmap method) finally has no effect for VOU.
>> When the test program opens video device it causes reset PAL mode in VOU 
>> and
>> does not in TV encoder.
>
> Right, this is actually a bug in the VOU driver. It didn't affect me,
> because I was opening the device only once before all the configuration
> and streaming. Could you create and submit a patch to save the standard in
> driver private data and restore it on open() after the reset? I guess,
> other configuration parameters are lost too, feel free to fix them as
> well.

Here you are. Something like that? I avoided encoder reconfiguration (it is 
not needed) - do not call sh_vou_s_std() and in result 
v4l2_device_call_until_err().

--- sh_vou.c.orig       2012-06-06 15:58:28.785086939 +0000
+++ sh_vou.c    2012-06-06 17:04:30.684586479 +0000
@@ -1183,6 +1183,13 @@ static int sh_vou_open(struct file *file
                        vou_dev->status = SH_VOU_IDLE;
                        return ret;
                }
+
+               /* restore std */
+               if (vou_dev->std & V4L2_STD_525_60)
+                       sh_vou_reg_ab_set(vou_dev, VOUCR,
+ 
sh_vou_ntsc_mode(vou_dev->pdata->bus_fmt) << 29, 7 << 29);
+               else
+                       sh_vou_reg_ab_set(vou_dev, VOUCR, 5 << 29, 7 << 29);
        }

        videobuf_queue_dma_contig_init(&vou_file->vbq, &sh_vou_video_qops,

I tested the std restoring and picture is synced/stable in PAL mode now. 
However I  have still problem after 480 line because next lines are always 
green.
Fixing other configuration parameters seems little more complicated 
(sh_vou_s_fmt_vid_out(), sh_vou_configure_geometry()).

>> > > I noticed that VOU is limited to NTSC resolution: "Maximum 
>> > > destination
>> > > image
>> > > size: 720 x 240 per field".
>> >
>> > You mean in the datasheet?
>>
>> Yes, exactly.
>>
>> > I don't have it currently at hand, but I seem
>> > to remember, that there was a bug and the VOU does actually support a 
>> > full
>> > PAL resolution too. I'm not 100% certain, though.
>>
>> OK, I will test it. Do you remember how you discovered that?
>
> Asked the manufacturer company :)

OK:) I found the sentence in sh_vou.c: "Cropping scheme: max useful image is 
720x480, and the total video area is 858x525 (NTSC) or 864x625 (PAL)." Next 
is some magic:)

> No, I'll send it to you off the list - Laurent agreed. But he also said,
> it was a preliminary version of his yavta proram, so, you might be able to
> use that one.

OK, the code you sent works much better than my simple video output program 
but the same problem after 480 line. I have to investigate it.
I use yavta for frame capturing tests.

Unfortunately I will be outside the company next 2 weeks. I will have remote 
access only to my hardware so more tests are not possible then.

best regards
Janusz

