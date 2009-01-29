Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n0TI6jYe031166
	for <video4linux-list@redhat.com>; Thu, 29 Jan 2009 13:06:45 -0500
Received: from col0-omc3-s2.col0.hotmail.com (col0-omc3-s2.col0.hotmail.com
	[65.55.34.140])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id n0TI6OYr014684
	for <video4linux-list@redhat.com>; Thu, 29 Jan 2009 13:06:25 -0500
Message-ID: <COL103-W81FDA0A3A5327FAC36491588C90@phx.gbl>
From: George Adams <g_adams27@hotmail.com>
To: <video4linux-list@redhat.com>
Date: Thu, 29 Jan 2009 13:06:22 -0500
Content-Type: text/plain; charset="windows-1256"
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
Subject: =?windows-1256?q?RealProducer_and_=22Capture_Buffer_Empty=22=FE?=
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


Hello. I want to purchase a TV tuner card that will work with Linux and (Helix) RealProducer 11.  This will be for our church, where our needs for features are quite simple - we just need a card that can pick up a NTSC channel 3 signal (from a coax cable) and will work with RealProducer.
 
I don't know what to buy (recommendations greatly welcomed, BTW!) so I thought I'd start with the V4L2 Virtual Video Device driver that comes with my kernel.  This is a Gentoo box running Linux 2.6.28, and I have compiled the "vivi" driver.  Here is some output:
 
> modprobe vivi
(/var/log/messages: Jan 29 00:36:40 www Linux video capture interface: v2.00)
(/var/log/messages: Jan 29 00:36:40 www vivi: V4L2 device registered as /dev/video0)
(/var/log/messages: Jan 29 00:36:40 www Video Technology Magazine Virtual Video Capture Board ver 0.5.0 successfully loaded.)
 
> lsmod | egrep -i "(video|vivi|v4l)" 
vivi                   16788  0 
videodev               32640  1 vivi
v4l1_compat            15364  1 videodev
compat_ioctl32          5248  1 vivi
videobuf_vmalloc        9860  1 vivi
videobuf_core          20356  2 vivi,videobuf_vmalloc

 
This creates the /dev/video0 device.  I have tested the vivi driver out with mplayer ("mencoder -tv driver=v4l2:width=640:height=480 tv:// -o tv.avi -ovc raw -endpos 5") and can successfully record the test pattern bars that "vivi" generates to an AVI file.  However, when I try encoding with RealProducer, I get this.
 
> /usr/local/helix/producer/producer -pd
Helix DNA(TM) Producer 11.0 Build number: 11.0.0.2013
 
VIDEO
 
Device 00: vivi /dev/video0
    Port 00: Camera
 
AUDIO
 
Device 00: Realtek ALC650F /dev/dsp
    Port 00: vol
    Port 01: line
    Port 02: mic
    Port 03: cd
    Port 04: line1
    Port 05: phin
    Port 06: phout
    Port 07: video
 
Device 01: SigmaTel STAC9708,11 /dev/dsp1
    Port 00: vol
    Port 01: line
    Port 02: mic
    Port 03: cd
    Port 04: line1
    Port 05: phin
    Port 06: phout
    Port 07: video
 
> /usr/local/helix/producer/producer -vc /dev/video0 -vp 0 -o /tmp/test.rm
Helix DNA(TM) Producer 11.0 Build number: 11.0.0.2013
Error: Could not set color format (I420) for video capture device (VIDIOCSPICT: depth=12, palette=15)
Jan 29 00:50:21 www vivi: open called (minor=0)
Jan 29 00:50:21 www vivi: open called (minor=0)
Warning: Ignoring enableTwoPass for live encoding                              
Info: Starting encode                                                          
Error: Could not set image size to 160x120 for color format YUY2 (7) (VIDIOCMCAPTURE: buffer 0)
Warning: Capture Buffer is empty at 552608645ms for last 61 times
Warning: Capture Buffer is empty at 552609925ms for last 61 times
Warning: Capture Buffer is empty at 552611205ms for last 61 times
 [CTRL-C]
