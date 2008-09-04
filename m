Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx2.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m84MrLrt014898
	for <video4linux-list@redhat.com>; Thu, 4 Sep 2008 18:53:21 -0400
Received: from mail1.radix.net (mail1.radix.net [207.192.128.31])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m84Mr8KP019423
	for <video4linux-list@redhat.com>; Thu, 4 Sep 2008 18:53:08 -0400
From: Andy Walls <awalls@radix.net>
To: "B. Bogart" <ben@ekran.org>
In-Reply-To: <48C05DC8.5060700@ekran.org>
References: <48C05DC8.5060700@ekran.org>
Content-Type: multipart/mixed; boundary="=-++kIrR444FRyeUSNLNDQ"
Date: Thu, 04 Sep 2008 18:51:27 -0400
Message-Id: <1220568687.2736.12.camel@morgan.walls.org>
Mime-Version: 1.0
Cc: video4linux-list@redhat.com, gem-dev@iem.at
Subject: Re: V4l2 :: Debugging an issue with cx8800 card.
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>


--=-++kIrR444FRyeUSNLNDQ
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

On Thu, 2008-09-04 at 15:14 -0700, B. Bogart wrote:
> Hello all,
> 
> This issue has been lagging for years and I wanted to get some expert
> advice on debugging it. It seems I'm the only one with a cx8800 card
> that is having problems so I hope to take the challenge up and propose a
> solution to the maintainer.
> 
> So the software I'm using is GEM. It has v4l2 support, and works fine
> with my bt848 card. Problem is I can't get things working properly with
> my cx8800 cards.
> 
> First HW info:
> 
> lspci reports my tuner as:
> 
> 00:0d.0 Multimedia video controller: Conexant CX23880/1/2/3 PCI Video
> and Audio Decoder (rev 05)
> 
> The card is branded as a Leadtek Winfast 2000XP Expert.
> 
> I'm sure the problem is with the v4l2 implementation in Gem as running
> the following command gives me perfect video on this card at 640x480:
> 
> mplayer tv:// -tv driver=v4l2:device=/dev/video0:input=1:norm=NTSC-M
> 
> (the output follows this message).
> 
> So the card is capable of 640x480.
> 
> If I run Gem on this card as 320x240 all works fine. (pictured in
> attachment 320x240.png)
> 
> As soon as I change the resolution to 640x480 I get the following errors
> repeated:
> 
> VIDIOCMCAPTURE1: Invalid argument
> VIDIOCMCAPTURE2: Invalid argument
> 
> And the image appears as in attachment 640x480.png
> 
> What should my steps for debugging be?
> 
> Is there dead-simple v4l2 example source (including output so I can
> confirm its working) I can test with and compare with Gem sources?

I am not a V4L2 app programmer.

However, I have attached a program I wrote a while ago to exercise the
cx18 driver and HVR-1600 as MythTV would opening an ivtv/cx18 based
card.  The cx88 probably won't support the MPEG ioctls but I think the
program is a pretty simple example of how to set up a v4l2 device and
capture data.

You might want to look at the set_picture_size() call.

The V4L2 API document can be found at linuxtv.org, if you need further
documentation on the ioctl()s.

Regards,
Andy

