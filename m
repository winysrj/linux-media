Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:55159 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754761Ab1JAJoL (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 1 Oct 2011 05:44:11 -0400
Received: by bkbzt4 with SMTP id zt4so2722817bkb.19
        for <linux-media@vger.kernel.org>; Sat, 01 Oct 2011 02:44:09 -0700 (PDT)
Message-ID: <4E86E0E5.5090803@gmail.com>
Date: Sat, 01 Oct 2011 11:44:05 +0200
From: Sylwester Nawrocki <snjw23@gmail.com>
MIME-Version: 1.0
To: Sakari Ailus <sakari.ailus@iki.fi>
CC: Sylwester Nawrocki <s.nawrocki@samsung.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: [GIT PATCHES FOR 3.2] S5K6AAFX sensor driver and a videobuf2
 update
References: <4E85EA07.7060606@samsung.com> <20110930211608.GI6180@valkosipuli.localdomain>
In-Reply-To: <20110930211608.GI6180@valkosipuli.localdomain>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

On 09/30/2011 11:16 PM, Sakari Ailus wrote:
> Hi Sylwester,
> 
> On Fri, Sep 30, 2011 at 06:10:47PM +0200, Sylwester Nawrocki wrote:
>> Hi Mauro,
>>
>> please pull from
>>    git://git.infradead.org/users/kmpark/linux-2.6-samsung s5k6aafx
>>
>> for S5K6AAFX sensor subdev driver, a videbuf2 enhancement for non-MMU systems
>> and minor s5p-mfc amendment changing the firmware name to something more
>> generic as the driver supports multiple SoC versions.
>>
>>
>> The following changes since commit 446b792c6bd87de4565ba200b75a708b4c575a06:
>>
>>    [media] media: DocBook: Fix trivial typo in Sub-device Interface (2011-09-27
>> 09:14:58 -0300)
>>
>> are available in the git repository at:
>>    git://git.infradead.org/users/kmpark/linux-2.6-samsung s5k6aafx
>>
>> Sachin Kamat (1):
>>        MFC: Change MFC firmware binary name
>>
>> Scott Jiang (1):
>>        vb2: add vb2_get_unmapped_area in vb2 core
>>
>> Sylwester Nawrocki (2):
>>        v4l: Add AUTO option for the V4L2_CID_POWER_LINE_FREQUENCY control
>>        v4l: Add v4l2 subdev driver for S5K6AAFX sensor
> 
> I'd like to ask you what's your intention regarding the preset functionality
> in this driver? My understanding it it isn't provided to user space
> currently, nor we have such drivers currently (that I know of).

The user configuration register sets present in the device are separated by 
the driver from user space. So there is no such thing like user-space preset
functionality coming with this driver. I think it's pretty clear from the code.
Also please see my response to the previous e-mail (v2 thread).
If there is anything that should be fixed in this driver I'd like Mauro to
decide about this.

Cheers, S.
