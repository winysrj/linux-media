Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m51J7bqJ002689
	for <video4linux-list@redhat.com>; Sun, 1 Jun 2008 15:07:37 -0400
Received: from cdptpa-omtalb.mail.rr.com (cdptpa-omtalb.mail.rr.com
	[75.180.132.120])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m51J7PTS016697
	for <video4linux-list@redhat.com>; Sun, 1 Jun 2008 15:07:25 -0400
Date: Sun, 1 Jun 2008 14:07:14 -0500
From: David Engel <david@istwok.net>
To: Michael Krufky <mkrufky@linuxtv.org>
Message-ID: <20080601190714.GB23388@opus.istwok.net>
References: <f50b38640805291557m38e6555aqe9593a2a42706aa5@mail.gmail.com>
	<20080530145830.GA7177@opus.istwok.net>
	<f50b38640805300841q1a4f05c3udbf0d0f7f19cdb6e@mail.gmail.com>
	<20080530171850.GA8130@opus.istwok.net>
	<37219a840806010015i342f324dl3a9849579d2defb5@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <37219a840806010015i342f324dl3a9849579d2defb5@mail.gmail.com>
Cc: video4linux-list@redhat.com, Jason Pontious <jpontious@gmail.com>
Subject: Re: Kworld 115-No Analog Channels
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

On Sun, Jun 01, 2008 at 03:15:30AM -0400, Michael Krufky wrote:
> On Fri, May 30, 2008 at 1:18 PM, David Engel <david@istwok.net> wrote:
> > If dtv_input is set to 0, it will be misinterpreted as autoselect and
> > then the use of QAM_64 or QAM_256 will make the code use input 1!
> 
> "1" is tuner 1
> "2" is tuner 2  (actually, "not one" is tuner "not one")
> "0" is autoselect

Ah, OK.  Thanks for clarifying.

David
-- 
David Engel
david@istwok.net

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
