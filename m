Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from n55.bullet.mail.sp1.yahoo.com ([98.136.44.188])
	by www.linuxtv.org with smtp (Exim 4.63)
	(envelope-from <free_beer_for_all@yahoo.com>) id 1KYRPD-00017e-4n
	for linux-dvb@linuxtv.org; Wed, 27 Aug 2008 22:14:17 +0200
Date: Wed, 27 Aug 2008 13:06:59 -0700 (PDT)
From: barry bouwsma <free_beer_for_all@yahoo.com>
To: Beth <beth.null@gmail.com>
In-Reply-To: <7641eb8f0808261538i569a9cc5o1f7a6a106f0b04c8@mail.gmail.com>
MIME-Version: 1.0
Message-ID: <757904.94437.qm@web46101.mail.sp1.yahoo.com>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Skystar HD2 (device don't stream data).
Reply-To: free_beer_for_all@yahoo.com
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

I finally knocked over the beer bottle long enough to try
and make sense of why `scan' sometimes fails for me in the
same way it fails for Beth.

I get immediate signal lock on all Astra 19E2 DVB-S transponders
and from them, when `scan' behaves today, I'm getting 1421
received services, taking slightly over 5 minutes when using
the `Astra SDT' frequency as the seed.

In general, I should never see the word `timeout' in the
stderr output when running `scan -v'.  When my `scan' has
been misbehaving and delivering PIDs of 0 and ghost services,
I see these timeouts, and plenty of them.

After several hacks to `scan' to try and get it to read and
discard data, without perfect success, I've had three
consecutive scans without the problems, that in my last scan,
resulted in three transponders with bad data.  More on that
soon.

I don't know what I'm doing, and have no clue what `scan' is
doing, nor what the underlying API and driver are doing, so my
hacks are certainly wrong.  Also, I don't see these problems
with two other DVB-S cards I have, only with my newest one.

At best, this is a workaround in `scan' and not a fix.



I ran `scan -v -v -v -v -v v- v-v v-v-v' (you get the idea)
fed by the Astra SDT frequency.  What do you know, the
first frequency scanned had problems, allowing me to repeat
the scan simply and get correct results.

Here's the basics of the `diff' of stderr of these results...

--- /tmp/success        2008-08-27 16:26:08.244916390 +0200
+++ /tmp/parse  2008-08-27 14:30:30.264896960 +0200
@@ -18,31 +18,31 @@
 update_poll_fds:1418: poll fd 6
 update_poll_fds:1418: poll fd 5
 update_poll_fds:1418: poll fd 4
-parse_section:1257: pid 0x00 tid 0x00 table_id_ext 0x0454, 0/0 (version 15)
+parse_section:1257: pid 0x00 tid 0x00 table_id_ext 0x0004, 0/0 (version 16)
 PAT
-add_filter:1498: add filter pid 0x002a
-start_filter:1438: start filter pid 0x002a table_id 0x02
+add_filter:1498: add filter pid 0x0067
+start_filter:1438: start filter pid 0x0067 table_id 0x02
 update_poll_fds:1418: poll fd 7
 update_poll_fds:1418: poll fd 6
 update_poll_fds:1418: poll fd 5
 update_poll_fds:1418: poll fd 4
-add_filter:1498: add filter pid 0x0034
-start_filter:1438: start filter pid 0x0034 table_id 0x02
+add_filter:1498: add filter pid 0x006c
+start_filter:1438: start filter pid 0x006c table_id 0x02

And on it goes.

The incorrect lines above are those preceded by `+'; notably,
the PID 0 (PAT) table_id_ext is different, as are the PIDs to
be found within.

However the correct SDT is read, which is the next filter (PID 0x11)
to be added.  In the code of scan.c (my line numbers will be off)...

   1971 static void scan_tp_dvb (void)
   1972 {
   1973         struct section_buf s0;
   1974         struct section_buf s1;
   1975         struct section_buf s2;
   1976         struct section_buf s3;
   1977
   1978         /**
   1979          *  filter timeouts > min repetition rates specified in ETR211
   1980          */
   1981         setup_filter (&s0, demux_devname, 0x00, 0x00, -1, 1, 0, 5); /* P
   1981 AT */
   1982         setup_filter (&s1, demux_devname, 0x11, 0x42, -1, 1, 0, 5); /* S
   1982 DT */
   1983
   1984         add_filter (&s0);
   1985         add_filter (&s1);


What happens for me is that with every twenty or so attempts
to tune a new transponder with `scan', even at the start of a
scan, the first filter set up for PID 0 delivers the PAT table
from the previously-tuned DVB-S transponder.

However, the second filter, the SDT table, delivers the correct
data.  The following filters added are based on the incorrect
PAT PIDs, and therefore timeout without receiving anything.  The
SDT entries don't get filled out by matching PIDs from the PAT
and they too appear in the result without the proper PIDs, but
with the correct names from the SDT.


This has not been observed to be a problem with two other cards
I have, ever -- only with one card, the Opera DVB-USB tuner, and
at the time of my tests, on lightly-hacked 2.6.27-rc4 as of 23.Aug
(and had been present on all previous kernels I tested).

My attempt to read and discard and re-read from these PIDs was a
half-success (I got valid PIDs for all proper services, but I still
saw leftovers).  My latest hack is simply adding these filters,
promptly deleting them, and adding them again, and so far has not
failed, but more testing is needed.

A few more scans have revealed no problems, and my 'net connectivity
has disappeared, preventing me from verifying the source for other
flavours of `scan'.  So I submit this patch from my hacked scan.c:


@@ -1842,15 +1981,39 @@ static void scan_tp_dvb (void)
        setup_filter (&s0, demux_devname, 0x00, 0x00, -1, 1, 0, 5); /* PAT */
        setup_filter (&s1, demux_devname, 0x11, 0x42, -1, 1, 0, 5); /* SDT */

        add_filter (&s0);
        add_filter (&s1);

+/* XXX HACK  sometimes, filter s0 gets stale data, while the SDT filter
+ * gets the correct data.  Then nothing gets proper PIDs.  what to do...
+ * try removing the filters, and re-adding... */
+
+       remove_filter (&s0);
+       remove_filter (&s1);
+
+#if 0  /* this partly helped, but not completely  */
+//     do {
+//             read_filters ();
+//     } while (!(list_empty(&running_filters) &&
+//                list_empty(&waiting_filters)));
+#endif
+
+       setup_filter (&s0, demux_devname, 0x00, 0x00, -1, 1, 0, 5); /* PAT */
+       setup_filter (&s1, demux_devname, 0x11, 0x42, -1, 1, 0, 5); /* SDT */
+
+       add_filter (&s0);
+       add_filter (&s1);
+
+/* XXX  */
+
        if (!current_tp_only || output_format != OUTPUT_PIDS) {
+             if (!no_nits) {
                setup_filter (&s2, demux_devname, 0x10, 0x40, -1, 1, 0, 15); /* NIT */
                add_filter (&s2);
+             }
                if (get_other_nits) {
                        /* get NIT-others
                         * Note: There is more than one NIT-other: one per
                         * network, separated by the network_id.
                         */
                         setup_filter (&s3, demux_devname, 0x10, 0x41, -1, 1, 1, 15);



You certainly need to apply this by hand; in particular,
you don't want to apply past the last `XXX', the !no_nits
test is a local hack I have.

In my script I've eliminated the `sleep' that was supposed to
clear out the old data, and a full scan of all 120 transponders
(including non-DVB-S) takes me less than 6 1/2 min, and only
occasionally results in a random `timeout' message from a single
service, that is probably momentarily missing the needed PIDs,
as it's the same in some four successful scans.

It turns out I had already downloaded the DVB-S2-aware `scan', and
the code above seems to be pretty much identical.



Beth, as you know, you suffer two problems --

* services with 0:0 PIDs that should be something else, and
  related to this, extra services that should not be there;

* Difficulty tuning certain transponders, either a driver
  issue if your other OSen work well, or perhaps a dish issue.

The first of these problems *may* be `fixed' (ha) by the hack
above.  Please try it; I don't think it will break anything.
In any case, you should be able to get correct PIDs for TVGalicia
and others with every one of repeated scans -- at least, it has
worked for me.


With my last scan, I saw 295 services which had 0:0 PIDs, out
of the 1421 DVB-S services.  Most of these are data services.
Some of these aren't, and may be different at a different time
of day or with a different `scan' program...

### SCRAMBLED!!!  ###  NOT RUNNING!  #Blue Hustler:10920:h:1:22000:0:0:20353
Pr0n that only is shown at night, at which time a different
service on this transponder gets 0:0 PIDs as it stops running
for the evening.

##  NOT RUNNING!  #.:12246:v:1:27500:0:0:10128
I really hate the way APS manages their transponders, keeping
off-the-air programs around, or recycling service IDs so that
Volksmusik TV is replaced by pr0n and I have to hastily reprogram
all the receivers I installed for grandparents.  Some receivers
will show these status not-running channels and I can't delete
them and have them stay deleted.  At some time these may return
as a new service, pr0n, most likely.  Is it okay if I rant about
APS here?

NDR FS HH+:12421:h:1:27500:0:0:28325
Placeholders from recently discontinued programs to allow EPG
info about the frequency change to appear; will, like all the
others, disappear within some weeks.

Radio 4 Surround:12515:h:1:22000:0:0:4047
Like Oe1 DD, an AC3-only audio service, while `scan' only prints
the primary audio PID for me.

### SCRAMBLED!!!  #BiB:12574:h:1:22000:0:0:5029
This gave me timeouts the last few scans; used to have proper PIDs

### SCRAMBLED!!!  #RADIOROPA-H<F6>rbuch 2:12603:h:1:22000:0:0:6002
No longer broadcasting; some other services should start here

### SCRAMBLED!!!  ###  NOT RUNNING!  #Bundesliga 9:12662:h:1:22000:0:0:13110
Again, sometimes you'll see it, sometimes not.


Most of what you'll see will be data services, and in general,
if you can receive all active transponders from 19E2, you should
see somewhat less than 300 PIDs of 0:0 at the time I write this.
That's about one data service out of every five services.



--- On Tue, 8/26/08, Beth <beth.null@gmail.com> wrote:

> > a different card, with the same `scan' that works
> fine with two
> > other cards on a different machine (much older
> kernel).
> 
> Can I try another scan? from where?

I don't think so, as your card supports DVB-S2 -- but, as I
don't have hands-on experience with any of those cards and
related drivers, I don't even have an overview.

At best, a normal `scan' would give you only DVB-S results;
at worst, you wouldn't see anything...



barry bouwsma


      


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
