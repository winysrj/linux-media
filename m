Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m318hRRh015272
	for <video4linux-list@redhat.com>; Tue, 1 Apr 2008 04:43:27 -0400
Received: from rv-out-0910.google.com (rv-out-0910.google.com [209.85.198.191])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m318hGNb024211
	for <video4linux-list@redhat.com>; Tue, 1 Apr 2008 04:43:16 -0400
Received: by rv-out-0910.google.com with SMTP id k15so1199537rvb.51
	for <video4linux-list@redhat.com>; Tue, 01 Apr 2008 01:43:16 -0700 (PDT)
Message-ID: <998e4a820804010143w79ff1513x9ba0945576cfad9a@mail.gmail.com>
Date: Tue, 1 Apr 2008 16:43:16 +0800
From: "=?GB2312?B?t+v2zg==?=" <fengxin215@gmail.com>
To: video4linux-list@redhat.com
MIME-Version: 1.0
Content-Type: text/plain; charset=GB2312
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Subject: some question for "soc_camera V4L2 interface for directly connected
	cameras"
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

I use a driver that is "soc_camera V4L2 interface for directly
connected cameras".but I have some problems:
1¡¢is this driver for linux-2.6.24?
2¡¢I want to know how can I get arch/arm/mach-pxa/devices.c.
3¡¢the function mt9v022_probe(struct i2c_client *client) in mt9v022.c
does not execute,why?

thanks
fengxin

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
