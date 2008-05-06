Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m46CsZ4B021170
	for <video4linux-list@redhat.com>; Tue, 6 May 2008 08:54:35 -0400
Received: from mail.uni-paderborn.de (mail.uni-paderborn.de [131.234.142.9])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m46CsL3u004410
	for <video4linux-list@redhat.com>; Tue, 6 May 2008 08:54:21 -0400
Message-ID: <482054F9.4000509@hni.uni-paderborn.de>
Date: Tue, 06 May 2008 14:54:17 +0200
From: Stefan Herbrechtsmeier <hbmeier@hni.uni-paderborn.de>
MIME-Version: 1.0
To: video4linux-list@redhat.com
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 8bit
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: mt9m001 and mt9v022 in mercurial source don't compile due to I2C
 API change
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

Hi,

the mt9m001 and mt9v022 driver in mercurial source don't compile against 
a 2.6.25 kernel
due to I2C API change in the next kernel.

Regards
    Stefan

-- 
Dipl.-Ing. Stefan Herbrechtsmeier

Heinz Nixdorf Institute
University of Paderborn 
System and Circuit Technology 
Fürstenallee 11
D-33102 Paderborn (Germany)

office : F0.415
phone  : + 49 5251 - 60 6342
fax    : + 49 5251 - 60 6351

mailto : hbmeier@hni.upb.de

www    : http://wwwhni.upb.de/sct/mitarbeiter/hbmeier


--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
