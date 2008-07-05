Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m658MgHw015955
	for <video4linux-list@redhat.com>; Sat, 5 Jul 2008 04:22:42 -0400
Received: from smtp7-g19.free.fr (smtp7-g19.free.fr [212.27.42.64])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m658MS5g031627
	for <video4linux-list@redhat.com>; Sat, 5 Jul 2008 04:22:29 -0400
Received: from smtp7-g19.free.fr (localhost [127.0.0.1])
	by smtp7-g19.free.fr (Postfix) with ESMTP id 743FA322816
	for <video4linux-list@redhat.com>;
	Sat,  5 Jul 2008 10:22:28 +0200 (CEST)
Received: from [192.168.0.13] (lns-bzn-53-82-65-47-76.adsl.proxad.net
	[82.65.47.76])
	by smtp7-g19.free.fr (Postfix) with ESMTP id 337C33227F2
	for <video4linux-list@redhat.com>;
	Sat,  5 Jul 2008 10:22:28 +0200 (CEST)
From: Jean-Francois Moine <moinejf@free.fr>
To: video4linux-list@redhat.com
Content-Type: text/plain; charset=ISO-8859-1
Date: Sat, 05 Jul 2008 10:14:26 +0200
Message-Id: <1215245666.1697.5.camel@localhost>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [PULL] gspca 2.1.4
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

Hi Mauro,

Please pull from http://linuxtv.org/hg/~jfrancois/gspca/

for:

8164:64e1a6791544
gspca: Make CONFIG_VIDEO_ADV_DEBUG actually work.

8165:285f4b0807f2
From: Hans de Goede <j.w.r.degoede@hhs.nl>

8166:8c13846f43bd
gspca: Input buffer may be changed on reg write.

8167:feeaaa9d3ed3
gspca: Fix the format of the low resolution mode of spca561.

8168:ad75df3f3242
gspca: Input buffer overwritten in spca561 + cleanup code.

8169:facbd35d017f
gspca: Correct sizeimage in vidioc_s/try/g_fmt_cap

8170:8745ad321988
gspca: pac207 frames no more decoded in the subdriver.

8171:ce410a987cb8
gspca: Frame decoding errors when PAC207 in full daylight.

8172:ca7772029429
gspca: Compile warnings about NULL ptr.

Cheers.

-- 
Ken ar c'hentañ |             ** Breizh ha Linux atav! **
Jef             |               http://moinejf.free.fr/


--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
