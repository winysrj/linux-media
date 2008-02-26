Return-path: <video4linux-list-bounces@redhat.com>
Date: Tue, 26 Feb 2008 12:24:35 -0500
From: Alan Cox <alan@redhat.com>
To: Michel Bardiaux <mbardiaux@mediaxim.be>
Message-ID: <20080226172435.GC5445@devserv.devel.redhat.com>
References: <47C3F5CB.1010707@mediaxim.be> <20080226130200.GA215@daniel.bse>
	<20080226133839.GE26389@devserv.devel.redhat.com>
	<47C440FB.8080705@mediaxim.be>
	<20080226170215.GB4682@devserv.devel.redhat.com>
	<47C4488A.8080107@mediaxim.be>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47C4488A.8080107@mediaxim.be>
Cc: Alan Cox <alan@redhat.com>, video4linux-list@redhat.com
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

On Tue, Feb 26, 2008 at 06:12:42PM +0100, Michel Bardiaux wrote:
> As I find more relevant pages, my question has now become: given a 
> 768x576 capture (by a BT878) can I check whether the PALPLUS is there? 

I don't know and the manual doesn't seem to answer that. You can certainly
fish out stuff like teletext info  in software that way (and US closed
caption/analog ip over tv)

> No use trying to implement the decoder in software if the signal simply 
> isnt there!

Agreed

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
