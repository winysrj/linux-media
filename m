Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:52086 "EHLO
        mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752162AbdJ0I4h (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 27 Oct 2017 04:56:37 -0400
Received: by mail-wm0-f67.google.com with SMTP id b9so2275985wmh.0
        for <linux-media@vger.kernel.org>; Fri, 27 Oct 2017 01:56:37 -0700 (PDT)
Subject: Re: [PATCH 07/13] media: soc_camera pad-aware driver initialisation
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
To: William Towle <william.towle@codethink.co.uk>,
        linux-media@vger.kernel.org, linux-kernel@lists.codethink.co.uk
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Hans Verkuil <hverkuil@xs4all.nl>
References: <1437654103-26409-1-git-send-email-william.towle@codethink.co.uk>
 <1437654103-26409-8-git-send-email-william.towle@codethink.co.uk>
 <abf6792b-a43b-ed80-6d07-fff7f42fdf2a@cogentembedded.com>
Message-ID: <51629ac9-0ae2-6d70-5bf6-c3eaab76191d@cogentembedded.com>
Date: Fri, 27 Oct 2017 10:56:26 +0200
MIME-Version: 1.0
In-Reply-To: <abf6792b-a43b-ed80-6d07-fff7f42fdf2a@cogentembedded.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 10/27/2017 10:52 AM, Sergei Shtylyov wrote:

>> Add detection of source pad number for drivers aware of the media
>> controller API, so that the combination of soc_camera and rcar_vin
>> can create device nodes to support modern drivers such as adv7604.c
>> (for HDMI on Lager) and the converted adv7180.c (for composite)
>> underneath.
>>
>> Building rcar_vin gains a dependency on CONFIG_MEDIA_CONTROLLER, in
>> line with requirements for building the drivers associated with it.
>>
>> Signed-off-by: William Towle <william.towle@codethink.co.uk>
>> Signed-off-by: Rob Taylor <rob.taylor@codethink.co.uk>
>> ---
>>   drivers/media/platform/soc_camera/Kconfig      |    1 +
>>   drivers/media/platform/soc_camera/rcar_vin.c   |    1 +
> 
>     This driver no longer exists. What did you base on?

    Sorry, I didn't realize I was replying to 2 years old patch. :-)

[...]

MBR, Sergei
