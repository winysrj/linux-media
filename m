Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mAAFXO4h031183
	for <video4linux-list@redhat.com>; Mon, 10 Nov 2008 10:33:24 -0500
Received: from ashesmtp01.verizonbusiness.com (ashesmtp01.verizonbusiness.com
	[198.4.8.163])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mAAFX9Ne022871
	for <video4linux-list@redhat.com>; Mon, 10 Nov 2008 10:33:09 -0500
Received: from dgismtp04.wcomnet.com ([166.38.58.144])
	by firewall.verizonbusiness.com
	(Sun Java(tm) System Messaging Server 6.3-5.02 (built Oct 12 2007;
	32bit))
	with ESMTP id <0KA400M86J78UO00@firewall.verizonbusiness.com> for
	video4linux-list@redhat.com; Mon, 10 Nov 2008 15:33:08 +0000 (GMT)
Received: from dgismtp04.wcomnet.com ([127.0.0.1])
	by dgismtp04.mcilink.com (iPlanet Messaging Server 5.2 HotFix 2.08
	(built Sep
	22 2005)) with SMTP id <0KA400D6UJ789R@dgismtp04.mcilink.com> for
	video4linux-list@redhat.com; Mon, 10 Nov 2008 15:33:08 +0000 (GMT)
Received: from [127.0.0.1] ([166.34.133.101])
	by dgismtp04.mcilink.com (iPlanet Messaging Server 5.2 HotFix 2.08
	(built Sep
	22 2005)) with ESMTP id <0KA400B5VJ75AL@dgismtp04.mcilink.com> for
	video4linux-list@redhat.com; Mon, 10 Nov 2008 15:33:08 +0000 (GMT)
Date: Mon, 10 Nov 2008 08:33:05 -0700
From: Mark Paulus <mark.paulus@verizonbusiness.com>
In-reply-to: <1cf807b00811100709p5c70701aoa11043e4d12388c8@mail.gmail.com>
To: Kris Huang <imaborg@gmail.com>
Message-id: <49185431.2070701@verizonbusiness.com>
MIME-version: 1.0
Content-type: multipart/mixed; boundary=------------050304010109070408000204
References: <1cf807b00811100709p5c70701aoa11043e4d12388c8@mail.gmail.com>
Cc: video4linux-list@redhat.com
Subject: Re: How to stop driver from loading to prevent from hanging during
 booting
Reply-To: mark.paulus@verizonbusiness.com
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

This is a multi-part message in MIME format.
--------------050304010109070408000204
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



Kris Huang wrote:
> Hi,
> 
>  Good day.
>  In order to get my Compro T750F channel switch working, I use hg and
> download the latest v4l drivers. After make install and reboot, my Ubuntu
> Intrepid box just hanged. I am not that familiar with Ubuntu, so I don't
> know how to stop the trouble driver from being loaded during the boot
> process.
>  Any ideas?
>  Thanks.
> 

looks like you need to add a file to /etc/modprobe.d directory,
something called, maybe, v4l-blacklist, and in it, put in the 
driver name that is hanging....  (looks like saa7134).

Have you downloaded firmware for this card, and put it into
/lib/firmware?  

There looks to be a bit of info in this post:
http://www.linuxtv.org/pipermail/linux-dvb/2007-April/017433.html

BTW, if booting into single user mode still tries to load the
driver, then you will need to boot off of a CD or floppy.  Your
Install media might have a "Go to Shell" option where you can
mount your hard drive and then edit your files, or something like
Tomsrtbt disk, or "The Ultimate Boot CD (UBCD)), or even
Mythubuntu or Knoppix/Mythknoppix.  Basically
you need to boot any kind of linux kernel/system that 
will allow you to go to a shell, mount your hard drive,
and then have vi or some other editor that will allow you 
to create the file(s) you need.

--------------050304010109070408000204
Content-Type: text/x-vcard; charset=utf-8;
 name="mark_paulus.vcf"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename="mark_paulus.vcf"

YmVnaW46dmNhcmQNCmZuOk1hcmsgUGF1bHVzDQpuOlBhdWx1cztNYXJrDQpvcmc6TUNJO0xl
YyBJbnRlcmZhY2VzIC8gNDA0MTkNCmFkcjtkb206OzsyNDI0IEdhcmRlbiBvZiB0aGUgR29k
cyBSZDtDb2xvcmFkbyBTcHJpbmdzO0NPOzgwOTE5DQplbWFpbDtpbnRlcm5ldDptYXJrLnBh
dWx1c0B2ZXJpem9uYnVzaW5lc3MuY29tDQp0aXRsZTpNYXJrIFBhdWx1cw0KdGVsO3dvcms6
NzE5LTUzNS01NTc4DQp0ZWw7cGFnZXI6ODAwLXBhZ2VtY2kgLyAxNDA2MDUyDQp0ZWw7aG9t
ZTp2NjIyLTU1NzgNCnZlcnNpb246Mi4xDQplbmQ6dmNhcmQNCg0K
--------------050304010109070408000204
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
--------------050304010109070408000204--
