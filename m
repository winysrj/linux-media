Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m7I87rDV024166
	for <video4linux-list@redhat.com>; Mon, 18 Aug 2008 04:07:55 -0400
Received: from smtp3-g19.free.fr (smtp3-g19.free.fr [212.27.42.29])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m7I87FxE004156
	for <video4linux-list@redhat.com>; Mon, 18 Aug 2008 04:07:15 -0400
From: Jean-Francois Moine <moinejf@free.fr>
To: rob <susegebr@gmail.com>
In-Reply-To: <48A8ACFB.4070506@gmail.com>
References: <48A8ACFB.4070506@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Date: Mon, 18 Aug 2008 09:54:36 +0200
Message-Id: <1219046076.1707.30.camel@localhost>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Cc: video4linux-list@redhat.com
Subject: Re: troubles with my webcam and kernel 2.6.27.rc3  Msi StarCam
	0xc45 0x60fc   sn9c105  hv7131r   with mic
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

On Sun, 2008-08-17 at 18:58 -0400, rob wrote:
> Hello all

Hello rob,

> This is my first post to this list

No, it is the second one ;)

> i have troubles with my webcam and kernel 2.6.27.rc3  (Opensuse)
> there are modules loaded gspca  sonic sn9s102 
> but no program sees the webcam
> The webcam is   Msi StarCam  0xc45 0x60fc   sn9c105  hv7131r   with mic

This webcam is handled by both the sn9c102 and gspca drivers. If the
driver sn9c102 is generated, gspca does not handle it.

> With the gspcav1 drivers compiled on kernel 2.6.25.11-0.1 (opensuse)
> the webcam is seen as a v4L1 webcam see  log below
	[snip]

If your webcam worked with gspca v1, it should work with gspca v2. So,
remove the driver sn9c102, get the last gspca v2 from

	http://linuxtv.org/hg/~jfrancois/gspca/

and look at the gspca_README.txt in my page for generation and usage.

Cheers.

-- 
Ken ar c'hentañ |             ** Breizh ha Linux atav! **
Jef             |               http://moinejf.free.fr/


--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
