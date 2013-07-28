Return-path: <linux-media-owner@vger.kernel.org>
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:5551 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752159Ab3G1WA2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 28 Jul 2013 18:00:28 -0400
Received: from [172.20.0.43] (vlan0.orion.intree.net [96.11.231.210])
	(using TLSv1 with cipher DHE-RSA-CAMELLIA256-SHA (256/256 bits))
	(No client certificate requested)
	by conserv.silverdirk.com (Postfix) with ESMTPSA id 6F159800A1A
	for <linux-media@vger.kernel.org>; Sun, 28 Jul 2013 18:00:31 -0400 (EDT)
Message-ID: <51F59481.6050300@nrdvana.net>
Date: Sun, 28 Jul 2013 18:00:33 -0400
From: Michael Conrad <mike@nrdvana.net>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: Green/purple video from 950Q + security cam
Content-Type: multipart/mixed;
 boundary="------------060002000800030404020309"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is a multi-part message in MIME format.
--------------060002000800030404020309
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Hi,

I have a WinTV-HVR-950Q which I am using to capture composite video.  I 
have two cameras: a rear-view cam for a car, and a security camera.

When I plug either of these cameras into the video plug on a plain old 
TV, they work great.  When I plug either camera into the 950Q on Windows 
using the supplied WinTV software, they work great.  When I plug the 
rear-view camera into the 950Q on Linux, it works great.  But when I 
plug the security camera into 950Q on Linux, it mostly works and then 
the picture starts randomly jumping sideways (like it is having trouble 
keeping a horizontal sync on the signal) and then will suddenly flip to 
a green-grayscale image with all bright areas as purple-grayscale.  Once 
turned green/purple, it remains like this until I reset the camera, but 
the video is full framerate, low latency, and looks flawless aside from 
the bizarre colors.

For the tests under Linux, I am using the v4l2 API directly in a simple 
demo C program I wrote.  It is attached.  I tried both the "read" API, 
and the mmap API.  Both produce identical results.

My other attempts on Linux had been to use v4l2-ctl to select the 
composite channel, and then play the device with VLC or Cheese.  Neither 
were successful (no video at all) but I need to do this from C in the 
long run, anyway.

Anyone seen anything like this before?

Thanks in advance.
-Mike

------------

Some details:

Linux Mint 12, 3.0.0-12-generic #20-Ubuntu SMP Fri Oct 7 14:56:25 UTC 
2011 x86_64 x86_64 x86_64 GNU/Linux

Bus 001 Device 007: ID 2040:7200 Hauppauge
Device Descriptor:
   bLength                18
   bDescriptorType         1
   bcdUSB               2.00
   bDeviceClass            0 (Defined at Interface level)
   bDeviceSubClass         0
   bDeviceProtocol         0
   bMaxPacketSize0        64
   idVendor           0x2040 Hauppauge
   idProduct          0x7200
   bcdDevice            0.05
   iManufacturer           1
   iProduct                2
   iSerial                10
   bNumConfigurations      1

Relevant loaded modules:

tuner                  27428  1
au8522                 27916  2
au0828                 48363  0
dvb_core              110616  1 au0828
videobuf_vmalloc       13589  1 au0828
videobuf_core          26390  2 au0828,videobuf_vmalloc
tveeprom               21249  1 au0828
v4l2_common            16454  3 tuner,au8522,au0828
videodev               93004  4 tuner,au8522,au0828,v4l2_common
v4l2_compat_ioctl32    17083  1 videodev

Relevant kernel messages (only from bootup, nothing new shows while playing)