> Any advice appreciated.
> 
> B. Bogart
> 
> 
> --
> Here is the mplayer output:
> 
> MPlayer dev-SVN-r26940
> CPU: AMD Athlon(tm) 64 Processor 3200+ (Family: 15, Model: 47, Stepping: 0)
> CPUflags:  MMX: 1 MMX2: 1 3DNow: 1 3DNow2: 1 SSE: 1 SSE2: 1
> Compiled with runtime CPU detection.
> Can't open joystick device /dev/input/js0: No such file or directory
> Can't init input joystick
> mplayer: could not connect to socket
> mplayer: No such file or directory
> Failed to open LIRC support. You will not be able to use your remote
> control.
> 
> Playing tv://.
> TV file format detected.
> Selected driver: v4l2
>  name: Video 4 Linux 2 input
>  author: Martin Olschewski <olschewski@zpr.uni-koeln.de>
>  comment: first try, more to come ;-)
> Selected device: Leadtek Winfast 2000XP Expert
>  Tuner cap:
>  Tuner rxs:
>  Capabilites:  video capture  VBI capture device  tuner  read/write
> streaming
>  supported norms: 0 = PAL-BG; 1 = PAL-DK; 2 = PAL-I; 3 = PAL-M; 4 =
> PAL-N; 5 = PAL-Nc; 6 = PAL-60; 7 = NTSC-M; 8 = NTSC-M-JP; 9 = NTSC-443;
> 10 = SECAM-DK; 11 = SECAM-L;
>  inputs: 0 = Television; 1 = Composite1; 2 = S-Video;
>  Current input: 1
>  Current format: BGR24
> v4l2: current audio mode is : MONO
> v4l2: ioctl set format failed: Invalid argument
> v4l2: ioctl set format failed: Invalid argument
> open: No such file or directory
> [MGA] Couldn't open: /dev/mga_vid
> open: No such file or directory
> [MGA] Couldn't open: /dev/mga_vid
> [VO_TDFXFB] Can't open /dev/fb0: No such file or directory.
> s3fb: can't open /dev/fb0: No such file or directory
> ==========================================================================
> Opening video decoder: [raw] RAW Uncompressed Video
> VDec: vo config request - 640 x 480 (preferred colorspace: Packed UYVY)
> VDec: using Packed UYVY as output csp (no 0)
> Movie-Aspect is undefined - no prescaling applied.
> VO: [xv] 640x480 => 640x480 Packed UYVY
> Selected video codec: [rawuyvy] vfm: raw (RAW UYVY)
> ==========================================================================
> Audio: no sound
> Starting playback...
> v4l2: 40 frames successfully processed, -39 frames dropped.
> 
> Exiting... (Quit)
> 
> --
> video4linux-list mailing list
> Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
> https://www.redhat.com/mailman/listinfo/video4linux-list

--=-++kIrR444FRyeUSNLNDQ
Content-Disposition: attachment; filename=pollcx18.c
Content-Type: text/x-csrc; name=pollcx18.c; charset=utf8
Content-Transfer-Encoding: 7bit

/*
 * pollcx18 - exercise the cx18 driver in a manner similar to MythTV
 * Copyright (C) 2008 Andy Walls
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
 *
 * Author: Andy Walls <cwalls@radix.net>
 *
 * Compile: gcc -Wall -O2 -o pollcx18 pollcx18.c
 *
 * Invoke:  ./pollcx18 -d /dev/video1 -o foo.mpg
 *
 * To see the cx23418 encoder stall out for a while and a select() timeout,
 * cx18_v4l2_enc_poll() should be modified not to check q_io, and you should
 * tune to and away from a weak, snowy TV station (but not one that's all snow)
 */

#include <unistd.h>
#include <stdio.h>
#include <stdlib.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <signal.h>
#include <sys/select.h>
#include <errno.h>
#include <string.h>
#include <sys/ioctl.h>
#include <linux/videodev2.h>

struct parsed_args
{
	char *devpath;
	char *outfile;
};

static int quit = 0;

void sig_handler (int signum, siginfo_t *info, void *ucontext)
{
	quit = 1;
}

int parse_args (int argc, char **argv, struct parsed_args *args)
{
	int c, retval;

	args->devpath = "/dev/video";
	args->outfile = NULL;
	retval = 0;
	while ((c = getopt(argc, argv, "d:o:")) != -1)
	{
		switch (c)
		{
			case 'd':
				args->devpath = optarg;
				break;
			case 'o':
				args->outfile = optarg;
				break;
			default:
				fprintf (stderr, "Usage:\npollcx18 [-d videodev] [-o outfile]\n");
				retval = -1;
				break;
		}
	}
	return retval;
}

