Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx1.redhat.com (mx1.redhat.com [172.16.48.31])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m8QKjUxv012818
	for <video4linux-list@redhat.com>; Fri, 26 Sep 2008 16:45:30 -0400
Received: from rv-out-0506.google.com (rv-out-0506.google.com [209.85.198.230])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id m8QKjF1D017469
	for <video4linux-list@redhat.com>; Fri, 26 Sep 2008 16:45:15 -0400
Received: by rv-out-0506.google.com with SMTP id f6so1167569rvb.51
	for <video4linux-list@redhat.com>; Fri, 26 Sep 2008 13:45:14 -0700 (PDT)
Message-ID: <48DD4A38.4080401@hotmail.com>
Date: Fri, 26 Sep 2008 13:46:48 -0700
From: Lee Alkureishi <lee_alkureishi@hotmail.com>
MIME-Version: 1.0
To: video4linux-list@redhat.com
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Subject: HDTV Wonder - analog portion isn't working
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

Hi everyone,

I'm hoping someone might be able to help me get the analogue portion of 
my ATI HDTV Wonder up and running. I've already set up the ATSC dvb0 
device, and am using it to watch HD content without problems.

When I try to watch tv using the second coaxial input (which is set up 
in mythtv-setup as an analogue v4l device at /dev/video0), I just get a 
black screen. Scanning for channels produces timeouts at every station 
(no signal). I'm mainly using mythtv (mythbuntu 8.04, mythtv 0.21, fully 
updated), but the same thing happens in tvtime and xawtv. I'm unable to 
find any channels.

My setup is an athlon 2400+, 512Mb RAM, nvidia GF 440MX, ATI HDTV wonder.

When I try to manually run v4l-conf, I get the following error:

leeko@leeko-media:~$ v4l-conf -c /dev/video0 -1
v4l-conf: using X11 display :0.0
dga: version 2.0
X Error of failed request:  XF86DGANoDirectVideoMode
  Major opcode of failed request:  137 (XFree86-DGA)
  Minor opcode of failed request:  1 (XF86DGAGetVideoLL)
  Serial number of failed request:  13
  Current serial number in output stream:  13

Running xawtv, I get a black screen, and it's fixed to 
"NTSC/europe-west" with no way to change it to us-bcast. Changing the 
channels produces nothing.

Troubleshooting, I tried this:

leeko@leeko-media:~$ xawtv -noxv -nodga

But it produces another set of error messages:

This is xawtv-3.95.dfsg.1, running on Linux/i686 (2.6.24-19-generic)
xinerama 0: 1024x768+0+0
X Error of failed request:  XF86DGANoDirectVideoMode
  Major opcode of failed request:  137 (XFree86-DGA)
  Minor opcode of failed request:  1 (XF86DGAGetVideoLL)
  Serial number of failed request:  13
  Current serial number in output stream:  13
v4l-conf had some trouble, trying to continue anyway
Warning: Cannot convert string 
"-*-ledfixed-medium-r-*--39-*-*-*-c-*-*-*" to type FontStruct
ioctl: VIDIOC_REQBUFS(count=2;type=VIDEO_CAPTURE;memory=MMAP): Success
ioctl: VIDIOC_REQBUFS(count=2;type=VIDEO_CAPTURE;memory=MMAP): Success

and when I try to change channel:

ioctl: VIDIOC_REQBUFS(count=2;type=VIDEO_CAPTURE;memory=MMAP): Resource 
temporarily unavailable
ioctl: VIDIOC_REQBUFS(count=2;type=VIDEO_CAPTURE;memory=MMAP): Resource 
temporarily unavailable


Please help! I don't know what to do next, to get this analogue input 
working!


Thanks in advance,

Lee

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
