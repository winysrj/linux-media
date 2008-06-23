Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m5NARXZf031766
	for <video4linux-list@redhat.com>; Mon, 23 Jun 2008 06:27:33 -0400
Received: from aragorn.vidconference.de (dns.vs-node3.de [87.106.12.105])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m5NAQDJD030174
	for <video4linux-list@redhat.com>; Mon, 23 Jun 2008 06:26:16 -0400
Message-ID: <485F7A42.8020605@vidsoft.de>
Date: Mon, 23 Jun 2008 12:26:10 +0200
From: Gregor Jasny <jasny@vidsoft.de>
MIME-Version: 1.0
To: linux-uvc-devel@lists.berlios.de, video4linux-list@redhat.com
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: 
Subject: Thread safety of ioctls
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

in our video conference application the grabbing (QBUF, DQBUF) is done 
in a separate thread. The main thread is responsible for the user 
interface and queries the controls, input and current standard values 
from time to time.

With the latest uvc driver (r217) and vanilla Linux 2.6.25.6 I've 
noticed the strange behavior that the grabbing thread hangs in the DQBUF 
ioctl. If I remove the control queries from the gui thread everything is 
working fine. After the first hang of the driver, even luvcview hangs at 
the buffer operation.

With the bttv driver everything works fine. I'll test vivi and pwc 
driver later.

My systems are a i686 and one amd64 system with one Logitech 9000 and 
one Microsoft NX-6000. I've tried to create a simple testcase, but 
suprinsingly this testcase works fine.

Can I enable more logging than setting the trace parameter to 0xfff?
Have you any idea what went wrong here? Is the V4L2-API designed to be 
thread safe?

Thanks,
Gregor

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