[   10.467852] Linux video capture interface: v2.00
[   10.677764] au0828 driver loaded
[   11.036080] au0828: i2c bus registered
[   11.294654] tveeprom 0-0050: Hauppauge model 72001, rev B4F0, serial# 
8455749
[   11.294658] tveeprom 0-0050: MAC address is 00:0d:fe:81:06:45
[   11.294661] tveeprom 0-0050: tuner model is Xceive XC5000 (idx 150, 
type 76)
[   11.294664] tveeprom 0-0050: TV standards NTSC(M) ATSC/DVB Digital 
(eeprom 0x88)
[   11.294666] tveeprom 0-0050: audio processor is AU8522 (idx 44)
[   11.294669] tveeprom 0-0050: decoder processor is AU8522 (idx 42)
[   11.294672] tveeprom 0-0050: has no radio, has IR receiver, has no IR 
transmitter
[   11.294674] hauppauge_eeprom: hauppauge eeprom: model=72001
[   11.321442] nvidia: module license 'NVIDIA' taints kernel.
[   11.321446] Disabling lock debugging due to kernel taint
[   12.006495] nvidia 0000:01:00.0: PCI INT A -> GSI 16 (level, low) -> 
IRQ 16
[   12.006503] nvidia 0000:01:00.0: setting latency timer to 64
[   12.006508] vgaarb: device changed decodes: 
PCI:0000:01:00.0,olddecodes=io+mem,decodes=none:owns=io+mem
[   12.006583] NVRM: loading NVIDIA UNIX x86_64 Kernel Module  280.13 
Wed Jul 27 16:53:56 PDT 2011
[   12.020865] au8522 0-0047: creating new instance
[   12.020867] au8522_decoder creating new instance...
[   12.061240] i2c-core: driver [tuner] using legacy suspend method
[   12.061242] i2c-core: driver [tuner] using legacy resume method
[   12.061662] tuner 0-0061: Tuner -1 found with type(s) Radio TV.
[   12.089530] xc5000 0-0061: creating new instance
[   12.094274] xc5000: Successfully identified at address 0x61
[   12.094277] xc5000: Firmware has not been loaded previously
[   12.094536] au8522 0-0047: attaching existing instance
[   12.101901] xc5000 0-0061: attaching existing instance
[   12.112396] xc5000: Successfully identified at address 0x61
[   12.112398] xc5000: Firmware has not been loaded previously
[   12.112400] DVB: registering new adapter (au0828)
[   12.112402] DVB: registering adapter 0 frontend 0 (Auvitek AU8522 
QAM/8VSB Frontend)...
[   12.112699] Registered device AU0828 [Hauppauge HVR950Q]
[   12.631925] usbcore: registered new interface driver snd-usb-audio
[   12.632064] usbcore: registered new interface driver au0828

Output from my program:

Driver : au0828
Card   : Hauppauge HVR950Q
Bus    : au0828 1-5.1.2:1.0
Version: 0.0.1
Caps   : V4L2_CAP_VIDEO_CAPTURE V4L2_CAP_VBI_CAPTURE V4L2_CAP_TUNER 
V4L2_CAP_AUDIO V4L2_CAP_READWRITE V4L2_CAP_STREAMING
Control 9963776: Brightness           (0-255) slider
Control 9963777: Contrast             (0-255) slider
Control 9963778: Saturation           (0-255) slider
Control 9963779: Hue                  (-32768-32768) slider
4 controls
Input Television: tuner 0  status:
Input Composite: camera status:
Input S-Video: camera status:
3 inputs.
Set input to 1 (new val = 1)
Current video standard: NTSC-M
Image Format: 720 x 480 UYVY field=4 pitch=1440 size=691200 colorspace=1
End of formats
Received 691200 bytes
... (repeated for each frame)

--------------060002000800030404020309
Content-Type: text/x-c++src;
 name="v4ltest.cpp"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="v4ltest.cpp"

//#include "config.h"
#include <SDL/SDL.h>
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>

#include <string.h>
#include <assert.h>

#include <fcntl.h>
#include <unistd.h>
#include <errno.h>

#include <malloc.h>
#include <sys/stat.h>
#include <sys/types.h>
#include <sys/time.h>
#include <sys/mman.h>
#include <sys/ioctl.h>

#include <asm/types.h>
#include <linux/videodev2.h>
typedef long long unsigned UINT64_C;
extern "C" {
#include <libavutil/avutil.h>
#include <libswscale/swscale.h>
}

#include <fcntl.h>
#include <sys/ioctl.h>

void showcaps(int fd);
void showcontrols(int fd);
void show_inputs(int fd);
void set_input(int fd, int idx);
void query_standard(int fd);
void query_imgfmt(int fd, v4l2_pix_format *fmt);
void query_formats(int fd);
bool show_frame(uint8_t *frame, PixelFormat fmt, int stride, int w, int h);
void init_mmap(int fd);
void* acquire_mmap_frame(int fd, struct v4l2_buffer *buffer);
void release_mmap_frame(int fd, struct v4l2_buffer *buffer);
void finalize_mmap(int fd);

