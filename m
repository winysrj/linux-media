Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:65497 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751051Ab1LPJTI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 16 Dec 2011 04:19:08 -0500
Received: by wgbdr13 with SMTP id dr13so5861064wgb.1
        for <linux-media@vger.kernel.org>; Fri, 16 Dec 2011 01:19:07 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAHG8p1Cki1tbziatSXsB3e1NVtZ2VmKgCLpR3-8+6QAKrzFEVg@mail.gmail.com>
References: <1324022443-5967-1-git-send-email-javier.martin@vista-silicon.com>
	<CAHG8p1Cki1tbziatSXsB3e1NVtZ2VmKgCLpR3-8+6QAKrzFEVg@mail.gmail.com>
Date: Fri, 16 Dec 2011 10:19:07 +0100
Message-ID: <CACKLOr3h4yCPSLHCV8j6JbxNrpXZ5Ws5AFWuJpO3MYWndase4Q@mail.gmail.com>
Subject: Re: [PATCH] V4L: soc-camera: provide support for S_INPUT.
From: javier Martin <javier.martin@vista-silicon.com>
To: Scott Jiang <scott.jiang.linux@gmail.com>
Cc: linux-media@vger.kernel.org, g.liakhovetski@gmx.de,
	saaguirre@ti.com, mchehab@infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 16 December 2011 09:34, Scott Jiang <scott.jiang.linux@gmail.com> wrote:
> 2011/12/16 Javier Martin <javier.martin@vista-silicon.com>:
>> Some v4l-subdevs such as tvp5150 have multiple
>> inputs. This patch allows the user of a soc-camera
>> device to select between them.
>>
>> Signed-off-by: Javier Martin <javier.martin@vista-silicon.com>
>> ---
>>  drivers/media/video/soc_camera.c |    6 +++---
>>  1 files changed, 3 insertions(+), 3 deletions(-)
>>
>> diff --git a/drivers/media/video/soc_camera.c b/drivers/media/video/soc_camera.c
>> index b72580c..1cea1a9 100644
>> --- a/drivers/media/video/soc_camera.c
>> +++ b/drivers/media/video/soc_camera.c
>> @@ -235,10 +235,10 @@ static int soc_camera_g_input(struct file *file, void *priv, unsigned int *i)
>>
>>  static int soc_camera_s_input(struct file *file, void *priv, unsigned int i)
>>  {
>> -       if (i > 0)
>> -               return -EINVAL;
> should it check max input?
>
>> +       struct soc_camera_device *icd = file->private_data;
>> +       struct v4l2_subdev *sd = soc_camera_to_subdev(icd);
>>
>> -       return 0;
>> +       return v4l2_subdev_call(sd, video, s_routing, i, 0, 0);
>>  }
>>
> why must output be zero?

Current behavior of soc-camera is not touching output at all, but
s_routing() callback enforces to select both input and output values.
The more neutral value I could think of for output is 0. Of course any
other suggestions are welcome.


-- 
Javier Martin
Vista Silicon S.L.
CDTUC - FASE C - Oficina S-345
Avda de los Castros s/n
39005- Santander. Cantabria. Spain
+34 942 25 32 60
www.vista-silicon.com
