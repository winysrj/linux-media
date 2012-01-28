Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:55793 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751477Ab2A1RCb (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 28 Jan 2012 12:02:31 -0500
Received: by mail-ee0-f46.google.com with SMTP id c14so921320eek.19
        for <linux-media@vger.kernel.org>; Sat, 28 Jan 2012 09:02:31 -0800 (PST)
Message-ID: <4F242A07.5020602@gmail.com>
Date: Sat, 28 Jan 2012 18:01:59 +0100
From: Sylwester Nawrocki <snjw23@gmail.com>
MIME-Version: 1.0
To: Sakari Ailus <sakari.ailus@iki.fi>
CC: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	"HeungJun, Kim" <riverful.kim@samsung.com>,
	linux-media@vger.kernel.org, mchehab@redhat.com,
	hverkuil@xs4all.nl, s.nawrocki@samsung.com,
	kyungmin.park@samsung.com
Subject: Re: [RFC PATCH 0/4] Add some new camera controls
References: <1325053428-2626-1-git-send-email-riverful.kim@samsung.com> <201112281501.25091.laurent.pinchart@ideasonboard.com> <4EFD9E10.1050407@gmail.com> <20120104210708.GK9323@valkosipuli.localdomain>
In-Reply-To: <20120104210708.GK9323@valkosipuli.localdomain>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi everybody,

On 01/04/2012 10:07 PM, Sakari Ailus wrote:
> On Fri, Dec 30, 2011 at 12:18:40PM +0100, Sylwester Nawrocki wrote:
>> Thus we would three levels of controls for camera,
>>   1) image source class (lowest possible level), dealing mostly with hardware
>>      registers;
> 
> I intended the image source class for controls which only deal with the a/d
> conversion itself. Other controls would be elsewhere.
> 
> There hasn't been a final decision on this yet, but an alternative which has
> been also discussed is just to call this a "low level" control class.
> 
>>   2) "normal" camera controls (V4L2_CID_CAMERA_CLASS) [2];
>>   3) high level camera controls (for camera software algorithms)
...
> 
>> I'm afraid a little it might be hard to distinguish if some control should
>> belong to 2) or 3), as sensors' logic complexity and advancement varies.
> 
> I can see two main use cases:
> 
> 1. V4L2 / V4L2 subdev / MC as the low level API for camera control and
> 
> 2. Regular V4L2 applications.
> 
> For most controls it's clear which of the two classes they belong to.

Have you any ideas on what the class' name could be ? I thought about 
V4L2_CTRL_CLASS_HIGH_LEVEL_CAMERA or V4L2_CTRL_CLASS_CAMERA_USER although 
I'm not too happy with any of them and it seems hard to make up some 
reasonable name, when we already have V4L2_CTRL_CLASS_CAMERA.

>> Although I can see an advantage of logically separating controls which have
>> influence on one or more other (lower level) controls. And separate control
>> class would be helpful in that.
>>
>> The candidates to such control class might be:
>>
>> * V4L2_CID_METERING_MODE,
>> * V4L2_CID_EXPOSURE_BIAS,
>> * V4L2_CID_ISO,
>> * V4L2_CID_WHITE_BALANCE_PRESET,
>> * V4L2_CID_SCENEMODE,
>> * V4L2_CID_WDR,
>> * V4L2_CID_ANTISHAKE,
> 
> The list looks good to me.

--

Thanks,
Sylwester
