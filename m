Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx1.redhat.com (mx1.redhat.com [172.16.48.31])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n1KHQ0Zm004140
	for <video4linux-list@redhat.com>; Fri, 20 Feb 2009 12:26:00 -0500
Received: from unifiedpaging.messagenetsystems.com
	(www.digitalsignage.messagenetsystems.com [24.123.23.170] (may
	be forged))
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id n1KHPqSP012685
	for <video4linux-list@redhat.com>; Fri, 20 Feb 2009 12:25:53 -0500
Message-ID: <499EE795.6030404@messagenetsystems.com>
Date: Fri, 20 Feb 2009 12:25:41 -0500
From: Robert Vincent Krakora <rob.krakora@messagenetsystems.com>
MIME-Version: 1.0
To: Devin Heitmueller <devin.heitmueller@gmail.com>
References: <412bdbff0902200317h26f4d42fh4327b3ff08c79d5c@mail.gmail.com>	
	<499EC9CC.3040703@linuxtv.org>	
	<b24e53350902200910p1f5745b6s864490400f50b9@mail.gmail.com>	
	<b24e53350902200911udfb9717t5429dd2b9fc81355@mail.gmail.com>	
	<b24e53350902200913h3760ccbdqc9f14217afe5fdb1@mail.gmail.com>
	<412bdbff0902200918g328b8541v5414ad98ead688a2@mail.gmail.com>
In-Reply-To: <412bdbff0902200918g328b8541v5414ad98ead688a2@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: V4L <video4linux-list@redhat.com>
Subject: Re: HVR-950q analog support - testers wanted
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

Devin Heitmueller wrote:
> On Fri, Feb 20, 2009 at 12:13 PM, Robert Krakora
> <rob.krakora@messagenetsystems.com> wrote:
>   
>> I have three Linux-based media-ports here and I will put an HR950Q on
>> each and let them run with my tester that changes channels and that
>> opens and closes the device...
>>     
>
> Robert,
>
> Thank you for offering to take the time to test.  I am definitely
> interested in the results.
>
> One thing worth noting is that Michael Krufky pointed out a couple of
> cases this morning where I missed a mutex, so if you connect multiple
> 950q's to the same system you might hit a race condition at system
> bootup.  I'll nail it down this weekend but I wanted to warn you in
> advance since you said you had multiple 950q devices.
>
> Of course, I would be *very* interested in finding some way to get you
> to do some testing of multiple devices connected at the same time once
> that fix is in.  I only have one unit to test with so I haven't really
> exercised that use case.
>
> Regards,
>
> Devin
>
>   
Devin:

I will test one per machine for now and I can put two on one of the 
machines once your mutex fix is in place.

Best Regards,
-- 
Rob Krakora
Senior Software Engineer
MessageNet Systems
101 East Carmel Dr. Suite 105
Carmel, IN 46032
(317)566-1677 Ext. 206
(317)663-0808 Fax

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
