Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m3ULwNUd002416
	for <video4linux-list@redhat.com>; Wed, 30 Apr 2008 17:58:23 -0400
Received: from mail-in-04.arcor-online.net (mail-in-04.arcor-online.net
	[151.189.21.44])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m3ULw9cu002125
	for <video4linux-list@redhat.com>; Wed, 30 Apr 2008 17:58:09 -0400
From: hermann pitton <hermann-pitton@arcor.de>
To: mahakali <mahakali@orange.fr>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Hartmut Hackmann <hartmut.hackmann@t-online.de>
In-Reply-To: <20080430155851.GA5818@orange.fr>
References: <20080428182959.GA21773@orange.fr>
	<alpine.DEB.1.00.0804282103010.22981@sandbox.cz>
	<20080429192149.GB10635@orange.fr>
	<1209507302.3456.83.camel@pc10.localdom.local>
	<20080430155851.GA5818@orange.fr>
Content-Type: text/plain; charset=UTF-8
Date: Wed, 30 Apr 2008 23:56:48 +0200
Message-Id: <1209592608.31036.36.camel@pc10.localdom.local>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Cc: video4linux-list@redhat.com
Subject: Re: Card Asus P7131 hybrid > no signal
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

Hi,

Am Mittwoch, den 30.04.2008, 17:58 +0200 schrieb mahakali:
> On Wed, Apr 30, 2008 at 12:15:02AM +0200, hermann pitton wrote :
> 
> > > 
> > >   
> > > The problem is: No picture .... I thinkk, if you
> > > have no signal, it is pretty normal.
> > > 
> > > What are the options you pass to the saa7134 module ?
> > > I mean card=<number> tuner=<number>
> > > I have card=112 tuner=61 (auto detect).
> > > In one Saa7134-hardware how-to the autor gives
> > > following values : card=78 tuner=54.
> > > 
> > > Any help would be great.
> > > 
> > > mahakali
> > > 
> > > 
> > 
> > Hello,
> > 
> > if you have card=112 tuner=61 auto detected something goes very wrong.
> > 
> > On any recent "official" code the card should be auto detected as
> > card=112, tuner=54, which is the tda8290 analog IF demodulator within
> > the saa7131e and behind its i2c gate is a tda8275ac1 at address 0x61
> > which is correct in your logs.
> > 
> > Hopefully you are only confusing tuner address 61 with tuner type,
> > auto detection should be OK then.
> >
> module saa7134 is now loading with following parameters :
> 
> card=112 tuner=54 i2c_scan=1 secam=L
>  
> > Analog TV is on the upper antenna connector (cable TV) and you need a
> > saa7134 insmod option "secam=L" in France. ("modinfo saa7134")
> > On La Corse may still be some "secam=Lc" broadcast, not sure about that.

> I don't have any upper or lower connector , only right and link.
> °right connector is described as RF-FM and link as CAT-TV

That's OK.

> > DVB-T (numerique) is on the lower antenna connector where also is
> > radio/FM.
> > 
> > We have many reports that there often is an positive offset of about
> > 166000Hz needed in France, which you don't seem to use on your digital
> > tuning attempt. If this is needed and missing, the tda10046 will fail.
> > You might try to add it.
> > 
> > Download dvb-apps from linuxtv.org mercurial and check if there is an
> > updated initial scan file for your region in scan/dvb-t.
> 
> Nothing new.
> > example with offset:
> > 
> > # Paris - France - various DVB-T transmitters
> > # contributed by Alexis de Lattre < >
> > # Paris - Tour Eiffel      : 21 24 27 29 32 35
> > # Paris Est - Chennevières : 35 51 54 57 60 63
> > # Paris Nord - Sannois     : 35 51 54 57 60 63
> > # Paris Sud - Villebon     : 35 51 56 57 60 63
> > # T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
> > T 474166000 8MHz 2/3 NONE QAM64 8k 1/32 NONE
> > T 498166000 8MHz 2/3 NONE QAM64 8k 1/32 NONE
> > T 522166000 8MHz 2/3 NONE QAM64 8k 1/32 NONE
> > T 538166000 8MHz 2/3 NONE QAM64 8k 1/32 NONE
> > T 562166000 8MHz 2/3 NONE QAM64 8k 1/32 NONE
> > T 586166000 8MHz 3/4 NONE QAM64 8k 1/8 NONE
> > T 714166000 8MHz 2/3 NONE QAM64 8k 1/32 NONE
> > T 738166000 8MHz 2/3 NONE QAM64 8k 1/32 NONE
> > T 754166000 8MHz 2/3 NONE QAM64 8k 1/32 NONE
> > T 762166000 8MHz 2/3 NONE QAM64 8k 1/32 NONE
> > T 786166000 8MHz 2/3 NONE QAM64 8k 1/32 NONE
> > T 810166000 8MHz 2/3 NONE QAM64 8k 1/32 NONE
> >
>  Itried it now with fr_Auxerre + offset
> #### Auxerre - Molesmes ####
> #R1
> T 570166000 8MHz AUTO NONE QAM64 8k AUTO NONE
> #R2
> T 794166000 8MHz AUTO NONE QAM64 8k AUTO NONE
> #R3
> T 770166000 8MHz AUTO NONE QAM64 8k AUTO NONE
> #R4
> T 546166000 8MHz AUTO NONE QAM64 8k AUTO NONE
> #R5
> T 586166000 8MHz AUTO NONE QAM64 8k AUTO NONE
> #R6
> T 562166000 8MHz AUTO NONE QAM64 8k AUTO NONE
> 
> but scanning fails ..... 
>  
> > You can also try to "scan" on a known frequency and bandwidth and set
> > the rest to AUTO AUTO ... or get "wscan" or try with "kaffeine".
>  I tried it with kaffeine = no result
>  I tried it with me-tv :
> 
> me-tv        
> Me TV-Message: 30.04.2008 17:37:26 - Me TV Version: 0.5.17
> Me TV-Message: 30.04.2008 17:37:27 - Chargement du fichier glade
> '/usr/share/me-tv/glade/me-tv.glade' en cours
> Me TV-Message: 30.04.2008 17:37:52 - Création du GEP dans
> '/home/claude/.me-tv/epg.xml'
> Me TV-Message: 30.04.2008 17:37:52 - GEP chargé
> initial transponder 570166000 0 9 9 3 1 4 0
> initial transponder 794166000 0 9 9 3 1 4 0
> initial transponder 770166000 0 9 9 3 1 4 0
> initial transponder 546166000 0 9 9 3 1 4 0
> initial transponder 586166000 0 9 9 3 1 4 0
> initial transponder 562166000 0 9 9 3 1 4 0
> >>> tune to: 
> WARNING: >>> tuning failed!!!
> >>> tune to:  (tuning failed)
> WARNING: >>> tuning failed!!!
> >>> tune to: 
> WARNING: >>> tuning failed!!!
> >>> tune to:  (tuning failed)
> WARNING: >>> tuning failed!!!
> >>> tune to: 
> WARNING: >>> tuning failed!!!
> >>> tune to:  (tuning failed)
> WARNING: >>> tuning failed!!!
> >>> tune to: 
> WARNING: >>> tuning failed!!!
> >>> tune to:  (tuning failed)
> WARNING: >>> tuning failed!!!
> >>> tune to: 
> WARNING: >>> tuning failed!!!
> >>> tune to:  (tuning failed)
> WARNING: >>> tuning failed!!!
> >>> tune to: 
> WARNING: >>> tuning failed!!!
> >>> tune to:  (tuning failed)
> WARNING: >>> tuning failed!!!
> ERROR: initial tuning failed
> dumping lists (0 services)
> 
> > You might also try to increase the tuning timeout.
> > 
> > Good Luck,
> > 
> > Hermann
> 
> Any idea ??

