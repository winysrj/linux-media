Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx1.redhat.com (mx1.redhat.com [172.16.48.31])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n5NEqRqS029435
	for <video4linux-list@redhat.com>; Tue, 23 Jun 2009 10:52:27 -0400
Received: from web35307.mail.mud.yahoo.com (web35307.mail.mud.yahoo.com
	[66.163.179.101])
	by mx1.redhat.com (8.13.8/8.13.8) with SMTP id n5NEq6Z6010194
	for <video4linux-list@redhat.com>; Tue, 23 Jun 2009 10:52:06 -0400
Message-ID: <656465.87998.qm@web35307.mail.mud.yahoo.com>
Date: Tue, 23 Jun 2009 07:52:05 -0700 (PDT)
From: Curtis Schroeder <cstarjewel@yahoo.com>
To: video4linux-list@redhat.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Subject: Helpful hints for gspca maintenance
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


A couple helpful hints I've learned for maintaining a gspca driver.

To rebuild the driver after a kernel update:

make clean
rm v4l/.version
make
sudo make install
sudo depmod -ae $(uname -r)

To automatically prevent the sn9c102 driver from being loaded.  Create file '/etc/modprobe.d/blacklist' with the following content:

#webcam bad driver
blacklist sn9c102

I hope others on this list find this information helpful,

Curt



      

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
