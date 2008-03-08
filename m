Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m28IoOdv028281
	for <video4linux-list@redhat.com>; Sat, 8 Mar 2008 13:50:24 -0500
Received: from web56412.mail.re3.yahoo.com (web56412.mail.re3.yahoo.com
	[216.252.111.91])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id m28InlRD027693
	for <video4linux-list@redhat.com>; Sat, 8 Mar 2008 13:49:48 -0500
Date: Sat, 8 Mar 2008 10:49:41 -0800 (PST)
From: r bartlett <techwritebos@yahoo.com>
To: video4linux-list@redhat.com
In-Reply-To: <47D2CF95.3060001@tmr.com>
MIME-Version: 1.0
Message-ID: <48012.76691.qm@web56412.mail.re3.yahoo.com>
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Subject: Re: WinTV-HVR-1800 help...
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

Okay, so if I get the rabbit ears, am I right to think that the following command will set up the channels?

/usr/bin/scandvb /usr/share/dvb-apps/atsc/us-MA-Boston

Currently when I do this it progressively searches and says "tuning failed" each time, producing an error at the end because it didn't find any channels.

But if I had atsc signals that would work?  And then I run xawtv to view them?

Apparently the digital package in my area does require a box (though each time I chat with Comcast I get a different answer), and is more expensive.  So that nixes, for now, SD and Clear QAM...right?

Where does one find rabbit ears these days?  Radio Shack?


Bill Davidsen <davidsen@tmr.com> wrote:
I would check pricing very carefully, to see if you can just change to 
the digital plan and not get a box converter. Don't assume it's bundled.

Second, borrow an old set of rabbit ears and *try* the signal on digital 
broadcast. Radio is limited to 50kw max, while most TV stations run 
200kw or more, giving you at least 3db more signal. The broadcast is 
amazing, in addition to five networks[1] in NTSC and HD, I get weather 
and alternate content from most of them, and some alternative 
programming like ION network, with several levels of content.

> Again, thanks for any and all help getting this going.  It's not a massive problem if I can't figure it out, but I do greatly appreciate the help/time.  
> 
Don't assume any worst cases without testing, I was totally amazed at 
what came over the air and what was on the digital cable I didn't expect.

[1] ABC, CBS, FOX, NBC, PBS. Also ION and whatever is called C-W.


-- 
Bill Davidsen 
   "We have more to fear from the bungling of the incompetent than from
the machinations of the wicked."  - from Slashdot


       
---------------------------------
Be a better friend, newshound, and know-it-all with Yahoo! Mobile.  Try it now.
--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
