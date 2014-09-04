Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pd0-f176.google.com ([209.85.192.176]:33714 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755210AbaIDUMI (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 4 Sep 2014 16:12:08 -0400
Received: by mail-pd0-f176.google.com with SMTP id w10so4953434pde.35
        for <linux-media@vger.kernel.org>; Thu, 04 Sep 2014 13:12:07 -0700 (PDT)
Message-ID: <5408C78C.2010608@gmail.com>
Date: Fri, 05 Sep 2014 01:41:56 +0530
From: Alaganraj Sandhanam <alaganraj.sandhanam@gmail.com>
MIME-Version: 1.0
To: =?UTF-8?B?Ik3DoWNoYSwgS2FyZWwi?= <KMacha@atb-potsdam.de>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: Corrupt images, when capturing images from multiple cameras using
 the V4L2 driver
References: <BDE207EB81F3F14F85CFF86344BBE70E2D2FDF@saturn.atb-potsdam.de>
In-Reply-To: <BDE207EB81F3F14F85CFF86344BBE70E2D2FDF@saturn.atb-potsdam.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Karel,

I suggest you to zero fill v4l2 structures before assign values also
check the return value of all ioctl call.
for example,

    struct v4l2_format fmt;

    memset(&fmt, 0, sizeof fmt);
    fmt.type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
    fmt.fmt.pix.width = xRes;
    ret = ioctl(fd, VIDIOC_S_FMT, &fmt);
    if (ret < 0)
           printf("VIDIOC_S_FMT failed: %d\n", ret);

Please find comments in-line.

On Tuesday 02 September 2014 05:36 PM, Mácha, Karel wrote:
> Hello, 
> 
> I would like to grab images from multiple cameras under using the V4L2
> API. I followed the presentation under found on
> http://linuxtv.org/downloads/presentations/summit_jun_2010/20100206-fosdem.pdf 
> used the code and adapted it sightly for my purpose. It works very well
> for 1 camera.
> 
> However Once I begin to grab images from multiple cameras (successively)
> I get corrupt images. I uploaded an example image to
> http://www.directupload.net/file/d/3733/9c4jx3pv_png.htm
> 
> Although I set the right resolution for the camera (744 x 480), the
> output of buffer.bytesused, after the VIDIOC_DQBUF does not correspond
> with the expected value (744x480 = 357120). This would probably explain
> the corrupt images.
> 
> The more camera I use, the less buffer.bytesused I get and the more
> stripes are in the image. Could you please give me a hint, what am I
> doing wrong ?
> 
> Thanks, Karel
> 
> Here is the minimal C code I use for my application:
> 
> 
> int main()
> {
> 	/* ##################### INIT ##################### */
> 
> 	int numOfCameras = 6;
As it works well for 1 camera, try with only 2 instead of 6
> 	int xRes = 744;
> 	int yRes = 480;
> 	int exposure = 2000;
> 	unsigned int timeBetweenSnapshots = 2; // in sec
> 	char fileName[sizeof "./output/image 000 from camera 0.PNG"];
> 
> 	static const char *devices[] = { "/dev/video0", "/dev/video1",
> "/dev/video2", "/dev/video3", "/dev/video4", "/dev/video5",
> "/dev/video6", "/dev/video7" };
> 
> 	struct v4l2_capability cap[8];
> 	struct v4l2_control control[8];
> 	struct v4l2_format format[8];
> 	struct v4l2_requestbuffers req[8];
> 	struct v4l2_buffer buffer[8];
> 
> 	int type = V4L2_BUF_TYPE_VIDEO_CAPTURE; // had to declare the type here
> because of the loop
> 
> 	unsigned int i;
> 	unsigned int j;
> 	unsigned int k;
> 
> 	int fd[8];
> 	void **mem[8];
> 	//unsigned char **mem[8];
> 
> 	/* ##################### OPEN DEVICE ##################### */
> 
> 	for (j = 0; j < numOfCameras; ++j) {
> 
> 		fd[j] = open(devices[j], O_RDWR);
> 		ioctl(fd[j], VIDIOC_QUERYCAP, &cap[j]);
check the return value
> 
> 
> 		/* ##################### CAM CONTROLL ############### */
> 
zero fill control[j]
memset(control[j], 0, sizeof control[j]);
> 		control[j].id = V4L2_CID_EXPOSURE_AUTO;
> 		control[j].value = V4L2_EXPOSURE_SHUTTER_PRIORITY;
> 		ioctl(fd[j], VIDIOC_S_CTRL, &control[j]);
> 
> 		control[j].id = V4L2_CID_EXPOSURE_ABSOLUTE;
> 		control[j].value = exposure;
> 		ioctl(fd[j], VIDIOC_S_CTRL, &control[j]);
> 
> 		/* ##################### FORMAT ##################### */
> 
zero fill format[j]
memset(format[j], 0, sizeof format[j]);
> 		ioctl(fd[j], VIDIOC_G_FMT, &format[j]);
> 		format[j].type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
> 		format[j].fmt.pix.width = xRes;
> 		format[j].fmt.pix.height = yRes;
> 		//format.fmt.pix.pixelformat = V4L2_PIX_FMT_YUYV;
> 		format[j].fmt.pix.pixelformat = V4L2_PIX_FMT_GREY;
> 		ioctl(fd[j], VIDIOC_S_FMT, &format[j]);
> 
> 		/* ##################### REQ BUF #################### */
> 
memset(req[j], 0, sizeof req[j]);
> 		req[j].type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
> 		req[j].count = 4;
> 		req[j].memory = V4L2_MEMORY_MMAP;
> 		ioctl(fd[j], VIDIOC_REQBUFS, &req[j]);
> 		mem[j] = malloc(req[j].count * sizeof(*mem));
> 
> 		/* ##################### MMAP ##################### */
> 
> 		for (i = 0; i < req[j].count; ++i) {
                        memset(buffer[j], 0, sizeof buffer[j]);
> 			buffer[j].type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
> 			buffer[j].memory = V4L2_MEMORY_MMAP;
> 			buffer[j].index = i;
> 			ioctl(fd[j], VIDIOC_QUERYBUF, &buffer[j]);
> 			mem[j][i] = mmap(0, buffer[j].length,
> 					PROT_READ|PROT_WRITE,
> 					MAP_SHARED, fd[j], buffer[j].m.offset);
> 		}
> 
> 		/* ##################### CREATE QUEUE ############### */
> 
> 		for (i = 0; i < req[j].count; ++i) {
memset(buffer[j], 0, sizeof buffer[j]);
> 			buffer[j].type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
> 			buffer[j].memory = V4L2_MEMORY_MMAP;
> 			buffer[j].index = i;
> 			ioctl(fd[j], VIDIOC_QBUF, &buffer[j]);
check the return value
> 		}
> 
> 	} /* ### ### end of camera init ### ### */
> 
> 	/* ##################### STREAM ON ##################### */
> 	for (j = 0; j < numOfCameras; ++j) {
> 
> 		ioctl(fd[j], VIDIOC_STREAMON, &type);
> 	}
> 
> 
> 	/* ##################### GET FRAME ##################### */
> 
> 	k = 0;
> 	while (!kbhit()){
Instead of multiple frames, capture single frame and check the result.
> 		k ++;
> 
> 		for (j = 0; j < numOfCameras; j++) {
> 
    memset(buffer[j], 0, sizeof buffer[j]);
> 			buffer[j].type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
> 			buffer[j].memory = V4L2_MEMORY_MMAP;
> 			usleep(100000);
> 			ioctl(fd[j], VIDIOC_DQBUF, &buffer[j]);
> 			printf("\nBuffer {%p}, Buf. Index %d, Buf. bytes used %d\n",
> mem[j][buffer[j].index], buffer[j].index,  buffer[j].bytesused);
> 
> 			// create filename
> 			sprintf(fileName, "./output/image %03d from camera %d.PNG", k, j);
> 			// save as PNG file
> 			saveToPng(mem[j][buffer[j].index], fileName, xRes, yRes);
> 
> 			ioctl(fd[j], VIDIOC_QBUF, &buffer[j]);
> 
> 			sleep(timeBetweenSnapshots);
> 		}
> 	}
> 
> 	/* ##################### STREAM OFF ##################### */
> 	for (j = 0; j < numOfCameras; ++j) {
> 
> 		ioctl(fd[j], VIDIOC_STREAMOFF, &type);
> 	}
> 
> 	/* ##################### CLEANUP ##################### */
> 
> 	for (j = 0; j < numOfCameras; ++j) {
> 
> 		close(fd[j]);
> 		free(mem[j]);
> 	}
> 
> 	return (0);
> }
> 
> **********************************************************************
> Leibniz-Institut für Agrartechnik Potsdam-Bornim e.V.
> Max-Eyth-Allee 100
> D-14469 Potsdam
>  
> Vorstand: 
> Prof. Dr. Reiner Brunsch (Wissenschaftlicher Direktor)
> Dr. Martin Geyer (Stellvertreter des Wissenschaftlichen Direktors)
> Prof. Dr. Thomas Amon  (2. Stellvertreter des Wissenschaftlichen Direktors)
> Dr. Uta Tietz (Verwaltungsleiterin) 
> Amtsgericht Potsdam, VR 680 P, USt-ID DE811704150
> 
> **********************************************************************
> This email and any files transmitted with it are confidential and
> intended solely for the use of the individual or entity to whom they
> are addressed. If you have received this email in error please notify
> the system manager.
> 
> Scanned by the Clearswift SECURE Email Gateway.
> 
> www.clearswift.com
> **********************************************************************
> N�����r��y���b�X��ǧv�^�)޺{.n�+����{���bj)���w*jg��������ݢj/���z�ޖ��2�ޙ���&�)ߡ�a�����G���h��j:+v���w�٥
> 

Regards,
Alaganraj
