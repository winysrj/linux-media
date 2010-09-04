Return-path: <mchehab@localhost>
Received: from mx1.redhat.com (ext-mx10.extmail.prod.ext.phx2.redhat.com
	[10.5.110.14])
	by int-mx01.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id o84Ea5C7011158
	for <video4linux-list@redhat.com>; Sat, 4 Sep 2010 10:36:05 -0400
Received: from mail-fx0-f46.google.com (mail-fx0-f46.google.com
	[209.85.161.46])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id o84EZum7015333
	for <video4linux-list@redhat.com>; Sat, 4 Sep 2010 10:35:56 -0400
Received: by fxm13 with SMTP id 13so2720692fxm.33
	for <video4linux-list@redhat.com>; Sat, 04 Sep 2010 07:35:55 -0700 (PDT)
MIME-Version: 1.0
Date: Sat, 4 Sep 2010 09:35:55 -0500
Message-ID: <AANLkTiku0b9_5Vra-bMWOjSKHfz+P4R_xNgfhnNjkF-9@mail.gmail.com>
Subject: CVD::V4LBuffer<yuv422> Logitech web 9000 cam control help
From: "Camilo S." <cmsvalenzuela@gmail.com>
To: video4linux-list@redhat.com
List-Unsubscribe: <https://www.redhat.com/mailman/options/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: video4linux-list-bounces@redhat.com
Sender: Mauro Carvalho Chehab <mchehab@localhost>
List-ID: <video4linux-list@redhat.com>

Hi people,my name is Camilo im student of Systems Engineering at Universidad
Catolica de Colombia  http://mi.eng.cam.ac.uk/~er258/cvd/ , im currently
working on a project based on PTAM http://www.robots.ox.ac.uk/~gk/PTAM/, im
tryng to have control of my cam but i can not do it, there is the following
code to control video source using v4l2 like this (the project use this
libraries in here for computer vision http://mi.eng.cam.ac.uk/~er258/cvd/)

// Copyright 2008 Isis Innovation Limited
#include "VideoSource.h"
#include <cvd/Linux/v4lbuffer.h>
#include <cvd/colourspace_convert.h>
#include <cvd/colourspaces.h>
#include <gvars3/instances.h>

namespace PTAMM {

using namespace CVD;
using namespace std;
using namespace GVars3;

VideoSource::VideoSource()
{
  cout << "  VideoSource_Linux: Opening video source..." << endl;
  string QuickCamFile = GV3::get<string>("VideoSource.V4LDevice",
"/dev/video0");
  ImageRef irSize = GV3::get<ImageRef>("VideoSource.Resolution",
ImageRef(1600,1200));
  int nFrameRate = GV3::get<int>("VideoSource.Framerate", 30);
  V4LBuffer<yuv422>* pvb = new V4LBuffer<yuv422>(QuickCamFile, irSize, -1,
false, nFrameRate);
  mirSize = pvb->size();
  mptr = pvb;
  cout << "  ... got video source." << endl;
};
ImageRef VideoSource::Size()
{
  return mirSize;
};

void VideoSource::GetAndFillFrameBWandRGB(Image<byte> &imBW, Image<Rgb<byte>
> &imRGB)
{
  V4LBuffer<yuv422>* pvb = (V4LBuffer<yuv422>*) mptr;
  VideoFrame<yuv422> *pVidFrame = pvb->get_frame();
  convert_image(*pVidFrame, imBW);
  convert_image(*pVidFrame, imRGB);
  pvb->put_frame(pVidFrame);
}}

but i dont have control of camera paremeters i change resolution but i dont
get any result, im beginner with this so im kind of lost, this app start
video using opengl window, but when i try to maximize window i lose
resolution, do you have any ideas so i can control cam paremeters, camera
has a lot of features as you can see in here
http://www.logitech.com/en-us/webcam-communications/webcams/devices/6333,
thanks for any help you people can give me, please forgive me for poor
details on specifications for what i need, but i dont know what else to
explain about my situation, i was tryng to read methods for
V4LBuffer<yuv422>, but i dont find a way to change camera parameters.


thanks in advance

att: Camilo Soto
--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
