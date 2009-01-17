Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail-bw0-f20.google.com ([209.85.218.20])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <mrechberger@gmail.com>) id 1LO8EZ-00072n-98
	for linux-dvb@linuxtv.org; Sat, 17 Jan 2009 11:16:56 +0100
Received: by bwz13 with SMTP id 13so5559744bwz.17
	for <linux-dvb@linuxtv.org>; Sat, 17 Jan 2009 02:16:21 -0800 (PST)
Message-ID: <d9def9db0901170216g5be0ed16sa1eeb4c4f9acce76@mail.gmail.com>
Date: Sat, 17 Jan 2009 11:16:21 +0100
From: "Markus Rechberger" <mrechberger@gmail.com>
To: "BOUWSMA Barry" <freebeer.bouwsma@gmail.com>
In-Reply-To: <alpine.DEB.2.00.0901171037230.18169@ybpnyubfg.ybpnyqbznva>
MIME-Version: 1.0
Content-Disposition: inline
References: <496C9FDE.2040408@hemmail.se>
	<d9def9db0901131101y59cd5c1ct2344052f86b42feb@mail.gmail.com>
	<d9def9db0901151028k6ab8bd79q6627c7516020aabe@mail.gmail.com>
	<alpine.DEB.2.00.0901171037230.18169@ybpnyubfg.ybpnyqbznva>
Cc: DVB mailin' list thingy <linux-dvb@linuxtv.org>, em28xx@mcentral.de
Subject: Re: [linux-dvb] Terratec XS HD support?
Reply-To: linux-media@vger.kernel.org
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

On Sat, Jan 17, 2009 at 10:57 AM, BOUWSMA Barry
<freebeer.bouwsma@gmail.com> wrote:
> Hi Markus, I follow your list as a non-subscriber, but I thought
> it would be worthwhile to post this to linux-dvb as well, and
> eventually to linux-media...
>
> On Thu, 15 Jan 2009, Markus Rechberger wrote:
>
>> On Tue, Jan 13, 2009 at 8:01 PM, Markus Rechberger
>> <mrechberger@gmail.com> wrote:
>
>> >> Is there any news about Terratec HTC USB XS HD support?
>
>> > it's upcoming soon.
>
> Thanks Markus, that's good news for me, and for several people
> who have written me as well!
>
>
>> http://mcentral.de/wiki/index.php5/Terratec_HTC_XS
>> you might track that site for upcoming information.
>
> Interesting.  You say that your code will make use of a BSD
> setup.  Can you or someone say something about this, or point
> to past discussion which explains this?  Would this be the
> userspace_tuner link on your wiki?
>
> In particular, I'm wondering whether this is completely
> compatible with the standard DVB utilities -- dvbscan,
> dvbstream, and the like, or whether a particular higher-
> level end-user application is required.
>
>

The design goes hand in hand with some discussions that have been made
with some BSD developers.
The setup makes use of usbdevfs and pci configspace access from
userland, some work still has to be done there, it (will give/gives)
manufacturers the freedom to release opensource and binary drivers for
userland.
I'm a friend of open development and not of some kind of monopoly
where a few people rule everything (linux).

There's quite some work going on in portability so that one driver can
be written for Linux/BSD and OSX - still needing some Host dependent
hooks for transferring the data but the same for configuring the
chips.
Someone might have noticed the empty frontend dummy driver in
em28xx-new, by using userland commands the same device nodes can be
used for DVB-C and DVB-T mpeg-ts streams. Currently linuxtv would
require to set up different nodes for those nodes with earlier kernels
- the userland approach is pretty much backward compatible while not
having to update the core media framework, and it gives vendors the
possibility to set up their drivers with vendor specific features too.
libv4l(2)? is probably already a good approach to support v4l with
multiple applications although most applications are still not capable
of supporting all v4l(2) devices anyway.

As for the em28xx project, Micronas who doesn't want to release their
intellectual property triggered quite a few discussions with some
people. I have code here with several 10.000th lines of code from
them, and people earn their money by selling solutions based on that.
Giving away that proprietary work would immediately kill the
commercial value of their work and alot money would be lost for
smaller companies. I'm somehow convenient that it might go Opensource
in years when the commercial market is finished for their products. As
written the goal is to give chip manufacturers/designers the
possibility to provide support for their chips in an operating system
and license independent way.

best regards,
Markus

_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
