Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx1.redhat.com (mx1.redhat.com [172.16.48.31])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n380Eo5k000881
	for <video4linux-list@redhat.com>; Tue, 7 Apr 2009 20:14:50 -0400
Received: from mail-fx0-f180.google.com (mail-fx0-f180.google.com
	[209.85.220.180])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id n380EQlS010422
	for <video4linux-list@redhat.com>; Tue, 7 Apr 2009 20:14:27 -0400
Received: by fxm28 with SMTP id 28so2775408fxm.3
	for <video4linux-list@redhat.com>; Tue, 07 Apr 2009 17:14:26 -0700 (PDT)
MIME-Version: 1.0
Date: Wed, 8 Apr 2009 01:14:26 +0100
Message-ID: <7d2e5a7c0904071714q7eac166dj735ec394da8c0ae5@mail.gmail.com>
From: Garik Suess <garik.suess@gmail.com>
To: video4linux-list@redhat.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Subject: VIDEOC_STREAMON, VIDEOC_STREAMOFF -> Device or Resource Busy
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

Hi all,

this is my first post to this mail list (Well, first post, 2nd attempt as I
believe that my first attempt might not have been received properly...), so
I am sorry if I should have posted somewhere else.

I have made frame grabber in C that captures from my usb webcam. Although
the frame-grabbing itself works very smoothly, I am having trouble to stop
and then subsequently restart the stream within the same process.

This is the routine I use to stop the stream:

void BitstreamGrabber_v4l2::terminate() {
 lock();

 int type = V4L2_BUF_TYPE_VIDEO_CAPTURE;

 int e = ioctl(_fd,VIDIOC_STREAMOFF, &type);
 if(e < 0)
  throw Exception::create() << "Unable to end capture: \n"
  << strerror(errno);

 e = close(_fd);

 if(e < 0)
  throw Exception::create() << "Failed to close capture device: \n"
  << strerror(errno);

 if(_buf) {
  delete[] _buf;
  _buf = NULL;
 }

}//terminate


And this is the routine I use to start it again (this is the same routine
worked when I started the stream the first time):

void BitstreamGrabber_v4l2::start() {
 if(!_devicePath)
  throw Exception::create() << "Fatal program error. Cannot determine device
path";

 _fd = open(_devicePath,O_RDWR);

 if(_fd == -1)
  throw Exception::create() << "Cannot open device file "
  << path <<": \n"<< strerror(errno);

 checkCapabilities();

 _streamType = setFormat(true); //error occurs here

 _setfps = setFrameRate(_reqfps);

 allocateBuffers();

 int type = V4L2_BUF_TYPE_VIDEO_CAPTURE;

 int e = ioctl(_fd,VIDIOC_STREAMON, &type);
 if(e < 0)
  throw Exception::create() << "Unable to start capture: \n"
  << strerror(errno);

 unlock();
}//start

I detect the error within the setFormat() function after calling:

ioctl(_fd, VIDIOC_S_FMT, _fmt);

_fmt is exactly the same as in first round. The error I get from errno is:

"Device or Resource Busy"

I suspect this must be because either I am terminating or starting the
stream incorrectly or the kernel doesn't allow me to do this for some
reason?

I am running it on Ubuntu 8.10 Intrepid Ibex x64:

Linux garic6u 2.6.27-13-generic #1 SMP Thu Feb 26 07:31:49 UTC 2009 x86_64
GNU/Linux

Thank you very much in adavance.

Best Regards,

Garik
--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
