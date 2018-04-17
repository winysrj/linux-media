Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:54966 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753088AbeDQN6f (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 17 Apr 2018 09:58:35 -0400
Date: Tue, 17 Apr 2018 10:58:24 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Hans Verkuil <hansverk@cisco.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Daniel Mentz <danielmentz@google.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: Re: [PATCH 4/5] media: v4l2-compat-ioctl32: fix several __user
 annotations
Message-ID: <20180417105824.6abafda9@vento.lan>
In-Reply-To: <20180417101009.71d98c63@vento.lan>
References: <cover.1523960171.git.mchehab@s-opensource.com>
        <510d0652872c612db21be8b846755f80e3cc4588.1523960171.git.mchehab@s-opensource.com>
        <a150928f-c236-4751-b704-7ce71fd56bc2@cisco.com>
        <20180417075358.61a878c8@vento.lan>
        <b3ed6478-9cf5-478d-067b-5d325dfeaadd@cisco.com>
        <20180417100131.3add7f67@vento.lan>
        <20180417101009.71d98c63@vento.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Tue, 17 Apr 2018 10:10:09 -0300
Mauro Carvalho Chehab <mchehab@s-opensource.com> escreveu:

> Em Tue, 17 Apr 2018 10:01:31 -0300
> Mauro Carvalho Chehab <mchehab@s-opensource.com> escreveu:
> 
> > > >> ->blocks is a u32, so this should be a u32 cast as well.      
> > > 
> > > Be aware that the unsigned char * cast is actually a bug: it will clamp the
> > > u32 'blocks' value to a u8.
> > > 
> > > Regards,
> > > 
> > > 	Hans  
> > 
> > What about this approach (code untested)?  
> 
> Even better:
> 
> [PATCH] media: v4l2-compat-ioctl32: simplify casts
> 
> Making the cast right for get_user/put_user is not trivial, as
> it needs to ensure that the types are the correct ones.
> 
> Improve it by using macros.
> 
> PS.: Patch untested

Tested with:

	$ sudo modprobe vivid no_error_inj=1
	$ v4l2-compliance-32bits -a -s10 >32bits && v4l2-compliance-64bits -a -s10 > 64bits && diff 32bits 64bits

32 bits version results:

v4l2-compliance SHA   : bc71e4a67c6fbc5940062843bc41e7c8679634ce

Compliance test for device /dev/video0:

Driver Info:
	Driver name      : vivid
	Card type        : vivid
	Bus info         : platform:vivid-000
	Driver version   : 4.17.0
	Capabilities     : 0x853f0df7
		Video Capture
		Video Output
		Video Overlay
		VBI Capture
		VBI Output
		Sliced VBI Capture
		Sliced VBI Output
		RDS Capture
		RDS Output
		SDR Capture
		Tuner
		HW Frequency Seek
		Modulator
		Audio
		Radio
		Read/Write
		Streaming
		Extended Pix Format
		Device Capabilities
	Device Caps      : 0x05230005
		Video Capture
		Video Overlay
		Tuner
		Audio
		Read/Write
		Streaming
		Extended Pix Format

Required ioctls:
	test VIDIOC_QUERYCAP: OK

Allow for multiple opens:
	test second /dev/video0 open: OK
	test VIDIOC_QUERYCAP: OK
	test VIDIOC_G/S_PRIORITY: OK
	test for unlimited opens: OK

Debug ioctls:
	test VIDIOC_DBG_G/S_REGISTER: OK
	test VIDIOC_LOG_STATUS: OK

Input ioctls:
	test VIDIOC_G/S_TUNER/ENUM_FREQ_BANDS: OK
	test VIDIOC_G/S_FREQUENCY: OK
	test VIDIOC_S_HW_FREQ_SEEK: OK (Not Supported)
	test VIDIOC_ENUMAUDIO: OK
	test VIDIOC_G/S/ENUMINPUT: OK
	test VIDIOC_G/S_AUDIO: OK
	Inputs: 4 Audio Inputs: 2 Tuners: 1

Output ioctls:
	test VIDIOC_G/S_MODULATOR: OK (Not Supported)
	test VIDIOC_G/S_FREQUENCY: OK
	test VIDIOC_ENUMAUDOUT: OK (Not Supported)
	test VIDIOC_G/S/ENUMOUTPUT: OK (Not Supported)
	test VIDIOC_G/S_AUDOUT: OK (Not Supported)
	Outputs: 0 Audio Outputs: 0 Modulators: 0

Input/Output configuration ioctls:
	test VIDIOC_ENUM/G/S/QUERY_STD: OK
	test VIDIOC_ENUM/G/S/QUERY_DV_TIMINGS: OK
	test VIDIOC_DV_TIMINGS_CAP: OK
	test VIDIOC_G/S_EDID: OK

Control ioctls (Input 0):
	test VIDIOC_QUERY_EXT_CTRL/QUERYMENU: OK
	test VIDIOC_QUERYCTRL: OK
	test VIDIOC_G/S_CTRL: OK
	test VIDIOC_G/S/TRY_EXT_CTRLS: OK
	test VIDIOC_(UN)SUBSCRIBE_EVENT/DQEVENT: OK
	test VIDIOC_G/S_JPEGCOMP: OK (Not Supported)
	Standard Controls: 15 Private Controls: 39

Format ioctls (Input 0):
	test VIDIOC_ENUM_FMT/FRAMESIZES/FRAMEINTERVALS: OK
	test VIDIOC_G/S_PARM: OK
	test VIDIOC_G_FBUF: OK
	test VIDIOC_G_FMT: OK
	test VIDIOC_TRY_FMT: OK
	test VIDIOC_S_FMT: OK
	test VIDIOC_G_SLICED_VBI_CAP: OK (Not Supported)
	test Cropping: OK (Not Supported)
	test Composing: OK (Not Supported)
	test Scaling: OK (Not Supported)

Codec ioctls (Input 0):
	test VIDIOC_(TRY_)ENCODER_CMD: OK (Not Supported)
	test VIDIOC_G_ENC_INDEX: OK (Not Supported)
	test VIDIOC_(TRY_)DECODER_CMD: OK (Not Supported)

Buffer ioctls (Input 0):
	test VIDIOC_REQBUFS/CREATE_BUFS/QUERYBUF: OK
	test VIDIOC_EXPBUF: OK

Control ioctls (Input 1):
	test VIDIOC_QUERY_EXT_CTRL/QUERYMENU: OK
	test VIDIOC_QUERYCTRL: OK
	test VIDIOC_G/S_CTRL: OK
	test VIDIOC_G/S/TRY_EXT_CTRLS: OK
	test VIDIOC_(UN)SUBSCRIBE_EVENT/DQEVENT: OK
	test VIDIOC_G/S_JPEGCOMP: OK (Not Supported)
	Standard Controls: 15 Private Controls: 39

Format ioctls (Input 1):
	test VIDIOC_ENUM_FMT/FRAMESIZES/FRAMEINTERVALS: OK
	test VIDIOC_G/S_PARM: OK
	test VIDIOC_G_FBUF: OK
	test VIDIOC_G_FMT: OK
	test VIDIOC_TRY_FMT: OK
	test VIDIOC_S_FMT: OK
	test VIDIOC_G_SLICED_VBI_CAP: OK (Not Supported)
	test Cropping: OK
	test Composing: OK
	test Scaling: OK

Codec ioctls (Input 1):
	test VIDIOC_(TRY_)ENCODER_CMD: OK (Not Supported)
	test VIDIOC_G_ENC_INDEX: OK (Not Supported)
	test VIDIOC_(TRY_)DECODER_CMD: OK (Not Supported)

Buffer ioctls (Input 1):
	test VIDIOC_REQBUFS/CREATE_BUFS/QUERYBUF: OK
	test VIDIOC_EXPBUF: OK

Control ioctls (Input 2):
	test VIDIOC_QUERY_EXT_CTRL/QUERYMENU: OK
	test VIDIOC_QUERYCTRL: OK
	test VIDIOC_G/S_CTRL: OK
	test VIDIOC_G/S/TRY_EXT_CTRLS: OK
	test VIDIOC_(UN)SUBSCRIBE_EVENT/DQEVENT: OK
	test VIDIOC_G/S_JPEGCOMP: OK (Not Supported)
	Standard Controls: 15 Private Controls: 39

Format ioctls (Input 2):
	test VIDIOC_ENUM_FMT/FRAMESIZES/FRAMEINTERVALS: OK
	test VIDIOC_G/S_PARM: OK
	test VIDIOC_G_FBUF: OK
	test VIDIOC_G_FMT: OK
	test VIDIOC_TRY_FMT: OK
	test VIDIOC_S_FMT: OK
	test VIDIOC_G_SLICED_VBI_CAP: OK (Not Supported)
	test Cropping: OK
	test Composing: OK
	test Scaling: OK

Codec ioctls (Input 2):
	test VIDIOC_(TRY_)ENCODER_CMD: OK (Not Supported)
	test VIDIOC_G_ENC_INDEX: OK (Not Supported)
	test VIDIOC_(TRY_)DECODER_CMD: OK (Not Supported)

Buffer ioctls (Input 2):
	test VIDIOC_REQBUFS/CREATE_BUFS/QUERYBUF: OK
	test VIDIOC_EXPBUF: OK

Control ioctls (Input 3):
	test VIDIOC_QUERY_EXT_CTRL/QUERYMENU: OK
	test VIDIOC_QUERYCTRL: OK
	test VIDIOC_G/S_CTRL: OK
	test VIDIOC_G/S/TRY_EXT_CTRLS: OK
		warn: v4l2-test-controls.cpp(825): V4L2_CID_DV_RX_POWER_PRESENT not found for input 3
	test VIDIOC_(UN)SUBSCRIBE_EVENT/DQEVENT: OK
	test VIDIOC_G/S_JPEGCOMP: OK (Not Supported)
	Standard Controls: 15 Private Controls: 39

Format ioctls (Input 3):
	test VIDIOC_ENUM_FMT/FRAMESIZES/FRAMEINTERVALS: OK
	test VIDIOC_G/S_PARM: OK
	test VIDIOC_G_FBUF: OK
	test VIDIOC_G_FMT: OK
	test VIDIOC_TRY_FMT: OK
	test VIDIOC_S_FMT: OK
	test VIDIOC_G_SLICED_VBI_CAP: OK (Not Supported)
	test Cropping: OK
	test Composing: OK
	test Scaling: OK

Codec ioctls (Input 3):
	test VIDIOC_(TRY_)ENCODER_CMD: OK (Not Supported)
	test VIDIOC_G_ENC_INDEX: OK (Not Supported)
	test VIDIOC_(TRY_)DECODER_CMD: OK (Not Supported)

Buffer ioctls (Input 3):
	test VIDIOC_REQBUFS/CREATE_BUFS/QUERYBUF: OK
	test VIDIOC_EXPBUF: OK

Test input 0:

Streaming ioctls:
	test read/write: OK

	Video Capture: Frame #000
	Video Capture: Frame #001
	Video Capture: Frame #002
	Video Capture: Frame #003
	Video Capture: Frame #004
	Video Capture: Frame #005
	Video Capture: Frame #006
	Video Capture: Frame #007
	Video Capture: Frame #008
	Video Capture: Frame #009
	                                                  

	Video Capture: Frame #000 (polling)
	Video Capture: Frame #001 (polling)
	Video Capture: Frame #002 (polling)
	Video Capture: Frame #003 (polling)
	Video Capture: Frame #004 (polling)
	Video Capture: Frame #005 (polling)
	Video Capture: Frame #006 (polling)
	Video Capture: Frame #007 (polling)
	Video Capture: Frame #008 (polling)
	Video Capture: Frame #009 (polling)
	                                                  
	test MMAP: OK

	Video Capture: Frame #000
	Video Capture: Frame #001
	Video Capture: Frame #002
	Video Capture: Frame #003
	Video Capture: Frame #004
	Video Capture: Frame #005
	Video Capture: Frame #006
	Video Capture: Frame #007
	Video Capture: Frame #008
	Video Capture: Frame #009
	                                                  

	Video Capture: Frame #000 (polling)
	Video Capture: Frame #001 (polling)
	Video Capture: Frame #002 (polling)
	Video Capture: Frame #003 (polling)
	Video Capture: Frame #004 (polling)
	Video Capture: Frame #005 (polling)
	Video Capture: Frame #006 (polling)
	Video Capture: Frame #007 (polling)
	Video Capture: Frame #008 (polling)
	Video Capture: Frame #009 (polling)
	                                                  
	test USERPTR: OK
	test DMABUF: Cannot test, specify --expbuf-device

Test input 1:

Streaming ioctls:
	test read/write: OK
		warn: v4l2-test-buffers.cpp(235): V4L2_BUF_FLAG_TIMECODE was used!

	Video Capture: Frame #000
	Video Capture: Frame #001
	Video Capture: Frame #002
	Video Capture: Frame #003
	Video Capture: Frame #004
	Video Capture: Frame #005
	Video Capture: Frame #006
	Video Capture: Frame #007
	Video Capture: Frame #008
	Video Capture: Frame #009
	                                                  

	Video Capture: Frame #000 (polling)
	Video Capture: Frame #001 (polling)
	Video Capture: Frame #002 (polling)
	Video Capture: Frame #003 (polling)
	Video Capture: Frame #004 (polling)
	Video Capture: Frame #005 (polling)
	Video Capture: Frame #006 (polling)
	Video Capture: Frame #007 (polling)
	Video Capture: Frame #008 (polling)
	Video Capture: Frame #009 (polling)
	                                                  
	test MMAP: OK

	Video Capture: Frame #000
	Video Capture: Frame #001
	Video Capture: Frame #002
	Video Capture: Frame #003
	Video Capture: Frame #004
	Video Capture: Frame #005
	Video Capture: Frame #006
	Video Capture: Frame #007
	Video Capture: Frame #008
	Video Capture: Frame #009
	                                                  

	Video Capture: Frame #000 (polling)
	Video Capture: Frame #001 (polling)
	Video Capture: Frame #002 (polling)
	Video Capture: Frame #003 (polling)
	Video Capture: Frame #004 (polling)
	Video Capture: Frame #005 (polling)
	Video Capture: Frame #006 (polling)
	Video Capture: Frame #007 (polling)
	Video Capture: Frame #008 (polling)
	Video Capture: Frame #009 (polling)
	                                                  
	test USERPTR: OK
	test DMABUF: Cannot test, specify --expbuf-device

Test input 2:

Streaming ioctls:
	test read/write: OK

	Video Capture: Frame #000
	Video Capture: Frame #001
	Video Capture: Frame #002
	Video Capture: Frame #003
	Video Capture: Frame #004
	Video Capture: Frame #005
	Video Capture: Frame #006
	Video Capture: Frame #007
	Video Capture: Frame #008
	Video Capture: Frame #009
	                                                  

	Video Capture: Frame #000 (polling)
	Video Capture: Frame #001 (polling)
	Video Capture: Frame #002 (polling)
	Video Capture: Frame #003 (polling)
	Video Capture: Frame #004 (polling)
	Video Capture: Frame #005 (polling)
	Video Capture: Frame #006 (polling)
	Video Capture: Frame #007 (polling)
	Video Capture: Frame #008 (polling)
	Video Capture: Frame #009 (polling)
	                                                  
	test MMAP: OK

	Video Capture: Frame #000
	Video Capture: Frame #001
	Video Capture: Frame #002
	Video Capture: Frame #003
	Video Capture: Frame #004
	Video Capture: Frame #005
	Video Capture: Frame #006
	Video Capture: Frame #007
	Video Capture: Frame #008
	Video Capture: Frame #009
	                                                  

	Video Capture: Frame #000 (polling)
	Video Capture: Frame #001 (polling)
	Video Capture: Frame #002 (polling)
	Video Capture: Frame #003 (polling)
	Video Capture: Frame #004 (polling)
	Video Capture: Frame #005 (polling)
	Video Capture: Frame #006 (polling)
	Video Capture: Frame #007 (polling)
	Video Capture: Frame #008 (polling)
	Video Capture: Frame #009 (polling)
	                                                  
	test USERPTR: OK
	test DMABUF: Cannot test, specify --expbuf-device

Test input 3:

Streaming ioctls:
	test read/write: OK

	Video Capture: Frame #000
	Video Capture: Frame #001
	Video Capture: Frame #002
	Video Capture: Frame #003
	Video Capture: Frame #004
	Video Capture: Frame #005
	Video Capture: Frame #006
	Video Capture: Frame #007
	Video Capture: Frame #008
	Video Capture: Frame #009
	                                                  

	Video Capture: Frame #000 (polling)
	Video Capture: Frame #001 (polling)
	Video Capture: Frame #002 (polling)
	Video Capture: Frame #003 (polling)
	Video Capture: Frame #004 (polling)
	Video Capture: Frame #005 (polling)
	Video Capture: Frame #006 (polling)
	Video Capture: Frame #007 (polling)
	Video Capture: Frame #008 (polling)
	Video Capture: Frame #009 (polling)
	                                                  
	test MMAP: OK

	Video Capture: Frame #000
	Video Capture: Frame #001
	Video Capture: Frame #002
	Video Capture: Frame #003
	Video Capture: Frame #004
	Video Capture: Frame #005
	Video Capture: Frame #006
	Video Capture: Frame #007
	Video Capture: Frame #008
	Video Capture: Frame #009
	                                                  

	Video Capture: Frame #000 (polling)
	Video Capture: Frame #001 (polling)
	Video Capture: Frame #002 (polling)
	Video Capture: Frame #003 (polling)
	Video Capture: Frame #004 (polling)
	Video Capture: Frame #005 (polling)
	Video Capture: Frame #006 (polling)
	Video Capture: Frame #007 (polling)
	Video Capture: Frame #008 (polling)
	Video Capture: Frame #009 (polling)
	                                                  
	test USERPTR: OK
	test DMABUF: Cannot test, specify --expbuf-device

Total: 118, Succeeded: 118, Failed: 0, Warnings: 2

64 bits result:


v4l2-compliance SHA   : bc71e4a67c6fbc5940062843bc41e7c8679634ce

Compliance test for device /dev/video0:

Driver Info:
	Driver name      : vivid
	Card type        : vivid
	Bus info         : platform:vivid-000
	Driver version   : 4.17.0
	Capabilities     : 0x853f0df7
		Video Capture
		Video Output
		Video Overlay
		VBI Capture
		VBI Output
		Sliced VBI Capture
		Sliced VBI Output
		RDS Capture
		RDS Output
		SDR Capture
		Tuner
		HW Frequency Seek
		Modulator
		Audio
		Radio
		Read/Write
		Streaming
		Extended Pix Format
		Device Capabilities
	Device Caps      : 0x05230005
		Video Capture
		Video Overlay
		Tuner
		Audio
		Read/Write
		Streaming
		Extended Pix Format

Required ioctls:
	test VIDIOC_QUERYCAP: OK

Allow for multiple opens:
	test second /dev/video0 open: OK
	test VIDIOC_QUERYCAP: OK
	test VIDIOC_G/S_PRIORITY: OK
	test for unlimited opens: OK

Debug ioctls:
	test VIDIOC_DBG_G/S_REGISTER: OK
	test VIDIOC_LOG_STATUS: OK

Input ioctls:
	test VIDIOC_G/S_TUNER/ENUM_FREQ_BANDS: OK
	test VIDIOC_G/S_FREQUENCY: OK
	test VIDIOC_S_HW_FREQ_SEEK: OK (Not Supported)
	test VIDIOC_ENUMAUDIO: OK
	test VIDIOC_G/S/ENUMINPUT: OK
	test VIDIOC_G/S_AUDIO: OK
	Inputs: 4 Audio Inputs: 2 Tuners: 1

Output ioctls:
	test VIDIOC_G/S_MODULATOR: OK (Not Supported)
	test VIDIOC_G/S_FREQUENCY: OK
	test VIDIOC_ENUMAUDOUT: OK (Not Supported)
	test VIDIOC_G/S/ENUMOUTPUT: OK (Not Supported)
	test VIDIOC_G/S_AUDOUT: OK (Not Supported)
	Outputs: 0 Audio Outputs: 0 Modulators: 0

Input/Output configuration ioctls:
	test VIDIOC_ENUM/G/S/QUERY_STD: OK
	test VIDIOC_ENUM/G/S/QUERY_DV_TIMINGS: OK
	test VIDIOC_DV_TIMINGS_CAP: OK
	test VIDIOC_G/S_EDID: OK

Control ioctls (Input 0):
	test VIDIOC_QUERY_EXT_CTRL/QUERYMENU: OK
	test VIDIOC_QUERYCTRL: OK
	test VIDIOC_G/S_CTRL: OK
	test VIDIOC_G/S/TRY_EXT_CTRLS: OK
	test VIDIOC_(UN)SUBSCRIBE_EVENT/DQEVENT: OK
	test VIDIOC_G/S_JPEGCOMP: OK (Not Supported)
	Standard Controls: 15 Private Controls: 39

Format ioctls (Input 0):
	test VIDIOC_ENUM_FMT/FRAMESIZES/FRAMEINTERVALS: OK
	test VIDIOC_G/S_PARM: OK
	test VIDIOC_G_FBUF: OK
	test VIDIOC_G_FMT: OK
	test VIDIOC_TRY_FMT: OK
	test VIDIOC_S_FMT: OK
	test VIDIOC_G_SLICED_VBI_CAP: OK (Not Supported)
	test Cropping: OK (Not Supported)
	test Composing: OK (Not Supported)
	test Scaling: OK (Not Supported)

Codec ioctls (Input 0):
	test VIDIOC_(TRY_)ENCODER_CMD: OK (Not Supported)
	test VIDIOC_G_ENC_INDEX: OK (Not Supported)
	test VIDIOC_(TRY_)DECODER_CMD: OK (Not Supported)

Buffer ioctls (Input 0):
	test VIDIOC_REQBUFS/CREATE_BUFS/QUERYBUF: OK
	test VIDIOC_EXPBUF: OK

Control ioctls (Input 1):
	test VIDIOC_QUERY_EXT_CTRL/QUERYMENU: OK
	test VIDIOC_QUERYCTRL: OK
	test VIDIOC_G/S_CTRL: OK
	test VIDIOC_G/S/TRY_EXT_CTRLS: OK
	test VIDIOC_(UN)SUBSCRIBE_EVENT/DQEVENT: OK
	test VIDIOC_G/S_JPEGCOMP: OK (Not Supported)
	Standard Controls: 15 Private Controls: 39

Format ioctls (Input 1):
	test VIDIOC_ENUM_FMT/FRAMESIZES/FRAMEINTERVALS: OK
	test VIDIOC_G/S_PARM: OK
	test VIDIOC_G_FBUF: OK
	test VIDIOC_G_FMT: OK
	test VIDIOC_TRY_FMT: OK
	test VIDIOC_S_FMT: OK
	test VIDIOC_G_SLICED_VBI_CAP: OK (Not Supported)
	test Cropping: OK
	test Composing: OK
	test Scaling: OK

Codec ioctls (Input 1):
	test VIDIOC_(TRY_)ENCODER_CMD: OK (Not Supported)
	test VIDIOC_G_ENC_INDEX: OK (Not Supported)
	test VIDIOC_(TRY_)DECODER_CMD: OK (Not Supported)

Buffer ioctls (Input 1):
	test VIDIOC_REQBUFS/CREATE_BUFS/QUERYBUF: OK
	test VIDIOC_EXPBUF: OK

Control ioctls (Input 2):
	test VIDIOC_QUERY_EXT_CTRL/QUERYMENU: OK
	test VIDIOC_QUERYCTRL: OK
	test VIDIOC_G/S_CTRL: OK
	test VIDIOC_G/S/TRY_EXT_CTRLS: OK
	test VIDIOC_(UN)SUBSCRIBE_EVENT/DQEVENT: OK
	test VIDIOC_G/S_JPEGCOMP: OK (Not Supported)
	Standard Controls: 15 Private Controls: 39

Format ioctls (Input 2):
	test VIDIOC_ENUM_FMT/FRAMESIZES/FRAMEINTERVALS: OK
	test VIDIOC_G/S_PARM: OK
	test VIDIOC_G_FBUF: OK
	test VIDIOC_G_FMT: OK
	test VIDIOC_TRY_FMT: OK
	test VIDIOC_S_FMT: OK
	test VIDIOC_G_SLICED_VBI_CAP: OK (Not Supported)
	test Cropping: OK
	test Composing: OK
	test Scaling: OK

Codec ioctls (Input 2):
	test VIDIOC_(TRY_)ENCODER_CMD: OK (Not Supported)
	test VIDIOC_G_ENC_INDEX: OK (Not Supported)
	test VIDIOC_(TRY_)DECODER_CMD: OK (Not Supported)

Buffer ioctls (Input 2):
	test VIDIOC_REQBUFS/CREATE_BUFS/QUERYBUF: OK
	test VIDIOC_EXPBUF: OK

Control ioctls (Input 3):
	test VIDIOC_QUERY_EXT_CTRL/QUERYMENU: OK
	test VIDIOC_QUERYCTRL: OK
	test VIDIOC_G/S_CTRL: OK
	test VIDIOC_G/S/TRY_EXT_CTRLS: OK
		warn: v4l2-test-controls.cpp(825): V4L2_CID_DV_RX_POWER_PRESENT not found for input 3
	test VIDIOC_(UN)SUBSCRIBE_EVENT/DQEVENT: OK
	test VIDIOC_G/S_JPEGCOMP: OK (Not Supported)
	Standard Controls: 15 Private Controls: 39

Format ioctls (Input 3):
	test VIDIOC_ENUM_FMT/FRAMESIZES/FRAMEINTERVALS: OK
	test VIDIOC_G/S_PARM: OK
	test VIDIOC_G_FBUF: OK
	test VIDIOC_G_FMT: OK
	test VIDIOC_TRY_FMT: OK
	test VIDIOC_S_FMT: OK
	test VIDIOC_G_SLICED_VBI_CAP: OK (Not Supported)
	test Cropping: OK
	test Composing: OK
	test Scaling: OK

Codec ioctls (Input 3):
	test VIDIOC_(TRY_)ENCODER_CMD: OK (Not Supported)
	test VIDIOC_G_ENC_INDEX: OK (Not Supported)
	test VIDIOC_(TRY_)DECODER_CMD: OK (Not Supported)

Buffer ioctls (Input 3):
	test VIDIOC_REQBUFS/CREATE_BUFS/QUERYBUF: OK
	test VIDIOC_EXPBUF: OK

Test input 0:

Streaming ioctls:
	test read/write: OK

	Video Capture: Frame #000
	Video Capture: Frame #001
	Video Capture: Frame #002
	Video Capture: Frame #003
	Video Capture: Frame #004
	Video Capture: Frame #005
	Video Capture: Frame #006
	Video Capture: Frame #007
	Video Capture: Frame #008
	Video Capture: Frame #009
	                                                  

	Video Capture: Frame #000 (polling)
	Video Capture: Frame #001 (polling)
	Video Capture: Frame #002 (polling)
	Video Capture: Frame #003 (polling)
	Video Capture: Frame #004 (polling)
	Video Capture: Frame #005 (polling)
	Video Capture: Frame #006 (polling)
	Video Capture: Frame #007 (polling)
	Video Capture: Frame #008 (polling)
	Video Capture: Frame #009 (polling)
	                                                  
	test MMAP: OK

	Video Capture: Frame #000
	Video Capture: Frame #001
	Video Capture: Frame #002
	Video Capture: Frame #003
	Video Capture: Frame #004
	Video Capture: Frame #005
	Video Capture: Frame #006
	Video Capture: Frame #007
	Video Capture: Frame #008
	Video Capture: Frame #009
	                                                  

	Video Capture: Frame #000 (polling)
	Video Capture: Frame #001 (polling)
	Video Capture: Frame #002 (polling)
	Video Capture: Frame #003 (polling)
	Video Capture: Frame #004 (polling)
	Video Capture: Frame #005 (polling)
	Video Capture: Frame #006 (polling)
	Video Capture: Frame #007 (polling)
	Video Capture: Frame #008 (polling)
	Video Capture: Frame #009 (polling)
	                                                  
	test USERPTR: OK
	test DMABUF: Cannot test, specify --expbuf-device

Test input 1:

Streaming ioctls:
	test read/write: OK
		warn: v4l2-test-buffers.cpp(235): V4L2_BUF_FLAG_TIMECODE was used!

	Video Capture: Frame #000
	Video Capture: Frame #001
	Video Capture: Frame #002
	Video Capture: Frame #003
	Video Capture: Frame #004
	Video Capture: Frame #005
	Video Capture: Frame #006
	Video Capture: Frame #007
	Video Capture: Frame #008
	Video Capture: Frame #009
	                                                  

	Video Capture: Frame #000 (polling)
	Video Capture: Frame #001 (polling)
	Video Capture: Frame #002 (polling)
	Video Capture: Frame #003 (polling)
	Video Capture: Frame #004 (polling)
	Video Capture: Frame #005 (polling)
	Video Capture: Frame #006 (polling)
	Video Capture: Frame #007 (polling)
	Video Capture: Frame #008 (polling)
	Video Capture: Frame #009 (polling)
	                                                  
	test MMAP: OK

	Video Capture: Frame #000
	Video Capture: Frame #001
	Video Capture: Frame #002
	Video Capture: Frame #003
	Video Capture: Frame #004
	Video Capture: Frame #005
	Video Capture: Frame #006
	Video Capture: Frame #007
	Video Capture: Frame #008
	Video Capture: Frame #009
	                                                  

	Video Capture: Frame #000 (polling)
	Video Capture: Frame #001 (polling)
	Video Capture: Frame #002 (polling)
	Video Capture: Frame #003 (polling)
	Video Capture: Frame #004 (polling)
	Video Capture: Frame #005 (polling)
	Video Capture: Frame #006 (polling)
	Video Capture: Frame #007 (polling)
	Video Capture: Frame #008 (polling)
	Video Capture: Frame #009 (polling)
	                                                  
	test USERPTR: OK
	test DMABUF: Cannot test, specify --expbuf-device

Test input 2:

Streaming ioctls:
	test read/write: OK

	Video Capture: Frame #000
	Video Capture: Frame #001
	Video Capture: Frame #002
	Video Capture: Frame #003
	Video Capture: Frame #004
	Video Capture: Frame #005
	Video Capture: Frame #006
	Video Capture: Frame #007
	Video Capture: Frame #008
	Video Capture: Frame #009
	                                                  

	Video Capture: Frame #000 (polling)
	Video Capture: Frame #001 (polling)
	Video Capture: Frame #002 (polling)
	Video Capture: Frame #003 (polling)
	Video Capture: Frame #004 (polling)
	Video Capture: Frame #005 (polling)
	Video Capture: Frame #006 (polling)
	Video Capture: Frame #007 (polling)
	Video Capture: Frame #008 (polling)
	Video Capture: Frame #009 (polling)
	                                                  
	test MMAP: OK

	Video Capture: Frame #000
	Video Capture: Frame #001
	Video Capture: Frame #002
	Video Capture: Frame #003
	Video Capture: Frame #004
	Video Capture: Frame #005
	Video Capture: Frame #006
	Video Capture: Frame #007
	Video Capture: Frame #008
	Video Capture: Frame #009
	                                                  

	Video Capture: Frame #000 (polling)
	Video Capture: Frame #001 (polling)
	Video Capture: Frame #002 (polling)
	Video Capture: Frame #003 (polling)
	Video Capture: Frame #004 (polling)
	Video Capture: Frame #005 (polling)
	Video Capture: Frame #006 (polling)
	Video Capture: Frame #007 (polling)
	Video Capture: Frame #008 (polling)
	Video Capture: Frame #009 (polling)
	                                                  
	test USERPTR: OK
	test DMABUF: Cannot test, specify --expbuf-device

Test input 3:

Streaming ioctls:
	test read/write: OK

	Video Capture: Frame #000
	Video Capture: Frame #001
	Video Capture: Frame #002
	Video Capture: Frame #003
	Video Capture: Frame #004
	Video Capture: Frame #005
	Video Capture: Frame #006
	Video Capture: Frame #007
	Video Capture: Frame #008
	Video Capture: Frame #009
	                                                  

	Video Capture: Frame #000 (polling)
	Video Capture: Frame #001 (polling)
	Video Capture: Frame #002 (polling)
	Video Capture: Frame #003 (polling)
	Video Capture: Frame #004 (polling)
	Video Capture: Frame #005 (polling)
	Video Capture: Frame #006 (polling)
	Video Capture: Frame #007 (polling)
	Video Capture: Frame #008 (polling)
	Video Capture: Frame #009 (polling)
	                                                  
	test MMAP: OK

	Video Capture: Frame #000
	Video Capture: Frame #001
	Video Capture: Frame #002
	Video Capture: Frame #003
	Video Capture: Frame #004
	Video Capture: Frame #005
	Video Capture: Frame #006
	Video Capture: Frame #007
	Video Capture: Frame #008
	Video Capture: Frame #009
	                                                  

	Video Capture: Frame #000 (polling)
	Video Capture: Frame #001 (polling)
	Video Capture: Frame #002 (polling)
	Video Capture: Frame #003 (polling)
	Video Capture: Frame #004 (polling)
	Video Capture: Frame #005 (polling)
	Video Capture: Frame #006 (polling)
	Video Capture: Frame #007 (polling)
	Video Capture: Frame #008 (polling)
	Video Capture: Frame #009 (polling)
	                                                  
	test USERPTR: OK
	test DMABUF: Cannot test, specify --expbuf-device

Total: 118, Succeeded: 118, Failed: 0, Warnings: 2


> 
> Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
> 
> diff --git a/drivers/media/v4l2-core/v4l2-compat-ioctl32.c b/drivers/media/v4l2-core/v4l2-compat-ioctl32.c
> index 8c05dd9660d3..d2f0268427c2 100644
> --- a/drivers/media/v4l2-core/v4l2-compat-ioctl32.c
> +++ b/drivers/media/v4l2-core/v4l2-compat-ioctl32.c
> @@ -30,6 +30,24 @@
>  	get_user(__assign_tmp, from) || put_user(__assign_tmp, to);	\
>  })
>  
> +#define get_user_cast(__x, __ptr)					\
> +({									\
> +	get_user(__x, (typeof(*__ptr) __user *)(__ptr));		\
> +})
> +
> +#define put_user_force(__x, __ptr)					\
> +({									\
> +	put_user((typeof(*__x) __force *)(__x), __ptr);			\
> +})
> +
> +#define assign_in_user_cast(to, from)					\
> +({									\
> +	typeof(*from) __assign_tmp;					\
> +									\
> +	get_user_cast(__assign_tmp, from) || put_user(__assign_tmp, to);\
> +})
> +
> +
>  static long native_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
>  {
>  	long ret = -ENOIOCTLCMD;
> @@ -543,8 +561,7 @@ static int get_v4l2_buffer32(struct v4l2_buffer __user *p64,
>  			return -EFAULT;
>  
>  		uplane = aux_buf;
> -		if (put_user((__force struct v4l2_plane *)uplane,
> -			     &p64->m.planes))
> +		if (put_user_force(uplane, &p64->m.planes))
>  			return -EFAULT;
>  
>  		while (num_planes--) {
> @@ -682,7 +699,7 @@ static int get_v4l2_framebuffer32(struct v4l2_framebuffer __user *p64,
>  
>  	if (!access_ok(VERIFY_READ, p32, sizeof(*p32)) ||
>  	    get_user(tmp, &p32->base) ||
> -	    put_user((void __force *)compat_ptr(tmp), &p64->base) ||
> +	    put_user_force(compat_ptr(tmp), &p64->base) ||
>  	    assign_in_user(&p64->capability, &p32->capability) ||
>  	    assign_in_user(&p64->flags, &p32->flags) ||
>  	    copy_in_user(&p64->fmt, &p32->fmt, sizeof(p64->fmt)))
> @@ -831,8 +848,7 @@ static int get_v4l2_ext_controls32(struct file *file,
>  	if (aux_space < count * sizeof(*kcontrols))
>  		return -EFAULT;
>  	kcontrols = aux_buf;
> -	if (put_user((__force struct v4l2_ext_control *)kcontrols,
> -		     &p64->controls))
> +	if (put_user_force(kcontrols, &p64->controls))
>  		return -EFAULT;
>  
>  	for (n = 0; n < count; n++) {
> @@ -898,12 +914,11 @@ static int put_v4l2_ext_controls32(struct file *file,
>  		unsigned int size = sizeof(*ucontrols);
>  		u32 id;
>  
> -		if (get_user(id, (unsigned int __user *)&kcontrols->id) ||
> +		if (get_user_cast(id, &kcontrols->id) ||
>  		    put_user(id, &ucontrols->id) ||
> -		    assign_in_user(&ucontrols->size,
> -				   (unsigned int __user *)&kcontrols->size) ||
> +		    assign_in_user_cast(&ucontrols->size, &kcontrols->size) ||
>  		    copy_in_user(&ucontrols->reserved2,
> -				 (unsigned int __user *)&kcontrols->reserved2,
> +				 (void __user *)&kcontrols->reserved2,
>  				 sizeof(ucontrols->reserved2)))
>  			return -EFAULT;
>  
> @@ -916,7 +931,7 @@ static int put_v4l2_ext_controls32(struct file *file,
>  			size -= sizeof(ucontrols->value64);
>  
>  		if (copy_in_user(ucontrols,
> -			         (unsigned int __user *)kcontrols, size))
> +			         (void __user *)kcontrols, size))
>  			return -EFAULT;
>  
>  		ucontrols++;
> @@ -970,10 +985,9 @@ static int get_v4l2_edid32(struct v4l2_edid __user *p64,
>  	if (!access_ok(VERIFY_READ, p32, sizeof(*p32)) ||
>  	    assign_in_user(&p64->pad, &p32->pad) ||
>  	    assign_in_user(&p64->start_block, &p32->start_block) ||
> -	    assign_in_user(&p64->blocks,
> -			   (unsigned char __user *)&p32->blocks) ||
> +	    assign_in_user_cast(&p64->blocks, &p32->blocks) ||
>  	    get_user(tmp, &p32->edid) ||
> -	    put_user((void __force *)compat_ptr(tmp), &p64->edid) ||
> +	    put_user_force(compat_ptr(tmp), &p64->edid) ||
>  	    copy_in_user(p64->reserved, p32->reserved, sizeof(p64->reserved)))
>  		return -EFAULT;
>  	return 0;
> 
> 
> Thanks,
> Mauro



Thanks,
Mauro
