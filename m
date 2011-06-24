Return-path: <mchehab@pedra>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:52322 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755791Ab1FXOcx (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 24 Jun 2011 10:32:53 -0400
Received: from eu_spt1 (mailout2.w1.samsung.com [210.118.77.12])
 by mailout2.w1.samsung.com
 (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTP id <0LNA00K5UTQS98@mailout2.w1.samsung.com> for
 linux-media@vger.kernel.org; Fri, 24 Jun 2011 15:32:52 +0100 (BST)
Received: from [106.116.48.223] by spt1.w1.samsung.com
 (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTPA id <0LNA001GHTQQYI@spt1.w1.samsung.com> for
 linux-media@vger.kernel.org; Fri, 24 Jun 2011 15:32:51 +0100 (BST)
Date: Fri, 24 Jun 2011 16:32:48 +0200
From: Tomasz Stanislawski <t.stanislaws@samsung.com>
Subject: Summary of brainstorm about cropping and pipeline configuration
In-reply-to: <1307534611-32283-4-git-send-email-t.stanislaws@samsung.com>
To: linux-media@vger.kernel.org
Cc: m.szyprowski@samsung.com, kyungmin.park@samsung.com,
	hverkuil@xs4all.nl, laurent.pinchart@ideasonboard.com,
	sakari.ailus@maxwell.research.nokia.com, mchehab@redhat.com,
	g.liakhovetski@gmx.de, Sylwester Nawrocki <s.nawrocki@samsung.com>,
	'Kamil Debski' <k.debski@samsung.com>
Message-id: <4E04A010.7090408@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7BIT
References: <1307534611-32283-1-git-send-email-t.stanislaws@samsung.com>
 <1307534611-32283-4-git-send-email-t.stanislaws@samsung.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hello Everyone,
This mail summarizes IRC meeting about extensions to crop/compose API in 
V4L2.

Please refer to the links below for further details.
http://thread.gmane.org/gmane.linux.drivers.video-input-infrastructure/32899
http://thread.gmane.org/gmane.linux.drivers.video-input-infrastructure/32152

The discussion took place from 31 May to 6 Jun. Many offside topic were
analyzed. This summary covers following issues:

Section 1-4. Pipeline configuration.
Section 5. S_FRAMESIZE ioctl
Section 6. S_SELECTION ioctl
Section 7. Backward compatibility issues


1. Introduction to the pipeline configuration.
It is assumed that the pipeline may contain following blocks. A cropping
device that cuts a part of an input image and pass that part to further 
parts
of the pipeline. A scaler is a device responsible changing resolution of
processed image data. The composer is a device that allows to paste an image
into a part of the other image. The composing operation may involve 
scaling if
resolution of destination area differs from the input image.

The pipeline configuration strongly depends on hardware capabilities. 
The main
issue is presence of a scaler and a composer. The effects of ioctls may 
change
dramatically depending on presence of HW pieces. The expected behaviours
separated by hardware configuration is described in the following 
paragraphs.

1.1. No composer, no scaler.
S_FMT is optional. S_FMT does not change anything except fourcc. The 
width and
height from S_FMT are ignored and they are substituted by width and 
height of a
cropping rectangle.

1.2. Composer, no scaler.
S_FMT sets the pixel format and the buffer size. The driver will adjust the
size, the minimum size being the S_CROP rectangle, and the maximum size is a
driver-defined limit. The size of a compose rectangle is equal to the crop
rectangle. User can adjust offsets but the whole compose rectangle must lay
inside the buffer.

1.3. No composer, scaler.
Scaler is configured by S_FMT and S_CROP. The composing rectangle is always
equal to S_FMT.

1.4. Composer, scaler.
It is considered to be the most difficult case. The scaler is configured by
S_CROP and (S_FMT xor composing rectangle). If the composing rectangle 
is not
defined then its size is equal to S_FMT, and the offset is top/left corner.

2. Configuration flow for video capture.
There was a lot of discussion about configuration order for capture devices.
Two solutions were proposed:

2.1. Transaction based setup.
It was considered good at media controller level. It is more general and
flexible for applications that know capabilities of hardware exactly. 
However
this approach is too complex for standard applications.

2.2. Specify in detail in what order the ioctls should be called.
It is preferable solution because it suits to simple applications with 
simple
pipelines.

2.2.1. Assumptions:
 - Standard pipeline is a pipeline that can be defined using following
   operation (in order):
    * load from source (video receiver, sensor)
    * crop
    * scale/rotate/convert format
    * compose
    * store to sink (memory)
- Setting a part at higher in a pipeline resets all parts below.
- Enforcing an order of ioctls means than an ioctl can reset parameters of
  other ioctls down the pipeline, but not up the pipeline.
- Compatibility with existing applications. The configuration achieved by
  calling ioctl S_STD/S_DV_PRESET, S_CROP, S_FMT must satisfy all 
requirements
  specified in current V4L2 documentation.
- Sequence S_STD/S_DV_PRESET, S_CROP, S_FMT must always end with a buffer
  without any margin
- all essential parts of standard pipeline must be mapped to dedicated 
ioctls
- all steps are optional, driver should be able to work on default
  configuration
- no need for S_SCALE ioctl, use cropping and composing rectangles to set
  scalers.

2.2.2. The proposed order of ioctls:
- Select input using S_INPUT
- Input resolution: S_STD, S_DV_PRESET or S_FRAMESIZE (upcoming extension).
- Set cropping S_CROP/S_SELECTION.
- Set rotation using controls.
- Set composing rectangle using S_SELECTION.
- Set buffer format using S_FMT.

2.2.4 Discussion about order of compose and S_FMT.
2.2.4.1. Proposition I.
Use special bit passed in v4l2_pix_format::priv field. If bit is not set 
then
S_FMT resets the compose rectangle to a full S_FMT resolution. If bit is set
then format size is adjusted to contain the composing rectangle. The 
composing
rectangle is left untouched. The priv field is used by drivers: pwc, 
stk-webcam
and solo6x10. Moreover dependency of ioctls is broken. If there is no 
composer
then S_FMT forces composing rectangle, and therefore forces scaling
configuration. Scaling is above format in the pipeline.

2.2.4.2. Proposition II.
Setting compose always resets format and introduces bounds for format. It is
similar to Proposition I but the special bit is always on. The difference is
that composing is configured before buffer format. Only setup of 
crop/composing
pair is used to set scaling factor. Such a behaviour is inconsistent with
current S_FMT/S_CROP behaviour. Please refer to section 7 for further 
details
and ideas for keeping backward compatibility with existing applications.

3. Configuration flow for video output.
The case similar to video capture. The configuration order device->memory is
preferred over data flow one. If data flow order (memory->device) would be
applied then setting buffer size should reset a display. It is neither 
natural
nor intuitive way of output configuration.

3.1. The proposed order of ioctls:
- Select output using S_OUTPUT
- Output resolution: S_STD, S_DV_PRESET or S_FRAMESIZE (upcoming extension).
- Set composing S_CROP/S_SELECTION.
- Set rotation using controls.
- Set cropping rectangle using S_SELECTION.
- Set buffer format using S_FMT.

3.2. Issues about the order of S_SELECTION(crop) and S_FMT. The problem 
is the
same as in 2.2.4,

4. Configuration flow for memory-to-memory devices (mem2mem).
The pipeline configuration sequence for mem2mem devices and possible dev2dev
devices is an open issue. The rule "device to memory" is ambiguous for both
device types. It was proposed to apply the same order as the data flow.

4.1. Proposed order of ioctls for mem2mem.
- S_FMT(output)
- S_SELECTION(crop-output)
- setting rotation
- S_SELECTION(compose-capture)
- S_FMT(capture)

4.2. Other propositions.
Model mem2mem devices as two joint pipelines. First one is 
memory->device. The
second one is device->memory. There is a virtual device entity between two
buffers.  Both pipelines are configured using device to memory order. The
nature of the virtual device in the middle is to be defined.

5. Requirements for new ioctl S_FRAMESIZE.
- cap bit in ENUMINPUTS and ENUMOUTPUTS
- list of available frame sizes is obtained by ENUM_FRAMESIZES ioctl
- only needed if the driver supports scaling and/or has more than one 
framesize
  in ENUM_FRAMESIZES
- framesizes will select a combination of binning and skipping
- if app never calls S_FRAMESIZE then the framesize remains at whatever was
  selected last
- introduce additional subdev ops for s_framesize
- S_FRAMESIZE is dedicated fora sensor arrays in case of sensor arrays,
  additional framesizes are used to model binning and skipping
- LCDs which content fed by a scaler, framebuffers could be modelled as such
  kind of video output

5.1. Open questions
- constraint bits (like SIZE_LE) for S_FRAMESIZE
- the former name of the ioctl was S_SENSOR, it was dedicated for sensors.
  S_SENSOR was rejected because there was not enough sensor-specific 
settings
  to differentiate S_SENSOR for FRAMESIZE API.

6. S_SELECTION issues.
- no TRY flags
- TRY_SELECTION is postponed, not needed yet because TRY_CROP does not exist
- hint flags like V4L2_SEL_SIZE_LE and V4L2_SEL_SIZE_GE become 
constraint flags
- combination SIZE_LE | SIZE_GE indicate that application tries to set size
  exactly equal to desired one
- on success, the adjusted rectangle is returned in v4l2_selection::r,
- if driver is not able to find selection rectangle satisfying all 
constraints
  then ERANGE is returned
- on failure, the closest possible rectangle is returned in 
v4l2_selection::r
- S_SELECTION always return a rectangle for with there exists at least one
  valid configuration of the whole pipeline, for example 
S_SELECTION(compose)
  could not return rectangle for which there is no valid S_FMT

7. Backward compatibility issues.
Use V4L2 framework to adjust S_FMT depending if compose was configured 
or not:

7.1. Example.
Here I would like discuss problems with backward compatibility. Consider
following scenario. There is a sensor with composing capabilities. 
Assume that
there is no cropping and no scaling for simplicity reasons. Existing
application wants to grab sensor's image to a buffer. The application calls
only S_FMT and it assumes that pipeline is configured. Assume that the 
sensor's
resolution is 640 x 480. The application calls S_FMT(width = 800, height =
600).

7.1.1. Old behaviour.
The format should be adjusted to framesize. The buffer 640x480 is allocated.
The buffer is filled fully by a grabbed image. There should be no margins.

7.1.2. New behaviour.
The result would be different from
point of view of the new pipeline configuration:
- implicit S_FRAMESIZE(640, 480) - driver choose default resolution
- implicit S_SELECTION(crop: 640, 480) - no cropping indicate cropping the
  whole array content
- implicit S_SELECTION(compose: 640, 480) - driver assumes no scaling, 
so crop
  = compose,
- explicit S_FMT(800, 600) - setting buffer resolution to 800 x 600
The result is composing 640x480 image to 800x600 buffer. The margins are
introduced.

7.2. Proposed solution.
In order to solve the problem V4L2 has to detect is application is aware of
composing API.

7.2.1. Solution I.
Look to 2.2.4.1.

7.2.2. Solution II.
The problem would disappear if composing some layer in V4L2 stack could 
detect
if composing rectangle was already configured. It means that
S_SELECTION(compose) was called. If composing rectangle is not set before
S_FMT(width, height) then an implicit call to driver is introduced. It 
would be
S_SELECTION(compose) with width and height form S_FMT. The used offset 
should
be zero. Successful setup of composing rectangle is followed by S_FMT. The
open question is how such an ioctl tracing and a business logic is 
handled. It
may be implemented in libv4l, V2L2 framework or even in the driver.


I hope you find this information useful,

Regards,
Tomasz Stanislawski

