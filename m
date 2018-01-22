Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud7.xs4all.net ([194.109.24.28]:45973 "EHLO
        lb2-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751204AbeAVJTP (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 22 Jan 2018 04:19:15 -0500
Subject: Re: atomisp and g/s_parm
To: Sakari Ailus <sakari.ailus@linux.intel.com>
References: <fdb4a3df-e7fa-9197-a64a-02be81b548bd@xs4all.nl>
 <20180121224858.bmf32prgkqh5yht7@kekkonen.localdomain>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        andriy.shevchenko@linux.intel.com, alan@linux.intel.com
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <5b344cd1-3bb5-290d-b07b-15ddbd6ef7c5@xs4all.nl>
Date: Mon, 22 Jan 2018 10:19:13 +0100
MIME-Version: 1.0
In-Reply-To: <20180121224858.bmf32prgkqh5yht7@kekkonen.localdomain>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 21/01/18 23:48, Sakari Ailus wrote:
> Hi Hans,
> 
> On Sun, Jan 21, 2018 at 11:46:46AM +0100, Hans Verkuil wrote:
>> Hi Sakari,
>>
>> I looked a bit closer at how atomisp uses g/s_parm. They abuse the capturemode field
>> to select video/preview/still modes on the sensor, which actually changes the list
>> of supported resolutions.
>>
>> The following files use this:
>>
>> i2c/atomisp-gc0310.c
>> i2c/atomisp-gc2235.c
>> i2c/atomisp-ov2680.c
>> i2c/atomisp-ov2722.c
>> i2c/ov5693/atomisp-ov5693.c
>> pci/atomisp2/atomisp_file.c
>> pci/atomisp2/atomisp_tpg.c
>>
>> The last two have a dummy g/s_parm implementation, so are easy to fix.
>> The gc0310 and 0v2680 have identical resolution lists for all three modes, so
>> the capturemode can just be ignored and these two drivers can be simplified.
>>
>> Looking at the higher level code it turns out that this atomisp driver appears
>> to be in the middle of a conversion from using s_parm to a V4L2_CID_RUN_MODE
>> control. If the control is present, then that will be used to set the mode,
>> otherwise it falls back to s_parm.
>>
>> So the best solution would be if Intel can convert the remaining drivers from
>> using s_parm to the new control and then drop all code that uses s_parm to do
>> this, so g/s_parm is then only used to get/set the framerate.
>>
>> Is this something you or a colleague can take on?
> 
> I've stabbed the atomisp sensor drivers enough to remove the s_parm and
> g_parm usage there. This effectively removes the s_parm abuse, as there was
> nothing else it was being used for.
> 
> The patches are here; there are no changes to your patches in the branch
> you pointed me to:
> 
> <URL:https://git.linuxtv.org/sailus/media_tree.git/log/?h=sparm>
> 
> I've split dropping support for certain modes in the drivers into separate
> patch; it's easy to bring them back by just reverting the patch ("staging:
> atomisp: i2c: Disable non-preview configurations") or removing the ifdefs.
> I don't object merging this with the previous patch either.
> 
> What comes to the run mode control --- this logic should have always
> resided in user space; that control (and s_parm hack) is basically getting
> around lack of support for MC / V4L2 sub-device interface in the driver. So
> that control isn't the right solution either going forward.
> 
> Cc Andy and Alan.
> 

Looks good. Just one note: in atomisp_ioctl.c the atomisp_g_parm function still
abuses this API (setting capturemode) but more importantly, it never calls
g_frame_interval. The atomisp_s_parm function *does* call s_frame_interval.

So this is inconsistent. However, this was always there, so it's not something
that was introduced by these changes.

Regards,

	Hans
