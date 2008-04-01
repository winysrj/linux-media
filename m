Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m315947I030097
	for <video4linux-list@redhat.com>; Tue, 1 Apr 2008 01:09:04 -0400
Received: from fg-out-1718.google.com (fg-out-1718.google.com [72.14.220.159])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m3158FDY029384
	for <video4linux-list@redhat.com>; Tue, 1 Apr 2008 01:08:52 -0400
Received: by fg-out-1718.google.com with SMTP id e12so1840176fga.7
	for <video4linux-list@redhat.com>; Mon, 31 Mar 2008 22:08:52 -0700 (PDT)
Message-ID: <47F1C35F.6090109@claranet.fr>
Date: Tue, 01 Apr 2008 07:08:47 +0200
From: Eric Thomas <ethomas@claranet.fr>
MIME-Version: 1.0
To: video4linux <video4linux-list@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Subject: conflicting syntax used DVB_FE_CUSTOMISE / DVB_FE_CUSTOMIZE
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

from drivers/media/video/cx23885/Kconfig

   select DVB_PLL if !DVB_FE_CUSTOMISE
   select TUNER_XC2028 if !DVB_FE_CUSTOMIZE

Considering that cx23885 support has joinded rc kernels, I guess it's
only an obvious typo ?

Eric

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
