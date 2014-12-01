Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ob0-f178.google.com ([209.85.214.178]:50582 "EHLO
	mail-ob0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753192AbaLAIyg (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 1 Dec 2014 03:54:36 -0500
Received: by mail-ob0-f178.google.com with SMTP id gq1so7606129obb.9
        for <linux-media@vger.kernel.org>; Mon, 01 Dec 2014 00:54:35 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1417188223.3721.2.camel@pengutronix.de>
References: <CAL8zT=i+UZP7gpukW-cRe2M=xWW5Av9Mzd-FnnZAP5d+5J7Mzg@mail.gmail.com>
 <1417020934.3177.15.camel@pengutronix.de> <CAL8zT=hY8XeAb4j7-eBt3VJX-3Kzg6-BOajvSpxvgc+o3ZRuYQ@mail.gmail.com>
 <CAL8zT=gnkaD=9XbyBDcDh7D=w+rDSQPsi3dKfQ17ezvz6NZMCg@mail.gmail.com>
 <CAOMZO5BsikrKPCjV129FWWW2DVe-ziLz_kMGSh6aM2JC=wnkhA@mail.gmail.com> <1417188223.3721.2.camel@pengutronix.de>
From: Jean-Michel Hautbois <jean-michel.hautbois@vodalys.com>
Date: Mon, 1 Dec 2014 09:54:19 +0100
Message-ID: <CAL8zT=ga2G7Zb2wjrT91Jq__OzUvjdCVgPH5ofcuX-7ZOCDkow@mail.gmail.com>
Subject: Re: i.MX6 CODA960 encoder
To: Philipp Zabel <p.zabel@pengutronix.de>
Cc: Fabio Estevam <festevam@gmail.com>,
	Sascha Hauer <kernel@pengutronix.de>,
	Fabio Estevam <fabio.estevam@freescale.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Robert Schwebel <r.schwebel@pengutronix.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Philipp,

2014-11-28 16:23 GMT+01:00 Philipp Zabel <p.zabel@pengutronix.de>:
> Am Donnerstag, den 27.11.2014, 16:10 -0200 schrieb Fabio Estevam:
>> On Thu, Nov 27, 2014 at 3:54 PM, Jean-Michel Hautbois
>> <jean-michel.hautbois@vodalys.com> wrote:
>>
>> > I don't have the same behaviour, but I may have missed a patch.
>> > I have taken linux-next and rebased my work on it. I have some issues,
>> > but nothing to be worried about, no link with coda.
>> > I get the following :
>> > $> v4l2-ctl -d0 --set-fmt-video-out=width=1280,height=720,pixelfor
>> > $> v4l2-ctl -d0 --stream-mmap --stream-out-mmap --stream-to x.raw
>> > [  173.705701] coda 2040000.vpu: CODA PIC_RUN timeout
>>
>> I have this same error with linux-next when I try to decode a file.
>>
>> Philipp,
>>
>> Do you know if linux-next contains all required coda patches?
>>
>> Could this be caused by the fact that we are using an unsupported VPU
>> firmware version?
>
> I missed that the commit a04a0b6fed4f ("ARM: dts: imx6qdl: Enable
> CODA960 VPU") lost the switching of the interrupts between
> http://www.spinics.net/lists/arm-kernel/msg338645.html
> and
> http://www.spinics.net/lists/arm-kernel/msg376571.html .
>
> Of course the JPEG interrupt will never fire when encoding H.264, which
> causes the timeout. Patch in another mail.

OK, I applied the patch you mentionned, and it works ! :)
Now, I will try to make it working with gstreamer...

JM
