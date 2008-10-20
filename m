Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m9KH14bG009981
	for <video4linux-list@redhat.com>; Mon, 20 Oct 2008 13:01:04 -0400
Received: from linos.es (centrodatos.linos.es [86.109.105.97])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m9KH123m006135
	for <video4linux-list@redhat.com>; Mon, 20 Oct 2008 13:01:02 -0400
Message-ID: <48FCB94C.90505@linos.es>
Date: Mon, 20 Oct 2008 19:01:00 +0200
From: Linos <info@linos.es>
MIME-Version: 1.0
To: video4linux-list@redhat.com
References: <48FC8DF1.8010807@linos.es> <20081020161436.GB1298@daniel.bse>
In-Reply-To: <20081020161436.GB1298@daniel.bse>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Subject: Re: bttv 2.6.26 problem
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

Daniel Glöckner escribió:
> On Mon, Oct 20, 2008 at 03:56:01PM +0200, Linos wrote:
>> Error: Could not set image size to 352x288 for color format I420 (15) 
>> (VIDIOCMCAPTURE: buffer 0)
> 
> The problem is that the v4l1-compat code for VIDIOCMCAPTURE calls
> VIDIOC_S_FMT. At the beginning of bttv_s_fmt_vid_cap the call to
> bttv_switch_type fails because the buffers have already been mmap'ed
> by the application. I'd say this is a bug in bttv.
> 
> In which case does the videobuf_queue_is_busy test prevent bad things
> from happening?
> 
> 
> A workaround is to set the resolution and image format before the
> buffers are mapped, f.ex. with this small program:
> --------------
> #include <sys/ioctl.h>
> #include <fcntl.h>
> #include <unistd.h>
> #include <linux/videodev.h>
> 
> void main()
> {
>   struct video_mmap vmm;
>   vmm.height=352;
>   vmm.width=288;
>   vmm.format=VIDEO_PALETTE_YUV420P;
>   vmm.frame=0;
>   ioctl(open("/dev/video",O_RDWR),VIDIOCMCAPTURE,&vmm);
> }
> --------------
> 
>   Daniel
> 

Hi Daniel,
	thanks for help, i have tried the code you have posted, but it does not works 
or i have not understand you correctly, i have compiled the code, i have tried 
directly with /dev/video (like your example) or changing it with /dev/video0 
(the video dev i am using), after compile it and execute it i launch the helix 
producer but still the same error.

webcontrol:~# gcc -o test_video test_video.c
test_video.c: In function 'main':
test_video.c:7: warning: return type of 'main' is not 'int'
webcontrol:~# ./test_video
webcontrol:~# producer -vc /dev/video0 -ad 128k -vp "0" -dt -vm sharp -o 
/tmp/test.rm
Helix DNA(TM) Producer 11.0 Build number: 11.0.0.2013
Info: Starting encode
Error: Could not set image size to 352x288 for color format I420 (15) 
(VIDIOCMCAPTURE: buffer 0)
Warning: Capture Buffer is empty at 455505251ms for last 61 times

do i am doing anything wrong?

Regards,
Miguel Angel.

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
