Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from fk-out-0910.google.com ([209.85.128.190])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <mrechberger@gmail.com>) id 1KhQXP-0000IQ-5N
	for linux-dvb@linuxtv.org; Sun, 21 Sep 2008 17:07:54 +0200
Received: by fk-out-0910.google.com with SMTP id f40so1326308fka.1
	for <linux-dvb@linuxtv.org>; Sun, 21 Sep 2008 08:07:47 -0700 (PDT)
Message-ID: <d9def9db0809210807k43467bf6y78a9797c28b4da99@mail.gmail.com>
Date: Sun, 21 Sep 2008 17:07:47 +0200
From: "Markus Rechberger" <mrechberger@gmail.com>
To: "Paul Chubb" <paulc@singlespoon.org.au>
In-Reply-To: <48CB978D.1030308@singlespoon.org.au>
MIME-Version: 1.0
Content-Disposition: inline
References: <485872.32367.qm@web46101.mail.sp1.yahoo.com>
	<48CB978D.1030308@singlespoon.org.au>
Cc: "linux-dvb >> linux dvb" <linux-dvb@linuxtv.org>
Subject: Re: [linux-dvb] Why my binary-only Win95 closed-source drivers
	trump your puny free-as-in-beer etc. [was: Re: why (etc.)]
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

On Sat, Sep 13, 2008 at 12:35 PM, Paul Chubb <paulc@singlespoon.org.au> wrote:
> Barry,
> delightful post. I am not sure I am able to answer all your questions
> because my experience is strictly limited to what I have done in the
> last three weeks. My experience is two surmountable incompatibilities.
> Being a newbie I may have misunderstood what I am seeing but:
>
> 1) My take is that the mcentral.de tree was originally based somewhere
> around 2.6.22. At some stage the functionality in videobuf_core.c was
> replaced by video-buf-dvb.c. This meant that when you compile against
> the 2.6.22 headers it works fine but still loads the videobuf_core
> module from the previous module set. Once you get to 2.6.24 it still
> loads videobuf_core, however now you get a lot of symbol issues when it
> loads and ultimately the driver for the card didn't work. This was
> simply fixed by removing all the old drivers in the drivers/media/video
> directory.
>

slightly wrong assumption it's separated since 2.6.12 and earlier
probably already
it was a staging tree for linuxtv initially, the changes grew and are
out of scope of
a staging tree for linuxtv now. It's a full development tree on its
own regulary adding
support for newer devices. eg. currently there are full hybrid
analogTV/DVB-T/DVB-C/radio
devices, ISDB-T and DMB-TH on the list to get in there.

Also when looking at the other repositories on mcentral.de, there are
applications like
tvtime, vlc, gqradio which are modified in order to support those
devices. It's not only about
the driver there.

As for the Acer One Aspire it's nearly impossible to get audio work at
all the default way,
there has been some development at that side too in order to just get
it work without
having to modify the whole system. (eg em28xx-aad, which is work in
progress too).


> 2) The v4l-dvb tree has complex firmware loading logic in tuner-xc2028.c
> that is tied to a single file that has lots of firmware modules in it.
> the mcentral.de tree has that code replaced by a new xc3028-tuner module
> that is designed to load individual fw files. Mr Rechberger managed to
> get original firmware from Xcieve.
>

Yes we have full Xceive manufacturer support, I mainly leave those
modules for Xceive
since they still use to update those drivers and we sometimes have to
adjust some settings
too in order to increase the signal quality. The Xceive tuners will
remain a topic for us.

tuner-xc2028 is Mauro's work which was cobbled together from a leaked
outdated xc3028
source which has been sent around last year, the code is quite
asynchronous with what
xceive actually delivers not taking care about their changes and bugs.
Personally I'm no fan
of that firmware parsing stuff, we have devices which require 4
firmwares already in order
to get those components work. The usual user way is to search it with
google (even though when
it's documented on linuxtv.org).

We also have commercial customers which build further products with
our devices they keep
watching particular parts of the driver quite intensive, and we also
use to provide custom
v4l2/dvb/atsc patches for their applications. As for them it's also
comfortable just to receive
rpm, debian or other packages not touching anything of their existing
system but still adding
full support for the product which they use. Many of them already have
the UVC driver built against
their running system and wouldn't like to upgrade the core.

There will always be people not liking this situation but alot people
also prefer it to have it like that.
Upstream pushes of the existing code can be discussed on the em28xx
mailinglist I'm open for such a
discussion (we have the necessary kernel changes but still some open
points which came in again recently).

There are more or less more contributors there as can be seen in the
commit logs which
show up the constant development.
http://mcentral.de/hg/~mrec/em28xx-new/shortlog

-Markus

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
