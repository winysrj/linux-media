Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx1.redhat.com (ext-mx06.extmail.prod.ext.phx2.redhat.com
	[10.5.110.10])
	by int-mx03.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id n9EMdgpg005609
	for <video4linux-list@redhat.com>; Wed, 14 Oct 2009 18:39:42 -0400
Received: from partygirl.tmr.com (mail.tmr.com [64.65.253.246])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id n9EMdU8d005732
	for <video4linux-list@redhat.com>; Wed, 14 Oct 2009 18:39:32 -0400
Message-ID: <4AD65320.6050600@tmr.com>
Date: Wed, 14 Oct 2009 18:39:28 -0400
From: Bill Davidsen <davidsen@tmr.com>
MIME-Version: 1.0
To: Devin Heitmueller <dheitmueller@kernellabs.com>
References: <4AC5FA6E.2000201@tmr.com>	
	<829197380910020940o599f5678t60abb2b2da6f8d46@mail.gmail.com>	
	<4AC64358.3010200@tmr.com>	
	<829197380910021134t4df64ddq279ab817b792855@mail.gmail.com>	
	<4AD643D2.1080904@tmr.com>
	<829197380910141442s5a0c255ei26669b5cc0a3c5d4@mail.gmail.com>
In-Reply-To: <829197380910141442s5a0c255ei26669b5cc0a3c5d4@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: video4linux M/L <video4linux-list@redhat.com>
Subject: Re: Upgrading from FC4 to current Linux
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
> Hello Bill,
>
> On Wed, Oct 14, 2009 at 5:34 PM, Bill Davidsen <davidsen@tmr.com> wrote:
> <snip>
>   
>> analog apps. I have a bunch of cards (mostly PCI) and several USB dongles,
>> none seem to do S-video under Linux. That's turned out to be more of an
>> issue than I expected as well, I considered feeding the USB to a VM and
>> Windows under KVM, but I really want Windows out!
>>     
>
> You have boards where the analog RF input works under Linux but the
> S-video does not?  That's a bit surprising given it's usually pretty
> trivial to make all the inputs work once you get the first one
> working.
>
> Which boards do you have?
>   

Sorry, I didn't say that clearly. Under FC4/FC6 the boards work for both 
analog and S-video. Under more recent kernels they don't seem to work 
for either with any application I tried. Applications offer dvb-t dvb-s 
etc, but don't seem to offer S-video input. Didn't mean to confuse the 
issue.

-- 
Bill Davidsen <davidsen@tmr.com>
  Unintended results are the well-earned reward for incompetence.

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
