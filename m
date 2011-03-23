Return-path: <mchehab@pedra>
Received: from smtpauth03.prod.mesa1.secureserver.net ([64.202.165.183]:44462
	"HELO smtpauth03.prod.mesa1.secureserver.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751066Ab1CWGaO (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 23 Mar 2011 02:30:14 -0400
Subject: Re: soc-camera layer2 driver
Mime-Version: 1.0 (Apple Message framework v1082)
Content-Type: text/plain; charset=us-ascii
From: Gilles <gilles@gigadevices.com>
In-Reply-To: <201103221148.17804.laurent.pinchart@ideasonboard.com>
Date: Tue, 22 Mar 2011 23:30:11 -0700
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	linux-media@vger.kernel.org
Content-Transfer-Encoding: 7bit
Message-Id: <E4F4A76D-2DA4-4C88-9DFF-C4723E41D8D8@gigadevices.com>
References: <092708F1-CB5B-420A-B675-EED63B7E68A7@gigadevices.com> <4898622A-5298-4E4D-BAB0-D1C71B7C2845@gigadevices.com> <Pine.LNX.4.64.1103221021450.29576@axis700.grange> <201103221148.17804.laurent.pinchart@ideasonboard.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Laurent,

>> the videobuf2-dma-contig allocator), look at sh_mobile_ceu for an advanced
>> example, or at one of mx3_camera, mx2_camera, mx1_camera for simpler ones.
>> omap1_camera is also trying to support both sg and contig... If you have
>> questions, don't hesitate to ask on the ML, also cc me and / or the
>> respective driver author. Maybe you end up writing some such howto too;)

Thank you for your help and pointers. I will definitely consider the
howto when I feel like I understand what I'm doing. I guess what
worries me is that there are many options I will not get to
exercice (because I may not need them in my case) so my howto would be
incomplete. But I'll be glad to write what I've learned.


>> I'm not aware about any 3d efforts in v4l2... I would've thought, that one
>> would want to synchronize frames at the driver level, the application
>> level is too indeterministic. So, you would need to add an API to retrieve
>> pairs of frames, I presume, one of which is marked left, other right. This
>> frame-pair handling is one addition to the generic V4L2 API. You'll also
>> need a way to open / associate two sensors with one v4l2 device node.
>> Then, how you assemble two different frames from two sensors in one
>> stereo-frame is up to your driver, I presume.

No questions about it. Both cameras should definitely be handled by the
same driver. The application should be able to select whether it wants to
capture frame-alternative or side-by-side and the driver would package
accordingly.

At this point, I have a hardware issue because I hooked up both cameras
to the same reset and same pixel clock but the HSync signals are not in
sync so it's relatively impossible for me (even at the driver level) to
control when a frame is captured. I think it has to do with I2C commands
changing the timing. This is outside of the scope of this thread but it
would be interesting to discuss how 3D would be added to V4L.

Anyway, Thank you for your help, I have some things to look at.

Thanks,
Gilles
.