void mainloop (int *readfd, int outfd, int *quit, char *devpath)
{
	const int bufsize = 4 * 1024; /* 4 kB is what MythTV uses */
	char buffer[bufsize];
	int bytesused, n;

	/* Set retry limit to > 0 to try a few times before closing and
	 * reopening the fd on a select() timeout */
	const int retry_limit = 0;
	int retries;
	int got_data;

	int nfds;
	struct timeval timeout;
	fd_set rfds;

	retries = 0;
	got_data = 0;
	bytesused = 0;
	while (!(*quit))
	{
		/* 
 		 * Attempt to reopen the capture device like MythTV, since
 		 * we may close it later in this loop on timeout, like MythTV
 		 *
 		 * We reopen it without O_NONBLOCK, as does MythTV,
 		 * but that's really a MythTV bug.  We should really reopen with
 		 * O_NONBLOCK set.
 		 *
 		 */
		if (*readfd < 0)
		{ 
			if ((*readfd =
			             open(devpath, O_RDWR /*|O_NONBLOCK*/)) < 0)
			{
				perror("open");
				fprintf(stderr,
			        "Unable to re-open video capture device: %s\n",
		                	devpath);
				*quit = 1;
				break;
			}
			else
			{
				got_data = 0;
				retries = 0;
			}
		}

		FD_ZERO(&rfds);
		FD_SET(*readfd, &rfds);
		timeout.tv_sec  = 5;  /* MythTV uses 5 seconds */
		timeout.tv_usec = 0;
		nfds = *readfd + 1;

		nfds = select (nfds, &rfds, NULL, NULL, &timeout);

		switch (nfds)
		{
			case -1:
				if (errno == EINTR)
					continue;

				perror("select");
				fprintf(stderr, "select failed on video "
				        "capture device: %s\n",
		                        devpath);
				*quit = 1;
				retries++; /* this doesn't matter for now */
				continue;

			case 0:
				fprintf(stderr, "select timeout on video "
				        "capture device: %s\n",
		                        devpath);
				/*
 				 * MythTV tries to fix things by closing and
 				 * reopening the readfd
 				 *
 				 * Well do few retries before doing so.
 				 */
				retries++;
				if (retries >= retry_limit)
				{
					close(*readfd);
					*readfd = -1;
					retries = 0;
					got_data = 0;
				}
				continue;

			default:
				break;
		}

		retries = 0;

		n = read(*readfd, &(buffer[bytesused]), bufsize-bytesused);
		if (n == -1 && errno != EAGAIN && errno != EINTR)
		{
			perror("read");
			fprintf(stderr,
			        "read failed on video capture device: %s\n",
		                devpath);
			*quit = 1;
		}
		if (n > 0)
		{
			bytesused += n;
			if (got_data == 0)
			{
				fprintf(stderr,
			          "received data on video capture device: %s\n",
		                  devpath);
				got_data = 1;
			}
				
		}
		if (bytesused >= bufsize)
		{
			if (outfd > -1)
				write(outfd, buffer, bufsize);
			bytesused = 0;
		}
	}

	/* write out the final partially filled buffer */
	if (bytesused > 0 && outfd > -1)
		write(outfd, buffer, bytesused);

	return;
}

int set_picture_size (int chanfd, int width, int height, char *devpath)
{
	struct v4l2_format f;

	memset (&f, 0, sizeof (f));
	f.type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
	if (ioctl(chanfd, VIDIOC_G_FMT, &f) < 0)
	{
		perror ("ioctl");
		fprintf (stderr, "couldn't get video format for device %s\n",
		         devpath);
		return -1;
	}

	f.fmt.pix.width = width;
	f.fmt.pix.height = height;

	if (ioctl(chanfd, VIDIOC_S_FMT, &f) < 0)
	{
		perror("ioctl");
		fprintf(stderr, "couldn't get video format for device %s\n",
		         devpath);
		return -1;
	}
	return 0;
}

int set_volume (int chanfd, int level, char *devpath)
{
	struct v4l2_control c;

	c.id = V4L2_CID_AUDIO_VOLUME;
	c.value = (65536*level)/100;
	if (ioctl(chanfd, VIDIOC_S_CTRL, &c) < 0)
	{
		perror("ioctl");
		fprintf(stderr, "couldn't set audio volume for device %s\n",
		        devpath);
		return -1;
	}
	return 0;
}

int set_audio_fs (int chanfd, int rate, char *devpath)
{
	struct v4l2_ext_controls e;
	struct v4l2_ext_control c;

	memset(&e, 0, sizeof(e));
	memset(&c, 0, sizeof(c));

	e.ctrl_class = V4L2_CTRL_CLASS_MPEG;
	e.count = 1;
	e.controls = &c;

	c.id = V4L2_CID_MPEG_AUDIO_SAMPLING_FREQ;
	switch (rate)
	{
		case 32000:
			c.value = V4L2_MPEG_AUDIO_SAMPLING_FREQ_32000;
			break;
		case 44100:
			c.value = V4L2_MPEG_AUDIO_SAMPLING_FREQ_44100;
			break;
		case 48000:
		default:
			c.value = V4L2_MPEG_AUDIO_SAMPLING_FREQ_48000;
			break;
	}

	if (ioctl(chanfd, VIDIOC_S_EXT_CTRLS, &e) < 0)
	{
		perror("ioctl");
		fprintf(stderr,
			"couldn't set audio sample rate for device %s\n",
		        devpath);
		return -1;
	}
	return 0;
}

