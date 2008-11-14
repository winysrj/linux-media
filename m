Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mAE6uY5W020566
	for <video4linux-list@redhat.com>; Fri, 14 Nov 2008 01:56:34 -0500
Received: from cnc.isely.net (cnc.isely.net [64.81.146.143])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mAE6tVAu004083
	for <video4linux-list@redhat.com>; Fri, 14 Nov 2008 01:55:31 -0500
Date: Fri, 14 Nov 2008 00:55:28 -0600 (CST)
From: Mike Isely <isely@isely.net>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
In-Reply-To: <20081113161137.11529bf0@pedra.chehab.org>
Message-ID: <Pine.LNX.4.64.0811132349230.3738@cnc.isely.net>
References: <20081113152622.6f6b7092@pedra.chehab.org>
	<Pine.LNX.4.64.0811131135290.27554@cnc.isely.net>
	<20081113161137.11529bf0@pedra.chehab.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: Video <video4linux-list@redhat.com>, Michael Krufky <mkrufky@linuxtv.org>
Subject: Re: [PATCH] missdetection on pvrusb2
Reply-To: Mike Isely <isely@pobox.com>
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

On Thu, 13 Nov 2008, Mauro Carvalho Chehab wrote:

> On Thu, 13 Nov 2008 11:46:07 -0600 (CST)
> Mike Isely <isely@isely.net> wrote:
> 
> > This is logic that hasn't changed in a LONG time in the pvrusb2 driver.  
> > So why is it only now becoming a problem?  Did something change on the 
> > tvaudio side?
> 
> The only change at tvaudio side I'm aware of are the conversion to the new i2c mode.
> 
> > I see in the diff below that tvaudio's 
> > chip_legacy_probe() function is going to return true for any adapter 
> > tagged with I2C_CLASS_TV_ANALOG.  Is that really (!) right?  That seems 
> > a bit overbroad.
> 
> This is the common code on all V4L i2c devices.
> 
> >  Unfortunately I'm at a disadvantage right now and am 
> > unable to look at the surrounding full source.  But I certainly will 
> > tonight.  Perhaps there is additional filtering elsewhere.

OK, I've figured this out.  First, I tested with the tvaudio driver in 
the current v4l-dvb master repository as of a few hours ago - so I'm 
accounting for all of the commits that you did earlier today.

On a 29xxx pvrusb2 device, tvaudio appears to be falsely detecting 
because it's hitting the I2C address that actually corresponds to the 
msp3400.  On a 24xxx device there's no problem since there's no msp3400 
(a cx25840 is used instead).  This issue is probably going to happen to 
tvaudio any time it encounters any device with a resident msp3400.

However tvaudio is not really detecting at all.  The message in the 
kernel log is misleading.  Here's the explanation...

The function chip_probe() in tvaudio.c is the actor here.  Upon entry it 
immediately reports a "chip found" message, but this is before it has 
actually decided to use the chip.  AFTER that message prints, 
chip_probe() enters a loop where it tries to identify the chip.  It does 
this via a table search based on the probed I2C address.  The table in 
question, "chiplist", includes two entries that correspond to the 
msp3400's address.  They are "tea6300" and "tea6320".  For each table 
entry checked, a file-local flag is checked (pointed to by the insmodopt 
member); if that flag is zero then the table entry is rejected and the 
search continues.  In the case of tea6300 and tea6320, the flags are 
(not surprisingly) local int variables tea6300 and tea6320 (can be found 
around line 1268).  These variable are compile-time set to ZERO, thus 
the chip_probe() function's identification algorithm fails and tvaudio 
then will leave the msp3400 alone.

This is a benign action.  What's really happening here is that 
chip_probe() in tvaudio.c is finding a candidate chip and then rejecting 
it before anything harmful can take place.  Interestingly enough, the 
static declarations for those variable are annotated this way:

static int tea6300;	/* default 0 - address clash with msp34xx */
static int tea6320;	/* default 0 - address clash with msp34xx */

