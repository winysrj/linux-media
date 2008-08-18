Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m7IBCiNp024409
	for <video4linux-list@redhat.com>; Mon, 18 Aug 2008 07:12:44 -0400
Received: from smtp8-g19.free.fr (smtp8-g19.free.fr [212.27.42.65])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m7IBCgAs000444
	for <video4linux-list@redhat.com>; Mon, 18 Aug 2008 07:12:43 -0400
From: Jean-Francois Moine <moinejf@free.fr>
To: ravi <ravi@mrt-communication.com>
In-Reply-To: <013a01c900eb$d77a7090$2000a8c0@Sneha>
References: <013a01c900eb$d77a7090$2000a8c0@Sneha>
Content-Type: text/plain; charset=ISO-8859-1
Date: Mon, 18 Aug 2008 12:59:35 +0200
Message-Id: <1219057175.1707.60.camel@localhost>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Cc: video4linux-list@redhat.com
Subject: Re: video errors while running USB webcam on ARM linux system
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

On Mon, 2008-08-18 at 10:05 +0530, ravi wrote:
> Hi,

Hi Ravi,

> I am using a USB webcam from Dream Logic-AP1501,a taiwanese company.I have downloaded the provided by you i.e gspca-20071224 tar file.I am trying this USB webcam 
> 
> to work on ARM9 processor,after cross compiling  and porting the module, i am able to detect my USB webcam  as "SONIX JPEG camera".
	[snip]

The driver gspca v1 is not maintained anymore. You shall use the gspca
v2 instead (look at my page).

Otherwise, the error -38 seems to indicate you have problems in the USB
subsystem (usb driver? - check the loaded modules - ohci/uhci/ehci).

Best regards.

-- 
Ken ar c'hentañ |             ** Breizh ha Linux atav! **
Jef             |               http://moinejf.free.fr/


--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
