Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mB16WHbL025925
	for <video4linux-list@redhat.com>; Mon, 1 Dec 2008 01:32:17 -0500
Received: from tomts43-srv.bellnexxia.net (tomts43-srv.bellnexxia.net
	[209.226.175.110])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mB16W2dn026479
	for <video4linux-list@redhat.com>; Mon, 1 Dec 2008 01:32:02 -0500
Received: from toip5.srvr.bell.ca ([209.226.175.88])
	by tomts43-srv.bellnexxia.net
	(InterMail vM.5.01.06.13 201-253-122-130-113-20050324) with ESMTP id
	<20081201063201.OLFM1582.tomts43-srv.bellnexxia.net@toip5.srvr.bell.ca>
	for <video4linux-list@redhat.com>; Mon, 1 Dec 2008 01:32:01 -0500
From: Bill Pringlemeir <bpringle@sympatico.ca>
To: CityK <cityk@rogers.com>
References: <49334769.8070908@rogers.com>
Date: Mon, 01 Dec 2008 02:29:10 -0500
In-Reply-To: <49334769.8070908@rogers.com> (cityk@rogers.com's message of
	"Sun, 30 Nov 2008 21:09:45 -0500")
Message-ID: <87k5akbbg9.fsf@sympatico.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: V4L <video4linux-list@redhat.com>, Michael Krufky <mkrufky@linuxtv.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: KWorld ATSC 110 and NTSC
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

On 30 Nov 2008, cityk@rogers.com wrote:

> Bill Pringlemeir wrote:

>> I have experimented with this a bit further.  Here are some of my
>> observations,

>> I switch the antenna feed between top and bottom inputs with no effect
>> on getting the NTSC signal.

> The NTSC issue is a known problem.

http://marc.info/?l=linux-video&m=121210186625441&w=2

[... blah blah blah ...]

I did investigate some of the difference between 2.6.24 and more
recent kernels.  The code is far better; user should expect some pain.
I was just hoping I was helping with a new issue; but I guess the
kernel lags behind mecurial.

> I tracked the error down to a commit Mauro had made (IIRC, back in
> April) which ended up causing a regression on some boards (e.g. KWorld
> ATSC 110/115).  M.Krufky spun a quick patch (which works fine), but it
> cannot be applied to the main Hg sources as it too would break other
> things, and so some discussion would be needed to resolve the underlying
> problem.  I was going to bug Mauro about the issue, but never got around
> to it, and I don't know if Mike discussed this with Mauro at the recent
> Plummers conference.  (I have cc'ed both in on the message).

> Several posters on AVS forums were complaining of this and I posted a
> link to Mike's patch and instructions (including a warning that it could
> break support with other cards).  AFAIK, zero feedback was achieved from
> that, as posters were either too scared by the warning or couldn't
> follow the instructions, nor responded to further posts.  Whatever.

Google was not helpful at showing me this thread.  I patch and used
'rmmod tuner; modprobe tuner'.  This allow NTSC reception.

> In any regard, Mike's patch, as I said, works fine, albeit is not a
> perfect solution as it requires some manual intervention (or script) on
> the part of the user to enable the analogue TV functionality.

> Mauro -- the exact changeset in question is:   7753:67faa17a5bcb
> Mike's patch is located at:
> http://linuxtv.org/~mkrufky/fix-broken-atsc110-analog.patch

No, having an i2c driver muck with a tuner is not nice (it is what was
in the 2.6.24 kernel).

Couldn't the nxt200x driver be placing outputs in OC state via a
'hw_init' and 'hw_fini' type callback (or maybe
hw_quiescent). Switching between analog and digital demodulators would
need something like this?  When tuner-simple switches A/D, it needs to
make a call up to the main saa7134 driver to ask for the demodulators
(nxt200x) to be put in the right state (or is the saa7134 already
aware of this switch?).  At least, that is what somebody who knows
nothing about this code would expect.

Thanks,
Bill Pringlemeir.

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
