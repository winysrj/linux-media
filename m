Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from nskntmtas05p.mx.bigpond.com ([61.9.168.149])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <jhhummel@bigpond.com>) id 1KSXa4-0007Rn-Iw
	for linux-dvb@linuxtv.org; Mon, 11 Aug 2008 15:37:08 +0200
From: Jonathan Hummel <jhhummel@bigpond.com>
To: stev391@email.com
In-Reply-To: <20080810014226.07EFF47808F@ws1-5.us4.outblaze.com>
References: <20080810014226.07EFF47808F@ws1-5.us4.outblaze.com>
Content-Type: multipart/mixed; boundary="=-16usuwxT/xolEH2aMNAI"
Date: Mon, 11 Aug 2008 23:36:25 +1000
Message-Id: <1218461785.7443.10.camel@mistress>
Mime-Version: 1.0
Cc: linux dvb <linux-dvb@linuxtv.org>
Subject: Re: [linux-dvb] [PATCH-TESTERS-REQUIRED] Leadtek Winfast PxDVR 3200
	H - DVB	Only support
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>


--=-16usuwxT/xolEH2aMNAI
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

On Sun, 2008-08-10 at 11:42 +1000, stev391@email.com wrote:
> 
> 
>         ----- Original Message -----
>         From: "Jonathan Hummel" 
>         To: stev391@email.com
>         Subject: Re: [PATCH-TESTERS-REQUIRED] Leadtek Winfast PxDVR
>         3200 H - DVB Only support
>         Date: Sat, 09 Aug 2008 21:48:21 +1000
>         
>         
>         Hi All,
>         
>         Finnaly got some time to give the patch a go. I used the
>         pacakges
>         Stephen, sent the link to, not Mark's. I cant't get past the
>         attached
>         problem. The dmesg output is attached. I tried setting the
>         card like
>         this:
>         /etc/modprobe.d/options file and add the line: options cx88xx
>         card=11
>         I also tried the following two varients:
>         cx23885 card=11
>         cx23885 card=12
>         
>         I also got what looked like an error message when applying the
>         first
>         patch, something like "strip count 1 is not a
>         number" (although 1 not
>         being a number would explain my difficulties with maths!)
>         
>         Cheers
>         
>         Jon
>         
>         On Wed, 2008-08-06 at 07:33 +1000, stev391@email.com wrote:
>         > Mark, Jon,
>         >
>         > The patches I made were not against the v4l-dvb tip that is
>         referenced
>         > in Mark's email below. I did this on purpose because there
>         is a small
>         > amount of refactoring (recoding to make it better) being
>         performed by
>         > Steven Toth and others.
>         >
>         > To get the version I used for the patch download (This is
>         for the
>         > first initial patch [you can tell it is this one as the
>         patch file
>         > mentions cx23885-sram in the path]):
>         > http://linuxtv.org/hg/~stoth/cx23885-sram/archive/tip.tar.gz
>         >
>         > For the second patch that emailed less then 12 hours ago
>         download this
>         > version of drivers:
>         > http://linuxtv.org/hg/~stoth/v4l-dvb/archive/tip.tar.gz
>         > and then apply my patch (this patch mentions v4l-dvb). This
>         version is
>         > a cleanup of the previous and uses the generic callback
>         function.
>         >
>         > Other then that you are heading in the correct direction...
>         >
>         > Do either of you have the same issue I have that when the
>         computer is
>         > first turned on the autodetect card feature doesn't work due
>         to
>         > subvendor sub product ids of 0000? Or is just a faulty card
>         that I
>         > have?
>         >
>         > Regards,
>         >
>         > Stephen.
>         > ----- Original Message -----
>         > From: "Mark Carbonaro" To: "Jonathan Hummel" 
>         > Subject: Re: [PATCH-TESTERS-REQUIRED] Leadtek Winfast PxDVR
>         > 3200 H - DVB Only support
>         > Date: Tue, 5 Aug 2008 23:47:46 +1000 (EST)
>         >
>         >
>         > Hi Mark,
>         >
>         > Forgive my ignorance/ newbie-ness, but what do I do with
>         that
>         > patch code
>         > below? is there a tutorial or howto or something somewhere
>         > that will
>         > introduce me to this. I have done some programming, but
>         > nothing of this
>         > level.
>         >
>         > cheers
>         >
>         > Jon
>         >
>         > ----- Original Message -----
>         > From: "Jonathan Hummel" To: "Mark Carbonaro" 
>         > Cc: stev391@email.com, linux-dvb@linuxtv.org
>         > Sent: Tuesday, 5 August, 2008 10:21:11 PM (GMT+1000)
>         > Auto-Detected
>         > Subject: Re: [PATCH-TESTERS-REQUIRED] Leadtek Winfast PxDVR
>         > 3200 H - DVB Only support
>         >
>         > Hi Jon,
>         >
>         > Not a problem at all, I'm new to this myself, below is what
>         > went through and I may not be doing it the right 
>         > way either. So if anyone would like to point out what I 
>         > am doing wrong I would
>         > really appreciate it.
>         >
>         > The file that I downloaded was called
>         > v4l-dvb-2bade2ed7ac8.tar.bz2 which I downloaded 
>         > from 
>         > http://linuxtv.org/hg/~stoth/v4l-dvb/archive/tip.tar.bz2, I
>         > also saved the patch to the same location as the download.
>         >
>         > The patch didn't apply for me, so I manually patched applied
>         > the patches and created a new diff that should 
>         > hopefully work for
>         > you also (attached and inline below). From what I 
>         > could see the offsets in Stephens patch were a little off 
>         > for this code
>         > snapshot but otherwise it is all good.
>         >
>         > I ran the following using the attached diff...
>         >
>         > tar -xjf v4l-dvb-2bade2ed7ac8.tar.bz2
>         > cd v4l-dvb-2bade2ed7ac8
>         > patch -p1 < ../Leadtek.Winfast.PxDVR.3200.H.2.diff
>         >
>         > Once the patch was applied I was then able to build and
>         > install the modules as per the instructions in 
>         > the INSTALL file. I ran
>         > the following...
>         >
>         > make all
>         > sudo make install
>         >
>         > From there I could load the modules and start testing.
>         >
>         > I hope this helps you get started.
>         >
>         > Regards,
>         > Mark
>         >
>         >
>         >
>         >
>         >
>         >
>         
>         
> Jon,
> 
> The patch did not apply correctly as the dmesg should list an extra
> entry in card list (number 12), and it should have autodetected.
> 
> Attached is the newest copy of the patch (save this in the same
> directory that you use the following commands from), just to avoid
> confusion. 
> Following the following:
> wget http://linuxtv.org/hg/~stoth/v4l-dvb/archive/2bade2ed7ac8.tar.gz
> tar -xf 2bade2ed7ac8.tar.gz
> cd v4l-dvb-2bade2ed7ac8
> patch -p1 <../Leadtek_Winfast_PxDVR3200_H.diff
> make
> sudo make install
> sudo make unload
> sudo modprobe cx23885
> 
> Now the card should have been detected and you should
> have /dev/adapterN/ (where N is a number). If it hasn't been detected
> properly you should see a list of cards in dmesg with the card as
> number 12. Unload the module (sudo rmmod cx23885) and then load it
> with the option card=12 (sudo modprobe cx23885 card=12)
> 
> For further instructions on how to watch digital tv look at the wiki
> page (you need to create a channels.conf).
> 
> Regards,
> Stephen
> 
> P.S.
> Please make sure you cc the linux dvb mailing list, so if anyone else
> has the same issue we can work together to solve it.
> Also the convention is to post your message at the bottom (I got
> caught by this one until recently).
> 
> 
> -- 
> Be Yourself @ mail.com!
> Choose From 200+ Email Addresses
> Get a Free Account at www.mail.com!