Not much more. Maybe some other value is wrong, which other digital
demods tolerate. That was that with try AUTO there, except for frequency
and bandwidth.

> 
> Thanks
> 
> mahakali
> 
> PS :
> I was asking myself , perhaps is something wrong with the connection, I
> had to  put together cable and plug, so perhaps a bad electrical
> transmission (??) but as I already said tvtime is dectecting some
> channels but no image
> 

I'm not aware of issues for DVB-T. There was trouble for such boards
with LNA recently on devel stuff, but as far as I know it did not make
it out to a kernel.

We have definitely issues on analog, but I can't test SECAM_L.

After ioctl2 conversion, the apps don't let the user select specific
subnorms like PAL_I, PAL_BG, PAL_DK and SECAM_L, SECAM_DK, SECAM_Lc
anymore.

What one can only select is visible here.
http://linuxtv.org/hg/v4l-dvb/rev/aa554a86b38a


@@ -216,6 +216,12 @@ static struct saa7134_format formats[] = 
		.vbi_v_stop_0  = 21,	\ 
		.vbi_v_start_1 = 273,	\ 
		.src_timing    = 7 
+ 
+#define SAA7134_NORMS	\ 
+		V4L2_STD_PAL    | V4L2_STD_PAL_N | \ 
+		V4L2_STD_PAL_Nc | V4L2_STD_SECAM | \ 
+		V4L2_STD_NTSC   | V4L2_STD_PAL_M | \ 
+		V4L2_STD_PAL_60 

The driver previously exposed all supported standards to the
applications and they were user selectable.

All would be this.

#define SAA7134_NORMS	(\
V4L2_STD_PAL     | V4L2_STD_PAL_BG   | V4L2_STD_PAL_I  | V4L2_STD_PAL_DK   | \
V4L2_STD_PAL_N   | V4L2_STD_PAL_Nc   | V4L2_STD_SECAM  | V4L2_STD_SECAM_DK | \
V4L2_STD_SECAM_L | V4L2_STD_SECAM_LC | V4L2_STD_NTSC   | V4L2_STD_PAL_M    | \
V4L2_STD_PAL_60)

Internally the driver knows about all norms, but we have a clear
breakage of application backward compatibility and might see various
side effects. Especially, but not only for SECAM, it was important that
the users can select the exact norm themselves because of audio carrier
detection issues.

It is firstly on 2.6.25.

If you are affected, apps like xawtv or mplayer will only report these
TV standards.

TV file format detected.
Selected driver: v4l2
 name: Video 4 Linux 2 input
 author: Martin Olschewski <olschewski@zpr.uni-koeln.de>
 comment: first try, more to come ;-)
Selected device: Philips Tiger reference design
 Tuner cap: STEREO LANG1 LANG2
 Tuner rxs: MONO
 Capabilites:  video capture  video overlay  VBI capture device  tuner  read/write  streaming
 supported norms: 0 = PAL; 1 = PAL-M; 2 = PAL-N; 3 = PAL-Nc; 4 = PAL-60; 5 = NTSC; 6 = SECAM;
 inputs: 0 = Television; 1 = Composite1; 2 = S-Video;
 Current input: 0

Cheers,
Hermann



--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
