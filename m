Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m7BDdGbu017443
	for <video4linux-list@redhat.com>; Mon, 11 Aug 2008 09:39:16 -0400
Received: from omzesmtp02a.verizonbusiness.com
	(omzesmtp02a.verizonbusiness.com [199.249.25.198])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m7BDdEZw018114
	for <video4linux-list@redhat.com>; Mon, 11 Aug 2008 09:39:14 -0400
Received: from pmismtp05.wcomnet.com ([166.37.158.165])
	by firewall.verizonbusiness.com
	(Sun Java(tm) System Messaging Server 6.3-5.02 (built Oct 12 2007;
	32bit))
	with ESMTP id <0K5F00B46V918H00@firewall.verizonbusiness.com> for
	video4linux-list@redhat.com; Mon, 11 Aug 2008 13:39:02 +0000 (GMT)
Received: from pmismtp05.wcomnet.com ([127.0.0.1])
	by pmismtp05.mcilink.com (iPlanet Messaging Server 5.2 HotFix 2.08
	(built Sep
	22 2005)) with SMTP id <0K5F005P6V91DK@pmismtp05.mcilink.com> for
	video4linux-list@redhat.com; Mon, 11 Aug 2008 13:39:01 +0000 (GMT)
Received: from [127.0.0.1] ([166.34.132.9])
	by pmismtp05.mcilink.com (iPlanet Messaging Server 5.2 HotFix 2.08
	(built Sep
	22 2005)) with ESMTP id <0K5F0050XV5OSJ@pmismtp05.mcilink.com> for
	video4linux-list@redhat.com; Mon, 11 Aug 2008 13:39:01 +0000 (GMT)
Date: Mon, 11 Aug 2008 07:37:03 -0600
From: Mark Paulus <mark.paulus@verizonbusiness.com>
To: Linux and Kernel Video <video4linux-list@redhat.com>
Message-id: <48A0407F.8020104@verizonbusiness.com>
MIME-version: 1.0
Content-type: multipart/mixed; boundary=------------060308070801030205090105
Subject: Help with recent DVB/QAM problem please.
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
--------------060308070801030205090105
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi all,

Background:
I have a machine in my basement with:
Hauppauge PVR-150 (connected to DCT2524)
Air2PC ATSC/OTA card (connected to antenna in attic)
Avermedia A180 (connected to comcast cable)
Dvico FusionHDTV RT 5 Lite (connectec comcast cable)
Debian using 2.6.24-x64 kernel

Situation:
Up until a week ago, I was able to use azap to tune in
a bunch of mplexids, and get good locks on both the 
A180 and the Dvico card.  However, starting on Monday,
I am not able to get locks on either of my DVB cards.
I have been able, and am still able to get good locks
on my air2pc OTA card.

Can anyone help me figure out why I can't seem to see
anything from my 2 QAM cards?  I've tried running a
dvbscan and neither card can make a good lock.

Thanks.

-- 
Mark Paulus
2424 Garden of the Gods Rd  | Phone:  v622-5578 / 719-535-5578
0419/117 - LEC Access ; D5-1010   | FAX:    719-535-1665
Colo Springs, CO  80919    | 1800PageMCI / 1406052
AIM : mgpaulus1    /  sametime : mark.paulus



--------------060308070801030205090105
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
--------------060308070801030205090105
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
--------------060308070801030205090105--
