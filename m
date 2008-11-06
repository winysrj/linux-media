Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mA60gjYW022321
	for <video4linux-list@redhat.com>; Wed, 5 Nov 2008 19:42:45 -0500
Received: from mailrelay011.isp.belgacom.be (mailrelay011.isp.belgacom.be
	[195.238.6.178])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mA60gZiQ020456
	for <video4linux-list@redhat.com>; Wed, 5 Nov 2008 19:42:35 -0500
From: Laurent Pinchart <laurent.pinchart@skynet.be>
To: video4linux-list@redhat.com
Date: Thu, 6 Nov 2008 01:42:48 +0100
References: <26aa882f0810280714u1b3964b9t1440369d2d2a36b7@mail.gmail.com>
In-Reply-To: <26aa882f0810280714u1b3964b9t1440369d2d2a36b7@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200811060142.48227.laurent.pinchart@skynet.be>
Cc: 
Subject: Re: Testing Requested: Python Bindings for Video4linux2
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

first of all, sorry for the late reply.

On Tuesday 28 October 2008, Jackson Yee wrote:
> For anyone who is a fellow python fan and has a video4linux2 capture
> card, please try out
>
> http://code.google.com/p/python-video4linux2/
>
> and let me know if the samples work out for you. I'd like to see how
> this performs on cards other than my Happugage ImpactVCB.

I'm testing your bindings with a Quickcam Pro for Notebooks (using the 
uvcvideo driver).

$ ./pyv4l2.py
Available devices:  ['/dev/video0', '/dev/video1394-0']
        /dev/video0
Capabilities:
        Capture
        Streaming
Input 0:
                Name:   Camera 1
                Type:   camera
                Standards: []
Traceback (most recent call last):
  File "./pyv4l2.py", line 755, in <module>
    d.SetStandard(d.standards['NTSC'])
  File "./pyv4l2.py", line 456, in SetStandard
    (FindKey(self.standards, std, 'Unknown'),
NameError: global name 'FindKey' is not defined

The uvcvideo driver doesn't implement the standard ioctls. This should not be 
fatal (and you probably want to define FindKeyas well).

$ ./streampics.py /dev/video0 0 MJPG 640 480 testpics
Traceback (most recent call last):
  File "./streampics.py", line 94, in <module>
    Run()
  File "./streampics.py", line 59, in Run
    d.SetResolution( int(options.width), int(options.height) )
  File "/home/laurent/src/kernel/uvc/python-v4l2/pyv4l2.py", line 551, in 
SetResolution
    self.SetFormat()
  File "/home/laurent/src/kernel/uvc/python-v4l2/pyv4l2.py", line 492, in 
SetFormat
    lib.Error()
Exception: Could not set format:        22: Invalid argument

The problem comes from a bad alignment in the PixFormat structure. At least on 
my architecture (x86) the type field is 32 bits wide.

Best regards,

Laurent Pinchart

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
