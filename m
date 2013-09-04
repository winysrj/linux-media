Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f171.google.com ([209.85.212.171]:48732 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761750Ab3IDCqp (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 3 Sep 2013 22:46:45 -0400
Received: by mail-wi0-f171.google.com with SMTP id hm2so1622629wib.16
        for <linux-media@vger.kernel.org>; Tue, 03 Sep 2013 19:46:44 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <5225C87D.2010606@licor.com>
References: <5220CADF.5050805@licor.com> <CA+V-a8t7sb9HVACCVTDG0c2LH6Ca=Tc7EY=UmU38apKNjVdZyA@mail.gmail.com>
 <5225C87D.2010606@licor.com>
From: Prabhakar Lad <prabhakar.csengg@gmail.com>
Date: Wed, 4 Sep 2013 08:16:24 +0530
Message-ID: <CA+V-a8sbSdCdoFMpP2rfPCzvXYS6mydnTEhbG741duUQqTUOQg@mail.gmail.com>
Subject: Re: davinci vpif_capture
To: Darryl <ddegraff@licor.com>
Cc: linux-media <linux-media@vger.kernel.org>,
	dlos <davinci-linux-open-source@linux.davincidsp.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On Tue, Sep 3, 2013 at 5:01 PM, Darryl <ddegraff@licor.com> wrote:
> On 08/31/2013 06:15 AM, Prabhakar Lad wrote:
>>
>> On Fri, Aug 30, 2013 at 10:09 PM, Darryl <ddegraff@licor.com> wrote:
>>>
>>> I am working on an application involving the davinci using the vpif.  My
>>> board file has the inputs configured to use VPIF_IF_RAW_BAYER if_type.
>>> When my application starts up, I have it enumerate the formats
>>> (VIDIOC_ENUM_FMT) and it indicates that the only available format is
>>> "YCbCr4:2:2 YC Planar" (from vpif_enum_fmt_vid_cap).  It looks to me that
>>> the culprit is vpif_open().
>>>
>>> struct channel_obj.vpifparams.iface is initialized at vpif_probe() time
>>> in
>>> the function vpif_set_input.  Open the device file (/dev/video0)
>>> overwrites
>>> this.  I suspect that it is __not__ supposed to do this, since I don't
>>> see
>>> any method for restoring the iface.
>>>
>> NAK, Ideally the application should go in the following manner,
>> you open the device say example /dev/video0 , then you issue
>> a VIDIOC_ENUMINPUT IOCTL,  this will enumerate the inputs
>> then you do  VIDIOC_S_INPUT this will select the input device
>> so when this IOCTL is called vpif_s_input() is called in vpif_capture
>> driver this function will internally call the vpif_set_input() which
>> will set the iface for you on line 1327.
>
>
> Is there a document or documents where I can find this "following manner"?
> I've read through a lot of v4l docs, but none seem to suggest an ordered
> sequence of ioctl calls.
>
Yes thats the way its done! I dont have any docs but you can refer some test
application yavta[1] so that you are clear and you can also go through
the link [2].

[1] http://git.ideasonboard.org/yavta.git/shortlog/refs/heads/master
[2] http://www.linuxtv.org/downloads/legacy/video4linux/API/V4L2_API/spec-single/v4l2.html

Regards,
--Prabhakar Lad
