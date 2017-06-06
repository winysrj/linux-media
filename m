Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ot0-f175.google.com ([74.125.82.175]:34640 "EHLO
        mail-ot0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750755AbdFFGfq (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 6 Jun 2017 02:35:46 -0400
MIME-Version: 1.0
In-Reply-To: <20170603081817.GQ1019@valkosipuli.retiisi.org.uk>
References: <CAEC9eQNW1hHrn2p9Tu-WR3Kft62x71383HjwbJQSiq_iWebsnw@mail.gmail.com>
 <20170603081817.GQ1019@valkosipuli.retiisi.org.uk>
From: Ajay kumar <ajaynumb@gmail.com>
Date: Tue, 6 Jun 2017 12:05:44 +0530
Message-ID: <CAEC9eQM6Ns07qRF6ofy5OL6BOGjM8gNs9uzDFxjpdpev-Z3zYA@mail.gmail.com>
Subject: Re: Support for RGB/YUV 10, 12 BPC(bits per color/component) image
 data formats in kernel
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: LKML <linux-kernel@vger.kernel.org>,
        linux-media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

On Sat, Jun 3, 2017 at 1:48 PM, Sakari Ailus <sakari.ailus@iki.fi> wrote:
> Hi Ajay,
>
> On Fri, Jun 02, 2017 at 06:38:53PM +0530, Ajay kumar wrote:
>> Hi all,
>>
>> I have tried searching for RGB/YUV 10, 12 BPC formats in videodev2.h,
>> media-bus-format.h and drm_fourcc.h
>> I could only find RGB 10BPC support in drm_fourcc.h.
>> I guess not much support is present for formats with (BPC > 8) in the kernel.
>
> What's "BPC"? Most YUV and RGB formats have only 8 bits per sample. More
> format definitions may be added if there's a driver that makes use of them.
BPC : Bits Per Color/Component
In my project, we have an image capture device which can capture 10 or
12 bits for each of R, G, B colors, i.e:
R[0:9] G[0:9] B[0:9] and
R[0:11] G[0:11] B[0:11]

I want to define macros for the above formats in videodev2.h.
But, I am not getting the logic behind the naming convention used to
define v4l2_fourcc macros.
ex:
V4L2_PIX_FMT_ARGB32      v4l2_fourcc('A', 'R', '2', '4');

How did they choose the characters 'A', 'R', '2', '4' in the above case?

I want to know the logic/naming convention behind that, so that I can create
new v4l2_fourcc defines for 10, 12 BPC formats and use in my driver.

Thanks,
Ajay Kumar
>>
>> Are there any plans to add fourcc defines for such formats?
>> Also, I wanted to how to define fourcc code for those formats?
>
> --
> Regards,
>
> Sakari Ailus
> e-mail: sakari.ailus@iki.fi     XMPP: sailus@retiisi.org.uk