uint8_t *framebuf;
uint8_t *rgbbuf;
struct mmap_buffer_item {
	void *start;
	size_t length;
	bool locked;
} *mmap_buffers= NULL;
int mmap_buffer_count= 0;

int main() {
	v4l2_pix_format fmt;
	struct v4l2_buffer buffer;
	//int lines;
	int got= 0;
	
	int fd= open("/dev/video0", O_RDWR);
	if (fd < 0) { perror("open(/dev/video0)"); exit(2); }
	
	showcaps(fd);
	showcontrols(fd);
	show_inputs(fd);
	
	set_input(fd, 1);
	query_standard(fd);
	query_imgfmt(fd, &fmt);
	query_formats(fd);
	printf("End of formats\n");
	
	int framesize= fmt.sizeimage;
	int imglines= fmt.height; // account for interlace
	//framebuf= (uint8_t*) malloc(framesize);
	//if (!framebuf) { perror("malloc"); return 1; }
	rgbbuf= (uint8_t*) malloc(fmt.width * imglines * 3);
	if (!rgbbuf) { perror("malloc"); return 1; }
	
	init_mmap(fd);
	while (1) {
		#if 0
		got= read(fd, framebuf, framesize);
		if (got < 0) { perror("read"); return 2; }
		#else
		framebuf= (uint8_t*) acquire_mmap_frame(fd, &buffer);
		got= framesize= buffer.bytesused;
		#endif
		printf("Received %d bytes\n", got);
	
	
		if (got != framesize) {
			printf("didn't get frame size\n");
		} else if (imglines * (int)fmt.bytesperline > framesize) {
			printf("frame not large enough for image\n");
		} else if (!show_frame(framebuf, PIX_FMT_UYVY422, fmt.bytesperline, fmt.width, imglines)) {
			abort();
		}
		
		release_mmap_frame(fd, &buffer);
	}
	
	//unlink("frame");
	//int out= open("frame", O_RDWR|O_CREAT, 777);
	//if (out < 0) { perror("open(frame)"); exit(2); }
	//write(out, framebuf, got);
	//close(out);

	close(fd);
	return 0;
}

struct SwsContext *convparam= NULL;
SDL_Surface *window= NULL;
SDL_Event event;

bool show_frame(uint8_t *frame, PixelFormat fmt, int stride, int w, int h) {
	if (!window) {
		if (SDL_Init(SDL_INIT_VIDEO) < 0) {
			fprintf(stderr, "Couldn't initialize SDL: %s\n", SDL_GetError());
			return false;
		}
		atexit(SDL_Quit);
		
		window = SDL_SetVideoMode(w, h, 24, SDL_SWSURFACE);
		if (!window) {
			fprintf(stderr, "Couldn't set create window: %s\n", SDL_GetError());
			return false;
		}
	}
	
	convparam= sws_getCachedContext(convparam, w, h, fmt, w, h, PIX_FMT_BGR24, SWS_BICUBIC, NULL, NULL, NULL);
	if (!convparam) {
		printf("Unable to convert image format\n");
		return false;
	}
	
	//void* pixels;
	//int pitch;
	if (SDL_LockSurface(window) < 0) {
		fprintf(stderr, "Couldn't lock texture: %s\n", SDL_GetError());
		return false;
	}
	
	uint8_t* s_data[4]= { frame, NULL, NULL, NULL };
	int s_linesize[4]= { stride, 0, 0, 0 };
	uint8_t* d_data[4]= { (uint8_t*)window->pixels, NULL, NULL, NULL };
	int d_linesize[4]= { window->pitch, 0, 0, 0 };
	sws_scale(convparam, s_data, s_linesize, 0, h, d_data, d_linesize);
	
	SDL_UnlockSurface(window);

	SDL_UpdateRect(window, 0, 0, w, h);

	bool done= false;
	while (SDL_PollEvent(&event)) {
		switch (event.type) {
		case SDL_KEYDOWN:
			if (event.key.keysym.sym == SDLK_ESCAPE) {
				done= true;
			}
			break;
		case SDL_QUIT:
			done= true;
			break;
		}
	}
	
	if (done) {
		SDL_Quit();
		window= NULL;
	}
	
	return true;
}

