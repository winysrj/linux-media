Return-path: <mchehab@pedra>
Received: from perceval.ideasonboard.com ([95.142.166.194]:51221 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753131Ab1EQKvT (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 17 May 2011 06:51:19 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
Subject: Re: [PATCH 3/3] adp1653: Add driver for LED flash controller
Date: Tue, 17 May 2011 12:51:12 +0200
Cc: linux-media@vger.kernel.org, nkanchev@mm-sol.com,
	g.liakhovetski@gmx.de, hverkuil@xs4all.nl, dacohen@gmail.com,
	riverful@gmail.com, andrew.b.adams@gmail.com, shpark7@stanford.edu
References: <4DD11FEC.8050308@maxwell.research.nokia.com> <201105170923.34326.laurent.pinchart@ideasonboard.com> <4DD2523D.1020908@maxwell.research.nokia.com>
In-Reply-To: <4DD2523D.1020908@maxwell.research.nokia.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201105171251.13683.laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Sakari,

On Tuesday 17 May 2011 12:47:25 Sakari Ailus wrote:
> Laurent Pinchart wrote:
> > On Tuesday 17 May 2011 07:38:38 Sakari Ailus wrote:
> [clip]
> 
> >>> If several applications read controls, only one of them will be
> >>> notified of faults. Shouldn't clearing the fault be handled explicitly
> >>> by writing to a control ? I know this changes the API :-)
> >> 
> >> This is true.
> >> 
> >> Although I can't imagine right now why two separate processes should be
> >> so interested in the faults but it is still entirely possible that
> >> someone does that since it's permitted by the interface.
> >> 
> >> Having to write zero to faults to clear them isn't good either since it
> >> might mean missing faults that are triggered between reading and writing
> >> this control.
> >> 
> >> Perhaps this would make sense as a file handle specific control?
> > 
> > Good question. Control events will help I guess, maybe that's the
> > solution.
> 
> They would help, yes, but in the case of N900 we don't have that luxury
> since there's no interrupt line from the adp1653 to OMAP. So if one user
> would read the control, the others would get notified. Yes, that would
> work, too.
> 
> The use case is mostly theoretical and that's actually best the hardware
> can offer, so I think this is good. No special arrangements needed then.
> 
> So reading the value will reset the faults?

OK, let's leave it that way, at least for now.

> >> The control documentation says that the faults are cleared when the
> >> register is read, but the adp1653 also clears the faults whenever
> >> writing zero to out_sel which happens also in other circumstances, for
> >> example when changing mode from flash to torch when the torch intensity
> >> is zero, or when indicator intensity is zero in other modes.
> >> 
> >>>> +	/* Restore configuration. */
> >>>> +	rval = adp1653_update_hw(flash);
> >>>> +	if (IS_ERR_VALUE(rval))
> >>>> +		return rval;
> >>> 
> >>> Will that produce expected results ? For instance, if a fault was
> >>> detected during flash strobe, won't it try to re-strobe the flash ?
> >>> Shouldn't the user
> >> 
> >> No. Flash is strobed using adp1653_strobe().
> >> 
> >>> be required to explicitly re-strobe the flash or turn the torch (or
> >>> indicator) on after a fault ? Once again this should be clarified in
> >>> the API :-)
> >> 
> >> The mode won't be changed from the flash but to strobe again, the user
> >> has to push V4L2_CID_FLASH_STROBE again.
> >> 
> >> The adp1653 doesn't have any torch (as such) or indicator faults; some
> >> other chips do have indicator faults at least. Using the torch mode
> >> might trigger faults, too, since it's the same LED; just the power isn't
> >> that high.
> > 
> > When an over-current fault is detected, shouldn't the mode be set back to
> > none ? If we just clear the fault and reprogram the registers, the torch
> > will be turned back on, and the fault will likely happen again.
> 
> That's a good point.
> 
> Over-temperature, over-voltage, and short circuit faults should change the
> LED mode to be set to none. This is likely chip independent behaviour but on
> the other hand, not all the chips implement all the faults.

If the chip doesn't implement faults handling there little we can do. For 
chips that do implement faults handling, let's switch the LED mode to none 
when a fault is detected.

-- 
Regards,

Laurent Pinchart
