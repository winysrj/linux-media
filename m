Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m4KLbeEV030478
	for <video4linux-list@redhat.com>; Tue, 20 May 2008 17:37:40 -0400
Received: from ashesmtp01.verizonbusiness.com (ashesmtp01.verizonbusiness.com
	[198.4.8.163])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m4KLbSuA009650
	for <video4linux-list@redhat.com>; Tue, 20 May 2008 17:37:28 -0400
Received: from dgismtp05.wcomnet.com ([166.38.58.88])
	by firewall.verizonbusiness.com
	(Sun Java(tm) System Messaging Server 6.3-5.02 (built Oct 12 2007;
	32bit))
	with ESMTP id <0K1600M16S2AZ600@firewall.verizonbusiness.com> for
	video4linux-list@redhat.com; Tue, 20 May 2008 21:37:22 +0000 (GMT)
Received: from dgismtp05.wcomnet.com ([127.0.0.1])
	by dgismtp05.mcilink.com (iPlanet Messaging Server 5.2 HotFix 2.08
	(built Sep
	22 2005)) with SMTP id <0K160060YS2A3Z@dgismtp05.mcilink.com> for
	video4linux-list@redhat.com; Tue, 20 May 2008 21:37:22 +0000 (GMT)
Received: from [127.0.0.1] ([166.34.132.9])
	by dgismtp05.mcilink.com (iPlanet Messaging Server 5.2 HotFix 2.08
	(built Sep
	22 2005)) with ESMTP id <0K1600463S27PA@dgismtp05.mcilink.com> for
	video4linux-list@redhat.com; Tue, 20 May 2008 21:37:22 +0000 (GMT)
Date: Tue, 20 May 2008 15:37:24 -0600
From: Mark Paulus <mark.paulus@verizonbusiness.com>
In-reply-to: <4291817.1211318326884.JavaMail.root@mswamui-billy.atl.sa.earthlink.net>
To: Adam Glover <aglover.v4l@mindspring.com>
Message-id: <48334494.9090505@verizonbusiness.com>
MIME-version: 1.0
Content-type: multipart/mixed; boundary=------------030708070109030201050208
References: <4291817.1211318326884.JavaMail.root@mswamui-billy.atl.sa.earthlink.net>
Cc: video4linux-list@redhat.com
Subject: Re: Problems building on Debian Etch
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
--------------030708070109030201050208
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



Adam Glover wrote:
> Kernel 2.6.18 (2.6.18.6?) is over a year old.  I don't know what
> the latest kernel available in the Etch repositories but Sid has
> the latest stable version (2.6.18.25 as of a few weeks ago) so
> you might want to update your kernel.  Etch doesn't appear to
> have a newer kernel, so you will need to compile your own.
> 
> I had problems just a few weeks ago compiling mercurial against
> 2.6.25.2 (linux stable) due to recent changes in the Linux GIT
> branches not yet merged into stable.  In my case, the errors
> only occurred for certain modules which I did not need so I was
> able to compile without them.
> 

Actually, you can get 2.6.24 from etchnhalf...
http://wiki.debian.org/EtchAndAHalf
Has info on what to add to /etc/apt/sources.list


--------------030708070109030201050208
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
--------------030708070109030201050208
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
--------------030708070109030201050208--