typedef struct {
	long long code;
	const char* name;
} const_entry_t;
/*const char * find_constant(struct const_entry_t *array, int array_len, int code) {
	for (int i=0; i<array_len; i++) {
		if (array[i].code == code)
			return array[i].name;
	}
	return "??";
}*/
#define ARRAY_LENGTH(array) ((int)(sizeof(array)/sizeof(*array)))
#define F(x) { x, #x }
static const_entry_t
v4l_cap_decode[]= {
	F(V4L2_CAP_VIDEO_CAPTURE),
	F(V4L2_CAP_VIDEO_OUTPUT),
	F(V4L2_CAP_VIDEO_OVERLAY),
	F(V4L2_CAP_VBI_CAPTURE),
	F(V4L2_CAP_VBI_OUTPUT),
	F(V4L2_CAP_SLICED_VBI_CAPTURE),
	F(V4L2_CAP_SLICED_VBI_OUTPUT),
	F(V4L2_CAP_RDS_CAPTURE),
	F(V4L2_CAP_VIDEO_OUTPUT_OVERLAY),
	F(V4L2_CAP_TUNER),
	F(V4L2_CAP_AUDIO),
	F(V4L2_CAP_RADIO),
	F(V4L2_CAP_READWRITE),
	F(V4L2_CAP_ASYNCIO),
	F(V4L2_CAP_STREAMING)
},
v4l_input_status[]= {
	F(V4L2_IN_ST_NO_POWER),
	F(V4L2_IN_ST_NO_SIGNAL),
	F(V4L2_IN_ST_NO_COLOR),
	F(V4L2_IN_ST_NO_H_LOCK),
	F(V4L2_IN_ST_COLOR_KILL),
	F(V4L2_IN_ST_NO_SYNC),
	F(V4L2_IN_ST_NO_EQU),
	F(V4L2_IN_ST_NO_CARRIER),
	F(V4L2_IN_ST_MACROVISION),
	F(V4L2_IN_ST_NO_ACCESS),
	F(V4L2_IN_ST_VTR),
},
v4l_vid_std[]= {
	F(V4L2_STD_PAL_B),
	F(V4L2_STD_PAL_B1),
	F(V4L2_STD_PAL_G),
	F(V4L2_STD_PAL_H),
	F(V4L2_STD_PAL_I),
	F(V4L2_STD_PAL_D),
	F(V4L2_STD_PAL_D1),
	F(V4L2_STD_PAL_K),
	F(V4L2_STD_PAL_M),
	F(V4L2_STD_PAL_N),
	F(V4L2_STD_PAL_Nc),
	F(V4L2_STD_PAL_60),
	F(V4L2_STD_NTSC_M),
	F(V4L2_STD_NTSC_M_JP),
	F(V4L2_STD_NTSC_443),
	F(V4L2_STD_NTSC_M_KR),
	F(V4L2_STD_SECAM_B),
	F(V4L2_STD_SECAM_D),
	F(V4L2_STD_SECAM_G),
	F(V4L2_STD_SECAM_H),
	F(V4L2_STD_SECAM_K),
	F(V4L2_STD_SECAM_K1),
	F(V4L2_STD_SECAM_L),
	F(V4L2_STD_SECAM_LC),
	F(V4L2_STD_ATSC_8_VSB),
	F(V4L2_STD_ATSC_16_VSB)
};
#undef F

void showcaps(int fd) {
	struct v4l2_capability caps;
	int ret= ioctl(fd, VIDIOC_QUERYCAP, &caps);
	if (ret < 0) { perror("ioctl(QUERYCAP)"); exit(2); }
	
	printf("Driver : %s\nCard   : %s\nBus    : %s\nVersion: %u.%u.%u\nCaps   :",
		caps.driver,
		caps.card,
		caps.bus_info,
		(caps.version>>16)&0xFF, (caps.version>>8)&0xFF, caps.version&0xFF);
	for (int i=0; i < ARRAY_LENGTH(v4l_cap_decode); i++) {
		if (caps.capabilities & v4l_cap_decode[i].code)
			printf(" %s", v4l_cap_decode[i].name);
	}
	printf("\n");
}

