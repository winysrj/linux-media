Return-path: <mchehab@pedra>
Received: from smtp-vbr2.xs4all.nl ([194.109.24.22]:2682 "EHLO
	smtp-vbr2.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754566Ab1ESLi0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 19 May 2011 07:38:26 -0400
Message-ID: <cde8c4d7287ff0d3a1bbdd2d3ad29474.squirrel@webmail.xs4all.nl>
In-Reply-To: <D5ECB3C7A6F99444980976A8C6D896384DF11B6342@EAPEX1MAIL1.st.com>
References: <D5ECB3C7A6F99444980976A8C6D896384DF1137013@EAPEX1MAIL1.st.com>
    <201105180832.52333.hverkuil@xs4all.nl>
    <D5ECB3C7A6F99444980976A8C6D896384DF11B615E@EAPEX1MAIL1.st.com>
    <201105190855.58027.hverkuil@xs4all.nl>
    <D5ECB3C7A6F99444980976A8C6D896384DF11B6342@EAPEX1MAIL1.st.com>
Date: Thu, 19 May 2011 13:38:21 +0200
Subject: RE: Audio Video synchronization for data received from a HDMI
 receiver chip
From: "Hans Verkuil" <hverkuil@xs4all.nl>
To: "Bhupesh SHARMA" <bhupesh.sharma@st.com>
Cc: "Charlie X. Liu" <charlie@sensoray.com>,
	"laurent.pinchart@ideasonboard.com"
	<laurent.pinchart@ideasonboard.com>,
	"g.liakhovetski@gmx.de" <g.liakhovetski@gmx.de>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

>> > Hi Hans,
>> >
>> > I have another doubt regarding the framework choice for the entire
>> > system that I have, especially the video part of the system. The
>> overall
>> > system is similar to the one depicted below:
>> >
>> > HDMI data --> HDMI receiver chip --> Video Port IP on SoC --> System
>> DDR
>> >
>> > HDMI data is received from external world (from say a set-up box or
>> dvd player),
>> > which is fed to the HDMI receiver chip on-board and then parallel
>> data lines feed
>> > this data to a Video Port IP on the SoC which has a DMA master
>> interface and
>> > hence can push the data thus received directly on system DDR.
>> >
>> > Now, I can figure out that there will be two drivers required here:
>> > # HDMI receiver chip driver (which is essentially a v4l2 subdev being
>> controller via I2C)
>> > # Video Port driver (which is a v4l2 bridge driver)
>> >
>> > Is my understanding correct?
>>
>> Yes.
>
> Thanks for clarifying this.
>
>> > Are there any HDMI receiver subdev driver and video bridge driver
>> already available which I can
>> > use for reference?
>>
>> Video bridge drivers are easier: examples are in
>> drivers/media/video/s5p-fimc
>> or in drivers/media/video/davinci. Note that you should use the new
>> videobuf2
>> framework instead of the older videobuf framework. s5p-fimc is using
>> vb2 already.
>> but the vpif capture and display drivers in the davinci directory do
>> not.
>
> I quickly had a look at the s5p-fimc and davinci approaches, but I found
> that
> the video bridge drivers supported in both the Samsung and TI SoCs,
> support video post-processing operations whereas in our case the Video
> Port
> IP performs almost no additional processing and only passes the unpacked
> RBG
> raw data received from HDMI bus to system DDR via a DMA master interface.

This is similar to the davinci vpif-capture/vpif-display drivers for the
TI dm646x SoCs. Those videoports are also just a DMA engine without video
processing.

> So as such these are no format conversion operations(rgb-to-yuv or
> vice-versa),
> image resizing operations (cropping, scaling..) and image quality
> operations
> (filtering, distortion removal) available in the H/W block.
>
> What should be the correct choice in such a case?

vpif-capture/display drivers are identical in that respect.

Regards,

       Hans

