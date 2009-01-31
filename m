Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx1.redhat.com (mx1.redhat.com [172.16.48.31])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n0VEH5MB009129
	for <video4linux-list@redhat.com>; Sat, 31 Jan 2009 09:17:06 -0500
Received: from tjworld.net (tjworld.net [67.18.187.6] (may be forged))
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id n0VDwJUD006528
	for <video4linux-list@redhat.com>; Sat, 31 Jan 2009 08:59:18 -0500
Received: from [10.254.252.6] (hephaestion.lan.tjworld.net [10.254.252.6])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by tjworld.net (Postfix) with ESMTP id 8ADA61816C
	for <video4linux-list@redhat.com>; Sat, 31 Jan 2009 13:58:03 +0000 (GMT)
From: TJ <linux@tjworld.net>
To: "video4linux-list@redhat.com" <video4linux-list@redhat.com>
Content-Type: text/plain
Date: Sat, 31 Jan 2009 13:58:01 +0000
Message-Id: <1233410281.17740.7.camel@hephaestion>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: FTBFS: v4l/tvmixer.c:226: error: 'I2C_DRIVERID_TVMIXER' undeclared
	here
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

http://www.linuxtv.org/hg/v4l-dvb

v4l/tvmixer.c:226: error: 'I2C_DRIVERID_TVMIXER' undeclared here

There is a FTBFS as a result of changeset 10402 (backport merge
3541eb5b56f7) where the definition of I2C_DRIVERID_TVMIXER was removed:

+++ b/linux/include/linux/i2c-id.h	Thu Jan 29 10:57:25 2009 -0200 
@@ -40,9 +40,7 @@ 
#define I2C_DRIVERID_SAA7185B	13	/* video encoder		*/ 
#define I2C_DRIVERID_SAA7110	22	/* video decoder		*/ 
#define I2C_DRIVERID_SAA5249	24	/* SAA5249 and compatibles	*/ 
-#define I2C_DRIVERID_PCF8583	25	/* real time clock		*/ 
#define I2C_DRIVERID_TDA7432	27	/* Stereo sound processor	*/ 
-#define I2C_DRIVERID_TVMIXER    28      /* Mixer driver for tv cards    */ 
#define I2C_DRIVERID_TVAUDIO    29      /* Generic TV sound driver      */ 




--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
