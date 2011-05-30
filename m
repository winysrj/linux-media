Return-path: <mchehab@pedra>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:63187 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751938Ab1E3VjO (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 30 May 2011 17:39:14 -0400
Received: by qwk3 with SMTP id 3so1819190qwk.19
        for <linux-media@vger.kernel.org>; Mon, 30 May 2011 14:39:13 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <201105301045.24326.laurent.pinchart@ideasonboard.com>
References: <BANLkTineUffG1yd3Ey30wr0xzAj3_Zd1KQ@mail.gmail.com>
	<201105301045.24326.laurent.pinchart@ideasonboard.com>
Date: Mon, 30 May 2011 23:39:13 +0200
Message-ID: <BANLkTi=t99QM93psfrOK+t2cRtpmtwzu6w@mail.gmail.com>
Subject: Re: Capabilities of the Omap3 ISP driver
From: Bastian Hecht <hechtb@googlemail.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	"Felix v. Hundelshausen" <felix.v.hundelshausen@live.de>
Content-Type: text/plain; charset=ISO-8859-1
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hello Laurent,

2011/5/30 Laurent Pinchart <laurent.pinchart@ideasonboard.com>:
> Hi Bastian,
>
> On Sunday 29 May 2011 15:27:23 Bastian Hecht wrote:
>> Hello Laurent,
>>
>> I'm on to a project that needs two synced separate small cameras for
>> stereovision.
>>
>> I was thinking about realizing this on an DM3730 with 2 aptina csi2
>> cameras that are used in snapshot mode.
>
> As far as I know, the DM3730 doesn't have CSI2 interfaces.

If I don't mix up datasheets, it is stated very clearly that 2 csi2
interfaces are supported. I took the datasheet at
http://www.ti.com/litv/pdf/sprugn4k declared as AM/DM37x Multimedia
Device Technical Reference Manual (Silicon Revision 1.x) (Rev. K)
(PDF  26851 KB).
"The camera ISP implements three receivers which are named CSI2A,
CSI1/CCP2B, and CSI2C. The CSI2A and CSI2C are MIPI D-PHY CSI2
compatible." on page 1070.

>> The questions that arise are:
>>
>> - is the ISP driver capable of running 2 concurrent cameras?
>
> Yes it can, but only one of them can use the CCDC, preview engine and resizer.
> The other will be captured directly to memory as raw data. You could capture
> both raw streams to memory, and then feed them alternatively through the rest
> of the pipeline. Whether this can work will depend on the image size and frame
> rate.
Ok I will check if it is sufficient to do any conversions on the cpu.

>> - is it possible to simulate a kind of video stream that is externally
>> triggered (I would use a gpio line that simply triggers 10 times a
>> sec) or would there arise problems with the csi2 protocoll (timeouts
>> or similar)?
>
> I don't think there will be CSI2 issues (although I'm not an expert there) if
> you trigger the sensors externally.

Nice, when the ISP side is probably no problem - do you have any
experience with snapshot mode and know if cameras are capable of doing
it at framerates about 10fps? It is just because snapshot mode sounds
like taking 1 frame every now and then... can't they call it "trigger
mode"? :)

A million thanks for your answer,

 Bastian Hecht


> --
> Regards,
>
> Laurent Pinchart
>
