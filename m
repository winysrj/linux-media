Return-path: <video4linux-list-bounces@redhat.com>
Date: Tue, 26 Feb 2008 12:02:15 -0500
From: Alan Cox <alan@redhat.com>
To: Michel Bardiaux <mbardiaux@mediaxim.be>
Message-ID: <20080226170215.GB4682@devserv.devel.redhat.com>
References: <47C3F5CB.1010707@mediaxim.be> <20080226130200.GA215@daniel.bse>
	<20080226133839.GE26389@devserv.devel.redhat.com>
	<47C440FB.8080705@mediaxim.be>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47C440FB.8080705@mediaxim.be>
Cc: video4linux-list@redhat.com
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

On Tue, Feb 26, 2008 at 05:40:27PM +0100, Michel Bardiaux wrote:
> credits on the captured MPEGs). But Daniel wrote that the 16:9 analog 
> broadcasts have only 432 lines, so the info is not there in the first 
> place. So that effect isnt an option for me. But thanks anyway.

Per frame.... if you sample as it scrolls and line up the title tops I suspect
most of the time you can get more samples as the title moves.

Just a crazy idea

Alan

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