Info: Stop encoder request received                                            
Info: Stopping encode                                                          
Info: File /tmp/test.rm already exists. Archiving existing file to /tmp/test_arch003.rm. Writing new file to /tmp/test.rm.
Info:        Out- Total Audio Video Pre- Audience Name                         
Info:        Aud  kbps  kbps  kbps  roll                                       
Info: Stat1: 1:1  0     n/a    0     0       256k DSL or Cable                 
Info:        Out- Avg  Min  Min      Avg Min Min      Audience Name            
Info:        Aud  FPS  FPS  FPS Time QI  QI  QI Time                           
Info: Total Bitrate = 0 kbps                                                   
Info: Encoding successful!                                                     
Done  Errors: 2 Warnings: 4
 
 
Doing a search for "Capture Buffer is empty" led me to http://lists-archives.org/video4linux/24820-bttv-2-6-26-problem.html , where someone had a similar problem and a workaround C program was given.  I haven't had any luck with it, though.  See for yourself:
 
(I used double-quotes instead of angle brackets on the "#include lines", since Hotmail seems to interpret them as HTML tags and removes them)
  
> cat fixvideo.c
#include "sys/ioctl.h"
#include "fcntl.h"
#include "unistd.h"
#include "linux/videodev.h"
 
void main()
{
  struct video_mmap vmm;
  vmm.width=160;
  vmm.height=120;
  vmm.format=VIDEO_PALETTE_YUV420P;
  vmm.frame=0;
  ioctl(open("/dev/video0",O_RDWR),VIDIOCMCAPTURE,&vmm);
}
 
> gcc -o fixvideo fixvideo.c
fixvideo.c: In function ‘main’:
fixvideo.c:7: warning: return type of ‘main’ is not ‘int’
 
> ./fixvideo
(/var/log/messages: Jan 29 00:58:59 www vivi: open called (minor=0))
 
> /usr/local/helix/producer/producer -vc /dev/video0 -vp 0 -o /tmp/test.rm
Helix DNA(TM) Producer 11.0 Build number: 11.0.0.2013
Error: Could not set color format (I420) for video capture device (VIDIOCSPICT: depth=12, palette=15)
Warning: Ignoring enableTwoPass for live encoding                              
Info: Starting encode                                                          
Error: Could not set image size to 160x120 for color format YUY2 (7) (VIDIOCMCAPTURE: buffer 0)
Jan 29 00:51:00 www vivi: open called (minor=0)
Jan 29 00:51:00 www vivi: open called (minor=0)
Warning: Capture Buffer is empty at 552648316ms for last 61 times              
Warning: Capture Buffer is empty at 552649596ms for last 61 times              
Warning: Capture Buffer is empty at 552650877ms for last 61 times              
        [CTRL-C]
Info: Stop encoder request received                                            
Info: Stopping encode                                                          
Info: File /tmp/test.rm already exists. Archiving existing file to /tmp/test_arch004.rm. Writing new file to /tmp/test.rm.
Info:        Out- Total Audio Video Pre- Audience Name                         
Info:        Aud  kbps  kbps  kbps  roll                                       
Info: Stat1: 1:1  0     n/a    0     0       256k DSL or Cable                 
Info:        Out- Avg  Min  Min      Avg Min Min      Audience Name            
Info:        Aud  FPS  FPS  FPS Time QI  QI  QI Time                           
Info: Total Bitrate = 0 kbps                                                   
Info: Encoding successful!                                                     
Done  Errors: 2 Warnings: 4
 
 
Can anyone help me understand what the problem is?  Is this something that's just a problem with the vivi driver, and won't be an issue when I get a real TV tuner card?  (again, suggestions on which one is compatible with RealProducer would be much appreciated!)  
 
Or is RealProducer just not compatible with V4L2, in spite of the v4l1_compat module?  In which case, am I just out of luck trying to encode video on a Linux box with RealProducer?
 
I've run out of ideas, so sincere thanks to anyone who can help!
_________________________________________________________________
Windows Live™ Hotmail®…more than just e-mail. 
http://windowslive.com/howitworks?ocid=TXT_TAGLM_WL_t2_hm_justgotbetter_howitworks_012009

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