int set_aspect_ratio (int chanfd, enum v4l2_mpeg_video_aspect aspect,
                      char *devpath)
{
	struct v4l2_ext_controls e;
	struct v4l2_ext_control c;

	memset(&e, 0, sizeof(e));
	memset(&c, 0, sizeof(c));

	e.ctrl_class = V4L2_CTRL_CLASS_MPEG;
	e.count = 1;
	e.controls = &c;

	c.id = V4L2_CID_MPEG_VIDEO_ASPECT;
	c.value = aspect;
	if (ioctl(chanfd, VIDIOC_S_EXT_CTRLS, &e) < 0)
	{
		perror("ioctl");
		fprintf(stderr, "couldn't set aspect ratio for device %s\n",
		        devpath);
		return -1;
	}
	return 0;
}

int set_audio_encoding (int chanfd, enum v4l2_mpeg_audio_encoding encoding,
                        char *devpath)
{
	struct v4l2_ext_controls e;
	struct v4l2_ext_control c;

	memset(&e, 0, sizeof(e));
	memset(&c, 0, sizeof(c));

	e.ctrl_class = V4L2_CTRL_CLASS_MPEG;
	e.count = 1;
	e.controls = &c;

	c.id = V4L2_CID_MPEG_AUDIO_ENCODING;
	c.value = encoding;
	if (ioctl(chanfd, VIDIOC_S_EXT_CTRLS, &e) < 0)
	{
		perror("ioctl");
		fprintf(stderr, "couldn't set audio encoding for device %s\n",
		        devpath);
		return -1;
	}
	return 0;
}

int set_audio_bitrate (int chanfd, enum v4l2_mpeg_audio_l2_bitrate rate,
                        char *devpath)
{
	struct v4l2_ext_controls e;
	struct v4l2_ext_control c;

	memset(&e, 0, sizeof(e));
	memset(&c, 0, sizeof(c));

	e.ctrl_class = V4L2_CTRL_CLASS_MPEG;
	e.count = 1;
	e.controls = &c;

	c.id = V4L2_CID_MPEG_AUDIO_L2_BITRATE;
	c.value = rate;
	if (ioctl(chanfd, VIDIOC_S_EXT_CTRLS, &e) < 0)
	{
		perror("ioctl");
		fprintf(stderr, "couldn't set audio encoding for device %s\n",
		        devpath);
		return -1;
	}
	return 0;
}

int set_video_bitrates (int chanfd, int peak, int nominal, char *devpath)
{
	struct v4l2_ext_controls e;
	struct v4l2_ext_control c[2];

	memset(&e, 0, sizeof(e));
	memset(&c, 0, sizeof(struct v4l2_ext_control)*2);

	e.ctrl_class = V4L2_CTRL_CLASS_MPEG;
	e.count = 2;
	e.controls = c;

	c[0].id = V4L2_CID_MPEG_VIDEO_BITRATE_PEAK;
	c[0].value = peak;
	c[1].id = V4L2_CID_MPEG_VIDEO_BITRATE;
	c[1].value = nominal;
	if (ioctl(chanfd, VIDIOC_S_EXT_CTRLS, &e) < 0)
	{
		perror("ioctl");
		fprintf(stderr, "couldn't set video bitrates for device %s\n",
		        devpath);
		return -1;
	}
	return 0;
}

int set_streamtype (int chanfd, enum v4l2_mpeg_stream_type type, char *devpath)
{
	struct v4l2_ext_controls e;
	struct v4l2_ext_control c;

	memset(&e, 0, sizeof(e));
	memset(&c, 0, sizeof(c));

	e.ctrl_class = V4L2_CTRL_CLASS_MPEG;
	e.count = 1;
	e.controls = &c;

	c.id = V4L2_CID_MPEG_STREAM_TYPE;
	c.value = type;
	if (ioctl(chanfd, VIDIOC_S_EXT_CTRLS, &e) < 0)
	{
		perror("ioctl");
		fprintf(stderr, "couldn't set stream type for device %s\n",
		        devpath);
		return -1;
	}
	return 0;
}

