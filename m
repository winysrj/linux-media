Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx1.redhat.com (ext-mx06.extmail.prod.ext.phx2.redhat.com
	[10.5.110.10])
	by int-mx03.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id o5N9K8tU010879
	for <video4linux-list@redhat.com>; Wed, 23 Jun 2010 05:20:09 -0400
Received: from mail-vw0-f46.google.com (mail-vw0-f46.google.com
	[209.85.212.46])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id o5N9JueN015825
	for <video4linux-list@redhat.com>; Wed, 23 Jun 2010 05:19:56 -0400
Received: by vws9 with SMTP id 9so881321vws.33
	for <video4linux-list@redhat.com>; Wed, 23 Jun 2010 02:19:56 -0700 (PDT)
MIME-Version: 1.0
Date: Wed, 23 Jun 2010 17:19:56 +0800
Message-ID: <AANLkTikFxDxD_p_Gt8DazzywifbtTTnrkEHs2XFFAMmD@mail.gmail.com>
Subject: User Controls
From: jiangtao nie <caicai0119@gmail.com>
To: video4linux-list@redhat.com
List-Unsubscribe: <https://www.redhat.com/mailman/options/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

Dear ALL:

   V4L2 has defined many user controls IDs prefixed with V4L2_CID_, which
can be found in header file *videodev*2*.h* or *v4l2 spec*. Does it miss
any?  For example, Camera class control IDs have been pre-defined as
followed.

*/*in videodev2.h*/*
 */*  Camera class control IDs */*
*#define V4L2_CID_CAMERA_CLASS ** **(V4L2_CTRL_CLASS_CAMERA | 1)*
*#define V4L2_CID_EXPOSURE_AUTO** **(V4L2_CID_CAMERA_CLASS_BASE+1)*
*.....................................*
*#define V4L2_CID_PRIVACY** **(V4L2_CID_CAMERA_CLASS_BASE+16)*

  16 IDs has been defined,But Camera terminal support 19 controls described
UVC spec.

     *D00 Scanning Mode*

*     D01 Auto-Exposure Mode*

*     D02 Auto-Exposure Priority*

*     D03 Exposure Time (Absolute)*

*     D04 Exposure Time (Relative)*

*     D05 Focus (Absolute)*

*     D06 Focus (Relative)*

*     D07 Iris (Absolute)*

*     D08 Iris (Relative)*

*     D09 Zoom (Absolute)*

*     D10 Zoom (Relative)*

*     D11 Pan (Absolute)*

*     D12 Pan (Relative)*

*     D13 Roll (Absolute)*

*     D14 Roll (Relative)*

*     D15 Tilt (Absolute)*

*     D16 Tilt (Relative)*

*     D17 Focus Auto*

*     D18 Privacy*

*
*

*     Would V4l2 will support all controls defined by uvc?*

*
*

*
*

*Tony*
--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
