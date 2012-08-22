Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr11.xs4all.nl ([194.109.24.31]:3191 "EHLO
	smtp-vbr11.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753814Ab2HVKLv (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 22 Aug 2012 06:11:51 -0400
Received: from alastor.dyndns.org (166.80-203-20.nextgentel.com [80.203.20.166] (may be forged))
	(authenticated bits=0)
	by smtp-vbr11.xs4all.nl (8.13.8/8.13.8) with ESMTP id q7MABmKM087410
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=FAIL)
	for <linux-media@vger.kernel.org>; Wed, 22 Aug 2012 12:11:50 +0200 (CEST)
	(envelope-from hverkuil@xs4all.nl)
Received: from tschai.localnet (tschai.lan [192.168.1.10])
	(Authenticated sender: hans)
	by alastor.dyndns.org (Postfix) with ESMTPSA id E243F35E0229
	for <linux-media@vger.kernel.org>; Wed, 22 Aug 2012 12:11:46 +0200 (CEST)
From: Hans Verkuil <hverkuil@xs4all.nl>
To: "linux-media" <linux-media@vger.kernel.org>
Subject: Re: RFC: Core + Radio profile
Date: Wed, 22 Aug 2012 12:11:47 +0200
References: <201208221140.25656.hverkuil@xs4all.nl>
In-Reply-To: <201208221140.25656.hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201208221211.47842.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I've added some more core profile requirements.

Regards,

	Hans

On Wed August 22 2012 11:40:25 Hans Verkuil wrote:
> Hi all!
> 
> The v4l2-compliance utility checks whether device drivers follows the V4L2
> specification. What is missing are 'profiles' detailing what device drivers
> should and shouldn't implement for particular device classes.
> 
> This has been discussed several times, but until now no attempt was made to
> actually write this down.
> 
> This RFC is my attempt to start this process by describing three profiles:
> the core profile that all drivers must adhere to, a profile for a radio
> receiver and a profile for a radio transmitter.
> 
> Missing in this RFC is a description of how tuner ownership is handled if a
> tuner is shared between a radio and video driver. This will be discussed
> during the workshop next week.
> 
> I am not certain where these profile descriptions should go. Should we add
> this to DocBook, or describe it in Documentation/video4linux? Or perhaps
> somehow add it to v4l2-compliance, since that tool effectively verifies
> the profile.
> 
> Also note that the core profile description is more strict than the spec. For
> example, G/S_PRIORITY are currently optional, but I feel that all new drivers
> should implement this, especially since it is very easy to add provided you
> use struct v4l2_fh. Similar with respect to the control requirements which
> assume you use the control framework.
> 
> Note that these profiles are primarily meant for driver developers. The V4L2
> specification is leading for application developers.
> 
> While writing down these profiles I noticed one thing that was very much
> missing for radio devices: there is no capability bit to tell the application
> whether there is an associated ALSA device or whether the audio goes through
> a line-in/out. Personally I think that this should be fixed.
> 
> Comments are welcome!
> 
> Regards,
> 
> 	Hans
> 
> 
> Core Profile
> ============
> 
> All V4L2 device nodes must support the core profile.
> 
> VIDIOC_QUERYCAP must be supported and must set the device_caps field.
> bus_info must be a unique string and must not be empty (pending result of
> the upcoming workshop).
> 
> VIDIOC_G/S_PRIORITY must be supported.
> 
> If you have controls then both the VIDIOC_G/S_CTRL and the VIDIOC_G/S/TRY_EXT_CTRLS
> ioctls must be supported, together with poll(), VIDIOC_DQEVENT and
> VIDIOC_(UN)SUBSCRIBE_EVENT to handle control events. Use the control framework
> to implement this.
> 
> VIDIOC_LOG_STATUS is optional, but recommended for complex drivers.
> 
> VIDIOC_DBG_G_CHIP_IDENT, VIDIOC_DBG_G/S_REGISTER are optional and are
> primarily used to debug drivers.
> 
> Video, Radio and VBI nodes are for input or output only. The only exception
> are video nodes that have the V4L2_CAP_VIDEO_M2M(_MPLANE) capability set.
> 
> Video nodes only control video, radio nodes only control radio and RDS, vbi
> nodes only control VBI (raw and/or sliced).
> 
> Streaming I/O is not supported by radio nodes.

It should be possible to open device nodes more than once. Just opening a
node and querying information from the driver should not change the state
of the driver.

The file handle that called VIDIOC_REQBUFS, VIDIOC_CREATE_BUFS, read/write
or select (for reading or writing) first is the only one that can do I/O.
Attempts by other file handles to call these ioctls/file operations will
get an EBUSY error.

This file handle remains the owner of the I/O until the file handle is
closed, or until VIDIOC_REQBUFS is called with count == 0.

> 
> Radio Receiver Profile
> ======================
> 
> Radio devices have a tuner and (usually) a demodulator. The audio is either
> send out to a line-out connector or uses ALSA to stream the audio.
> 
> It implements VIDIOC_G/S_TUNER, VIDIOC_G/S_FREQUENCY and VIDIOC_ENUM_FREQ_BANDS.
> 
> If hardware seek is supported, then VIDIOC_S_HW_FREQ_SEEK is implemented.
> 
> It does *not* implement VIDIOC_ENUM/G/S_INPUT or VIDIOC_ENUM/G/S_AUDIO.
> 
> If RDS_BLOCK_IO is supported, then read() and poll() are implemented as well.
> 
> If a mute control exists and the audio is output using a line-out, then the
> audio must be muted on driver load and unload.
> 
> On driver load the frequency must be initialized to a valid frequency.
> 
> Note: There are a few drivers that use a radio (pvrusb2) or video (ivtv)
> node to stream the audio. These are legacy exceptions to the rule.
> 
> FM Transmitter Profile
> ======================
> 
> FM transmitter devices have a transmitter and modulator. The audio is
> transferred using ALSA or a line-in connector.
> 
> It implements VIDIOC_G/S_MODULATOR, VIDIOC_G/S_FREQUENCY and VIDIOC_ENUM_FREQ_BANDS.
> 
> It does *not* implement VIDIOC_ENUM/G/S_OUTPUT or VIDIOC_ENUM/G/S_AUDOUT.
> 
> If RDS_BLOCK_IO is supported, then write() and poll() are implemented
> as well.
> 
> On driver load the frequency must be initialized to a valid frequency.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
