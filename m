Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from bombadil.infradead.org ([18.85.46.34])
	by www.linuxtv.org with esmtp (Exim 4.63) (envelope-from
	<SRS0+4cec8f44893c453db5f3+1665+infradead.org+mchehab@bombadil.srs.infradead.org>)
	id 1JaXL0-0007cn-HO
	for linux-dvb@linuxtv.org; Sat, 15 Mar 2008 15:26:18 +0100
Date: Sat, 15 Mar 2008 11:24:27 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Jan Hoogenraad <jan-conceptronic@h-i-s.nl>
Message-ID: <20080315112427.6b6c55a4@gaivota>
In-Reply-To: <47DAED1E.4030002@h-i-s.nl>
References: <1203538678.8313.12.camel@srv-roden.vogelwikke.nl>
	<47BCAC32.9050601@h-i-s.nl> <47BCB371.2020809@h-i-s.nl>
	<20080227075056.34a80abd@areia> <47D462DD.5080500@h-i-s.nl>
	<20080312180321.6a6800a1@gaivota> <47DAED1E.4030002@h-i-s.nl>
Mime-Version: 1.0
Cc: achasper@gmail.com, linux-dvb@linuxtv.org,
	stealth banana <stealth.banana@gmail.com>
Subject: Re: [linux-dvb] First patch for Freecom DVB-T (with usb id
	14aa:0160)
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

On Fri, 14 Mar 2008 22:24:46 +0100
Jan Hoogenraad <jan-conceptronic@h-i-s.nl> wrote:

> Dear v4l maintainer:
Please, just call me by my name ;)

> I have created a first version of the patch for the Freecom stick, based 
> on the latest sources I received today from RealTek.

Due to several issues I've noticed at the driver, I opted, for now, to add it
as a separate tree. This way, we can fix things there, without affecting the
staging tree. I've made it available at:
	http://linuxtv.org/hg/~mchehab/rtl2831

Also, I noticed that nobody, on RealTek signed it. It would be interesting if
someone there could send us a SOB for the first changeset:
	http://linuxtv.org/hg/~mchehab/rtl2831/rev/bb7749446173

Ah, by convention, we name directories in lowercase. So, I've did an "sed"
before applying your patch, as I've explained at the changeset comments.

> I have received several updates per week from them during the fixing 
> time, so I expect some updates later on.

Ok.

> I'm not very familiar with Mercurial / HG.
> I've put the sources into a separate directory, and created the patch 
> with hg commit / hg export .... / hg rollback
This works ;)

> It compiles with the latest v4l.
> It has been tested on my system only yet.
> 
> Please review the way of submission.

In general, patches are sent as in-line. However, for big patches, it is
accepted to have them compressed.

> Mauro:
> 
> Thanks for the help.
> I agree that this is probably the best thing to do.

Ok, this is the Lindent changeset:
	http://linuxtv.org/hg/~mchehab/rtl2831/rev/698c1894a3fd

> 
> Unfortunately, Lindent does not fix errors that
>   make checkpatch
> reports like the two below.
> 
> tuner_mxl5005s.h: In '// I2C birdge module demod argument setting':
> tuner_mxl5005s.h:531: ERROR: do not use C99 // comments

I tried to quickfix this with a small perl script, like:

for i in *.c *.h; do perl -ne \
'if (s|//\s*(.*)\n|/* \1 */\n|) { s|/\*\s*\*/||; } print $_' \
$i >/tmp/tmp; mv -f /tmp/tmp $i; done

However, this failed, since there are some comments with // inside. It doesn't
seem to be hard to fix this by a close script.

> tuner_mxl5005s.h: In 'void 
> mxl5005s_SetI2cBridgeModuleTunerArg(TUNER_MODULE * pTuner);':
> tuner_mxl5005s.h:532: ERROR: "foo * bar" should be "foo *bar"

True. Yet, this shows another thing that is forbidden on Linux CodingStyle: the
usage of typedef. While this is valid on a few cases, on most cases we prefer
to use things like "struct foo *foo;".

---

Due to the size of the driver, and the nature of it (a port from other OS), it
is natural that we will have a large amount of issues. Before visiting the code
to check everything, maybe the better approach would be to do some general
comments. 

I'll start commenting some things about CodingStyle. The better is if you could
read kernel Documentation/CodingStyle.

1) Kernel already defines several types. Please use the already defined typedefs.
For example:

+typedef unsigned char U8Data;

use, instead __u8

+typedef unsigned int UData_t; /* type must be at least 32 bits */

use, instead __u32

+typedef int SData_t; /* type must be at least 32 bits */

use, instead __s32

+typedef void *Handle_t; /* memory pointer type 

Just use "void *"

2) We don't use "typedef struct foo". Instead, just declare "struct foo" and
replace all "foo *" to "struct foo *":

+typedef struct {
+ UData_t nAS_Algorithm;
+ UData_t f_ref;
+ UData_t f_in;
+ UData_t f_LO1;
+ UData_t f_if1_Center;
+ UData_t f_if1_Request;
+ UData_t f_if1_bw;
+ UData_t f_LO2;
+ UData_t f_out;
+ UData_t f_out_bw;
+ UData_t f_LO1_Step;
+ UData_t f_LO2_Step;
+ UData_t f_LO1_FracN_Avoid;
+ UData_t f_LO2_FracN_Avoid;
+ UData_t f_zif_bw;
+ UData_t f_min_LO_Separation;
+ UData_t maxH1;
+ UData_t maxH2;
+ UData_t bSpurPresent;
+ UData_t bSpurAvoided;
+ UData_t nSpursFound;
+ UData_t nZones;
+ struct MT_ExclZone_t *freeZones;
+ struct MT_ExclZone_t *usedZones;
+ struct MT_ExclZone_t MT_ExclZones[MAX_ZONES];
} MT_AvoidSpursData_t; 

3) Name convention. Names are generally in lower case. Since we try to have all
lines with maxsize=80, the better is trying to have shorter names. 

I don't think that it would be a good idea to replace all names inside the driver,
since this will make your life harder, when receiving patches from Realtek.
Anyway, please consider this if you need to touch on some var name. 

There are other comments I want to do, about the integration with the tree. I
intend to do it later, after having a better understanding on how the driver
works and what can be done to avoid code duplication with dvb core and to allow
the usage of the tuners by other drivers.

Also, I'll need help from other developers on this large task ;)

Cheers,
Mauro

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
