Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m3JDMxuE005406
	for <video4linux-list@redhat.com>; Sat, 19 Apr 2008 09:22:59 -0400
Received: from imo-d03.mx.aol.com (imo-d03.mx.aol.com [205.188.157.35])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m3JDMPx2026729
	for <video4linux-list@redhat.com>; Sat, 19 Apr 2008 09:22:25 -0400
Received: from JonLowe@aol.com
	by imo-d03.mx.aol.com (mail_out_v38_r9.3.) id e.d20.289507f7 (37059)
	for <video4linux-list@redhat.com>; Sat, 19 Apr 2008 09:22:05 -0400 (EDT)
References: <8CA6F8825F2FE35-FC8-9F4@FWM-D12.sysops.aol.com>	<37219a840804181210s2f98c017t59b296ee65be720a@mail.gmail.com>
	<8CA6FF11949B262-3AC-9C68@webmail-nb12.sysops.aol.com>
To: video4linux-list@redhat.com
Date: Sat, 19 Apr 2008 09:22:01 -0400
In-Reply-To: <8CA6FF11949B262-3AC-9C68@webmail-nb12.sysops.aol.com>
MIME-Version: 1.0
From: Jon Lowe <jonlowe@aol.com>
Message-Id: <8CA70377CC5AC92-D6C-9F4@webmail-me16.sysops.aol.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Subject: Re: HVR-1500 issues
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


 Ok, got it to work with Me-TV.? Wasn't set to auto update in Ubuntu 8.04, and I had a buggy version.

New question: I can get nothing on analog NTSC in TVTime of any other analog app.? Is the analog side of the HVR-1500 supported yet?


 


Jon Lowe

 


 

-----Original Message-----
From: Jon Lowe <jonlowe@aol.com>
To: video4linux-list@redhat.com
Sent: Fri, 18 Apr 2008 11:58 pm
Subject: Re: HVR-1500 issues









Ok, I got it to work in Kaffeine.  No luck in ME-TV yet.  Rather use 
ME-TV as it autoscans.   Kaffeine is a pita to set up.?
?

How do you use azap?  Where do you put the channels.conf to use it with 
azap??
?

Jon?
?


When I test my boards, I use 'scan' (from dvb-apps, aka dvb-utils?

package) to scan for channels, then I use azap to tune (always pass -r?

and leave it open) , and view the stream using mplayer?

/dev/dvb/adapterX/dvr0.?
?

?






 

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
