Return-path: <video4linux-list-bounces@redhat.com>
Message-ID: <496AB41E.8020507@rogers.com>
Date: Sun, 11 Jan 2009 22:08:14 -0500
From: CityK <cityk@rogers.com>
MIME-Version: 1.0
To: Josh Borke <joshborke@gmail.com>
References: <496A9485.7060808@gmail.com>
In-Reply-To: <496A9485.7060808@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: V4L <video4linux-list@redhat.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Michael Krufky <mkrufky@linuxtv.org>,
	David Lonie <loniedavid@gmail.com>, linux-media@vger.kernel.org
Subject: Re: KWorld ATSC 115 all static
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <linux-media.vger.kernel.org>

Josh Borke wrote:
> After upgrading to Fedora 10 I am no longer able to tune analog or dvb
> channels using my KWorld ATSC 115. When I try to view a channel with
> tvtime all I can see is static and when I try to scandvb I keep
> getting tuning failed even though I know that there are channels being
> broadcast on the channels scanned. I have tried to find tips on the
> wiki of how to resolve my static problem but I could not find any. I'm
> not sure where to look for clues as to why it isn't working.
>
> I have a 1-to-4 splitter with 2 outputs going to the inputs of the
> KWorld ATSC and another going to a TV so I know there is signal on the
> cable.
>
> Any help would be really appreciated.

Hello everyone,

In addition to being a general broadcast message, I have cc'ed  in a
number of folks.

This (broken analog TV on, at the very minimum, the KWorld 110 and 115
cards) is a known problem that has persisted for a long time.  Far too
long now.   I last wrote about it here: 
http://marc.info/?l=linux-video&m=122809741331944&w=2.  No response was
generated from that.  So I will try again and outline what I believe is
the relevant history:

- Mauro, you introduced a regression for these boards in changeset: 
7753:67faa17a5bcb  (http://linuxtv.org/hg/v4l-dvb/rev/67faa17a5bcb). 
Since that commit, analog TV has been broken for these cards.

- Michael commented about this here:
http://marc.info/?l=linux-video&m=121243712021921&w=2

- Mauro responded here: 
http://marc.info/?l=linux-video&m=121243995927725&w=2

- Several users have brought this up since then (both here on the m/l's
and on internet forums) .

- Michael spun a stopgap solution for this (found here
:http://linuxtv.org/~mkrufky/fix-broken-atsc110-analog.patch
<http://linuxtv.org/%7Emkrufky/fix-broken-atsc110-analog.patch> ).  It
still applies cleanly.  Unfortunately, it is not a bonafide solution
because: (a) upon each reboot of the system, the user is required to
first "modprobe tuner -r" and then "modprobe tuner" before the analog
tuning will initialize and function properly.  (b) In addition,
Michael's patch may affect/break other devices, so it can not be
committed to the master repo.

- Hans, I know you have done a lot of clean ups in regards to i2c, but
do not know whether any of your work would have touched upon or have had
any impact here.  Nonetheless, I'd appreciate your input on the matter
too if you are able to comment.

I am hoping that this can be resolved to everyone's satisfaction.  In my
opinion, this should become a priority item, as this regression's life
has spanned over 4 kernels.

[For the sake of full disclosure, I am personally affected by the issue,
but I note that I use Mike's patch each and everyday (thank you Mike!),
and so, other then the minor inconvenience of having to do a modprobe
dance with the tuner module, I am not impacted too much.  Other users,
however, are left in the dark.  And, as I explained in my last message,
those AVS users that I addressed this issue with seemed entirely
hesitant about using the patch (maybe I scared them with a greivious
warning ??).  Anyway, as evidenced by Josh  (OP for this message) and
David (see his recent messages; e.g.
http://marc.info/?l=linux-video&m=123066362106086&w=2), end users
continue to encounter  this problem.  I am only surprised that we
haven't heard more about this issue.  As I noted earlier on, I believe
that its impact is greater then just upon the KWorld 11x cards.]





--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