Hi Stevhen, Mark,


So you write your post at the bottom of the email?! well that does
explain a lot, and does kinda make sense if your intending someone to
pick it up halfway through. I just normaly read backwards when that
happens to me.

As for the patch. I realised that it is patch -p1 (as in one) not -pl
(as in bLoody &*^^* i can't believe i was using the wrong character)
which explains why my patches never worked.
So the patch applied all fine and that, and dmesg looks great, but I
can't find anything by scanning. On my other card, the DTV2000H (rev J)
it can scan in MythTV to find channels, and with me-TV, I think it just
has a list which it picks from or something, tunes to that frequency to
see if there is anything there. Can't do that with this card so far.
Attached is the output from scan (or DVB scan) I don't know if it would
be useful, but I don't know what is useful for such a problem.

cheers

Jon

--=-16usuwxT/xolEH2aMNAI
Content-Disposition: attachment; filename=scan.txt
Content-Type: text/plain; name=scan.txt; charset=utf-8
Content-Transfer-Encoding: 7bit

 
sudo scan au-Sydney_North_Shore
[sudo] password for susan:
scanning au-Sydney_North_Shore
using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
initial transponder 226500000 1 3 9 3 1 1 0
initial transponder 177500000 1 2 9 3 1 1 0
initial transponder 191625000 1 3 9 3 1 1 0
initial transponder 219500000 1 3 9 3 1 1 0
initial transponder 571500000 1 2 9 3 1 2 0
initial transponder 578500000 1 2 9 3 1 0 0
>>> tune to: 226500000:INVERSION_AUTO:BANDWIDTH_7_MHZ:FEC_3_4:FEC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_16:HIERARCHY_NONE
WARNING: >>> tuning failed!!!
>>> tune to: 226500000:INVERSION_AUTO:BANDWIDTH_7_MHZ:FEC_3_4:FEC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_16:HIERARCHY_NONE (tuning failed)
WARNING: >>> tuning failed!!!
>>> tune to: 177500000:INVERSION_AUTO:BANDWIDTH_7_MHZ:FEC_2_3:FEC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_16:HIERARCHY_NONE
WARNING: >>> tuning failed!!!
>>> tune to: 177500000:INVERSION_AUTO:BANDWIDTH_7_MHZ:FEC_2_3:FEC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_16:HIERARCHY_NONE (tuning failed)
WARNING: >>> tuning failed!!!
>>> tune to: 191625000:INVERSION_AUTO:BANDWIDTH_7_MHZ:FEC_3_4:FEC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_16:HIERARCHY_NONE
WARNING: >>> tuning failed!!!
>>> tune to: 191625000:INVERSION_AUTO:BANDWIDTH_7_MHZ:FEC_3_4:FEC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_16:HIERARCHY_NONE (tuning failed)
WARNING: >>> tuning failed!!!
>>> tune to: 219500000:INVERSION_AUTO:BANDWIDTH_7_MHZ:FEC_3_4:FEC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_16:HIERARCHY_NONE
WARNING: >>> tuning failed!!!
>>> tune to: 219500000:INVERSION_AUTO:BANDWIDTH_7_MHZ:FEC_3_4:FEC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_16:HIERARCHY_NONE (tuning failed)
WARNING: >>> tuning failed!!!
>>> tune to: 571500000:INVERSION_AUTO:BANDWIDTH_7_MHZ:FEC_2_3:FEC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_8:HIERARCHY_NONE
WARNING: >>> tuning failed!!!
>>> tune to: 571500000:INVERSION_AUTO:BANDWIDTH_7_MHZ:FEC_2_3:FEC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_8:HIERARCHY_NONE (tuning failed)
WARNING: >>> tuning failed!!!
>>> tune to: 578500000:INVERSION_AUTO:BANDWIDTH_7_MHZ:FEC_2_3:FEC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_32:HIERARCHY_NONE
WARNING: >>> tuning failed!!!
>>> tune to: 578500000:INVERSION_AUTO:BANDWIDTH_7_MHZ:FEC_2_3:FEC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_32:HIERARCHY_NONE (tuning failed)
WARNING: >>> tuning failed!!!
ERROR: initial tuning failed
dumping lists (0 services)
Done.
--=-16usuwxT/xolEH2aMNAI
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--=-16usuwxT/xolEH2aMNAI--
