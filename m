Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx2.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m8CHulfp001674
	for <video4linux-list@redhat.com>; Fri, 12 Sep 2008 13:56:47 -0400
Received: from mail-gx0-f15.google.com (mail-gx0-f15.google.com
	[209.85.217.15])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m8CHu6nT023962
	for <video4linux-list@redhat.com>; Fri, 12 Sep 2008 13:56:06 -0400
Received: by gxk8 with SMTP id 8so12656631gxk.3
	for <video4linux-list@redhat.com>; Fri, 12 Sep 2008 10:56:05 -0700 (PDT)
Message-ID: <37219a840809121056h5dd3fdb2la55345529d2ced82@mail.gmail.com>
Date: Fri, 12 Sep 2008 13:56:05 -0400
From: "Michael Krufky" <mkrufky@linuxtv.org>
To: LinuxDVB <linux-dvb@linuxtv.org>,
	"Linux and Kernel Video" <video4linux-list@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Cc: 
Subject: [RFC / TESTERS WANTED] tuner callback refactoring
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

This creates a standardized mechanism for callback functions within
the tuner / frontend drivers that can be used by all components
withing a "frontend" object to call back to the bridge / adapter
driver.

I have removed the duplicated tuner_callback function pointers from
all of the tuner driver configuration and private state structures,
replacing them with a general-purpose callback pointer within struct
dvb_frontend.

A new parameter is added to the callback function, called "component".
This allows us to use this callback pointer by frontend components
other than the tuner, if need be. So far, this is only used by tuner
drivers, but if other drivers need this functionality in the future,
this leaves room for it.

Please test my changes to ensure proper operation. Users should not
expect any change in functionality -- this should behave exactly the
same as the master v4l-dvb branch.

I have already tested various devices that use xc3028 and xc5000.  I
don't have access to DVB-T signals today to test the tda8275 /
tda8275a, so I'm especially interested in hearing feedback from users
testing devices that use those tuners.

Please reply to this thread with any comments, or details of bugs that
this change may have caused.  If you find a bug, please ensure that
you do not experience the same issue in today's master v4l-dvb branch
before posting.

I will be leaving for a short vacation in a few minutes, so I will
respond when I get back on Monday.

Users of devices that use Xceive and Philips silicon tuners, please
test the following changes in my mercurial tree:

http://linuxtv.org/hg/~mkrufky/fe-callback

- add a general-purpose callback pointer to struct dvb_frontend
- convert tuner drivers to use dvb_frontend->callback

 drivers/media/common/tuners/tda827x.c       |   12 +-
 drivers/media/common/tuners/tda827x.h       |    1
 drivers/media/common/tuners/tda8290.c       |    4
 drivers/media/common/tuners/tda8290.h       |    1
 drivers/media/common/tuners/tuner-xc2028.c  |   41 +++++-----
 drivers/media/common/tuners/tuner-xc2028.h  |    2
 drivers/media/common/tuners/xc5000.c        |    8 -
 drivers/media/common/tuners/xc5000.h        |    2
 drivers/media/dvb/dvb-core/dvb_frontend.h   |    2
 drivers/media/dvb/dvb-usb/cxusb.c           |    7 +
 drivers/media/dvb/dvb-usb/dib0700_devices.c |    8 +
 drivers/media/video/au0828/au0828-cards.c   |    2
 drivers/media/video/au0828/au0828-dvb.c     |    3
 drivers/media/video/au0828/au0828.h         |    3
 drivers/media/video/cx18/cx18-gpio.c        |    2
 drivers/media/video/cx18/cx18-gpio.h        |    2
 drivers/media/video/cx23885/cx23885-cards.c |    2
 drivers/media/video/cx23885/cx23885-dvb.c   |   12 --
 drivers/media/video/cx23885/cx23885.h       |    2
 drivers/media/video/cx88/cx88-cards.c       |   24 ++++-
 drivers/media/video/cx88/cx88-dvb.c         |   40 ---------
 drivers/media/video/cx88/cx88.h             |    2
 drivers/media/video/em28xx/em28xx-cards.c   |    2
 drivers/media/video/em28xx/em28xx-dvb.c     |    3
 drivers/media/video/em28xx/em28xx.h         |    2
 drivers/media/video/ivtv/ivtv-gpio.c        |    2
 drivers/media/video/ivtv/ivtv-gpio.h        |    2
 drivers/media/video/saa7134/saa7134-cards.c |    2
 drivers/media/video/saa7134/saa7134-dvb.c   |    7 -
 drivers/media/video/saa7134/saa7134.h       |    2
 drivers/media/video/tuner-core.c            |   10 --
 include/media/tuner.h                       |    2
 32 files changed, 92 insertions(+), 124 deletions(-)

Thanks,

Mike Krufky

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