void showcontrols(int fd) {
	struct v4l2_queryctrl ctrl;
	int cnt= 0;
	for (int i=V4L2_CID_BASE; i < V4L2_CID_LASTP1; i++) {
		memset(&ctrl, 0, sizeof(ctrl));
		ctrl.id= i;
		int ret= ioctl(fd, VIDIOC_QUERYCTRL, &ctrl);
		if (ret < 0) {
			if (errno == EINVAL) continue;
			perror("ioctl(QUERYCTRL)"); exit(2);
		}
		cnt++;
		
		printf("Control %3d: %-20s (%d-%d)%s%s%s%s%s%s\n", i, ctrl.name, ctrl.minimum, ctrl.maximum,
			(ctrl.flags&V4L2_CTRL_FLAG_DISABLED)? " disabled":"",
			(ctrl.flags&V4L2_CTRL_FLAG_GRABBED)? " grabbed":"",
			(ctrl.flags&V4L2_CTRL_FLAG_READ_ONLY)? " r/o":"",
			(ctrl.flags&V4L2_CTRL_FLAG_UPDATE)? " update":"",
			(ctrl.flags&V4L2_CTRL_FLAG_INACTIVE)? " inact":"",
			(ctrl.flags&V4L2_CTRL_FLAG_SLIDER)? " slider":""
		);
	}
	printf("%d controls\n", cnt);
}

void show_inputs(int fd) {
	struct v4l2_input inp;
	int i= 0;
	while (1) {
		memset(&inp, 0, sizeof(inp));
		inp.index= i;
		int ret= ioctl(fd, VIDIOC_ENUMINPUT, &inp);
		if (ret < 0) {
			if (errno == EINVAL) break;
			perror("ioctl(ENUMINPUT)");
			exit(2);
		}
		i++;
		
		if (inp.type == V4L2_INPUT_TYPE_TUNER) {
			printf("Input %s: tuner %d  status:", inp.name, inp.tuner);
		} else if (inp.type == V4L2_INPUT_TYPE_CAMERA) {
			printf("Input %s: camera status:", inp.name);
		} else {
			printf("Input %s: (unknown) status:", inp.name);
		}
		for (int f= 0; f < ARRAY_LENGTH(v4l_input_status); f++) {
			if (inp.status & v4l_input_status[f].code)
				printf(" %s", v4l_input_status[i].name);
		}
		printf("\n");
	}
	printf("%d inputs.\n", i);
}

void set_input(int fd, int idx) {
	if (-1 == ioctl(fd, VIDIOC_S_INPUT, &idx)) {
		perror("VIDEOC_S_INPUT");
		exit(2);
	}
	int newVal= -1;
	if (-1 == ioctl(fd, VIDIOC_G_INPUT, &newVal)) {
		perror("VIDEOC_G_INPUT");
		exit(2);
	}
	printf("Set input to %d (new val = %d)\n", idx, newVal);
}

void query_standard(int fd) {
	v4l2_std_id std_id;
	struct v4l2_standard standard;

	if (-1 == ioctl (fd, VIDIOC_G_STD, &std_id)) {
			/* Note when VIDIOC_ENUMSTD always returns EINVAL this
			   is no video device or it falls under the USB exception,
			   and VIDIOC_G_STD returning EINVAL is no error. */

			perror ("VIDIOC_G_STD");
			exit (2);
	}

	memset (&standard, 0, sizeof (standard));
	standard.index = 0;

	while (0 == ioctl (fd, VIDIOC_ENUMSTD, &standard)) {
			if (standard.id & std_id) {
				   printf ("Current video standard: %s\n", standard.name);
				   return;
			}

			standard.index++;
	}
	printf("Unknown standard\n");
}

void query_formats(int fd) {
	v4l2_fmtdesc fmtd;
	int i=0;
	do {
		memset(&fmtd, 0, sizeof(fmtd));
		fmtd.index= i++;
		int ret= ioctl(fd, VIDIOC_ENUM_FMT, &fmtd);
		if (ret < 0) {
			if (errno == EINVAL) return;
			perror("ioctl(ENUM_FMT)");
		}
		
		printf("Pixel Format %s: type=%d flags=%d pixelformat=%d (%4.4s)\n", fmtd.description, fmtd.type, fmtd.flags, fmtd.pixelformat, (char*)&fmtd.pixelformat);
	} while (1);
}

