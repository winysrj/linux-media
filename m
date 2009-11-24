Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:57326 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751220AbZKXBCn (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 23 Nov 2009 20:02:43 -0500
Message-ID: <4B0B30B8.5030602@gmx.de>
Date: Tue, 24 Nov 2009 02:02:48 +0100
From: Kai Tiwisina <kai_tiwisina@gmx.de>
MIME-Version: 1.0
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Stefan Herbrechtsmeier <hbmeier@hni.uni-paderborn.de>
Subject: Re: image capture with ov9655 camera and intel pxa270C5C520
References: <20091123183928.206900@gmx.net> <Pine.LNX.4.64.0911232131590.4207@axis700.grange>
In-Reply-To: <Pine.LNX.4.64.0911232131590.4207@axis700.grange>
Content-Type: multipart/mixed;
 boundary="------------010609050102030605030306"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is a multi-part message in MIME format.
--------------010609050102030605030306
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Hello everyone,

here is a little update to my question and to the source code.

After i implemented an function with the VIDIOC_ENUM_FMT ioctl i 
recognized, that only two formats are support by the driver by now. 
(Thanks to Mr. Liakhovetski by the way ;) )
The output.txt shows the output of this function and mentions the two 
different types.

One is definately the V4L2_PIX_FMT_YUYV format but i don't know the 
other one exactly...

I changed my set_format function after i got this information and 
unfortunately nothing has changed...

Perhaps there are some further possibilities to solve this Problem.

Maybe there have some other v4l2 structures to be initialized, befor the 
VIDIOC_S_FMT ioctl runs?

Thans for the support and in advance.

Yours sincerely, Kai Tiwisina

#########################################################################

Guennadi Liakhovetski wrote:
> Hi Kai
>
> On Mon, 23 Nov 2009, Kai Tiwisina wrote:
>
>   
>> Hello,
>>
>> my name is Kai Tiwisina and i'm a student in germany and i'm trying to 
>> communicate with a Omnivision ov9655 camera which is atteched with my 
>> embedded linux system via the v4l commands.
>>
>> I've written a small testprogram which should grow step by step while i'm 
>> trying one ioctl after another.
>> Everything worked fine until i tried to use the VIDIOC_S_FMT ioctl. It's 
>> always giving me an "invalid argument" failure and i don't know why.
>>     
>
> Since you don't seem to have the source of the driver at hand, I'd suggest 
> to use the VIDIOC_ENUM_FMT http://v4l2spec.bytesex.org/spec/r8367.htm 
> ioctl to enumerate all pixel formats supported be the driver. If the 
> driver you're using is the same, that Stefan (cc'ed) has submitted to the 
> list, then indeed it does not support the V4L2_PIX_FMT_RGB555 format, that 
> you're requesting, only various YUV (and a Bayer?) formats.
>
>   
>> Perhaps someone of you is able to help me with this ioctl and give an 
>> advice for a simple flow chart for a single frame image capture. Which 
>> ioctl steps are neccessary and where do i need loops and for what, because 
>> the capture-example.c from bytesex.org is way too general for my purpose.
>>     
>
> Thanks
> Guennadi
> ---
> Guennadi Liakhovetski, Ph.D.
> Freelance Open-Source Software Developer
> http://www.open-technology.de/
>
>   


--------------010609050102030605030306
Content-Type: text/plain;
 name="output.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="output.txt"

root@bebot15:~# stream_test


*New file descriptor: 3*

driver:       pxa27x-camera
card:   PXA_Camera
bus_info:
version:        0.0.5
capabilities:   4000001(HEX)
buffer allocated 20 times 1


index:  0
buffer type:    1
compressed:     0
sescription:    YUV 4:2:2
pixelformat:    1448695129


index:  1
buffer type:    1
compressed:     0
sescription:    YUV 4:2:2 BE
pixelformat:    1498831189


buffer type:    1
image size:     0x0 pixels
pixelformat:    1448695129
v4l2 field-type:        1
bytes per line: 0
image size:     0
v4l2_colorspace-type:   0
Process set_format failed 22, Invalid argument

--------------010609050102030605030306
Content-Type: text/plain;
 name="stream_test.c"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="stream_test.c"

