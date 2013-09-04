Return-path: <linux-media-owner@vger.kernel.org>
Received: from tx2ehsobe005.messaging.microsoft.com ([65.55.88.15]:3004 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758561Ab3IDOJj (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 4 Sep 2013 10:09:39 -0400
Message-ID: <52273ED5.6090609@licor.com>
Date: Wed, 4 Sep 2013 09:08:21 -0500
From: Darryl <ddegraff@licor.com>
MIME-Version: 1.0
To: Prabhakar Lad <prabhakar.csengg@gmail.com>
CC: linux-media <linux-media@vger.kernel.org>,
	dlos <davinci-linux-open-source@linux.davincidsp.com>
Subject: Re: davinci vpif_capture
References: <5220CADF.5050805@licor.com> <CA+V-a8t7sb9HVACCVTDG0c2LH6Ca=Tc7EY=UmU38apKNjVdZyA@mail.gmail.com> <5225C87D.2010606@licor.com> <CA+V-a8sbSdCdoFMpP2rfPCzvXYS6mydnTEhbG741duUQqTUOQg@mail.gmail.com>
In-Reply-To: <CA+V-a8sbSdCdoFMpP2rfPCzvXYS6mydnTEhbG741duUQqTUOQg@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 09/03/2013 09:46 PM, Prabhakar Lad wrote:
> Hi,
>
> On Tue, Sep 3, 2013 at 5:01 PM, Darryl <ddegraff@licor.com> wrote:
>> On 08/31/2013 06:15 AM, Prabhakar Lad wrote:
>>> On Fri, Aug 30, 2013 at 10:09 PM, Darryl <ddegraff@licor.com> wrote:
>>>> I am working on an application involving the davinci using the vpif.  My
>>>> board file has the inputs configured to use VPIF_IF_RAW_BAYER if_type.
>>>> When my application starts up, I have it enumerate the formats
>>>> (VIDIOC_ENUM_FMT) and it indicates that the only available format is
>>>> "YCbCr4:2:2 YC Planar" (from vpif_enum_fmt_vid_cap).  It looks to me that
>>>> the culprit is vpif_open().
>>>>
>>>> struct channel_obj.vpifparams.iface is initialized at vpif_probe() time
>>>> in
>>>> the function vpif_set_input.  Open the device file (/dev/video0)
>>>> overwrites
>>>> this.  I suspect that it is __not__ supposed to do this, since I don't
>>>> see
>>>> any method for restoring the iface.
>>>>
>>> NAK, Ideally the application should go in the following manner,
>>> you open the device say example /dev/video0 , then you issue
>>> a VIDIOC_ENUMINPUT IOCTL,  this will enumerate the inputs
>>> then you do  VIDIOC_S_INPUT this will select the input device
>>> so when this IOCTL is called vpif_s_input() is called in vpif_capture
>>> driver this function will internally call the vpif_set_input() which
>>> will set the iface for you on line 1327.
>>
>> Is there a document or documents where I can find this "following manner"?
>> I've read through a lot of v4l docs, but none seem to suggest an ordered
>> sequence of ioctl calls.
>>
> Yes thats the way its done! I dont have any docs but you can refer some test
> application yavta[1] so that you are clear and you can also go through
> the link [2].
>
> [1] http://git.ideasonboard.org/yavta.git/shortlog/refs/heads/master
> [2] http://www.linuxtv.org/downloads/legacy/video4linux/API/V4L2_API/spec-single/v4l2.html

Thanks very much for your help.  I'll check out the yavta sources.

I've looked at both the legacy and current specs.  They are full of 
information, but sadly, in my opinion, don't give a unified vision of 
how to use the whole.

>
> Regards,
> --Prabhakar Lad
>


