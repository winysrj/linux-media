Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m9VF3dwt020445
	for <video4linux-list@redhat.com>; Fri, 31 Oct 2008 11:03:39 -0400
Received: from namebay.info (mail.namebay.info [80.247.68.40])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m9VF2KoV004906
	for <video4linux-list@redhat.com>; Fri, 31 Oct 2008 11:02:20 -0400
Received: from localhost by namebay.info (MDaemon PRO v9.6.2)
	with ESMTP id md50003704121.msg
	for <video4linux-list@redhat.com>; Fri, 31 Oct 2008 16:02:26 +0100
Message-ID: <20081031160520.2cc7whghs0gs8osk@webmail.hebergement.com>
Date: Fri, 31 Oct 2008 16:05:20 +0100
From: fpantaleao@mobisensesystems.com
To: video4linux-list@redhat.com
MIME-Version: 1.0
Content-Type: text/plain;
	charset=ISO-8859-1;
	DelSp="Yes";
	format="flowed"
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
Subject: About CITOR register value for pxa_camera
Reply-To: fpantaleao@mobisensesystems.com
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

While testing, I think I have found one reason why overruns occur with  
pxa_camera.
I propose to set CITOR to a non-null value.
I have no more overrun for single image grab with CITOR=16 and much
greater reactivity.
There are still overrun for multiple image grab, I investigate that also and
post a message about it soon.

I would appreciate any comment about this.

Best regards.

--
Florian PANTALEAO
MOBISENSE SYSTEMS SARL


----------------------------------------------------------------
This message was sent using IMP, the Internet Messaging Program.



--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
