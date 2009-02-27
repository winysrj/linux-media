Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n1RFlfm0014699
	for <video4linux-list@redhat.com>; Fri, 27 Feb 2009 10:47:41 -0500
Received: from smtp102.biz.mail.re2.yahoo.com (smtp102.biz.mail.re2.yahoo.com
	[68.142.229.216])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id n1RFlMX0025571
	for <video4linux-list@redhat.com>; Fri, 27 Feb 2009 10:47:22 -0500
Message-ID: <49A80A0B.6080602@embeddedalley.com>
Date: Fri, 27 Feb 2009 18:43:07 +0300
From: Vitaly Wool <vital@embeddedalley.com>
MIME-Version: 1.0
To: Vitaly Wool <vital@embeddedalley.com>
References: <49A3A61F.30509@embeddedalley.com>	<20090224234205.7a5ca4ca@pedra.chehab.org>	<49A53CB9.1040109@embeddedalley.com>	<20090225090728.7f2b0673@caramujo.chehab.org>	<49A567D9.80805@embeddedalley.com>	<20090225101812.212fabbe@caramujo.chehab.org>	<49A57BD4.6040209@embeddedalley.com>	<20090225153323.66778ad2@caramujo.chehab.org>	<49A59B31.9080407@embeddedalley.com>	<20090225204023.16b96fe5@pedra.chehab.org>
	<49A802ED.2060200@embeddedalley.com>
In-Reply-To: <49A802ED.2060200@embeddedalley.com>
Content-Type: text/plain; charset=KOI8-R; format=flowed
Content-Transfer-Encoding: 7bit
Cc: video4linux-list@redhat.com, Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: em28xx: Compro VideoMate For You sound problems
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

Vitaly Wool wrote:

> Ok, I'm working on that. The problem as of now is that it works fine on 
> 2.6.26 and doesn't work with 2.6.29-rc5.
> I'll get back to you when I find out the reason.
And here's the patch that solves the problem:

diff --git a/drivers/media/video/tvaudio.c b/drivers/media/video/tvaudio.c
index 5aeccb3..ae4b231 100644
--- a/drivers/media/video/tvaudio.c
+++ b/drivers/media/video/tvaudio.c
@@ -169,12 +169,14 @@ static int chip_write(struct CHIPSTATE *chip, int subaddr, int val)
 			return -1;
 		}
 	} else {
+#if 0
 		if (subaddr + 1 >= ARRAY_SIZE(chip->shadow.bytes)) {
 			v4l2_info(sd,
 				"Tried to access a non-existent register: %d\n",
 				subaddr);
 			return -EINVAL;
 		}
+#endif
 
 		v4l2_dbg(1, debug, sd, "chip_write: reg%d=0x%x\n",
 			subaddr, val);



Apparently this check is bogus. The patch for em28xx stuff will follow, after some cleanups.

Thanks,
   Vitaly

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
