Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud3.xs4all.net ([194.109.24.30]:44667 "EHLO
        lb3-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751407AbdFFJdb (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 6 Jun 2017 05:33:31 -0400
Subject: Re: Support for RGB/YUV 10, 12 BPC(bits per color/component) image
 data formats in kernel
To: Ajay kumar <ajaynumb@gmail.com>, Sakari Ailus <sakari.ailus@iki.fi>
References: <CAEC9eQNW1hHrn2p9Tu-WR3Kft62x71383HjwbJQSiq_iWebsnw@mail.gmail.com>
 <20170603081817.GQ1019@valkosipuli.retiisi.org.uk>
 <CAEC9eQM6Ns07qRF6ofy5OL6BOGjM8gNs9uzDFxjpdpev-Z3zYA@mail.gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        linux-media <linux-media@vger.kernel.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <6a384c69-7980-9eeb-912f-a9ac26818a40@xs4all.nl>
Date: Tue, 6 Jun 2017 11:33:27 +0200
MIME-Version: 1.0
In-Reply-To: <CAEC9eQM6Ns07qRF6ofy5OL6BOGjM8gNs9uzDFxjpdpev-Z3zYA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 06/06/17 08:35, Ajay kumar wrote:
> Hi Sakari,
> 
> On Sat, Jun 3, 2017 at 1:48 PM, Sakari Ailus <sakari.ailus@iki.fi> wrote:
>> Hi Ajay,
>>
>> On Fri, Jun 02, 2017 at 06:38:53PM +0530, Ajay kumar wrote:
>>> Hi all,
>>>
>>> I have tried searching for RGB/YUV 10, 12 BPC formats in videodev2.h,
>>> media-bus-format.h and drm_fourcc.h
>>> I could only find RGB 10BPC support in drm_fourcc.h.
>>> I guess not much support is present for formats with (BPC > 8) in the kernel.
>>
>> What's "BPC"? Most YUV and RGB formats have only 8 bits per sample. More
>> format definitions may be added if there's a driver that makes use of them.
> BPC : Bits Per Color/Component
> In my project, we have an image capture device which can capture 10 or
> 12 bits for each of R, G, B colors, i.e:
> R[0:9] G[0:9] B[0:9] and
> R[0:11] G[0:11] B[0:11]
> 
> I want to define macros for the above formats in videodev2.h.
> But, I am not getting the logic behind the naming convention used to
> define v4l2_fourcc macros.
> ex:
> V4L2_PIX_FMT_ARGB32      v4l2_fourcc('A', 'R', '2', '4');
> 
> How did they choose the characters 'A', 'R', '2', '4' in the above case?
> 
> I want to know the logic/naming convention behind that, so that I can create
> new v4l2_fourcc defines for 10, 12 BPC formats and use in my driver.

A = has Alpha channel, R = uses RGB, 24 = uses 24 bits for the RGB part.

So for 10 bit you'd get AR30 and for 12 bit per component it's AR36.
If there is no alpha channel, then use XR30/XR36.

In practice there isn't much of a system behind these formats.

Regards,

	Hans

> 
> Thanks,
> Ajay Kumar
>>>
>>> Are there any plans to add fourcc defines for such formats?
>>> Also, I wanted to how to define fourcc code for those formats?
>>
>> --
>> Regards,
>>
>> Sakari Ailus
>> e-mail: sakari.ailus@iki.fi     XMPP: sailus@retiisi.org.uk
