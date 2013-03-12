Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wg0-f54.google.com ([74.125.82.54]:58223 "EHLO
	mail-wg0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754759Ab3CLKLz (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 12 Mar 2013 06:11:55 -0400
Received: by mail-wg0-f54.google.com with SMTP id fm10so5785775wgb.33
        for <linux-media@vger.kernel.org>; Tue, 12 Mar 2013 03:11:53 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.64.1303121031200.680@axis700.grange>
References: <1360948121.29406.15.camel@mars>
	<20130215172452.GA27113@kroah.com>
	<1361009964.5028.3.camel@mars>
	<Pine.LNX.4.64.1303051845060.25837@axis700.grange>
	<CACKLOr0smOW2cukSmeoexq3=b=dpGw=CDO3qo=gGm4+28iwb8Q@mail.gmail.com>
	<Pine.LNX.4.64.1303120847480.680@axis700.grange>
	<1363076713.3873.21.camel@mars>
	<CACKLOr2oFe-ME47UV_Osme4=-7nErYts6UpE8dCAN2E2Yi+q0A@mail.gmail.com>
	<Pine.LNX.4.64.1303121031200.680@axis700.grange>
Date: Tue, 12 Mar 2013 11:11:53 +0100
Message-ID: <CACKLOr1bkMugmvW6GpfSDA1AiRe+iytFPVx1GFcmTTRPbnXqyg@mail.gmail.com>
Subject: Re: [PATCH v2] media: i.MX27 camera: fix picture source width
From: javier Martin <javier.martin@vista-silicon.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Christoph Fritz <chf.fritz@googlemail.com>,
	Greg KH <gregkh@linuxfoundation.org>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Shawn Guo <shawn.guo@linaro.org>,
	"Hans J. Koch" <hjk@hansjkoch.de>,
	linux-media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 12 March 2013 10:39, Guennadi Liakhovetski <g.liakhovetski@gmx.de> wrote:
> On Tue, 12 Mar 2013, javier Martin wrote:
>
>> Hi Guernnadi, Christoph,
>>
>> On 12 March 2013 09:25, Christoph Fritz <chf.fritz@googlemail.com> wrote:
>> > On Tue, 2013-03-12 at 08:58 +0100, Guennadi Liakhovetski wrote:
>> >> On Thu, 7 Mar 2013, javier Martin wrote:
>> >
>> >> > What mbus format are you using? Could you please check if the s_width
>> >> > value that your sensor mt9m001 returns is correct? Remember it should
>> >> > be in pixels, not in bytes.
>> >>
>> >> Thanks for looking at this. But here's my question: for a pass-through
>> >> mode mx2_camera uses a 16-bpp (RGB565) format. But what if it's actually
>> >> an 8-bpp format, don't you then have to adjust line-width register
>> >> settings? If you don't do that, the camera interface would expect a double
>> >> number of bytes per line, so, it could get confused by HSYNC coming after
>> >> half-line?
>>
>> You are right.
>>
>> > To emphasize this: I'm using here a mt9m001 (monochrome) camera with an
>> > 8-bpp format.
>>
>> Ok, now that makes sense.
>>
>> Then, what you should do is apply your patch conditionally so that you
>> don't break other working cases:
>> - Channel 1 is being used.
>> - Channel 1 is in pass-through mode.
>
> which would be
>
>         if (!prp->in_fmt && !prp->out_fmt)

Yes, that would do.

>> - The sensor uses an 8-bpp format.
>
> No, the format in unimportant - you pretend to use a 16-bit format, so,
> your "simulated" line is always bytesperline / 2 pseudo-pixels long.

OK.

> Christoph, in your next comment please add a comment something like
>
>         /*
>          * In pass-through we configure EMMA with a 16-bpp format,
>          * set the line-width accordingly.
>          */




-- 
Javier Martin
Vista Silicon S.L.
CDTUC - FASE C - Oficina S-345
Avda de los Castros s/n
39005- Santander. Cantabria. Spain
+34 942 25 32 60
www.vista-silicon.com
