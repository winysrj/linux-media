Return-path: <linux-media-owner@vger.kernel.org>
Received: from qw-out-2122.google.com ([74.125.92.27]:33034 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750943AbZGVJPQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 22 Jul 2009 05:15:16 -0400
Received: by qw-out-2122.google.com with SMTP id 8so18452qwh.37
        for <linux-media@vger.kernel.org>; Wed, 22 Jul 2009 02:15:15 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <91b198a70907201918l68435905u1ad590144d664a29@mail.gmail.com>
References: <91b198a70907100305t762a4596r734e44f7f4f88bc3@mail.gmail.com>
	 <20090711185415.3756dc26@pedra.chehab.org>
	 <91b198a70907130042y6594a96do8634eebdfef8ba5c@mail.gmail.com>
	 <91b198a70907162030l760bd7c5r32daaf6823c1dbe6@mail.gmail.com>
	 <20090717043225.4c786455@pedra.chehab.org>
	 <20090717124431.1bd3ea43@free.fr>
	 <91b198a70907200004y5418796dkbf491d2cae877fb7@mail.gmail.com>
	 <20090720105325.26f2ae1a@free.fr>
	 <91b198a70907201918l68435905u1ad590144d664a29@mail.gmail.com>
Date: Wed, 22 Jul 2009 17:15:15 +0800
Message-ID: <91b198a70907220215t14d509e7u8b33623cecafa26f@mail.gmail.com>
Subject: Re: Lenovo webcam problem which using gspca's vc032x driver
From: AceLan Kao <acelan.kao@canonical.com>
To: Jean-Francois Moine <moinejf@free.fr>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>, hugh@canonical.com,
	linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

2009/7/21 AceLan Kao <acelan.kao@canonical.com>:
> 2009/7/20 Jean-Francois Moine <moinejf@free.fr>:
>> On Mon, 20 Jul 2009 15:04:05 +0800
>> AceLan Kao <acelan.kao@canonical.com> wrote:
>>
>>> I use "Lenovo WebCam Center" and "Dorgem" to do the webcam preview
>>> function, there are the following resolution settings
>>> 160x120
>>> 176x144
>>> 320x240
>>> 352x288
>>> 640x480
>>> Do you need all the resolutions logs?
>>>
>>> I try to use "Device Monitoring Studio" to log the USB traffic this
>>> time. You can download the QVGA and VGA USB snoop log and the .INF
>>> file from here. http://people.canonical.com/~acelan//bugs/lp310760/
>>
>> Hello Acelan Kao,
>>
>> Thanks for the files. I could not look at the dms logs, having no tool
>> to do. Anyway, the .inf gives the exact USB sequence you set.
>>
>> I got a return from one guy with the same sensor. He said the driver
>> works better (with the LEDs), but there are still some frame overflows
>> and the image is upside down. Have you such a problem?
>>
>> The sequence for the SXVGA mode (1280x1024) is defined in the .inf. I
>> extracted it and attached. Does it work for you?
>>
>> Best regards.
>>
>> --
>> Ken ar c'hentañ |             ** Breizh ha Linux atav! **
>> Jef             |               http://moinejf.free.fr/
>>
>
> Dear Jean-Francois,
>
> The SXGA setting works for me if the resolution set to 1280x960 and
> the image is upside down.
> ===
>        {1280, 960, V4L2_PIX_FMT_JPEG, V4L2_FIELD_NONE, /* mi13x0_soc only */
>                .bytesperline = 1280,
>                .sizeimage = 1280 * 960 * 1 / 4 + 590,
>                .colorspace = V4L2_COLORSPACE_JPEG,
>                .priv = 2},
> ===
>
> And for the QVGA and VGA resolution preview, my display is good, not
> upside down.
>
> Best regards,
> AceLan Kao.
>
> --
> Chia-Lin Kao(AceLan)
> http://blog.acelan.idv.tw/
> E-Mail: acelan.kaoATcanonical.com (s/AT/@/)
>

Dear Jean-Francois,

I would like to know which version of vc032x.c won't make 041e:405b
device display upside down.
And have you let the 041e:405b device owner to test the SXGA setting
and with the 1280x960 resolution? What's the result?

Best regards,
AceLan Kao.

-- 
Chia-Lin Kao(AceLan)
http://blog.acelan.idv.tw/
E-Mail: acelan.kaoATcanonical.com (s/AT/@/)
