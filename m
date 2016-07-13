Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-io0-f194.google.com ([209.85.223.194]:32957 "EHLO
	mail-io0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752030AbcGMOBC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 13 Jul 2016 10:01:02 -0400
Received: by mail-io0-f194.google.com with SMTP id y195so2999434iod.0
        for <linux-media@vger.kernel.org>; Wed, 13 Jul 2016 07:01:01 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <57864702.5090006@st.com>
References: <1468250057-16395-1-git-send-email-jean-christophe.trotin@st.com>
 <1468259332.14217.8.camel@gmail.com> <CABxcv=k-1RVsDWw++2+1Y4tq-T1XR7TSDrmSet8Thiuw+ChYUw@mail.gmail.com>
 <57864702.5090006@st.com>
From: Javier Martinez Canillas <javier@dowhile0.org>
Date: Wed, 13 Jul 2016 10:00:35 -0400
Message-ID: <CABxcv=kr3gn4JnRPBSExxxTxfrMP5wp49pyfhMW5sd+d77Z9EQ@mail.gmail.com>
Subject: Re: [PATCH v2 0/3] support of v4l2 encoder for STMicroelectronics SOC
To: Jean Christophe TROTIN <jean-christophe.trotin@st.com>
Cc: "nicolas@ndufresne.ca" <nicolas@ndufresne.ca>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	"kernel@stlinux.com" <kernel@stlinux.com>,
	Benjamin Gaignard <benjamin.gaignard@linaro.org>,
	Yannick FERTRE <yannick.fertre@st.com>,
	Hugues FRUCHET <hugues.fruchet@st.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Jean Christophe,

On Wed, Jul 13, 2016 at 9:49 AM, Jean Christophe TROTIN
<jean-christophe.trotin@st.com> wrote:
>
>
> On 07/11/2016 08:57 PM, Javier Martinez Canillas wrote:
>> On Mon, Jul 11, 2016 at 1:48 PM, Nicolas Dufresne
>> <nicolas.dufresne@gmail.com> wrote:
>>> Le lundi 11 juillet 2016 à 17:14 +0200, Jean-Christophe Trotin a
>>> écrit :
>>
>> [snip]
>>
>>>>
>>>> Below is the v4l2-compliance report for the version 2 of the sti hva
>>>> driver:
>>>>
>>>>
>>>> root@sti-next:/home/video_test# v4l2-compliance -d /dev/video0
>>>> Driver Info:
>>>>        Driver name   : 8c85000.hva
>>>
>>> I think it would be nice to set a driver name that means something.
>>>
>>>>        Card type     : 8c85000.hva
>>
>> Agreed, same for Card type. The VIDIOC_QUERYCAP ioctl documentation
>> explains what information these fields should contain:
>>
>> https://linuxtv.org/downloads/v4l-dvb-apis/vidioc-querycap.html
>>
>> For example https://git.linuxtv.org/media_tree.git/commit/?id=e0d80c8acca0f221b9dedb2eab7a5184848b99b7
>>
>> Best regards,
>> Javier
>>
>
> Nicolas and Javier,
>
> Thank you for the remarks.
> I will modify the code in version 3 so that "driver" contains the name of the
> encoder ("hva"), "card" identifies the hardware version ("hva<hw_ip_version>"
> with <hw_ip_version> equal to 400 here, which leads to "hva400"), and "bus_info"
> indicates the location of the device ("platform:8c85000.hva").
>
> Before the modification:
> Driver Info:
>         Driver name   : 8c85000.hva
>         Card type     : 8c85000.hva
>         Bus info      : platform:hva
>         Driver version: 4.7.0
>
> After the modification:
> Driver Info:
>         Driver name   : hva
>         Card type     : hva400
>         Bus info      : platform:8c85000.hva
>         Driver version: 4.7.0
>

Thanks a lot for doing this, it looks correct to me now.

> Best regards,
> Jean-Christophe.

Best regards,
Javier
