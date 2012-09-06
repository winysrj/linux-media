Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:58989 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756461Ab2IFJRS (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 6 Sep 2012 05:17:18 -0400
Received: by obbuo13 with SMTP id uo13so2076515obb.19
        for <linux-media@vger.kernel.org>; Thu, 06 Sep 2012 02:17:17 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <50477B20.1030902@samsung.com>
References: <CAOMZO5D7Ar0SE9vmi41jSxbPqv8sSOQshbL6Uzv4Ltow5xKx4w@mail.gmail.com>
 <50477B20.1030902@samsung.com>
From: Prabhakar Lad <prabhakar.csengg@gmail.com>
Date: Thu, 6 Sep 2012 14:46:57 +0530
Message-ID: <CA+V-a8t0GCKsvn5i8U8xNpeRQZCfu6b0s3O+XuOKbSfUY8AD8Q@mail.gmail.com>
Subject: Re: Camera not detected on linux-next
To: Sylwester Nawrocki <s.nawrocki@samsung.com>
Cc: Fabio Estevam <festevam@gmail.com>,
	Javier Martin <javier.martin@vista-silicon.com>,
	=?ISO-8859-1?Q?Ga=EBtan_Carlier?= <gcembed@gmail.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Sascha Hauer <kernel@pengutronix.de>,
	linux-media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sylwester,

On Wed, Sep 5, 2012 at 9:47 PM, Sylwester Nawrocki
<s.nawrocki@samsung.com> wrote:
> Hi,
>
> On 09/05/2012 06:06 PM, Fabio Estevam wrote:
>> I am running linux-next 20120905 on a mx31pdk board with a ov2640 CMOS
>> and I am not able to get the ov2640 to be probed:
>>
>> soc-camera-pdrv soc-camera-pdrv.0: Probing soc-camera-pdrv.0
>> mx3-camera mx3-camera.0: MX3 Camera driver attached to camera 0
>> mx3-camera mx3-camera.0: MX3 Camera driver detached from camera 0
>> .... (no messages showing ov2640 being probed)
>>
>> I noticed that Kconfig changed the way to select the "Sensors used on
>> soc_camera driver" and I selected ov2640 in the .config.
>>
>> camera worked fine on this board running 3.5.3. So before start
>> bisecting, I would like to know if there is anything obvious I am
>> missing.
>>
>> Also tested on a mx27pdk and ov2640 could not be probed there as well.
>
> Maybe this is about the sensor/host driver linking order.
> If so, then this patch should help
>
> http://git.linuxtv.org/snawrocki/media.git/commitdiff/458b9b5ab8cb970887c9d1f1fddf88399b2d9ef2
>
Thanks for the patch.  I too had created one but didnt submit. I guess you will
post the patch soon to the list.

Thanks and Regards,
--Prabhakar Lad

> --
>
> Regards,
> Sylwester
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
