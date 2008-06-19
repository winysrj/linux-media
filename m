Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m5J6kaIr001044
	for <video4linux-list@redhat.com>; Thu, 19 Jun 2008 02:46:36 -0400
Received: from an-out-0708.google.com (an-out-0708.google.com [209.85.132.249])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m5J6jxgB011013
	for <video4linux-list@redhat.com>; Thu, 19 Jun 2008 02:45:59 -0400
Received: by an-out-0708.google.com with SMTP id d31so158247and.124
	for <video4linux-list@redhat.com>; Wed, 18 Jun 2008 23:45:59 -0700 (PDT)
Date: Thu, 19 Jun 2008 16:48:33 +1000
From: Dmitri Belimov <d.belimov@gmail.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <20080619164833.645a3953@glory.loctelecom.ru>
In-Reply-To: <200806190824.15270.hverkuil@xs4all.nl>
References: <20080414114746.3955c089@glory.loctelecom.ru>
	<1213842219.2554.16.camel@pc10.localdom.local>
	<20080619153139.3ee379b4@glory.loctelecom.ru>
	<200806190824.15270.hverkuil@xs4all.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: video4linux-list@redhat.com, gert.vervoort@hccnet.nl,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: Beholder card M6 with MPEG2 coder
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

Hi Hans

> > > > I found next problems with empress :)))
> > > >
> > > > I can`t get via v4l2-ctl list of external control for control
> > > > MPEG settings via this tool. --list-ctrls and --list-ctrls-menus
> > > > In debug log I can see only one call empress_querycap nothink
> > > > vidioc_g_ext_ctrls/empress_g_ext_ctrls calls. Didn`t work
> > > > v4l2-ctl --log-status
> > >
> > > just a late/early note on this, I'm still without a working
> > > empress device.
> > >
> > > After you have fixed several bugs on the empress ioctl2
> > > conversion, you are still the first user after years and now hit
> > > mpeg extended controls, Hans from the ivtv project kindly
> > > introduced, but he is also without any such device and the stuff
> > > is completely untested.
> > >
> > > As far I know, there are no handlers yet to modify the parameters.
> >
> > Does this command work for ivtv cards?? Can somebody show me a
> > sample command line and output from ivtv (or from another card with
> > its own MPEG encoder)? I need to get control settings of MPEG.
> > I don't see how I can test this thing in Beholder.
> 
> Hmm, the empress is broken: the required queryctrl ioctls are
> completely missing.

Frederic was help me to writing simple programm for configuring MPEG.

This programm start_mpeg here:

#include <stdio.h>
#include <unistd.h>
#include <string.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <sys/ioctl.h>
#include <fcntl.h>
#include "linux/videodev.h"

int main(void){

/* sets mpeg parameters */
   struct v4l2_ext_controls mc;
   struct v4l2_ext_control ctrls[32];
   mc.ctrl_class = V4L2_CTRL_CLASS_MPEG;
   mc.controls = ctrls;
   int fd=0;
   char *device="/dev/video1";
   
   int i;

   int false;
 
   int m_iVideoBR;
   int m_iVideoMaxBR;
   int m_iVideoVBR;
   int m_iAudioBR;
   int m_uiAspectRatio;

   if ((fd = open(device, O_RDONLY)) < 0) {
     printf("Couldn't open video1\n");
		return(-1);
   }

   /* Test defines start */
   false  = 0;
   m_iVideoBR = 7500;
   m_iVideoMaxBR = 9200;
   m_iVideoVBR = 0;
   m_iAudioBR = 256;
   m_uiAspectRatio = 0;
   /* Test defines stop */
   i = 0;
   mc.ctrl_class = V4L2_CTRL_CLASS_MPEG;
   ctrls[i].id = V4L2_CID_MPEG_VIDEO_BITRATE_MODE;
   ctrls[i++].value = (m_iVideoVBR ? V4L2_MPEG_VIDEO_BITRATE_MODE_VBR : 
V4L2_MPEG_VIDEO_BITRATE_MODE_CBR);
   ctrls[i].id = V4L2_CID_MPEG_AUDIO_MUTE;
   ctrls[i++].value = false;
   ctrls[i].id = V4L2_CID_MPEG_VIDEO_MUTE;
   ctrls[i++].value = false;
//  ctrls[i].id = V4L2_CID_MPEG_AUDIO_SAMPLING_FREQ;
//  ctrls[i++].value = V4L2_MPEG_AUDIO_SAMPLING_FREQ_48000;
   ctrls[i].id = V4L2_CID_MPEG_AUDIO_ENCODING;
   ctrls[i++].value = V4L2_MPEG_AUDIO_ENCODING_LAYER_2;
   ctrls[i].id = V4L2_CID_MPEG_AUDIO_L2_BITRATE;
   ctrls[i++].value = (m_iAudioBR==256) ? 
V4L2_MPEG_AUDIO_L2_BITRATE_256K : V4L2_MPEG_AUDIO_L2_BITRATE_384K;
   ctrls[i].id = V4L2_CID_MPEG_VIDEO_BITRATE;
   ctrls[i++].value = m_iVideoBR * 1000;
   ctrls[i].id = V4L2_CID_MPEG_VIDEO_BITRATE_PEAK;
   ctrls[i++].value = m_iVideoMaxBR * 1000;
   ctrls[i].id = V4L2_CID_MPEG_VIDEO_ASPECT;
   switch (m_uiAspectRatio)
   {
     case 0: ctrls[i++].value = V4L2_MPEG_VIDEO_ASPECT_1x1; break;
     case 2: ctrls[i++].value = V4L2_MPEG_VIDEO_ASPECT_16x9; break;
     case 3: ctrls[i++].value = V4L2_MPEG_VIDEO_ASPECT_221x100; break;
     default: ctrls[i++].value = V4L2_MPEG_VIDEO_ASPECT_4x3; break;
   }
   mc.count = i;
   if (ioctl(fd, VIDIOC_S_EXT_CTRLS, &mc) < 0) {
     printf("Mpeg parameters cannot be set !\n");
   }
  close (fd);

  return (0);
}

