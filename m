Return-path: <video4linux-list-bounces@redhat.com>
MIME-Version: 1.0
Date: Thu, 12 Mar 2009 10:14:38 +0100
Message-ID: <23be820f0903120214j3104a4e2jb56d1250c9a3331a@mail.gmail.com>
From: Gregor Fuis <gujs.lists@gmail.com>
To: linux-media@vger.kernel.org, video4linux-list@redhat.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: 
Subject: disable v4l2-ctl logging --log-status in /var/log/messages
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <linux-media.vger.kernel.org>

Hello,

Is it possible to disable v4l2-ctl application logging into
/var/log/messages.
I am using it to control and monitor my PVR 150 cards and every time I run
v4l2-ctl -d /dev/video0 --log-status all output is logged into
/var/log/messages and some other linux log files.

Best Regards,
Gregor
--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
