Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-gx0-f226.google.com ([209.85.217.226]:48216 "EHLO
	mail-gx0-f226.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932575AbZLHQmJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 8 Dec 2009 11:42:09 -0500
Received: by gxk26 with SMTP id 26so5256224gxk.1
        for <linux-media@vger.kernel.org>; Tue, 08 Dec 2009 08:42:15 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.64.0912072052030.8481@axis700.grange>
References: <37367b3a0912071113y41efc736h20a6fe203244811d@mail.gmail.com>
	 <Pine.LNX.4.64.0912072052030.8481@axis700.grange>
Date: Tue, 8 Dec 2009 14:42:15 -0200
Message-ID: <37367b3a0912080842h601be618tdc4151ba226bbb60@mail.gmail.com>
Subject: Re: soc_camera: OV2640
From: Alan Carvalho de Assis <acassis@gmail.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Guennadi,

On 12/7/09, Guennadi Liakhovetski <g.liakhovetski@gmx.de> wrote:
> Hi Alan
>
> On Mon, 7 Dec 2009, Alan Carvalho de Assis wrote:
>
> It's always better to cc a suitable list, in this case it is
>
> Linux Media Mailing List <linux-media@vger.kernel.org>
>

Sure, here we go.

>
>> I am trying to use an OV2640 camera with soc_camera.
>>
>> I'm using ov772x driver as base, but it needs too much modification to
>> work with ov2640.
>
> I don't know that sensor specifically, but they can be quite different.
>

Yes, in fact ov2640 appears quite different compared to ov772x and ov9640.

>> The OV2640 chip remaps all registers when register 0xFF is 1 or when it is
>> 0.
>
> This is not unusual. There are a few ways to implement this, for example,
> drivers/media/video/rj54n1cb0c.c uses 16-bit addresses, and decodes them
> to bank:register pairs in its reg_read() and reg_write() routines.
>

Ok, I will try to implement it this way, case nobody suggests me a
better approach.

Best Regards,

Alan
