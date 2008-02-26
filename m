Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m1QGuTpD022786
	for <video4linux-list@redhat.com>; Tue, 26 Feb 2008 11:56:29 -0500
Received: from mail.mediaxim.be (dns.adview.be [193.74.142.132])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m1QGtwTi001298
	for <video4linux-list@redhat.com>; Tue, 26 Feb 2008 11:55:58 -0500
Received: from localhost (mail.mediaxim.be [127.0.0.1])
	by mail.mediaxim.be (MediaXim Mail Daemon) with ESMTP id CE9D734025
	for <video4linux-list@redhat.com>; Tue, 26 Feb 2008 17:55:54 +0100 (CET)
Received: from [10.32.13.124] (unknown [10.32.13.124])
	by mail.mediaxim.be (MediaXim Mail Daemon) with ESMTP id 71F6434022
	for <video4linux-list@redhat.com>; Tue, 26 Feb 2008 17:55:53 +0100 (CET)
Message-ID: <47C44499.7050506@mediaxim.be>
Date: Tue, 26 Feb 2008 17:55:53 +0100
From: Michel Bardiaux <mbardiaux@mediaxim.be>
MIME-Version: 1.0
To: video4linux-list@redhat.com
References: <47C3F5CB.1010707@mediaxim.be> <20080226130200.GA215@daniel.bse>
In-Reply-To: <20080226130200.GA215@daniel.bse>
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

Daniel Glöckner wrote:
> On Tue, Feb 26, 2008 at 12:19:39PM +0100, Michel Bardiaux wrote:
>> Here in Belgium the broadcasts is sometimes 4:3, sometimes 16:9. 
>> Currently, the card goes automatically in letterbox mode when it 
>> receives 16:9, and our software captures the 4:3 frames at size 704x576. 
> 
> The card does not go into letterbox mode. It's the broadcaster who
> squeezes the 16:9 picture into 432 lines surrounded by 144 black lines.

Let me rephrase to check I understood correctly. In analog TV, there are 
no anamorphic broadcasts. When the WSS (accessible via /dev/vbi, right?) 
states 16:9, then a 16:9 (sic) TV switches to a mode where it crops 2x72 
lines, then stretches the image both horizontally and vertically to fill 
the whole 16:9 screen. Am I correct?

I must admit I have difficulty believing that. Could you give me the 
URLs of sites explaining all that?

> Some fill the chroma part of the black lines with a PALPlus helper
> signal. Although the algorithms to decode PALPlus are well documented in
> ETS 300 731, I have never seen a software implementation.
> 
>> 1. How do I sense from the software that the mode is currently 16:9 or 4:3?
> 
> Some broadcasters use WSS to signal 16:9.
> In Germany some signal 4:3 even on 16:9 shows.
> Read ETSI EN 300 294.
> 
>> 2. How do I setup the bttv so that it does variable anamorphosis instead 
>> of letterboxing? If that is at all possible of course...
> 
> You can't. Bttv can't stretch vertically.
> 
>   Daniel


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
