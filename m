Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from ug-out-1314.google.com ([66.249.92.170])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <freebeer.bouwsma@gmail.com>) id 1L8veT-0005MH-Bd
	for linux-dvb@linuxtv.org; Sat, 06 Dec 2008 12:48:50 +0100
Received: by ug-out-1314.google.com with SMTP id x30so227627ugc.16
	for <linux-dvb@linuxtv.org>; Sat, 06 Dec 2008 03:48:46 -0800 (PST)
Date: Sat, 6 Dec 2008 12:49:19 +0100 (CET)
From: BOUWSMA Barry <freebeer.bouwsma@gmail.com>
To: Uri Shkolnik <urishk@yahoo.com>
In-Reply-To: <399384.53896.qm@web110805.mail.gq1.yahoo.com>
Message-ID: <alpine.DEB.2.00.0812061045490.11349@ybpnyubfg.ybpnyqbznva>
References: <399384.53896.qm@web110805.mail.gq1.yahoo.com>
MIME-Version: 1.0
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] [PATCH 1/2] Siano's SMS subsystems API - SmsHost
 support
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

On Fri, 5 Dec 2008, Uri Shkolnik wrote:

> > > The first adds the SmsHost API support. This API
> > supports DTV standards yet to be fully supported by the
> > DVB-API (CMMB, T-DMB and more).

> > Is there a particular Linux distribution for which the
> > Siano
> > source code is intended, and, exactly what should I expect
> > to
> > see in /dev when I successfully load the module with my
> > device?

> Siano currently has dozens++ of customers using various flavors 
> of Linux. Desktop systems (multiple distributions), embedded 
> Linux (many types and targets) and some Linux derivative 
> systems.

Okay, thanks.  Now I see that I should not need to rely on
features of a particular distribution...


> Some use Linux DVB v3 API, most don't (either their system are 
> too small, and the kernel and user space are tailored to the 
> specific target/product, or the DTV standards is unsupported by 
> the DVB sub-system (CMMB, T-DMB and more)).

You probably remember this, but just in case anyone else
is at all concerned, my interest for now is in DAB/DAB+
radio reception, for which the v3 API obviously is of no
help.

As far as I know, while the v5 API can include other norms
than DVB/ATSC, such as ISDB, it does not yet have support
for the DMB/DAB family -- and so, I will need to use the
SmsHost and character devices.  At least, until it is
decided whether and how to fit DAB into v5...

(I do not expect that the other part of your patch, which
will provide API v5 support, will resolve this, but I'll
nonetheless wait to see...)



> In order to use the Siano sub-system you need to have C library 
> in user space

Understood.  This is also the part which I am hoping to be
able to avoid, hacking my own userspace tools to accomplish
the minimum that I need to tune a particular DAB ensemble,
and pull the data out and somehow parse it into an mp2 stream.

Of course, I must do this step-by-step.  The easy part was to
apply the diffs; now the next step seems to be for me to get
the device nodes to appear, so that then I can ask about
tuning...


> Siano is committed to support the LinuxTV community. But to 
> support individual end-users its quite an overstretch...

I appreciate this, especially with the bad experience that I
and several other users and developers have just had with
other products.

And I'm hoping that the Linux community can also work to help
itself, so that you don't need to be bothered by individuals
such as myself, instead supporting competent individuals
such as The Honourable Mr Krufky and anyone else with whom you
have been in developmental contact.  So, I'll pass along to
other readers some of the things I've learned so far, in hopes
that others can benefit from them.


> Anyway, dev node 251 is defined as "experimental/test" node, and 
> is used by Siano for communication between the kernel's 
> sub-system and the user space library and multimedia player 
> (e.g. both control and data paths).

It appears that on my recent `udev'-afflicted system, this 
assigned range of experimental majors 240-254 is dynamically 
allocated from the top down on a first-come, first-served
basis.  Here's what I see in part when I `cat /proc/devices` ...

212 DVB
249 smschar
250 hidraw
251 usb_endpoint
252 usbmon
253 bsg
254 pcmcia

So, in my case, when loading the smsmdtv.ko module that I've
built, I have needed to override the default -- while on my
much older production system, nothing is seen above major 212.

By the way, if it's not obvious to anyone else wanting to
play with this, move any
/lib/modules/`uname -r`/kernel/drivers/media/dvb/siano/sms1xxx.ko
out of the way so that it doesn't get automagically loaded
while you're playing...


However, when reading the patch you provided, I see that I
can also specify this `smschar_major' module parameter as 0;
then a suitable value will be selected (however, apparently
it doesn't get revealed in the `dmesg' output, should I choose
this -- I'll try to offer a debug patch later).

Other useful module parameters are `debug' (debug=3 for me),
and default_mode -- the default being DVB-T BDA operation.

In my case, `default_mode=2' loads the firmware to support
DAB and by extension T-DMB.  Other values, seen in the
siano/smscoreapi.h file, would be =1 for DVB-H, or =3 for
T-DMB/DAB-IP -- how this differs from mode 2 I don't know,
and I don't know which is the better choice for me yet.
The default is =4; ISDB-T is likely to be =6 (BDA driver);
and CMMB is =7.  For those too lazy to look at the source.

There may be special attention needed to providing the
firmware in the right place -- it ``just works'' for me
so I've managed to get that right a long time ago.
That is, I see `dmesg' output like
smsusb1_detectmode: 2 "SMS TDMB Receiver"
and I am momentarily at peace with the world.


So I see that smschar_register() succeeds and the major
number is assigned appropriately.  Additionally,
smschar_setup_cdev() succeeds for the seven devices.
At the moment for me, I don't get anything appearing
anywhere in /dev with the proper major number, or for
that matter, in /sys/dev/char or anywhere else in sysfs
that I've seen.

I'm comparing the dvb-core source before I hack blindly,
but if I may ask another stupid question, would creating
the device at the appropriate major number also be handled
by the C library to which you have referred, or perhaps
by a user application to handle tuning?  And, also,
I suspect that as the source you posted allows me to
handle the case where dev major 251 is already in use,
as well as choosing a non-default minor, the userspace
library will also handle this.


It's obvious that I'm not a device driver author, and I
don't expect you to help with these simple questions that
are purely Linux-related -- I've a google and I know how
to use it!  It just takes time...




> "Sir Mkrufky" ? I like that... I'll ask Mike if I'm too have the 
> privilege to refer him with that title....

I have heard it said that sweets work well to attract,
well, something.  So I prefer to address people the way
I don't deserve to be treated.  If nothing else, it's
usually good to reduce the recipient to giggling helplessly.

On the other hand, I've experimented and set out a lump
of sugar, along with some rotten month-old cheese, some
apple vinegar, decaying liquefying vegetables, and the
like, and strangely, all the bugs and flies were not
drawn to the lump of sweetness.  Draw your own conclusion,
but, well, my dinner is waiting...


Anyway, Sir Shkolnik (I'm sorry, may I call you Sir?),
thank you for your help, and I'll go back to hacking on
the source to see what I can make appear...

barry bouwsma

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
