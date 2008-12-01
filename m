Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mB12A0w1003684
	for <video4linux-list@redhat.com>; Sun, 30 Nov 2008 21:10:00 -0500
Received: from smtp121.rog.mail.re2.yahoo.com (smtp121.rog.mail.re2.yahoo.com
	[206.190.53.26])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id mB129jff031151
	for <video4linux-list@redhat.com>; Sun, 30 Nov 2008 21:09:46 -0500
Message-ID: <49334769.8070908@rogers.com>
Date: Sun, 30 Nov 2008 21:09:45 -0500
From: CityK <cityk@rogers.com>
MIME-Version: 1.0
To: V4L <video4linux-list@redhat.com>, bpringle@sympatico.ca,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Michael Krufky <mkrufky@linuxtv.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: 
Subject: KWorld ATSC 110 and NTSC [was: 2.6.25+ and KWorld ATSC 110 inputs]
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

Hi Bill,

Bill Pringlemeir wrote:

> I have experimented with this a bit further.  Here are some of my
> observations,
>  
> I switch the antenna feed between top and bottom inputs with no effect
> on getting the NTSC signal.
>   

The NTSC issue is a known problem.

I tracked the error down to a commit Mauro had made (IIRC, back in
April) which ended up causing a regression on some boards  (e.g. KWorld
ATSC 110/115).  M.Krufky spun a quick patch (which works fine), but it
cannot be applied to the main Hg sources as it too would break other
things, and so some discussion would be needed to resolve the underlying
problem.  I was going to bug Mauro about the issue, but never got around
to it, and I don't know if Mike discussed this with Mauro at the recent
Plummers conference.  (I have cc'ed both in on the message).

Several posters on AVS forums were complaining of this and I posted a
link to Mike's patch and instructions (including a warning that it could
break support with other cards).  AFAIK, zero feedback was achieved from
that, as posters were either too scared by the warning or couldn't
follow the instructions, nor responded to further posts.  Whatever.

In any regard, Mike's patch, as I said, works fine, albeit is not a
perfect solution as it requires some manual intervention (or script) on
the part of the user to enable the analogue TV functionality.

Mauro -- the exact changeset in question is:   7753:67faa17a5bcb
Mike's patch is located at:
http://linuxtv.org/~mkrufky/fix-broken-atsc110-analog.patch




--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