int setup_vbi (int chanfd, int vbitype, char *devpath)
{
	struct v4l2_format f;
	struct v4l2_ext_controls e;
	struct v4l2_ext_control c;

	memset (&f, 0, sizeof (f));

	f.type = V4L2_BUF_TYPE_SLICED_VBI_CAPTURE;
	f.fmt.sliced.service_set = vbitype;
	if (ioctl(chanfd, VIDIOC_S_FMT, &f) < 0)
	{
		perror("ioctl");
		fprintf(stderr, "couldn't enable vbi for device %s\n",
		        devpath);
		return -1;
	}

	memset(&e, 0, sizeof(e));
	memset(&c, 0, sizeof(c));

	e.ctrl_class = V4L2_CTRL_CLASS_MPEG;
	e.count = 1;
	e.controls = &c;

	c.id = V4L2_CID_MPEG_STREAM_VBI_FMT;
	c.value = V4L2_MPEG_STREAM_VBI_FMT_IVTV;
	if (ioctl(chanfd, VIDIOC_S_EXT_CTRLS, &e) < 0)
	{
		perror("ioctl");
		fprintf(stderr,
		        "couldn't set vbi stream format for device %s\n",
		        devpath);
		return -1;
	}
	return 0;
}

int main (int argc, char **argv)
{
	int chanfd, readfd, outfd;
	struct parsed_args args;
	struct sigaction sigact;

	if (parse_args(argc, argv, &args) < 0)
		exit(1);
	
	outfd = -1;
	if (args.outfile != NULL && 
	    (outfd = open(args.outfile, O_WRONLY|O_CREAT|O_TRUNC, 0660)) < 0)
	{
		perror("open");
		fprintf(stderr, "Unable to open output file: %s\n",
		        args.outfile);
	}

	/* MythTV would use this fd for controlling the capture device */
	if ((chanfd = open(args.devpath, O_RDWR)) < 0)
	{
		perror("open");
		fprintf(stderr, "Unable to open video control device: %s\n",
		        args.devpath);
		exit(2);
	}

	/* Setup like MythTV does on my NTSC-M system */
	set_picture_size   (chanfd, 704, 480,                   args.devpath);
	set_volume         (chanfd, 90,                         args.devpath);
	set_audio_fs       (chanfd, 48000,                      args.devpath);
	set_aspect_ratio   (chanfd, V4L2_MPEG_VIDEO_ASPECT_4x3, args.devpath);
	set_audio_encoding (chanfd, V4L2_MPEG_AUDIO_ENCODING_LAYER_2,
	                                                        args.devpath);
	set_audio_bitrate  (chanfd, V4L2_MPEG_AUDIO_L2_BITRATE_384K,
	                                                        args.devpath);
	set_video_bitrates (chanfd, 6000000, 4500000,           args.devpath);
	set_streamtype     (chanfd, V4L2_MPEG_STREAM_TYPE_MPEG2_PS,
	                                                        args.devpath);
	/*
  	 * This vbi setup makes the difference between the encoder permanently
  	 * stalling or not
	*/
	setup_vbi          (chanfd, V4L2_SLICED_VBI_525,        args.devpath);

	/* MythTV would use this fd for video capture */
	if ((readfd = open(args.devpath, O_RDWR|O_NONBLOCK)) < 0)
	{
		perror("open");
		fprintf(stderr, "Unable to open video capture device: %s\n",
		        args.devpath);
		exit(3);
	}

	sigact.sa_flags = SA_SIGINFO;
	sigact.sa_sigaction = sig_handler;
	sigemptyset(&(sigact.sa_mask));
	sigaction(SIGINT, &sigact, NULL);  /* handle ^C to do a graceful exit */

	quit = 0;
	mainloop(&readfd, outfd, &quit, args.devpath);

	close(readfd);
	close(chanfd);
	close(outfd);

	exit(0);
}

--=-++kIrR444FRyeUSNLNDQ
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
--=-++kIrR444FRyeUSNLNDQ--
