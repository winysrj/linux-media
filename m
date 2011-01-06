Return-path: <mchehab@gaivota>
Received: from perceval.ideasonboard.com ([95.142.166.194]:60393 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753042Ab1AFPcs (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 6 Jan 2011 10:32:48 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Subject: [RFC] Cropping and scaling with subdev pad-level operations
Date: Thu, 6 Jan 2011 16:33:29 +0100
Cc: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201101061633.30029.laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

Hi everybody,

I ran into an issue when implementing cropping and scaling on the OMAP3 ISP 
resizer sub-device using the pad-level operations. As nobody seems to be happy 
with the V4L2 crop ioctls, I thought I would ask for comments about the subdev 
pad-level API to avoid repeating the same mistakes.

A little background information first. The OMAP3 ISP resizer has an input and 
an output pad. It receives images on its input pad, performs cropping to a 
user-configurable rectange and then scales that rectangle up or down to a 
user-configurable output size. The resulting image is output on the output 
pad.

The hardware sets various restrictions on the crop rectangle and on the output 
size, or more precisely on the relationship between them. Horizontal and 
vertical scaling ratios are independent (at least independent enough for the 
purpose of this discussion), so I'll will not comment on one of them in 
particular.

The minimum and maximum scaling ratios are roughly 1/4 and x4. A complex 
equation describes the relationship between the ratio, the cropped size and 
the output size. It involves integer arithmetics and must be fullfilled 
exactly, so not all combination of crop rectangle and output size can be 
achieved.

The driver expects the user to set the input size first. It propagates the 
input format to the output pad, resetting the crop rectangle. That behaviour 
is common to all the OMAP3 ISP modules, and I don't think much discussion is 
needed there.

The user can then configure the crop rectangle and the output size 
independently. As not all combinations are possible, configuring one of them 
can modify the other one as a side effect. This is where problems come from.

Let's assume that the input size, the crop rectangle and the output size are 
all set to 4000x4000. The user then wants to crop a 500x500 rectangle and 
scale it up to 750x750.

If the user first sets the crop rectangle to 500x500,  the 4000x4000 output 
size would result in a x8 scaling factor, not supported by the resizer. The 
driver must then either modify the requested crop rectangle or the output size 
to fullfill the hardware requirements.

If the user first sets the output size to 750x750 we end up with a similar 
problem, and the driver needs to modify one of crop rectangle or output size 
as well.

When the stream is on, the output size can't be modified as it would change 
the captured frame size. The crop rectangle and scaling ratios, on the other 
hand, can be modified to implement digital zoom. For that reason, the resizer 
driver doesn't modify the output size when the crop rectangle is set while a 
stream is running, but restricts the crop rectangle size. With the above 
example as a starting point, requesting a 500x500 crop rectangle, which would 
result in an unsupported x8 zoom, will return a 1000x1000 crop rectangle.

When the stream is off, we have two options:

- Handle crop rectangle modifications the same way as when the stream is on. 
This is cleaner, but bring one drawback. The user can't set the crop rectangle 
to 500x500 and output size to 750x750 directly. No matter whether the crop 
rectangle or output size is set first, the intermediate 500x5000/4000x4000 or 
4000x4000/750x750 combination are invalid. An extra step will be needed: the 
crop rectangle will first be set to 1000x1000, the output size will then be 
set to 750x750, and the crop rectangle will finally be set to 500x500. That 
won't make life easy for userspace applications.

- Modify the output size when the crop rectangle is set. With this option, the 
output size is automatically set to the crop rectangle size when the crop 
rectangle is changed. With the above example, setting the crop rectangle to 
500x500 will automatically set the output size to 500x500, and the user will 
then just have to set the output size to 750x750.

The second option has a major drawback as well, as there's no way for 
applications to query the minimum/maximum zoom factor. With the first option 
an application can set the desired output size, and then set a very small crop 
rectangle to retrieve the minimum allowed crop rectangle (and thus the maximum 
zoom factor). With the second option the output size will be changed when the 
crop rectangle is set, so this isn't possible anymore.

Retrieving the maximum zoom factor in the stream off state is an application 
requirement to be able to display the zoom level on a GUI (with a slider for 
instance).

The OMAP3 ISP resizer currently implements the second option, and I'll modify 
it to implement the first option. The drawback is that some crop/output 
combinations will require an extra step to be achieved. I'd like your opinion 
on this issue. Is the behaviour described in option one acceptable ? Should 
the API be extended/modified to make it simpler for applications to configure 
the various sizes in the image pipeline ? Are we all doomed and will we have 
to use a crop/scale API that nobody will ever understand ? :-)

-- 
Regards,

Laurent Pinchart
