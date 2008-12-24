Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mBOEBBNU009681
	for <video4linux-list@redhat.com>; Wed, 24 Dec 2008 09:11:11 -0500
Received: from relay-pt2.poste.it (relay-pt2.poste.it [62.241.5.253])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mBOE8s0l023829
	for <video4linux-list@redhat.com>; Wed, 24 Dec 2008 09:08:54 -0500
Received: from geppetto.reilabs.com (78.15.202.84) by relay-pt2.poste.it
	(7.3.122) (authenticated as stefano.sabatini-lala@poste.it)
	id 49517C0000005B67 for video4linux-list@redhat.com;
	Wed, 24 Dec 2008 15:08:54 +0100
Received: from stefano by geppetto.reilabs.com with local (Exim 4.67)
	(envelope-from <stefano.sabatini-lala@poste.it>) id 1LFUOA-0004pV-Oi
	for video4linux-list@redhat.com; Wed, 24 Dec 2008 15:07:06 +0100
Date: Wed, 24 Dec 2008 15:07:06 +0100
From: Stefano Sabatini <stefano.sabatini-lala@poste.it>
To: video4linux-list Mailing List <video4linux-list@redhat.com>
Message-ID: <20081224140706.GA475@geppetto>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Subject: V4L1: what's the meaning of video_window.chromakey?
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

I'm reading/studying the code of a V4L1 application and I need to
understand the meaning of the video_window.chromakey field.

Official docs:
http://www.linuxtv.org/downloads/video4linux/API/V4L1_API.html

are not particularly exhaustive, so I'm falling back to request your
help here.

As far as I understood it, the video_window.chromakey field is used
only if video_capability.type & VID_TYPE_CHROMAKEY is true, and the
video_window.chromakey value (an RGB32 value, with the first byte set
to an undefined value) is set with the VIDIOCSWIN ioctl.

My guess is that V4L is using the simplest possible chromakeying
algorithm, so that it copies each pixel from the capture buffer to
the destination buffer with a value different from
video_window.chromakey.

Setting:
video_window.chromakey = -1; // the same as 0xffffffff

for example should copy all the pixels with a value different from
0xXXffffff to the destination buffer.

I wonder if this is the correct interpretation, and if the
chromakeying capability (if supported) can be disabled.

Many thanks in advance.

Regards.

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