/*
 ============================================================================
 Name        : stream_test.c
 Author      : Kai Tiwisina
 Version     :
 Description : Output of camera stream in to text-file
 ============================================================================
 */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <fcntl.h>              // open() is in here
#include <unistd.h>				// close() is in here
#include <errno.h>				// used for desolving error numbers
#include <sys/ioctl.h>			// ioctl() is in here
#include <sys/mman.h>
#include <linux/videodev.h>		// jpeg_markers are defined in here
#include <asm/types.h>			// for videodev2.h
#include <linux/videodev2.h>	// VIDIOC_QUERYCAP & struct v4ls_capability are defined in here

#define CLEAR(x) memset(&(x), 0, sizeof(x))

void print_errno(char *s);	//returns errno argument as value and expression
void open_device();	//opens a v4l device returning new file descriptor and gives error info if necessary
void query_cap();
void request_buffer();
void stream_on();
void query_buffer();
void memory_mapping();
void stream_off();
void get_format();
void set_format();


static struct v4l2_requestbuffers buffer;
static struct v4l2_buffer q_buffer;
static struct v4l2_format f_type;

static int fd;								// fd is the file descriptor

int main(void)
{
	open_device();
	printf("\n\n*New file descriptor: %i*\n\n",fd);
	query_cap();
	request_buffer();
	get_format();
	set_format();
	get_format();
	//stream_on();
	//query_buffer();
	//memory_mapping();
	//stream_off();
	close(fd);						//closes connection to device
	return 0;
}

void print_errno(char *s)
{
	printf("Process %s failed %d, %s\n", s, errno, strerror(errno));
	exit(EXIT_FAILURE);
}

void open_device()
{
	int status;
	status=open("/dev/video0",O_RDWR);	//Look up arguments for v4l2 open() in v4l_doku.pdf
	if(status==-1)						//Device_name has to include the whole path, here /dev
	{
		print_errno("open_device");
	}
	else
	{
		fd=status;
	}
}

void query_cap()
{
	int status;
	struct v4l2_capability camera_cap; // camera_cap should be representative for the bebot's cam
	status=ioctl(fd,VIDIOC_QUERYCAP,&camera_cap); // description on Page 188 in v4l_doku.pdf
	if(status==-1)
	{
		print_errno("Determination of device capabilities");
	}
	else
	{
		printf("driver:\t%s\n",camera_cap.driver);
		printf("card:\t%s\n",camera_cap.card);
		printf("bus_info:\t%s\n",camera_cap.bus_info);
		printf("version:\t%u.%u.%u\n",(camera_cap.version >> 16)&0xFF,(camera_cap.version >> 8)&0xFF,camera_cap.version&0xFF);
		printf("capabilities:\t%x(HEX)\n",camera_cap.capabilities);
	}
}

void request_buffer()
{
	int status;
	memset(&buffer,0,sizeof(buffer));
	buffer.type=V4L2_BUF_TYPE_VIDEO_CAPTURE;
	buffer.memory=V4L2_MEMORY_MMAP;
	buffer.count=2;
	status=ioctl(fd,VIDIOC_REQBUFS,&buffer);
	if(status==-1)
	{
		print_errno("request buffer");
	}
	else
	{
		printf("buffer allocated %i times %i\n",sizeof(buffer),sizeof(unsigned char));
	}

}

void stream_on()
{
	int status;
	status=ioctl(fd,VIDIOC_STREAMON,&buffer.type);
	if(status==-1)
	{
		print_errno("activating streaming device");
	}
	else
	{
		printf("streaming device activated\n");
	}
}

