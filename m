Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wj0-f193.google.com ([209.85.210.193]:36699 "EHLO
        mail-wj0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753389AbcLWSxt (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 23 Dec 2016 13:53:49 -0500
Subject: Re: [RFC/PATCH] media: Add video bus switch
To: Pavel Machek <pavel@ucw.cz>
References: <20161023200355.GA5391@amd>
 <20161119232943.GF13965@valkosipuli.retiisi.org.uk>
 <20161214122451.GB27011@amd> <20161222100104.GA30917@amd>
 <20161222133938.GA30259@amd> <20161222143244.ykza4wdxmop2t7bg@earth>
 <20161222224226.GB31151@amd> <20161222234028.oxntlek2oy62cjnh@earth>
 <20161223114237.GA5879@amd>
Cc: Sebastian Reichel <sre@kernel.org>,
        Sakari Ailus <sakari.ailus@iki.fi>, pali.rohar@gmail.com,
        linux-media@vger.kernel.org, galak@codeaurora.org,
        mchehab@osg.samsung.com, linux-kernel@vger.kernel.org
From: Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>
Message-ID: <5179d038-4a8a-610b-f5f4-0190d4c1dbad@gmail.com>
Date: Fri, 23 Dec 2016 20:53:44 +0200
MIME-Version: 1.0
In-Reply-To: <20161223114237.GA5879@amd>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On 23.12.2016 13:42, Pavel Machek wrote:
> Hi!
>
>>> [...]
>>>
>>>  static int isp_subdev_notifier_bound(struct v4l2_async_notifier *async,
>>> diff --git a/drivers/media/platform/video-bus-switch.c b/drivers/media/platform/video-bus-switch.c
>>> index 1a5d944..3a2d442 100644
>>> --- a/drivers/media/platform/video-bus-switch.c
>>> +++ b/drivers/media/platform/video-bus-switch.c
>>> @@ -247,12 +247,21 @@ static int vbs_s_stream(struct v4l2_subdev *sd, int enable)
>>>  {
>>>  	struct v4l2_subdev *subdev = vbs_get_remote_subdev(sd);
>>>
>>> +	/* FIXME: we need to set the GPIO here */
>>> +
>>
>> The gpio is set when the pad is selected, so no need to do it again.
>> The gpio selection actually works with your branch (assuming its
>> based on Ivo's).
>
> Yes. I did not notice... is there actually some interface to select
> the camera from userland?
>

When you construct the pipeline, you enable the port you need in vbs, so 
the camera is selected.

I used (similar to)this by the time I played with cameras:

front:

export LD_LIBRARY_PATH=./
./media-ctl -r
./media-ctl -l '"vs6555 binner 2-0010":1 -> "video-bus-switch":2 [1]'
./media-ctl -l '"video-bus-switch":0 -> "OMAP3 ISP CCP2":0 [1]'
./media-ctl -l '"OMAP3 ISP CCP2":1 -> "OMAP3 ISP CCDC":0 [1]'
./media-ctl -l '"OMAP3 ISP CCDC":2 -> "OMAP3 ISP preview":0 [1]'
./media-ctl -l '"OMAP3 ISP preview":1 -> "OMAP3 ISP resizer":0 [1]'
./media-ctl -l '"OMAP3 ISP resizer":1 -> "OMAP3 ISP resizer output":0 [1]'
./media-ctl -V '"vs6555 pixel array 2-0010":0 [SGRBG10/648x488 
(0,0)/648x488 (0,0)/648x488]'
./media-ctl -V '"vs6555 binner 2-0010":1 [SGRBG10/648x488 (0,0)/648x488 
(0,0)/648x488]'
./media-ctl -V '"OMAP3 ISP CCP2":0 [SGRBG10 648x488]'
./media-ctl -V '"OMAP3 ISP CCP2":1 [SGRBG10 648x488]'
./media-ctl -V '"OMAP3 ISP CCDC":2 [SGRBG10 648x488]'
./media-ctl -V '"OMAP3 ISP preview":1 [UYVY 648x488]'
./media-ctl -V '"OMAP3 ISP resizer":1 [UYVY 656x488]'


mplayer -tv 
driver=v4l2:width=656:height=488:outfmt=uyvy:device=/dev/video6 -vo xv 
-vf screenshot tv://

back:

export LD_LIBRARY_PATH=./
./media-ctl -r
./media-ctl -l '"et8ek8 3-003e":0 -> "video-bus-switch":1 [1]'
./media-ctl -l '"video-bus-switch":0 -> "OMAP3 ISP CCP2":0 [1]'
./media-ctl -l '"OMAP3 ISP CCP2":1 -> "OMAP3 ISP CCDC":0 [1]'
./media-ctl -l '"OMAP3 ISP CCDC":2 -> "OMAP3 ISP preview":0 [1]'
./media-ctl -l '"OMAP3 ISP preview":1 -> "OMAP3 ISP resizer":0 [1]'
./media-ctl -l '"OMAP3 ISP resizer":1 -> "OMAP3 ISP resizer output":0 [1]'

./media-ctl -V '"et8ek8 3-003e":0 [SGRBG10 864x656]'
./media-ctl -V '"OMAP3 ISP CCP2":0 [SGRBG10 864x656]'
./media-ctl -V '"OMAP3 ISP CCP2":1 [SGRBG10 864x656]'
./media-ctl -V '"OMAP3 ISP CCDC":2 [SGRBG10 864x656]'
./media-ctl -V '"OMAP3 ISP preview":1 [UYVY 864x656]'
./media-ctl -V '"OMAP3 ISP resizer":1 [UYVY 800x480]'

mplayer -tv 
driver=v4l2:width=800:height=480:outfmt=uyvy:device=/dev/video6 -vo xv 
-vf screenshot tv://


or IOW:

./media-ctl -l '"vs6555 binner 2-0010":1 -> "video-bus-switch":2 [1]' 
switches GPIO to use front camera

and
./media-ctl -l '"video-bus-switch":0 -> "OMAP3 ISP CCP2":0 [1]'

for back camera


Ivo
