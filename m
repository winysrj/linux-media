Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m3G9kCpp017072
	for <video4linux-list@redhat.com>; Wed, 16 Apr 2008 05:46:12 -0400
Received: from hera.newvibes.ch (alpha673.server4you.de [85.25.130.137])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m3G9ji21026749
	for <video4linux-list@redhat.com>; Wed, 16 Apr 2008 05:45:55 -0400
From: "Martin Rubli" <linux1@rubli.info>
To: "'Brandon Philips'" <brandon@ifup.org>
References: <op.t3hn72busxcvug@mrubli-nb.am.logitech.com>
	<20080213231244.GA15895@plankton.ifup.org>
	<20080415004416.GA11071@plankton.ifup.org>
In-Reply-To: <20080415004416.GA11071@plankton.ifup.org>
Date: Wed, 16 Apr 2008 17:45:10 +0800
Message-ID: <000f01c89fa6$96c612d0$c4523870$@info>
MIME-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----=_NextPart_000_0010_01C89FE9.A4E952D0"
Content-Language: en-us
Cc: 'Linux and Kernel Video' <video4linux-list@redhat.com>
Subject: RE: [PATCH] Support for write-only controls
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

This is a multipart message in MIME format.

------=_NextPart_000_0010_01C89FE9.A4E952D0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit

Hi Brandon,

> -----Original Message-----
> From: Brandon Philips [mailto:brandon@ifup.org]
> Sent: Tuesday, April 15, 2008 08:44
> To: Martin Rubli; linux1@rubli.info; Laurent Pinchart
> Cc: Linux and Kernel Video
> Subject: Re: [PATCH] Support for write-only controls
> 
> On 15:12 Wed 13 Feb 2008, Brandon Philips wrote:
> > On 01:01 Tue 18 Dec 2007, Martin Rubli wrote:
> > > Thanks a lot for all your feedback and the constructive discussion and
> sorry
> > > for the delay while I was without Internet on the weekend. I'll try to
> > > summarize what we have so far:
> > >
> > > Write-only controls:
> > >
> > > It seems, everybody likes EACCES. Michael, maybe we could get some
> feedback
> > > from you on this? It would be nice to change the spec, so that EACCES
> also
> > > becomes the error for writing read-only controls--it seems
appropriate.
> But
> > > if for some reason we can't change that we should probably make the
> > > write-only controls consistent and return EINVAL as well.
> > >
> > > Unusable controls due to device communication error:
> > >
> > > The easiest solution seems to be to set the V4L2_CTRL_FLAG_DISABLED
> flag as
> > > was suggested. The documentation currently says "permanently disabled
> and
> > > should be ignored by the application" which I think is exactly what
> applies
> > > to the situation. The V4L2_CTRL_FLAG_NEXT_CTRL would still be
> respected by
> > > drivers supporting the extended control enumeration, so no need to the
> spec
> > > is required. But I would still add a short paragraph about the first
part as
> > > a guide for future implementations and a witness of this thread. ;-)
> > >
> > > As soon as everyone agrees on this, I will propose new patches. Let me
> know
> > > what you think ...
> >
> 
> Ping.  I never saw patches come across for this.

Attached the patch for videodev2.h and the documentation sources.

Signed-off-by: Martin Rubli <linux1 rubli info>

Cheers,
Martin

------=_NextPart_000_0010_01C89FE9.A4E952D0
Content-Type: application/octet-stream; name="v4l2_ctrl_flag_write_only.patch"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
	filename="v4l2_ctrl_flag_write_only.patch"

diff -Naur v4l-dvb-5de66b04c598/linux/include/linux/videodev2.h =
v4l-dvb-new/linux/include/linux/videodev2.h=0A=
--- v4l-dvb-5de66b04c598/linux/include/linux/videodev2.h	2008-04-16 =
06:22:11.000000000 +0800=0A=
+++ v4l-dvb-new/linux/include/linux/videodev2.h	2008-04-16 =
17:37:38.000000000 +0800=0A=
@@ -831,6 +831,7 @@=0A=
 #define V4L2_CTRL_FLAG_UPDATE 		0x0008=0A=
 #define V4L2_CTRL_FLAG_INACTIVE 	0x0010=0A=
 #define V4L2_CTRL_FLAG_SLIDER 		0x0020=0A=
+#define V4L2_CTRL_FLAG_WRITE_ONLY 	0x0040=0A=
 =0A=
 /*  Query flag, to be ORed with the control ID */=0A=
 #define V4L2_CTRL_FLAG_NEXT_CTRL	0x80000000=0A=

------=_NextPart_000_0010_01C89FE9.A4E952D0
Content-Type: application/octet-stream;
	name="v4l2_ctrl_flag_write_only-doc.patch"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment; filename="v4l2_ctrl_flag_write_only-doc.patch"

diff -Naur v4l2spec-0.24/vidioc-queryctrl.sgml =
v4l2spec-0.24a/vidioc-queryctrl.sgml=0A=
--- v4l2spec-0.24/vidioc-queryctrl.sgml	2008-03-06 23:42:13.000000000 =
+0800=0A=
+++ v4l2spec-0.24a/vidioc-queryctrl.sgml	2008-04-16 17:27:36.000000000 =
+0800=0A=
@@ -361,6 +361,15 @@=0A=
             <entry>A hint that this control is best represented as a=0A=
 slider-like element in a user interface.</entry>=0A=
           </row>=0A=
+          <row>=0A=
+            =
<entry><constant>V4L2_CTRL_FLAG_WRITE_ONLY</constant></entry>=0A=
+            <entry>0x0040</entry>=0A=
+            <entry>This control is permanently writable only. Any=0A=
+attempt to read the control will result in an EACCES error code. This=0A=
+flag is typically present for relative controls or action controls where=0A=
+writing a value will cause the device to carry out a given action=0A=
+(e. g. motor control) but no meaningful value can be returned.</entry>=0A=
+          </row>=0A=
         </tbody>=0A=
       </tgroup>=0A=
     </table>=0A=

------=_NextPart_000_0010_01C89FE9.A4E952D0
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
------=_NextPart_000_0010_01C89FE9.A4E952D0--
