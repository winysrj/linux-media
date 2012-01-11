Return-path: <linux-media-owner@vger.kernel.org>
Received: from eu1sys200aog114.obsmtp.com ([207.126.144.137]:53532 "EHLO
	eu1sys200aog114.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753324Ab2AKL0j convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 11 Jan 2012 06:26:39 -0500
From: Bhupesh SHARMA <bhupesh.sharma@st.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	Bhupesh SHARMA <bhupesh.sharma@st.com>
Date: Wed, 11 Jan 2012 19:26:20 +0800
Subject: Purpose of .init and .release methods in soc_camera framework
Message-ID: <D5ECB3C7A6F99444980976A8C6D896384ECE79A86C@EAPEX1MAIL1.st.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Guennadi,

I was reading the latest soc_camera framework documentation (see [1]).
I can see on line 71 to 73 the following text:

" .add and .remove methods are called when a sensor is attached to or detached
 from the host, apart from performing host-internal tasks they shall also call
 sensor driver's .init and .release methods respectively."

Now, I was puzzled on seeing that none of the soc_camera bridge drivers (
like PXA and SH Mobile) call the sensor's .init and .release from their
.add and .remove methods respectively.

Also I cannot trace these calls in soc_camera.c layer

Actually, I am working on a camera sensor that requires certain
patches to be written to it before it can start working:

- Now, if I write these patches in the _probe_ of the sensor driver (similar 
to the ST VS6624 driver here : [2]), my sensor can work well for the 1st run
of the user-space application. But, if I launch the application again the patches
need to be written to the sensor again as I have implemented an 'icl->power' routine
which basically turns ON and OFF the sensor by toggling its CE (chip enable pin).

- As the soc_camera layer provides no explicit call to the camera sensor driver
when an _open_ is invoked from the userland, when and how should I write the
patch registers.

I can only think of using the .init routine to initialize the sensor patch registers
in such a case.

Please share your views on the same.

[1] http://lxr.free-electrons.com/source/Documentation/video4linux/soc-camera.txt
[2] http://www.spinics.net/lists/linux-media/msg37805.html


Regards,
Bhupesh

