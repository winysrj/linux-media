Return-path: <linux-media-owner@vger.kernel.org>
Received: from eu1sys200aog119.obsmtp.com ([207.126.144.147]:40787 "EHLO
	eu1sys200aog119.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756025Ab1IBJiK convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 2 Sep 2011 05:38:10 -0400
Received: from zeta.dmz-eu.st.com (zeta.dmz-eu.st.com [164.129.230.9])
	by beta.dmz-eu.st.com (STMicroelectronics) with ESMTP id 0AF48111
	for <linux-media@vger.kernel.org>; Fri,  2 Sep 2011 09:38:08 +0000 (GMT)
Received: from Webmail-eu.st.com (safex1hubcas4.st.com [10.75.90.69])
	by zeta.dmz-eu.st.com (STMicroelectronics) with ESMTP id B7E861A6C
	for <linux-media@vger.kernel.org>; Fri,  2 Sep 2011 09:38:08 +0000 (GMT)
From: Alain VOLMAT <alain.volmat@st.com>
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Date: Fri, 2 Sep 2011 11:38:06 +0200
Subject: Questions regarding Devices/Subdevices/MediaController usage in
 case of a SoC
Message-ID: <E27519AE45311C49887BE8C438E68FAA0100DBB53E71@SAFEX1MAIL1.st.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

I'm writing you in order to have some advices in the design of the V4L2 driver for a rather complex device. It is mainly related to device/subdev/media controller.

This driver would target SoCs which usually handle inputs (capture devices, for ex LinuxDVB, HDMI capture), several layers of graphical or video planes and outputs such as HDMI/analog. 
Basically we have 3 levels, capture devices data being pushed onto planes and planes being mixed on outputs. Moreover it is also possible to input or output datas from several points of the device.

The idea is to take advantage of the new MediaController in order to be able to define internal data path by linking capture devices to layers and layers to outputs.
Since MediaController allows to link pads of entities together, our understanding is that we need to have 1 subdevice per hardware resource. That is if we have 2 planes, we will have 2 subdevices handling them. Same for outputs and capture.
Is our understanding correct ?

A second point is now about the number of devices. I think we have 2 ways of doing that, and I would like to get your opinions about those 2 ways.
#1 Single device:
I could think of a single device which expose several inputs and outputs. We could enumerate them with VIDIOC_ENUM* and select them using VIDIOC_S_*. After the selection, data exchange could be done upon specifying a proper buffer type. The merit of such model is that an application using such device would only have to access the single available /dev/video0 for everything, without having to know if video0 is for capture, video1 output and so on.

#2 Multiple device:
In such case, each video device would only provide a single (or small amount of similar) input or output. So several video device nodes would be available to the application.
Looking at some other drivers around such as the OMAP4 ISP or Samsung S5P, it seems to be the preferred way to go, is that correct ? This way also fit more in the V4L2 model of device type (Video capture device, video output device) since way #1 would at last create a single big device which implement a mix of all those devices.

As far as the media controller is concerned, since all those resources are not sharable, it seems proper to have only a single media entry point in order to setup the SoC and internal data path (and not abstract media to match their video device counterpart)

It would be very helpful if you could advice me about the preferred design, based on your experience, existing drivers and existing applications ?

Best regards,

Alain Volmat
