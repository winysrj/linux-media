Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-oi0-f68.google.com ([209.85.218.68]:36662 "EHLO
        mail-oi0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751890AbeFETSs (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 5 Jun 2018 15:18:48 -0400
Received: by mail-oi0-f68.google.com with SMTP id 14-v6so3157359oie.3
        for <linux-media@vger.kernel.org>; Tue, 05 Jun 2018 12:18:47 -0700 (PDT)
Subject: Re: [RFC/RFT PATCH 0/6] Asynchronous UVC
To: Kieran Bingham <kieran.bingham@ideasonboard.com>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        laurent.pinchart@ideasonboard.com
Cc: Olivier BRAUN <olivier.braun@stereolabs.com>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>
References: <cover.67dff754d6d314373ac0a04777b3b1d785fc5dd4.1515010476.git-series.kieran.bingham@ideasonboard.com>
 <b18d0633-cb04-639b-4ade-55b6839da0b3@boundarydevices.com>
 <239ae307-9c8d-ab95-34c0-3a179d2899bd@ideasonboard.com>
From: Troy Kisky <troy.kisky@boundarydevices.com>
Message-ID: <283ce407-deff-de1d-e28f-4c0795c60885@boundarydevices.com>
Date: Tue, 5 Jun 2018 12:18:45 -0700
MIME-Version: 1.0
In-Reply-To: <239ae307-9c8d-ab95-34c0-3a179d2899bd@ideasonboard.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 6/5/2018 2:01 AM, Kieran Bingham wrote:
> Hi Troy
> 
> On 03/01/18 21:13, Troy Kisky wrote:
>> On 1/3/2018 12:32 PM, Kieran Bingham wrote:
>>> From: Kieran Bingham <kieran.bingham@ideasonboard.com>
>>>
>>> The Linux UVC driver has long provided adequate performance capabilities for
>>> web-cams and low data rate video devices in Linux while resolutions were low.
>>>
>>> Modern USB cameras are now capable of high data rates thanks to USB3 with
>>> 1080p, and even 4k capture resolutions supported.
>>>
>>> Cameras such as the Stereolabs ZED or the Logitech Brio can generate more data
>>> than an embedded ARM core is able to process on a single core, resulting in
>>> frame loss.
>>>
>>> A large part of this performance impact is from the requirement to
>>> ‘memcpy’ frames out from URB packets to destination frames. This unfortunate
>>> requirement is due to the UVC protocol allowing a variable length header, and
>>> thus it is not possible to provide the target frame buffers directly.
>>
>>
>> I have a rather large patch that does provide frame buffers directly for bulk
>> cameras. It cannot be used with ISOC cameras.  But it is currently for 4.1.
>> I'll be porting it to 4.9 in a few days if you'd like to see it.
> 
> 
> How did you get on with this porting activity?
> 
> Is it possible to share any of this work with the mailing lists ?


This is pretty ugly all squashed together but here is the 4.9 patch

It does a bit more than 0 copy. I'll just post a link, because I doubt anyone
else wants to look.

https://github.com/boundarydevices/linux-imx6/commit/5cbb48a3332a6e8aad4a1359b1b5eb05eb0fff96

HTH
Troy

> 
> (If you have not ported to v4.9 - I think it would be useful even to post the
> v4.1 patch and we can look at what's needed for getting it ported to mainline)
> 
> --
> Regards
> 
> Kieran
> 
> 
>>
>> BR
>> Troy
