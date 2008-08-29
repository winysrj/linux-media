Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx2.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m7TCKJlU019885
	for <video4linux-list@redhat.com>; Fri, 29 Aug 2008 08:20:20 -0400
Received: from ciao.gmane.org (main.gmane.org [80.91.229.2])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m7TCK9wc022103
	for <video4linux-list@redhat.com>; Fri, 29 Aug 2008 08:20:09 -0400
Received: from root by ciao.gmane.org with local (Exim 4.43)
	id 1KZ2xO-0004mC-Sg
	for video4linux-list@redhat.com; Fri, 29 Aug 2008 12:20:07 +0000
Received: from 210.212.120.92 ([210.212.120.92])
	by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
	id 1AlnuQ-0007hv-00
	for <video4linux-list@redhat.com>; Fri, 29 Aug 2008 12:20:02 +0000
Received: from vohra64 by 210.212.120.92 with local (Gmexim 0.1 (Debian))
	id 1AlnuQ-0007hv-00
	for <video4linux-list@redhat.com>; Fri, 29 Aug 2008 12:20:02 +0000
To: video4linux-list@redhat.com
From: Anil VOhra <vohra64@gmail.com>
Date: Fri, 29 Aug 2008 12:17:38 +0000 (UTC)
Message-ID: <loom.20080829T121154-418@post.gmane.org>
References: <1205053694.6188.312.camel@gloria.red.sld.cu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Subject: Re: Problems setting up Sabrent Mini Stick USB 2.0 TV Tuner
	(TV-USBST)	6000:0001
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

Maykel Moya <moya-lists <at> infomed.sld.cu> writes:

> 
> device: Sabrent Mini Stick USB 2.0 TV Tuner (TV-USBST)
> url: http://www.sabrent.com/products/specs/TV-USBST.htm
> id: 6000:0001
> chip: TM5600
> 
> And lsusb -d 6000:0001 -v output is attached.
> 
> I have a stock Debian 2.6.24 kernel. This is what I did:
> 
> 1. hg clone http://.../v4l-dvb v4l-dvb-upstream
> 2. hg clone http://.../tm6010 tm6010-upstream
> 3. hg clone v4l-dvb-upstream v4l-dvb
> 4. cd v4l-dvb
> 5. hg fetch ../tm6010-upstream
>    (some minor issues with file 
>     linux/drivers/media/video/tuner-xc2028.c during merge)
> 6. make && sudo make install
> 7. cd ../tm6010-upstream
> 8. copy /from/install/cd/the/right/tridvid.sys .
> 9. perl get_firmware.pl


TO install a tm5600 based device on Mandriva 2008.1 system, I was trying out 
the procedure outlined above. 

But I find that line 5 does not work with hg complaining not to recognize the 
command fetch

Any remedies?

Anil Vohra

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
