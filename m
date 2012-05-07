Return-path: <linux-media-owner@vger.kernel.org>
Received: from na3sys009aog137.obsmtp.com ([74.125.149.18]:60704 "EHLO
	na3sys009aog137.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753016Ab2EGWEe convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 7 May 2012 18:04:34 -0400
Received: by qcsu28 with SMTP id u28so1382677qcs.22
        for <linux-media@vger.kernel.org>; Mon, 07 May 2012 15:04:32 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.64.1205072321530.3564@axis700.grange>
References: <CAH9_wRP4+hzFpCdcZWmyyTZpTTFi+9wyTJxX2vPd+3r0QNhLkA@mail.gmail.com>
 <CAKnK67Qdte8qJ9L18OL2ft=YaF4YEAD-5rTP_bk7+_nQAn4u+A@mail.gmail.com> <Pine.LNX.4.64.1205072321530.3564@axis700.grange>
From: "Aguirre, Sergio" <saaguirre@ti.com>
Date: Mon, 7 May 2012 17:04:12 -0500
Message-ID: <CAKnK67SpO-roU_d_5DV4bq4J5URX0Niw=hCjXY3N=GUAumZLig@mail.gmail.com>
Subject: Re: Android Support for camera?
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Sriram V <vshrirama@gmail.com>, linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Guennadi,

On Mon, May 7, 2012 at 4:25 PM, Guennadi Liakhovetski
<g.liakhovetski@gmx.de> wrote:
> Hi Sergio
>
> On Mon, 7 May 2012, Aguirre, Sergio wrote:
>
>> Hi Sriram,
>>
>> On Mon, May 7, 2012 at 10:33 AM, Sriram V <vshrirama@gmail.com> wrote:
>> > Hi Sergio,
>> >  I understand that you are working on providing Android HAL Support
>> > for camera on omap4.
>>
>> That's right. Not an active task at the moment, due to some other
>> stuff going on,
>> but yes, I have that task pending to do.
>>
>> >  Were you able to capture and record?
>>
>> Well, I'm trying to take these patches as a reference:
>>
>> http://review.omapzoom.org/#/q/project:platform/hardware/ti/omap4xxx+topic:usbcamera,n,z
>>
>> Which are implementing V4L2 camera support for the CameraHAL,
>> currently tested with
>> the UVC camera driver only.
>
> I've implemented a (pretty basic so far) V4L2 camera HAL for android
> (ICS), patche submission is pending legal clarifications... I hope to
> manage to push them into the upstream android, after which they shall
> become available to all platforms. I've implemented the HAL as a
> platform-agnostic library in C with a minimal (and naive;-)) C++ glue. I'm
> sure, those patches will need some improvements, but I'd be happy, if they
> could be taken as a basis.

Ok, good to know.

Please share them whenever you get over those legal clarifications :)

Maybe we can work out a nice and complete solution all together!

Regards,
Sergio

Regards,
Sergio

>
> Thanks
> Guennadi
>
>> So, I need to set the IOCTLs to program the omap4iss media controller
>> device, to set a
>> usecase, and start preview.
>>
>> I'll keep you posted.
>>
>> Regards,
>> Sergio
>>
>> >
>> >  --
>> > Regards,
>> > Sriram
>
> ---
> Guennadi Liakhovetski, Ph.D.
> Freelance Open-Source Software Developer
> http://www.open-technology.de/