So it's already known by us all that these parts clash with the msp3400 
and that's why they are disabled by default.  It's possible to enable 
these parts at run-time within tvaudio because those variables are also 
available as module parameters, i.e. specifying "tea6300=1" on the 
module load line will enable tea6300 detection or I imagine if the 
module is compiled into the kernel then adding "tea6300=1" to the kernel 
command line will enable this detection.  But it's not enabled by 
default so there should not actually be a clash with the msp3400 in 
29xxx pvrusb2-driven devices.

It is confusing that tvaudio sends that "chip found" message to the 
kernel log but it doesn't follow up with any other info, like for 
example the fact that it's decided to ignore the part.  So a casual 
observer is going to see this and immediately think that tvaudio has 
wrongly attached to the device.  That's misleading.  The "chip found" 
message should probably be adjusted to something like "chip found; 
testing" or even better don't print the message at all until the 
identification check has passed.  Or print something else after the 
check is done indicating pass/reject.

I walked back through hg history on tvaudio.c, looking for changes to 
those two critical flags I mentioned above (tea6300 and tea6320).  The 
lines that declare those two flags noted above date all the way back to 
the initial version of the tvaudio.c driver when it first appeared in 
Mercurial.  The earliest change there is revision 784, and even back 
then those two flags are still set to zero with the comment about the 
msp3400 address clash.  Therefore there's NO WAY that the tvaudio module 
could ever actually have been attaching to the pvrusb2 driver unless the 
user specifically forced it by setting the tea6300=1 option when the 
module is loaded or the kernel booted.  Therefore I have to think that 
you're really getting misled by the log message from tvaudio.c.  That's 
the root issue here - a misleading log message from the tvaudio module.

I think it would be wiser to fix the misleading log message rather than 
to commit a change that makes the pvrusb2 driver a special case for the 
tvaudio module; especially since the problem is going to occur for ANY 
otherwise innocent driver which happens to employ an msp3400.


> > 
> > The above question not withstanding, the patch is otherwise harmless to 
> > the pvrusb2 driver.  Mike is right in that tvaudio should never actually 
> > be needed.  But before I ack this let me look at this code a little 
> > further.  I'd like to know why this has just now become an issue, before 
> > pasting over it with this patch.  I will do that tonight (about 10 hours 
> > from now).  So bear with me a little bit.
> 
> You should notice that the issue only happened when the user compiled tvaudio
> (and pvrusb2) at vmlinuz, instead of being a module.
> 
> When tvaudio is a module, as pvrusb2 don't request the module, this bug doesn't happen.

Right, because then tvaudio is present in the kernel and it's going to 
probe.  The same misleading tvaudio log message can be caused by simply 
modprobe'ing tvaudio into the kernel before you plug in a 29xxx pvrusb2 
driver.  This is what I actually reproduced while testing here.


> 
> Also, with the older pvrusb2 (I tested with model 29032), the i2c address 0x84
> is not used.

But 0x80 is used and that also trips tvaudio.  I tested with a 29032 
here and produced the behavior you described above.

I don't see a valid reason to apply the patch you are proposing.  It's 
just pasting over a symptom, not solving what is actually not a problem 
anyway.  The tvaudio module is doing the right thing, and the user has 
to do something explicit to cause it to REALLY attach erroneously to the 
driver.  Even if you still want to apply this patch, you should then 
really be complete about this and fix all other drivers which might 
possibly involve an msp3400 - because they are all going to have the 
same problem.  I don't think creating a special case for the pvrusb2 
driver is the right thing to do.

However if you really REALLY want to apply that patch, then from where 
I'm sitting it does no real harm to the pvrusb2 driver.  In that case:

Acked-by: Mike Isely <isely@pobox.com>

  -Mike


-- 

Mike Isely
isely @ pobox (dot) com
PGP: 03 54 43 4D 75 E5 CC 92 71 16 01 E2 B5 F5 C1 E8

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