Start MPEG script here:

./v4l2-ctl --set-freq=175.0 -d /dev/video0 
./v4l2-ctl --set-input=0 -d /dev/video0
./v4l2-ctl -s=secam-d -d /dev/video0
./start_mpeg

In debug log I see:

DEBUG: ts_open() start
DEBUG: ts_open() stop
DEBUG: empress_s_ext_ctrls() start
DEBUG: ts_init_encoder() start
DEBUG: ts_reset_encoder() start
DEBUG: ts_init_encoder() stop
DEBUG: empress_s_ext_ctrls() stop
DEBUG: ts_release() start
DEBUG: ts_reset_encoder() start
DEBUG: ts_reset_encoder() stop
DEBUG: ts_release() stop

But when I try:
cat /dev/video1 I get Input/Output error

In debug log :

DEBUG: ts_open() start
DEBUG: ts_open() stop
DEBUG: ts_init_encoder() start
DEBUG: ts_reset_encoder() start
DEBUG: ts_init_encoder() stop
DEBUG: buffer_setup() start
DEBUG: buffer_setup() stop
DEBUG: buffer_prepare() start 
DEBUG: line = 64
DEBUG: size = 12032
DEBUG: buffer_prepare() stop 
DEBUG: buffer_prepare() start 
DEBUG: line = 64
DEBUG: size = 12032
DEBUG: buffer_prepare() stop 
DEBUG: buffer_prepare() start 
DEBUG: line = 64
DEBUG: size = 12032
DEBUG: buffer_prepare() stop 
DEBUG: buffer_prepare() start 
DEBUG: line = 64
DEBUG: size = 12032
DEBUG: buffer_prepare() stop 
DEBUG: buffer_prepare() start 
DEBUG: line = 64
DEBUG: size = 12032
DEBUG: buffer_prepare() stop 
DEBUG: buffer_prepare() start 
DEBUG: line = 64
DEBUG: size = 12032
DEBUG: buffer_prepare() stop 
DEBUG: buffer_prepare() start 
DEBUG: line = 64
DEBUG: size = 12032
DEBUG: buffer_prepare() stop 
DEBUG: buffer_prepare() start 
DEBUG: line = 64
DEBUG: size = 12032
DEBUG: buffer_prepare() stop 
DEBUG: buffer_queue() start
DEBUG: buffer_queue() stop
DEBUG: buffer_queue() start
DEBUG: buffer_activate() start 
DEBUG: buffer_activate() stop 
DEBUG: buffer_queue() stop
DEBUG: buffer_queue() start
DEBUG: buffer_queue() stop
DEBUG: buffer_queue() start
DEBUG: buffer_queue() stop
DEBUG: buffer_queue() start
DEBUG: buffer_queue() stop
DEBUG: buffer_queue() start
DEBUG: buffer_queue() stop
DEBUG: buffer_queue() start
DEBUG: buffer_queue() stop
DEBUG: buffer_queue() start
DEBUG: buffer_queue() stop
DEBUG: buffer_activate() start 
DEBUG: buffer_activate() stop 
DEBUG: buffer_activate() start 
DEBUG: buffer_activate() stop 
DEBUG: buffer_queue() start
DEBUG: buffer_queue() stop
DEBUG: ts_release() start
DEBUG: buffer_release() start
DEBUG: buffer_release() stop
DEBUG: buffer_release() start
DEBUG: buffer_release() stop
DEBUG: buffer_release() start
DEBUG: buffer_release() stop
DEBUG: buffer_release() start
DEBUG: buffer_release() stop
DEBUG: buffer_release() start
DEBUG: buffer_release() stop
DEBUG: buffer_release() start
DEBUG: buffer_release() stop
DEBUG: buffer_release() start
DEBUG: buffer_release() stop
DEBUG: buffer_release() start
DEBUG: buffer_release() stop
DEBUG: buffer_release() start
DEBUG: buffer_release() stop
DEBUG: buffer_release() start
DEBUG: buffer_release() stop
DEBUG: buffer_release() start
DEBUG: buffer_release() stop
DEBUG: buffer_release() start
DEBUG: buffer_release() stop
DEBUG: buffer_release() start
DEBUG: buffer_release() stop
DEBUG: buffer_release() start
DEBUG: buffer_release() stop
DEBUG: buffer_release() start
DEBUG: buffer_release() stop
DEBUG: buffer_release() start
DEBUG: buffer_release() stop
DEBUG: ts_reset_encoder() start
DEBUG: ts_reset_encoder() stop
DEBUG: ts_release() stop

I don't understand why stream was stopped.

> The only way to change MPEG settings is to hardcode it in a program, 
> calling VIDIOC_S_EXT_CTRLS directly with the controls that 
> handle_ctrl() in saa6752.c understands.

Yes, but more better fix v4l2-ctl and empress module.

With my best regards, Dmitry.

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
