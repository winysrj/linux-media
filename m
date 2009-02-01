Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx1.redhat.com (mx1.redhat.com [172.16.48.31])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n11ERoAX009370
	for <video4linux-list@redhat.com>; Sun, 1 Feb 2009 09:27:50 -0500
Received: from smtp4-g21.free.fr (smtp4-g21.free.fr [212.27.42.4])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id n11ERVRE032140
	for <video4linux-list@redhat.com>; Sun, 1 Feb 2009 09:27:33 -0500
Date: Sun, 1 Feb 2009 15:24:35 +0100
From: Jean-Francois Moine <moinejf@free.fr>
To: =?ISO-8859-1?Q?N=E9meth_M=E1rton?= <nm127@freemail.hu>
Message-ID: <20090201152435.0e06e42e@free.fr>
In-Reply-To: <49856A54.1020105@freemail.hu>
References: <49856A54.1020105@freemail.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Cc: video4linux-list@redhat.com, LKML <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.28 + Trust 610 LCD PowerC@m Zoom, webcam mode?
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

On Sun, 01 Feb 2009 10:24:36 +0100
Németh Márton <nm127@freemail.hu> wrote:
> Hello Jean-Francois,

Hello Márton,

> I have a Trust 610 LCD PowerC@m Zoom camera which can operate in
> webcam mode also (USB ID=06d6:0031). I tried to use it together with
> Linux 2.6.28 and with xawtv-3.95.dfsg.1 and with gqcam 0.9.1.
> The /dev/video0 appeared, but no usable picture was visible.
> 
> However, I downloaded
> http://mxhaard.free.fr/spca50x/Download/gspcav1-20071224.tar.gz and
	[snip]
> Do you have any idea why the gspcav1 diver is working and the one
> which is included in Linux 2.6.28 not?

The gspcav1 is not maintained anymore.

It seems that your webcam has not been tested with gspcav2.

First, did you use the v4l library and its wrapper when running xawtv
and gqcam?

Then, have you tried my program svv?

If nothing works, please, send me the kernel traces and the image.dat as
indicated in the gspca_README.txt of my page.

Best regards.

-- 
Ken ar c'hentañ	|	      ** Breizh ha Linux atav! **
Jef		|		http://moinejf.free.fr/

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
