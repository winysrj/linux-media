Return-path: <linux-media-owner@vger.kernel.org>
Received: from devils.ext.ti.com ([198.47.26.153]:34721 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932866AbZGPVCQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 16 Jul 2009 17:02:16 -0400
From: "Karicheri, Muralidharan" <m-karicheri2@ti.com>
To: Hans de Goede <hdegoede@redhat.com>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>
Date: Thu, 16 Jul 2009 16:01:53 -0500
Subject: RE: Control IOCTLs handling
Message-ID: <A69FA2915331DC488A831521EAE36FE40144F1E7F2@dlee06.ent.ti.com>
References: <A69FA2915331DC488A831521EAE36FE40144E4B70A@dlee06.ent.ti.com>
 <4A5C3FAB.8@redhat.com>
In-Reply-To: <4A5C3FAB.8@redhat.com>
Content-Language: en-US
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

<Snip>
>
>> I don't see any control IDs available for Bayer RGB color space.
>>
>> In our video hardware, there is a set of Gain values that can be applied
>to the Bayer RGB data. We can apply them individually to R, Gr, Gb or B
>color components. So I think we need to have 4 more controls defined for
>doing white balancing in the Bayer RGB color space that is applicable for
>sensors (like MT9T031) and image tuning hardware like the VPFE CCDC&  IPIPE.
>>
>> Define following new controls for these in Bayer RGB color space White
>Balance (WB) controls??
>>
>> V4L2_CID_BAYER_RED_BALANCE	integer	Bayer Red balance.
>> V4L2_CID_BAYER_BLUE_BALANCE	integer	Bayer Blue balance.
>> V4L2_CID_BAYER_GREEN_R_BALANCE	integer	Bayer Gr balance.
>> V4L2_CID_BAYER_GREEN_B_BALANCE	integer	Bayer Gb balance.
>>
>> There is also an offset value defined per color which is like adjusting
>the black level in the video image data. It is subtracted from the image
>byte.
>> What you call this ? Should we define a new control,
>V4l2_CID_BAYER_OFFSET ??
>>
>
>I can't help but wonder if we should export all these as controls. One can
>probably export about 90% of the registers of a sensor as controls,
>but then why write a driver at all, why not just give the user an
>application to set the registers himself them ?
>
I can agree that we don't expect all registers exported to user space as control. I have consulted with our internal (Texas Instruments) sensor experts. Our customers need to change the Gains mentioned above as part of the Automatic White Balance algorithm which runs in the user space. So these needs to be exported to user space either as a proprietary control or as a standard  control. These Gains have maximum, minimum and a default values and looks similar to a control function. So The idea of sending this email was to see if any other hardware has similar functionality. If so, it is worth adding it to the list of standard Control IDs. If not, it can stay as a proprietary control ID, but then we need a way to set proprietary controls.

>When it comes to controls, less is more IMHO.
>
>So the question is can't we give these registers a sensible default setting
>and leave it at that?
>
As I have said, this will not work for AWB algorithm implementation.

>And currently the answer to that is yes, there currently are 2 ways to do
>whitebalance for sensors
>under Linux:
>1) The sensor does it in hardware (using per color gains like above)

Why not let VPFE image processing modules to do this as well ?

>2) libv4l does whitebalancing in software, in this case case a software
>gain is used as we can
>    control that very precisely and libv4l does not know the exact gain
>factor (and has no way to find
>    out) of per color gains exported through controls, so we just apply a
>software per color gain,
>    which we can control exactly.
>
In my opinion, both hardware and software options should be available to application so that it can choose one over other. 

>So currently the best thing todo is, either:
>a) make the sensor do hardware whitebalance if it can (much prefered), or:
Hardware here also should refers to image processing hardware like VPFE. So this calls for adding these control IDs to list of available control IDs. This are required for CCDC as well as IPIPE hardware modules in VPFE to do TI AWB algorithm.

>b) set all the per color gains in their default / middle position and
>handle
>    the whitebalancing fully in software.
>
Our customers would like to use VPFE based AWB algorithm that needs to set Gains in VPFE as well as sensors. So this is a NACK for our hardware.

>This applies even more to the per color offset's, I really see little use
>in exporting this to the
>end-user.
>
>You should look at controls as knobs the end user may want to tweak, if it
>is not something the end-user
>could want to / should tweak it should not be a control.
>
>Regards,
>
>Hans

