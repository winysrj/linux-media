Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m6TAkAKd024453
	for <video4linux-list@redhat.com>; Tue, 29 Jul 2008 06:46:10 -0400
Received: from smtp6.versatel.nl (smtp6.versatel.nl [62.58.50.97])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m6TAjwCA012513
	for <video4linux-list@redhat.com>; Tue, 29 Jul 2008 06:45:58 -0400
Message-ID: <488EF032.4080802@hhs.nl>
Date: Tue, 29 Jul 2008 12:25:54 +0200
From: Hans de Goede <j.w.r.degoede@hhs.nl>
MIME-Version: 1.0
To: video4linux-list@redhat.com
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Subject: CONFIG_VIDEO_ADV_DEBUG question
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

Hi All,

CONFIG_VIDEO_ADV_DEBUG enables additional debugging output in the gscpa 
driver, which then becomes "active" when a module option gets passed. So 
in the gspca case it normally only results in a larger driver without 
causing additional debug unless module option is passed.

I've been asking the Fedora kernel maintainers to enable this option by 
default for the Fedora development version atleast, and thus I wonder 
how this option affects other drivers, are there other drivers which 
become very chatty with this option, or do they all need a module option 
to truely enable all the debug spew like gspca?

Regards,

Hans

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
