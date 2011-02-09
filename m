Return-path: <mchehab@pedra>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:56570 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755053Ab1BIOdJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 9 Feb 2011 09:33:09 -0500
Received: from spt2.w1.samsung.com (mailout1.w1.samsung.com [210.118.77.11])
 by mailout1.w1.samsung.com
 (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTP id <0LGC00LD9TR7ST@mailout1.w1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 09 Feb 2011 14:33:07 +0000 (GMT)
Received: from [106.116.48.223] by spt2.w1.samsung.com
 (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTPA id <0LGC008SATR6VH@spt2.w1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 09 Feb 2011 14:33:06 +0000 (GMT)
Date: Wed, 09 Feb 2011 15:32:54 +0100
From: Tomasz Stanislawski <t.stanislaws@samsung.com>
Subject: [RFC] Cropping problem with V4L2, crop extension
To: linux-media@vger.kernel.org
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	t.stanislaws@samsung.com
Message-id: <4D52A596.9080309@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi everyone,
I am working on HDMI driver for latest Samsung SoC. I encountered 
problem with format and crop setup. I noticed that this issue was 
mentioned other threads before. First I would like to describe 
environment of a cropping problem.
There are two pieces of multimedia hardware on board I am working with. 
The avi decoder called MFC, and hdmi hardware called HDMI.  Please refer 
to posts for further details:

http://thread.gmane.org/gmane.linux.drivers.video-input-infrastructure/24022
http://thread.gmane.org/gmane.linux.drivers.video-input-infrastructure/28885

The MFC transforms movie stream to image in NV12T format. This format is 
very similar to NV12 but pixels are organized into macroblocks of size 
64 x 32. More information about NV12T format can be found in post:
http://thread.gmane.org/gmane.linux.drivers.video-input-infrastructure/28942
Due to hardware limitations sizes of output image have to multiples of 
128 x 32 pixels. The problem comes when movie size is not a multiple of 
128 x 32. The MFC is a M2M device, so it supports G_CROP ioctl on both 
CAPTURE and OUTPUT buffer. The active area in output image is obtained 
by calling G_CROP on CAPTURE buffer.

Let's consider following scenario:

MFC configuration is done in the first few steps.
1. We have H264 movie in resolution 320 x 240.
2. ioctl(fd = MFC, S_FMT, v4l2_format { .type = OUTPUT,
    .pixelformat=FMT_H264})
3. Allocates buffers using REQBUF
4. QBUF few frames to get stream resolution
5. Calls ioctl(fd = MFC, G_FMT, v4l2_format { .type = CAPTURE}) to get 
width and height of buffer that suit to the movie. Lets call it 
full_width, and full_height. These are 384 x 256 because it is the 
smallest multiple of 128 x  64 that contains full image.
6. Call ioctl(fd = MFC, G_CROP, v4l2_crop { .type = CAPTURE}) to get 
movie resolution. Call it width and height.

Now HDMI is configured. Assume 720p resolution on display. One wants to 
see movie on full screen, this is resolution 1280 x 720.

7. ioctl(fd = HDMI, S_FMT, v4l2_format { .type = OUTPUT,
   .pixelformat=FMT_NV12T, .height = full_height, .width = full_width })
8. Allocate buffers using REQBUF
9. Queue buffers and start streaming and so on.

In such a case, MFC creates buffer of size 384 x 256. Only subimage of 
size 320 x 240 contains movie frame. All padding pixels are filled with 
zeros. The output image 384 x 256 is passed to HDMI which is an V4L2 
output device. Zeroed pixels in YCrCr color space it an ugly green 
color. Such an ugly color is seen on output display.

And here comes the problem.

---------------------------------------------------------------

How to eliminate those ugly padding pixels from display output?

---------------------------------------------------------------

I think that possible solution to such a problem would be introducing 
new functionality called buffer crop. Please look at figures below. 
Figure 1 is similar to image 1.1 from V4L2 documentation:
http://www.linuxtv.org/downloads/v4l-dvb-apis/crop.html#crop-scale.
The value bounds.* refer to v4l2_cropcap.bounds. These values describe 
limits for cropping at output. The values c.* refer to v4l2_crop.c and 
describe active area on output device. Figure 2 depicts new feature 
called buffer crop. The image sizes pix.width and pix.height are 
configured using VIDIOC_S_FMT ioctl. The values bc.* define cropping 
rectangle in buffer. Only pixels inside IMAGE DATA rectangle are 
written/read during streaming. Only these pixels should be passed
to HDMI output. All other pixels are left untouched.

       bounds.width
   +--------------------+
   |                    |
  b| (c.left, c.top)    |
  o|       /            |
  u|      /             |
  n|     / c.width      |
  d|    +---------+     |
  s|  c |         |     |
  .|  . |         |     |
  h|  h |         |     |
  e|  e |  IMAGE  |     |
  i|  i |   DATA  |     |
  g|  g |         |     |
  h|  h |         |     |
  t|  t +---------+     |
   |                    |
   |                    |
   +--------------------+

Fig 1. Data on display.


       pix.width
  +-----------------------+
  |                       |
  |(bc.left, bc.top)      |
p|        \              |
i|         \  bc.width   |
x|          +---------+  |
.|         b|         |  |
h|         c|         |  |
e|         .|         |  |
i|         h|  IMAGE  |  |
g|         e|   DATA  |  |
h|         i|         |  |
t|         g|         |  |
  |         h|         |  |
  |         t+---------+  |
  |                       |
  |                       |
  +-----------------------+

Fig 2. Data in buffer.

Going back to above-mentioned scenario described.  In order to avoid 
showing ugly pixels on output display one would configure buffer crop 
with value { left = 0, top = 0, width = 320, height = 240}. The driver 
would automatically adjust all values to accepted limits, align and 
scaling factors. For hw I possess no such changes need to be applied.

The only problem is passing such a buffer crop to driver by V4L2 api.
I considered a few solutions.

1. Use existing API.
Use bytesperline field in struct v4l2_pix_format to configure real width 
of image data. Additionally one would have to compute proper pointer in
v4l2_buffer.m.userptr to simulate left/top offsets. Unfortunately, value
bytesperline has little meaning for macroblock formats, because there is 
no such a thing like 'Distance in bytes between the leftmost pixels in 
two adjacent lines'. Pixels are not ordered linearly. Better definition 
of bytesperline has to be stated. Computing proper pointer to pixel for 
image in macroblock format would be possible only for very small set of 
coordinates. It may involve complex and error-prone computations.

What about more complex formats like JPEG? It is not possible to compute 
a pointer without decompressing image, and parsing it, and applying 
modification to data before passing buffer by VIDIOC_QBUF. It is not 
possible to perform such cropping even though it is support in hardware.

2. Use existing API. Version II.
The v4l2_crop structure lacks any free place for extensions. It is quite 
often that a device supports only one buffer type. Then other buffer 
types could be passed in v4l2_crop.type. For example passing 
V4L2_BUF_TYPE_VIDEO_OVERLAY for devices that support only 
V4L2_BUF_TYPE_VIDEO_OUTPUT would indicate configuration of buffer crop. 
I heard some rumour that Nokia once used this solution. For M2M devices 
buffer cropping in OUTPUT buffer is configured by setting crop on 
CAPTURE buffer and vice-versa.

3. Introduce new ioctl.
New ioctl called VIDIOC_S_BUFCROP would be used to configure buffer 
cropping. It would use exactly the same parameters as VIDIOC_S_CROP. 
Additionally VIDIOC_S_BUFCROPCAP would be added. It would be used to 
inform application about possible cropping in buffer data. Ioctl 
VIDIOC_G_BUFCROP would return current configuration of cropping. If 
driver does not support buffer cropping then ioctl would return {left = 
0, top = 0, width = image_width, height = image_height}.

4. Introduce new ioctl. Version II
There was much discussion on scaling configuration by V4L2 api. Please 
look to post:
http://thread.gmane.org/gmane.linux.drivers.video-input-infrastructure/27581/focus=28243
It was stated there that atomic crop/format configuration is needed. I 
thought that it would be a good idea to kill two birds using one stone. 
I mean setting both normal crop and buffer crop at the same time. Usage 
of buffer cropping may help to avoid changing image format. So following 
structure is proposed. It is passed to driver with new VIDIOC_S_CROP2 ioctl.

struct v4l2_crop2 {
	u32 type; /* buffer type */
	struct v4l2_crop c; /* crop in hw configured by S_CROP ioctl */
	struct v4l2_crop b; /* crop in buffer */
	u32 hint; /* hints for driver for crop adjustments */
	u32 reserved[?]; /* place for possible extensions */
};

Hint would be bit flags that Exemplary hint might be 
V4L2_CROP_HINT_B_WIDTH_UP, which would prevent driver from lowering 
width of buffer cropping. Keeping height on c crop fixed could be 
achieved by (V4L2_CROP_HINT_C_HEIGHT_UP | V4L2_CROP_HINT_C_HEIGHT_DOWN). 
Other hint might be V4L2_CROP_HINT_FMT_FIXED that would imply keeping 
width and height of image fixed. The driver would use hints to adjust 
cropping according both to application and hardware restriction
simultaneously.

What it your opinion about proposed solutions?

Looking for a reply,

Best regards,
Tomasz Stanislawski




