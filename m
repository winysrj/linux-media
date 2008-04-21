Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m3LNVGr1011825
	for <video4linux-list@redhat.com>; Mon, 21 Apr 2008 19:31:16 -0400
Received: from yw-out-2324.google.com (yw-out-2324.google.com [74.125.46.31])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m3LNV58l001727
	for <video4linux-list@redhat.com>; Mon, 21 Apr 2008 19:31:05 -0400
Received: by yw-out-2324.google.com with SMTP id 3so1002190ywj.81
	for <video4linux-list@redhat.com>; Mon, 21 Apr 2008 16:31:05 -0700 (PDT)
Date: Mon, 21 Apr 2008 16:15:04 -0700
From: "'Brandon Philips'" <brandon@ifup.org>
To: mschimek@gmx.at
Message-ID: <20080421231503.GB7392@plankton.ifup.org>
References: <op.t3hn72busxcvug@mrubli-nb.am.logitech.com>
	<20080213231244.GA15895@plankton.ifup.org>
	<20080415004416.GA11071@plankton.ifup.org>
	<000f01c89fa6$96c612d0$c4523870$@info>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <000f01c89fa6$96c612d0$c4523870$@info>
Cc: Martin Rubli <linux1@rubli.info>,
	'Linux and Kernel Video' <video4linux-list@redhat.com>
Subject: [PATCH] v4l2-spec: write-only controls
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

Hello Michael-

Please fold this new control flag into the v4l2spec.

Thanks,

	Brandon

diff -Naur v4l2spec-0.24/vidioc-queryctrl.sgml v4l2spec-0.24a/vidioc-queryctrl.sgml
--- v4l2spec-0.24/vidioc-queryctrl.sgml	2008-03-06 23:42:13.000000000 +0800
+++ v4l2spec-0.24a/vidioc-queryctrl.sgml	2008-04-16 17:27:36.000000000 +0800
@@ -361,6 +361,15 @@
             <entry>A hint that this control is best represented as a
 slider-like element in a user interface.</entry>
           </row>
+          <row>
+            <entry><constant>V4L2_CTRL_FLAG_WRITE_ONLY</constant></entry>
+            <entry>0x0040</entry>
+            <entry>This control is permanently writable only. Any
+attempt to read the control will result in an EACCES error code. This
+flag is typically present for relative controls or action controls where
+writing a value will cause the device to carry out a given action
+(e. g. motor control) but no meaningful value can be returned.</entry>
+          </row>
         </tbody>
       </tgroup>
     </table>

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
