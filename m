Return-path: <mchehab@pedra>
Received: from smtp-roam1.Stanford.EDU ([171.67.219.88]:34688 "EHLO
	smtp-roam.stanford.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754588Ab0JNGMo (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 14 Oct 2010 02:12:44 -0400
Received: from smtp-roam.stanford.edu (localhost.localdomain [127.0.0.1])
	by localhost (Postfix) with SMTP id 195FF37D5F
	for <linux-media@vger.kernel.org>; Wed, 13 Oct 2010 23:12:44 -0700 (PDT)
Received: from [192.168.1.102] (adsl-69-107-76-187.dsl.pltn13.pacbell.net [69.107.76.187])
	(using TLSv1 with cipher AES256-SHA (256/256 bits))
	(No client certificate requested)
	(Authenticated sender: talvala)
	by smtp-roam.stanford.edu (Postfix) with ESMTPSA id 4CA5237D5E
	for <linux-media@vger.kernel.org>; Wed, 13 Oct 2010 23:12:43 -0700 (PDT)
Message-ID: <4CB69F54.7080707@stanford.edu>
Date: Wed, 13 Oct 2010 23:12:36 -0700
From: Eino-Ville Talvala <talvala@stanford.edu>
MIME-Version: 1.0
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: The FCam camera control API
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi all,

I wanted to talk a bit more about our project here at Stanford, because 
I thought several people on this list might be interested in it 
(although I know several of you may already have heard about it).

The short version:
We released a high-level camera control API for the Nokia N900 a few 
months ago, which allows for precise frame-level control of the sensor 
and associated devices while running at full sensor frame rate. Instead 
of treating the imaging pipeline as a box with control knobs on it that 
sends out a flow of images, it's instead a box that transforms image 
requests into images, with the requests encapsulating all sensor 
configuration (including resolution and frame duration) inside them. 
This makes it very easy to write applications such as an HDR viewfinder, 
which needs to alternate sensor exposure time every frame.  We've 
released a sample application for the N900 with features such as full 
manual camera control, HDR viewfinding/metering, best-of-8 burst mode, 
and saving raw sensor data as DNGs.  Our co-authors at Nokia have also 
released an HDR app that does on-device HDR fusion and a low-light 
photography app that improves image quality for dark scenes.

The home page is here:
http://fcam.garage.maemo.org

The long version:
Over the last two years or so, the research group I'm part of has been 
working on building our own fully open digital camera platform, aimed at 
researchers and hobbyists working in computational photography.  That 
covers more mundane things like HDR photography or panorama capture, and 
more out-there things like handshake removal, post-capture refocusable 
images, and so on.  This has all been in collaboration with Nokia 
Research Center Palo Alto.

After poking around with existing hardware and APIs, we found all of 
them to have various limitations from our point of view - there are very 
few open camera hardware platforms out there, and even if they were, 
most camera control APIs are not well-suited for computational photography.

Most of the details can be found in our SIGGRAPH 2010 paper, here:
http://graphics.stanford.edu/papers/fcam/

So, we built our own user-space C++ API on top of V4L2, which runs on 
both the N900 and our home-built F2 Frankencamera (both use the OMAP3).  
We call it FCam.


What does it do that V4L2 doesn't?

1) Imaging system configuration is done on a per-frame basis - every 
frame output from the system can have a different set of parameters, 
deterministically.  This is done by moved sensor/imaging pipeline state 
out of the device, and into requests that are fed to the device. One 
image is produced for every request fed into the system, and multiple 
requests can be in flight at once.  The only blocking call is the one to 
pop a completed Frame from the input queue.

2) Metadata (the original request, statistics unit output, state of 
other associated devices like the lens) and the image data is all tied 
together into a single packaged Frame that's handed back to the user. 
This makes it trivial to determine what sensor settings were used to 
capture the image data, so that one can easily write a metering or 
autofocus routine, for example.

3) Other devices can be synchronized with sensor operation - for 
example, the flash can be set to fire N ms into the exposure for a 
request. The application doesn't have to do the synchronization work itself.

Where did we have problems with V4L2?

Mostly everything was fine, but we ran into some problems that are due 
to V4L2's design as a video streaming API:
1) Fixed resolution
2) Fixed frame rate
We want to swap between viewfinder and full resolution frames as fast as 
possible (and in the future, between arbitrary resolutions or regions of 
interest), and if we're capturing an HDR burst, say, we don't want the 
frame rate to be constrained by the longest required exposure.

Our current implementation works around #2 by adding a custom V4L2 
control to change frame duration while streaming - this is clearly 
against the spirit of the V4L2 API, but is essential for our system to 
work well.  I'd be interested in knowing if there's a better way to deal 
with this than circumventing the API's promises.

#1 we couldn't do anything about, so if a request has a different 
resolution/pixel format than the previous request, the runtime has to 
simply stop V4L2 streaming, reconfigure, and start streaming again.  I 
don't see this part of V4L2 changing in the future, but hopefully the 
switching time will be reduced as implementations improve (with the 
shipping N900 OMA3 ISP driver, this takes about 700 ms).

We're now working on a F3 Frankencamera with a large (24x24 mm) sensor, 
using the Cypress LUPA-4000 image sensor (The F2 uses the Aptina MT9P031 
cell phone sensor).  We have an NSF grant to distribute N900s and F2 or 
F3 Frankencameras to reseachers and classes in the US, to run courses in 
computational photography and to provide reseachers with a platform to 
experiment with.

We think we've come up with something that works better than typical 
application-level still camera APIs, both for writing regular camera 
applications, and for the more crazy experimental stuff we're interested 
in.  So we're hoping developers and manufacturers take a look at what 
we've done, and perhaps the capabilities we'd love to have will become 
commonplace.

Regards,

Eino-Ville (Eddy) Talvala
Camera 2.0 Project, Computer Graphics Lab
Stanford University


