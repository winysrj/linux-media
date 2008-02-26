Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m1QGf2Or010225
	for <video4linux-list@redhat.com>; Tue, 26 Feb 2008 11:41:02 -0500
Received: from mail.mediaxim.be (dns.adview.be [193.74.142.132])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m1QGeTEv021284
	for <video4linux-list@redhat.com>; Tue, 26 Feb 2008 11:40:30 -0500
Received: from localhost (mail.mediaxim.be [127.0.0.1])
	by mail.mediaxim.be (MediaXim Mail Daemon) with ESMTP id 046CB34020
	for <video4linux-list@redhat.com>; Tue, 26 Feb 2008 17:40:28 +0100 (CET)
Received: from [10.32.13.124] (unknown [10.32.13.124])
	by mail.mediaxim.be (MediaXim Mail Daemon) with ESMTP id DB6CA3401F
	for <video4linux-list@redhat.com>; Tue, 26 Feb 2008 17:40:27 +0100 (CET)
Message-ID: <47C440FB.8080705@mediaxim.be>
Date: Tue, 26 Feb 2008 17:40:27 +0100
From: Michel Bardiaux <mbardiaux@mediaxim.be>
MIME-Version: 1.0
To: video4linux-list@redhat.com
References: <47C3F5CB.1010707@mediaxim.be> <20080226130200.GA215@daniel.bse>
	<20080226133839.GE26389@devserv.devel.redhat.com>
In-Reply-To: <20080226133839.GE26389@devserv.devel.redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Subject: Re: Grabbing 4:3 and 16:9
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

Alan Cox wrote:
> On Tue, Feb 26, 2008 at 02:02:00PM +0100, Daniel Glöckner wrote:
>>> 2. How do I setup the bttv so that it does variable anamorphosis instead 
>>> of letterboxing? If that is at all possible of course...
>> You can't. Bttv can't stretch vertically.
> 
> Use an OpenGL texture is probably the easiest for that kind of effect.

I didnt want the stretch per se, but to avoid losing info because of the 
letterboxing (the final project involves reading small print from film 
credits on the captured MPEGs). But Daniel wrote that the 16:9 analog 
broadcasts have only 432 lines, so the info is not there in the first 
place. So that effect isnt an option for me. But thanks anyway.

-- 
Michel Bardiaux
R&D Director
T +32 [0] 2 790 29 41
F +32 [0] 2 790 29 02
E mailto:mbardiaux@mediaxim.be

Mediaxim NV/SA
Vorstlaan 191 Boulevard du Souverain
Brussel 1160 Bruxelles
http://www.mediaxim.com/

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
