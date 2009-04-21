Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n3L3UJhZ025792
	for <video4linux-list@redhat.com>; Mon, 20 Apr 2009 23:30:19 -0400
Received: from nlpi053.prodigy.net (nlpi053.sbcis.sbc.com [207.115.36.82])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id n3L3TCmP013566
	for <video4linux-list@redhat.com>; Mon, 20 Apr 2009 23:29:12 -0400
Message-ID: <49ED3D94.2020303@xnet.com>
Date: Mon, 20 Apr 2009 22:29:24 -0500
From: stuart <stuart@xnet.com>
MIME-Version: 1.0
To: video4linux-list@redhat.com
References: <49EC7CBF.2070109@xnet.com>
	<133336.82215.qm@web88206.mail.re2.yahoo.com>
In-Reply-To: <133336.82215.qm@web88206.mail.re2.yahoo.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Dwaine Garden VE3GIF <dwainegarden@rogers.com>
Subject: Re: Where is the v4l remote howto?  (kworld 110)
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


Thank you Dwaine for posting this kworld 110 patch to the v4l software.

So what you are indicating is that this patch, that has been around 
going on 2 years, is still not part of the v4l distribution?  Why?  (I 
have a feeling I should not direct this question to Dwaine as much as 
toward those controlling the v4l project.)

And if v4l is not going to support the IR feature of tuner cards... 
well... is there a way to easily disable the IR part of v4l?  I mean, 
from what I can tell, v4l "gets in the way" of lirc making it impossible 
for lirc to access the IR hardware.

Dwaine, I just tried the patch on a version of v4l I pulled some time 
ago (about 8 months).  It looks like more the half the "hunks" fail. 
Guess I'll have to do some hand merging if I want this to be successful.

I'll work on this a bit more.  But now I'm wondering if this is what 
people actually do?  I mean, is it worth anyone's time to keep fixing 
v4l (patching it) each time the old v4l gets over-written by a system 
update?

I'm guessing - but are most people giving up on their tuner's IR port 
and using dedicated IR / USB dongles instead?

-thanks again Dwaine



Dwaine Garden VE3GIF wrote:
> Here is the original patch that I had.  It worked, just the repeat keys 
> did not work.   It has not been compiled against a recent kernel though, 
> so it might need to small patching to compile.
> 
> 
> 
> ------------------------------------------------------------------------
> *From:* stuart <stuart@xnet.com>
> *To:* video4linux-list@redhat.com
> *Sent:* Monday, April 20, 2009 9:46:39 AM
> *Subject:* Where is the v4l remote howto? (kworld 110)
> 
> 
> Hi...
> 
> Remote control for tuner cards appears dicey and a bit confusing.  My 
> impression is that it's no were near as rock solid as the efforts here 
> (@ v4l) to support the tuner portion of the cards.  So I've always been 
> willing to put in some work.  When I used an analog happauge tuner card 
> I went to some length to get lirc working.  Now as I switch to digital, 
> I find my self wanting to use an old but well supported kworld 110 ATSC 
> tuner.  I assume this means I will be using v4l keyboard events instead 
> of the lirc kernel modules.  However, I've not found a good source of 
> information as to how to go about this.  It's more likely I haven't 
> googled properly.  Can anyone point me in the right direction?
> 
> ...thanks
> 
> 
> --
> video4linux-list mailing list
> Unsubscribe mailto:video4linux-list-request@redhat.com 
> <mailto:video4linux-list-request@redhat.com>?subject=unsubscribe
> https://www.redhat.com/mailman/listinfo/video4linux-list

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
