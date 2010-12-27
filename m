Return-path: <mchehab@gaivota>
Received: from mx1.redhat.com (ext-mx02.extmail.prod.ext.phx2.redhat.com
	[10.5.110.6])
	by int-mx10.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id oBRFXeTc029894
	for <video4linux-list@redhat.com>; Mon, 27 Dec 2010 10:33:40 -0500
Received: from relay.ptn-ipout01.plus.net (relay.ptn-ipout01.plus.net
	[212.159.7.35])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id oBRFXVXa018413
	for <video4linux-list@redhat.com>; Mon, 27 Dec 2010 10:33:32 -0500
Message-ID: <4209e98c6d38ac56dfa55e254b65b6ab.squirrel@webmail.plus.net>
Date: Mon, 27 Dec 2010 15:33:30 -0000
Subject: Setting up Philips SPC 200NC webcam
From: "Anthony Hilton" <ajh@tinshill.f9.co.uk>
To: video4linux-list@redhat.com
MIME-Version: 1.0
List-Unsubscribe: <https://www.redhat.com/mailman/options/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: video4linux-list-bounces@redhat.com
Sender: Mauro Carvalho Chehab <mchehab@gaivota>
List-ID: <video4linux-list@redhat.com>

Apologies if this is too basic for here - please redirect me to
documentation or another mail list if appropriate.

I have looked through a couple of years of archives and found the thread
"Skype and libv4l" from March 2009 but I do not understand it enough to
take any action.

I have a Philips SPC 200NC USB webcam connected to my OpenSuSE system,
which I want to use with Skype.

I have attempted to follow the HowTo from
<http://www.tldp.org/HOWTO/html_single/Webcam-HOWTO/>

I installed the pwc driver and have /dev/video0 present.

xawtv-3.95 running on Linus/i686 (2.6.31.14-0.4-default) will display
webcam video in a window so I'm nearly there. On startup it reports:

This is xawtv-3.95, running on Linux/i686 (2.6.31.14-0.4-default)
xinerama 0: 1280x1024+0+0
/dev/video0 [v4l2]: no overlay support
v4l-conf had some trouble, trying to continue anyway
ioctl: VIDIOC_G_STD(std=0xb73f4f40b7770199
[PAL_B,PAL_H,PAL_I,PAL_K,PAL_M,SECAM_B,SECAM_D,SECAM_G,SECAM_K,SECAM_K1,SECAM_L,ATSC_16_VSB,(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null),(null)]):
Invalid argument

the xawtv menu shows video source zc3xx

Cheese 2.28.1 flickers the webcam indicator when loading but only ever
displays the test pattern.

Skype (2.1 beta) also flickers the webcam indicator when  I attempt to
test the webcam but I don't see any image.


I'm hoping that if I get Cheese working Skype will also work.


All comments and advice gratefully received

Anthony



--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
