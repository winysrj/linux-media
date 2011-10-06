Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:40938 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756876Ab1JFUIj (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 6 Oct 2011 16:08:39 -0400
Received: by eyg7 with SMTP id 7so404024eyg.19
        for <linux-media@vger.kernel.org>; Thu, 06 Oct 2011 13:08:38 -0700 (PDT)
Message-ID: <4E8E0AB5.9020309@gmail.com>
Date: Thu, 06 Oct 2011 22:08:21 +0200
From: Sylwester Nawrocki <snjw23@gmail.com>
MIME-Version: 1.0
To: Sakari Ailus <sakari.ailus@iki.fi>
CC: Sylwester Nawrocki <s.nawrocki@samsung.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: [GIT PATCHES FOR 3.2] S5K6AAFX sensor driver and a videobuf2
 update
References: <4E85EA07.7060606@samsung.com> <20110930211608.GI6180@valkosipuli.localdomain> <4E86E0E5.5090803@gmail.com> <20111002073629.GK6180@valkosipuli.localdomain>
In-Reply-To: <20111002073629.GK6180@valkosipuli.localdomain>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

On 10/02/2011 09:36 AM, Sakari Ailus wrote:
> On Sat, Oct 01, 2011 at 11:44:05AM +0200, Sylwester Nawrocki wrote:
>> On 09/30/2011 11:16 PM, Sakari Ailus wrote:
>>> On Fri, Sep 30, 2011 at 06:10:47PM +0200, Sylwester Nawrocki wrote:
>>>> Hi Mauro,
>>>>
>>>> please pull from
>>>>     git://git.infradead.org/users/kmpark/linux-2.6-samsung s5k6aafx
>>>>
>>>> for S5K6AAFX sensor subdev driver, a videbuf2 enhancement for non-MMU systems
>>>> and minor s5p-mfc amendment changing the firmware name to something more
>>>> generic as the driver supports multiple SoC versions.
>>>>
>>>>
>>>> The following changes since commit 446b792c6bd87de4565ba200b75a708b4c575a06:
>>>>
>>>>     [media] media: DocBook: Fix trivial typo in Sub-device Interface (2011-09-27
>>>> 09:14:58 -0300)
>>>>
>>>> are available in the git repository at:
>>>>     git://git.infradead.org/users/kmpark/linux-2.6-samsung s5k6aafx
>>>>
>>>> Sachin Kamat (1):
>>>>         MFC: Change MFC firmware binary name
>>>>
>>>> Scott Jiang (1):
>>>>         vb2: add vb2_get_unmapped_area in vb2 core
>>>>
>>>> Sylwester Nawrocki (2):
>>>>         v4l: Add AUTO option for the V4L2_CID_POWER_LINE_FREQUENCY control
>>>>         v4l: Add v4l2 subdev driver for S5K6AAFX sensor
>>>
>>> I'd like to ask you what's your intention regarding the preset functionality
>>> in this driver? My understanding it it isn't provided to user space
>>> currently, nor we have such drivers currently (that I know of).
>>
>> The user configuration register sets present in the device are separated by
>> the driver from user space. So there is no such thing like user-space preset
>> functionality coming with this driver. I think it's pretty clear from the code.
>> Also please see my response to the previous e-mail (v2 thread).
>> If there is anything that should be fixed in this driver I'd like Mauro to
>> decide about this.
> 
> Agreed; the preset functionality isn't shown to the user space. The sensor
> implements it and in my understanding some sensor features (not implemented
> in the driver) like flash strobe timing requires it.

Yes, that's exactly right.

> 
> We should discuss at some point how to best support sensors like this, but I
> don't think it has to be now.
> 
> I see no reason why this patch (v4l: Add v4l2 subdev driver for S5K6AAFX
> sensor) shouldn't go in right now.

Thanks.


Sylwester