void query_imgfmt(int fd, v4l2_pix_format *fmt) {
	v4l2_format vfmt;
	v4l2_pix_format *pix= &vfmt.fmt.pix;
	memset(&vfmt, 0, sizeof(vfmt));
	vfmt.type= V4L2_BUF_TYPE_VIDEO_CAPTURE;
	if (ioctl(fd, VIDIOC_G_FMT, &vfmt) < 0) {
		perror("ioctl(G_FMT)");
		exit(1);
	}
	printf("Image Format: %d x %d %4.4s field=%d pitch=%d size=%d colorspace=%d\n",
		pix->width, pix->height, (char*)&pix->pixelformat, pix->field, pix->bytesperline, pix->sizeimage, pix->colorspace);
	
	if (fmt) memcpy(fmt, pix, sizeof(*fmt));
}

void init_mmap(int fd) {
	struct v4l2_requestbuffers reqbuf;
	struct v4l2_buffer buffer;
	unsigned int i;
	
	memset(&reqbuf, 0, sizeof(reqbuf));
	reqbuf.type= V4L2_BUF_TYPE_VIDEO_CAPTURE;
	reqbuf.memory= V4L2_MEMORY_MMAP;
	reqbuf.count= 8;
	
	if (-1 == ioctl(fd, VIDIOC_REQBUFS, &reqbuf)) {
		if (errno == EINVAL)
			printf("Video capturing or mmap-streaming is not supported\n");
		else
			perror("VIDIOC_REQBUFS");

		exit(2);
	}
	
	/* We want at least five buffers. */
	mmap_buffer_count= reqbuf.count;
	if (mmap_buffer_count < 5) {
		/* You may need to free the buffers here. */
		printf("Not enough buffer memory\n");
		exit(2);
	}

	mmap_buffers= (struct mmap_buffer_item*) realloc(mmap_buffers, mmap_buffer_count * sizeof(*mmap_buffers));
	assert(mmap_buffers != NULL);
	memset(mmap_buffers, 0, mmap_buffer_count * sizeof(*mmap_buffers));

	for (i = 0; i < mmap_buffer_count; i++) {
		memset(&buffer, 0, sizeof(buffer));
		buffer.type= reqbuf.type;
		buffer.memory= V4L2_MEMORY_MMAP;
		buffer.index= i;

		if (-1 == ioctl(fd, VIDIOC_QUERYBUF, &buffer)) {
			perror("VIDIOC_QUERYBUF");
			exit(2);
		}
		
		mmap_buffers[i].length= buffer.length; /* remember for munmap() */

		mmap_buffers[i].start= mmap(NULL, buffer.length,
			PROT_READ | PROT_WRITE, /* recommended */
			MAP_SHARED,             /* recommended */
			fd, buffer.m.offset);

		if (MAP_FAILED == mmap_buffers[i].start) {
			/* If you do not exit here you should unmap() and free()
			   the buffers mapped so far. */
			perror("mmap");
			exit(2);
		}
		
		if (-1 == ioctl(fd, VIDIOC_QBUF, &buffer)) {
			perror("VIDIOC_QBUF");
			exit(2);
		}
	}
}

void* acquire_mmap_frame(int fd, struct v4l2_buffer *buffer) {
	int i;
	
	memset(buffer, 0, sizeof(*buffer));
	buffer->type= V4L2_BUF_TYPE_VIDEO_CAPTURE;
	buffer->memory= V4L2_MEMORY_MMAP;
	buffer->index= i;
	if (-1 == ioctl(fd, VIDIOC_DQBUF, buffer)) {
		perror("VIDIOC_DQBUF");
		exit(2);
	}
	if (buffer->index < 0 || buffer->index >= mmap_buffer_count) {
		printf("Buffer index out of bounds! %d\n", buffer->index);
		exit(2);
	}
	return mmap_buffers[buffer->index].start;
}

void release_mmap_frame(int fd, struct v4l2_buffer *buffer) {
	if (-1 == ioctl(fd, VIDIOC_QBUF, buffer)) {
		perror("VIDIOC_QBUF");
		exit(2);
	}
}

void finalize_mmap(int fd) {
	int i;
	for (i = 0; i < mmap_buffer_count; i++)
		munmap(mmap_buffers[i].start, mmap_buffers[i].length);
	free(mmap_buffers);
	mmap_buffers= NULL;
}

--------------060002000800030404020309--
