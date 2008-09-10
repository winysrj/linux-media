Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from hs-out-0708.google.com ([64.233.178.250])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <mkrufky@gmail.com>) id 1KdRoS-0000iu-80
	for linux-dvb@linuxtv.org; Wed, 10 Sep 2008 17:41:02 +0200
Received: by hs-out-0708.google.com with SMTP id 4so829650hsl.1
	for <linux-dvb@linuxtv.org>; Wed, 10 Sep 2008 08:40:56 -0700 (PDT)
Message-ID: <37219a840809100840q3f614720wb0ae7849027e4d88@mail.gmail.com>
Date: Wed, 10 Sep 2008 11:40:55 -0400
From: "Michael Krufky" <mkrufky@linuxtv.org>
To: urishk@yahoo.com
In-Reply-To: <260419.76903.qm@web38806.mail.mud.yahoo.com>
MIME-Version: 1.0
Content-Disposition: inline
References: <630160.40997.qm@web46116.mail.sp1.yahoo.com>
	<260419.76903.qm@web38806.mail.mud.yahoo.com>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Multiproto API/Driver Update
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

On Wed, Sep 10, 2008 at 5:16 AM, Uri Shkolnik <urishk@yahoo.com> wrote:
> Barry,
>
> My name is Uri Shkolnik and I'm Siano's software architect.
>
> If you would like to add a generic support for DAB, T-DMB, DAB2, DAB-IP, etc. to LinuxTV, it'll be great!
>
> I can assist you with generic information, plus chipset specific information.
>
> If you have a DAB related RF feed, I even can, on certain conditions, to supply you with a hardware (USB or SDIO based), I already did so before with different open source / Linux projects.
>
> I'm not sure that DVB sub-system is the perfect location for DAB related devices, and what about multi-DTV devices? (Siano based chipsets devices support many DTV standards, DVB-x and DAB-y among them), maybe somewhere up the chain (under media/common ? elsewhere? I'm not pretending to be a Linux kernel nor LinuxTV expert).
>
> Anyway, keep in touch, just letting you know that I'm here... (except my vacation between Sep 19th and Oct 20th :-)

Uri,

The policy on this mailing list is not to top-post.  Email replies
should appear below the quoted text -- please keep this in mind for
the future.

As far as your previous comments, please get over the DVB
nomenclature.  LinuxDVB is the _name_ of the Linux kernel subsystem
that deals with digital media, as a whole, *not* limited to DVB-T,
DVB-S, DVB-C, DVB-T2, DVB-S2, DVB-C2, ATSC, ISDB-T, DVB-H, DMB-TH,
DAB,  etc etc etc

Your comment stating that, "the LinuxTV/DVB sub-system will not
support non-DVB standards in the near future" is entirely invalid.
There is no reason why the LinuxDVB API cannot be extended to support,
as you call them, "non-DVB" standards.

Now that you, Uri, have joined our community and are offering help
with documentation, specifications, etc, this is a great opportunity
to help in adding support for these new standards to the Linux Kernel.

Just so that everybody is on the same page here, there are two API
proposals on the table.  These proposals deal with ways to extend the
LinuxDVB API for future expansion.   The issue being discussed is
*not*  how to deal with adding support for additional standards -- we
already have that covered.  Regardless of whether Manu's proposal or
Steve's proposal is accepted, support for the same additional
standards will be added, while still leaving room for future
expansion.

Once the decision is officially made, as per who's API extension
proposal is accepted, then I welcome you to start discussing how we
can add support for the additional standards into the kernel.

Please don't reply to this message -- we're better off dealing with
this topic in a _new_ thread, after the API discussions have
completed.  To continue on with this here will only distract from the
threads original topic.

Thank you for your input.

Regards,

Mike Krufky

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
