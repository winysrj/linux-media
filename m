Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vw0-f171.google.com ([209.85.212.171]:44479 "EHLO
	mail-vw0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752437AbZGTIFk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 20 Jul 2009 04:05:40 -0400
Received: by vwj1 with SMTP id 1so331172vwj.33
        for <linux-media@vger.kernel.org>; Mon, 20 Jul 2009 01:05:39 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20090717124431.1bd3ea43@free.fr>
References: <91b198a70907100305t762a4596r734e44f7f4f88bc3@mail.gmail.com>
	 <20090711185415.3756dc26@pedra.chehab.org>
	 <91b198a70907130042y6594a96do8634eebdfef8ba5c@mail.gmail.com>
	 <91b198a70907162030l760bd7c5r32daaf6823c1dbe6@mail.gmail.com>
	 <20090717043225.4c786455@pedra.chehab.org>
	 <20090717124431.1bd3ea43@free.fr>
Date: Mon, 20 Jul 2009 15:04:05 +0800
Message-ID: <91b198a70907200004y5418796dkbf491d2cae877fb7@mail.gmail.com>
Subject: Re: Lenovo webcam problem which using gspca's vc032x driver
From: AceLan Kao <acelan.kao@canonical.com>
To: Jean-Francois Moine <moinejf@free.fr>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>, hugh@canonical.com,
	linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Dear Jean-Francois,

I use "Lenovo WebCam Center" and "Dorgem" to do the webcam preview
function, there are the following resolution settings
160x120
176x144
320x240
352x288
640x480
Do you need all the resolutions logs?

I try to use "Device Monitoring Studio" to log the USB traffic this time.
You can download the QVGA and VGA USB snoop log and the .INF file from here.
http://people.canonical.com/~acelan//bugs/lp310760/

Dear Mauro,

Sure, I'll give you the patches against the V4L/DVB hg tree.
But I think I should come out a conclusion with Jean-Francois, right?

Best regards,
AceLan Kao.

2009/7/17 Jean-Francois Moine <moinejf@free.fr>:
> On Fri, 17 Jul 2009 04:32:25 -0300
> Mauro Carvalho Chehab <mchehab@redhat.com> wrote:
>
>> Em Fri, 17 Jul 2009 11:30:24 +0800
>> AceLan Kao <acelan.kao@canonical.com> escreveu:
>        [snip]
>> > Thanks for your advice and links, I have found out the correct i2c
>> > commands to turn on/off the LED flash for Lenovo
>> > webcam(SENSOR_MI1310_SOC). Also, I fixed the upstream kernel, so
>> > that the camera preview and capture function are working now.
>> > The problem came from these two patches
>> > 6af4e7a V4L/DVB (10424): gspca - vc032x: Add resolution 1280x1024
>> > for sensor mi1310_soc.
>> > a92e906 V4L/DVB (10420): gspca - vc032x: Webcam 041e:405b added and
>> > mi1310_soc updated.
>> > I just disable the 1280x1024 resolution and revert back to the
>> > origin mi1310_soc VGA and QVGA settings.
>        [snip]
>> Also, since Jean-Francois added 1280x1024 resolution and changed the
>> initialization tables, I suspect that this worked fine with some
>> webcam model.
>>
>> So, probably, the bug is specific to this cam model (or related to a
>> poor USB performance at Lenovo internal usb bus). So, it is important
>> to know what is broken and what is not at the i2c sequence of
>> commands, in order to not break other similar devices.
>
> Hi AceLan Kao,
>
> Sorry to be a bit late on the problem, I'm busy with too many other
> webcams!
>
> First about the LEDs. 0x89 as the request value in USB control messages
> seems to control to GPIO. It may turn on/off the LEDs and also does
> sensor selection for the Samsung Q1. It should be specific to the
> webcam.
>
> Then, about the mi1310_soc. The zs328.inf and the C0130Dev.inf
> extracted from the ms-win driver and the usb snoop I have contain almost
> identical sequences, the ones which are in the driver since the
> addition of the webcam 041e:405b. Three guys use this webcam. Indeed,
> they have problems (mainly image freeze with frame overflow messages in
> the kernel traces).
>
> For now, I may ask the 041e:405b owners to check if your patch works.
>
> Otherwise, I thought to add the YUYV mode to the mi1310_soc, as it is
> for the mi1320_soc (the usb snoop I have is in this mode).
>
> Also, as you have the webcam and surely the ms-win driver, may you send
> me usb snoops in all resolutions and the .INF?
>
> Thanks.
>
> --
> Ken ar c'hentañ |             ** Breizh ha Linux atav! **
> Jef             |               http://moinejf.free.fr/
>



-- 
Chia-Lin Kao(AceLan)
http://blog.acelan.idv.tw/
E-Mail: acelan.kaoATcanonical.com (s/AT/@/)
