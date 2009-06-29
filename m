Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx1.redhat.com (mx1.redhat.com [172.16.48.31])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n5TJA6ku019590
	for <video4linux-list@redhat.com>; Mon, 29 Jun 2009 15:10:06 -0400
Received: from diebold.com (mail2.verdico.com [208.228.181.118])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id n5TJ9rbH023975
	for <video4linux-list@redhat.com>; Mon, 29 Jun 2009 15:09:53 -0400
From: Diego de Freitas Nascimento <Diego.Nascimento@diebold.com>
To: video4linux-list@redhat.com
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Mon, 29 Jun 2009 03:04:20 -0300
Message-Id: <1246255460.3878.10.camel@dnascimento-pc.procomp.com.br>
Mime-Version: 1.0
Subject: ioctl failed with "Invalid Argument" Message
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

i'm trying to capture video from a web cam (vcamusb) and every ioctl
that i try return an error: "Invalid Argument".

For example. To set the contrast the code is:

...

v4l2_control ctrl;

memset( &ctrl, 0, sizeof( struct v4l2_control ) );

ctrl.id = V4L2_CID_CONTRAST;
ctrl.value = 80;

if ( ioctl( fd, VIDIOC_S_CTRL, &ctrl ) < 0 )
{
	perror( "VIDIOC_S_CTRL" );
}

...

this same code work to another camera (an uvc camera). But the driver to
uvc is already using v4l2 ioctls while the driver for vcamusb is using
old ioctls.

how can i fix this problem ?


--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
