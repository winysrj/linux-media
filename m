Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m9HJpV6V023105
	for <video4linux-list@redhat.com>; Fri, 17 Oct 2008 15:51:31 -0400
Received: from smtp.unisys.com.br (smtp.unisys.com.br [200.220.64.9])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id m9HJpHO6005867
	for <video4linux-list@redhat.com>; Fri, 17 Oct 2008 15:51:18 -0400
From: danflu@uninet.com.br
To: video4linux-list@redhat.com
Date: Fri, 17 Oct 2008 16:51:15 -0300
Message-id: <48f8ecb3.2e7.66c9.1239639314@uninet.com.br>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Subject: VIDIOC_ENUMAUDIO - please help
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

Hi,

I'm having problems with the ioctl VIDIOC_ENUMAUDIO.
When i use it the application returns EINVAL.
I Trying it with /dev/video0 

int fd;

if ( (fd = open("/dev/video0", O_RDWR)) != -1)

{
    return -1;
}

v4l2_audio audio;
memset(&audio, 0, sizeof(audio));
audio.index = 0;

while (ioctl(fd, VIDIOC_ENUMAUDIO, &audio) != -1)
{
   // some code
}

What am I doing wrong ??
Please help...

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
