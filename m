Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga07.intel.com ([134.134.136.100]:59830 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750928AbeAUWtB (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sun, 21 Jan 2018 17:49:01 -0500
Date: Mon, 22 Jan 2018 00:48:58 +0200
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        andriy.shevchenko@linux.intel.com, alan@linux.intel.com
Subject: Re: atomisp and g/s_parm
Message-ID: <20180121224858.bmf32prgkqh5yht7@kekkonen.localdomain>
References: <fdb4a3df-e7fa-9197-a64a-02be81b548bd@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fdb4a3df-e7fa-9197-a64a-02be81b548bd@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On Sun, Jan 21, 2018 at 11:46:46AM +0100, Hans Verkuil wrote:
> Hi Sakari,
> 
> I looked a bit closer at how atomisp uses g/s_parm. They abuse the capturemode field
> to select video/preview/still modes on the sensor, which actually changes the list
> of supported resolutions.
> 
> The following files use this:
> 
> i2c/atomisp-gc0310.c
> i2c/atomisp-gc2235.c
> i2c/atomisp-ov2680.c
> i2c/atomisp-ov2722.c
> i2c/ov5693/atomisp-ov5693.c
> pci/atomisp2/atomisp_file.c
> pci/atomisp2/atomisp_tpg.c
> 
> The last two have a dummy g/s_parm implementation, so are easy to fix.
> The gc0310 and 0v2680 have identical resolution lists for all three modes, so
> the capturemode can just be ignored and these two drivers can be simplified.
> 
> Looking at the higher level code it turns out that this atomisp driver appears
> to be in the middle of a conversion from using s_parm to a V4L2_CID_RUN_MODE
> control. If the control is present, then that will be used to set the mode,
> otherwise it falls back to s_parm.
> 
> So the best solution would be if Intel can convert the remaining drivers from
> using s_parm to the new control and then drop all code that uses s_parm to do
> this, so g/s_parm is then only used to get/set the framerate.
> 
> Is this something you or a colleague can take on?

I've stabbed the atomisp sensor drivers enough to remove the s_parm and
g_parm usage there. This effectively removes the s_parm abuse, as there was
nothing else it was being used for.

The patches are here; there are no changes to your patches in the branch
you pointed me to:

<URL:https://git.linuxtv.org/sailus/media_tree.git/log/?h=sparm>

I've split dropping support for certain modes in the drivers into separate
patch; it's easy to bring them back by just reverting the patch ("staging:
atomisp: i2c: Disable non-preview configurations") or removing the ifdefs.
I don't object merging this with the previous patch either.

What comes to the run mode control --- this logic should have always
resided in user space; that control (and s_parm hack) is basically getting
around lack of support for MC / V4L2 sub-device interface in the driver. So
that control isn't the right solution either going forward.

Cc Andy and Alan.

-- 
Regards,

Sakari Ailus
sakari.ailus@linux.intel.com
