Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-it0-f65.google.com ([209.85.214.65]:35966 "EHLO
	mail-it0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932515AbcGKS54 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 11 Jul 2016 14:57:56 -0400
Received: by mail-it0-f65.google.com with SMTP id h190so9534904ith.3
        for <linux-media@vger.kernel.org>; Mon, 11 Jul 2016 11:57:55 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1468259332.14217.8.camel@gmail.com>
References: <1468250057-16395-1-git-send-email-jean-christophe.trotin@st.com> <1468259332.14217.8.camel@gmail.com>
From: Javier Martinez Canillas <javier@dowhile0.org>
Date: Mon, 11 Jul 2016 14:57:54 -0400
Message-ID: <CABxcv=k-1RVsDWw++2+1Y4tq-T1XR7TSDrmSet8Thiuw+ChYUw@mail.gmail.com>
Subject: Re: [PATCH v2 0/3] support of v4l2 encoder for STMicroelectronics SOC
To: Jean-Christophe Trotin <jean-christophe.trotin@st.com>
Cc: nicolas@ndufresne.ca,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Hans Verkuil <hverkuil@xs4all.nl>, kernel@stlinux.com,
	Benjamin Gaignard <benjamin.gaignard@linaro.org>,
	Yannick Fertre <yannick.fertre@st.com>,
	Hugues Fruchet <hugues.fruchet@st.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Jul 11, 2016 at 1:48 PM, Nicolas Dufresne
<nicolas.dufresne@gmail.com> wrote:
> Le lundi 11 juillet 2016 à 17:14 +0200, Jean-Christophe Trotin a
> écrit :

[snip]

>>
>> Below is the v4l2-compliance report for the version 2 of the sti hva
>> driver:
>>
>>
>> root@sti-next:/home/video_test# v4l2-compliance -d /dev/video0
>> Driver Info:
>>       Driver name   : 8c85000.hva
>
> I think it would be nice to set a driver name that means something.
>
>>       Card type     : 8c85000.hva

Agreed, same for Card type. The VIDIOC_QUERYCAP ioctl documentation
explains what information these fields should contain:

https://linuxtv.org/downloads/v4l-dvb-apis/vidioc-querycap.html

For example https://git.linuxtv.org/media_tree.git/commit/?id=e0d80c8acca0f221b9dedb2eab7a5184848b99b7

Best regards,
Javier