void query_buffer()
{
	int status;
	q_buffer.type=V4L2_BUF_TYPE_VIDEO_CAPTURE;
	q_buffer.index=1;
	status=ioctl(fd,VIDIOC_QUERYBUF,&q_buffer);
	if(status==-1)
	{
		print_errno("querying buffer informations");
	}
	else
	{
		printf("index:\t%u\n",q_buffer.index);
		printf("buffer_type:\t%u\n",q_buffer.type);
		printf("bytes used:\t%u\n",q_buffer.bytesused);
		printf("flags:\t%u\n",q_buffer.flags);
		printf("field:\t%u\n",q_buffer.field);
		//printf("time_stamp:\t%i\n",q_buffer.timestamp);
		//printf("time_code:\t%i\n",q_buffer.timecode);
		printf("sequence:\t%u\n",q_buffer.sequence);
		printf("memory:\t%u\n",q_buffer.memory);
		printf("offset:\t%u\n",q_buffer.m.offset);
		printf("user_pointer:\t%lu\n",q_buffer.m.userptr);
		printf("length:\t%u\n",q_buffer.length);
		printf("input:\t%u\n",q_buffer.input);
		printf("\n\nstreaming device activated\n");
	}
}

void memory_mapping()
{
	int i,j,status;
	char *mem,*temp;
	FILE* fp;
	mem=mmap(NULL,q_buffer.length,PROT_READ|PROT_WRITE,MAP_SHARED,fd,q_buffer.m.offset);
	if(mem==MAP_FAILED)
	{
		print_errno("memory mapping");
	}
	else
	{
		temp=mem;
		get_format(fd);
		fp=fopen("/home/root/image.txt","r+");
		for(i=0;i<f_type.fmt.pix.height;i++)
		{
			for(j=0;j<f_type.fmt.pix.width;j++)
			{
				fprintf(fp,"%c\t",*temp);
				temp++;
			}
			fprintf(fp,"\n");
		}
		status=munmap(mem,q_buffer.length);
		if(status==-1)
		{
			print_errno("memory unmapping");
		}
	}
}

void stream_off()
{
	int status;
	status=ioctl(fd,VIDIOC_STREAMOFF,&buffer.type);
	if(status==-1)
	{
		print_errno("deactivating streaming device");
	}
	else
	{
		printf("streaming device deactivated\n");
	}
}

void get_format()
{
	int status;
	//struct v4l2_format f_type;
	f_type.type=1;
	status=ioctl(fd,VIDIOC_G_FMT,&f_type);
	if(status==-1)
	{
		print_errno("get_format");
	}
	else
	{
		printf("\n\nbuffer type:\t%i\n",f_type.type);
		printf("image size:\t%ix%i pixels \n",f_type.fmt.pix.width,f_type.fmt.pix.height);
		printf("pixelformat:\t%i\n",f_type.fmt.pix.pixelformat);
		printf("v4l2 field-type:\t%i\n",f_type.fmt.pix.field);
		printf("bytes per line:\t%i\n",f_type.fmt.pix.bytesperline);
		printf("image size:\t%i\n",f_type.fmt.pix.sizeimage);
		printf("v4l2_colorspace-type:\t%i\n",f_type.fmt.pix.colorspace);
	}
}

void set_format()
{
	int status;
	CLEAR(f_type);
	f_type.type=V4L2_BUF_TYPE_VIDEO_CAPTURE;
	//f_type.fmt.pix.colorspace=V4L2_COLORSPACE_SRGB;
	f_type.fmt.pix.pixelformat=V4L2_PIX_FMT_RGB555;
	f_type.fmt.pix.field=V4L2_FIELD_NONE;
	f_type.fmt.pix.height=640;
	f_type.fmt.pix.width=480;
	//f_type.fmt.pix.bytesperline=f_type.fmt.pix.width*3;
	//f_type.fmt.pix.sizeimage=f_type.fmt.pix.bytesperline*f_type.fmt.pix.height;

	status=ioctl(fd,VIDIOC_S_FMT,&f_type);
	if(status==-1)
	{
		print_errno("set_format");
	}
	else
	{
		printf("\n\nbuffer type:\t%i\n",f_type.type);
		printf("image size:\t%ix%i pixels \n",f_type.fmt.pix.width,f_type.fmt.pix.height);
		printf("pixelformat:\t%i\n",f_type.fmt.pix.pixelformat);
		printf("v4l2 field-type:\t%i\n",f_type.fmt.pix.field);
		printf("bytes per line:\t%i\n",f_type.fmt.pix.bytesperline);
		printf("image size:\t%i\n",f_type.fmt.pix.sizeimage);
		printf("v4l2_colorspace-type:\t%i\n",f_type.fmt.pix.colorspace);
	}
}

--------------010609050102030605030306--
