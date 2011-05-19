Return-path: <mchehab@pedra>
Received: from mail-ww0-f42.google.com ([74.125.82.42]:50335 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932671Ab1ESOWr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 19 May 2011 10:22:47 -0400
Received: by wwk4 with SMTP id 4so5695845wwk.1
        for <linux-media@vger.kernel.org>; Thu, 19 May 2011 07:22:45 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <201105191414.44721.laurent.pinchart@ideasonboard.com>
References: <4DD4F3CA.3040300@maxwell.research.nokia.com>
	<201105191414.44721.laurent.pinchart@ideasonboard.com>
Date: Thu, 19 May 2011 17:22:45 +0300
Message-ID: <BANLkTikVY_O-y5Vj3F6LSzC6rphcCobwng@mail.gmail.com>
Subject: Re: [PATCH 0/3] V4L2 API for flash devices and the adp1653 flash
 controller driver
From: David Cohen <dacohen@gmail.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	Nayden Kanchev <nkanchev@mm-sol.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Kim HeungJun <riverful@gmail.com>, andrew.b.adams@gmail.com,
	Sung Hee Park <shpark7@stanford.edu>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Laurent,

On Thu, May 19, 2011 at 3:14 PM, Laurent Pinchart
<laurent.pinchart@ideasonboard.com> wrote:
> Hi Sakari,
>
> On Thursday 19 May 2011 12:41:14 Sakari Ailus wrote:
>> Hi,
>>
>> This patchset implements RFC v4 of V4L2 API for flash devices [1], with
>> minor modifications, and adds the adp1653 flash controller driver.
>
> As already answered in private:
>
> Acked-by: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>

Sorry if I missed something, but shouldn't be your ack here? :)
The patches are from Sakari already.

Br,

David

>
>> This patchset depends on the bitmask controls patch [4].
>>
>> Changes since v2 [3] of the RFC patchset:
>>
>> - Improved flash control documentation in general.
>>
>> - Faults may change the LED mode to none. This is now documented.
>>
>> - adp1653 is returned to sane after faults are detected.
>>
>> - Proper error handling for adp1653_get_fault() in adp1653_strobe().
>>
>> - Remove useless function: adp1653_registered() and the corresponding
>>   callback. Controls are now initialised in adp1653_probe().
>>
>> - Improved fault handling in adp1653_init_device().
>>
>> Changes since v1 [2] of the RFC patchset:
>>
>> - Faults on the flash LED are allowed to make the LED unusable before
>> the faults are read. This is implemented in the adp1653 driver.
>>
>> - Intensities are using standard units; mA for flash / torch and uA for
>> the indicator.
>>
>>
>> Thanks to those who have given their feedback so far in the process!
>>
>>
>> [1] http://www.spinics.net/lists/linux-media/msg32030.html
>>
>> [2] http://www.spinics.net/lists/linux-media/msg32396.html
>>
>> [3] http://www.spinics.net/lists/linux-media/msg32436.html
>>
>> [4] http://www.spinics.net/lists/linux-media/msg31001.html
>
> --
> Regards,
>
> Laurent Pinchart
>
