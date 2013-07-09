Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-auth.no-ip.com ([8.23.224.61]:2590 "EHLO
	out.smtp-auth.no-ip.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750725Ab3GIETV (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 9 Jul 2013 00:19:21 -0400
From: "Carl-Fredrik Sundstrom" <cf@blueflowamericas.com>
To: "'Steven Toth'" <stoth@kernellabs.com>
Cc: "'Devin Heitmueller'" <dheitmueller@kernellabs.com>,
	<linux-media@vger.kernel.org>
References: <010c01ce7365$9181ff30$b485fd90$@blueflowamericas.com>	<CAGoCfiyjeqxVV8A_MM-iV58=s48FEhNPA=5MPg3WAOAKs8d2iA@mail.gmail.com>	<011901ce73ab$9b81cce0$d28566a0$@blueflowamericas.com> <CALzAhNV7Cv9SR1C2mpgtLTwxD_grCZeOWc6O-2XpJEAKg1mX6w@mail.gmail.com>
In-Reply-To: <CALzAhNV7Cv9SR1C2mpgtLTwxD_grCZeOWc6O-2XpJEAKg1mX6w@mail.gmail.com>
Subject: RE: lgdt3304
Date: Mon, 8 Jul 2013 23:18:47 -0500
Message-ID: <017101ce7c5b$6899c860$39cd5920$@blueflowamericas.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Language: en-us
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Need some advice and pointers.
I have gotten both adapters/frontends of the VerMedia AVerTVHD Duet PCTV
tuner (A188) A188-AF card to register.

[ 6251.073357] DVB: registering new adapter (SAA716x dvb adapter)
[ 6251.217817] tda18271 1-0060: creating new instance
[ 6251.219671] TDA18271HD/C2 detected @ 1-0060
[ 6251.484794] SAA716x Budget 0000:04:00.0: DVB: registering adapter 0
frontend 0 (LG Electronics LGDT3304 VSB/QAM Frontend)...
[ 6251.485084] DVB: registering new adapter (SAA716x dvb adapter)
[ 6251.601649] tda18271 0-0060: creating new instance
[ 6251.603615] TDA18271HD/C2 detected @ 0-0060
[ 6251.868787] SAA716x Budget 0000:04:00.0: DVB: registering adapter 1
frontend 0 (LG Electronics LGDT3304 VSB/QAM Frontend)...


The card only has one RF input hence I believe the two TDA18271 tuners are
setup in master/slave configuration.
When I try to set them up as master slave the slave fails to detect as seen
in below log. If I configure both as master 
both are detected 

[ 5410.137358] DVB: registering new adapter (SAA716x dvb adapter)
[ 5410.281839] tda18271 1-0060: creating new instance
[ 5410.283694] TDA18271HD/C2 detected @ 1-0060
[ 5410.548784] SAA716x Budget 0000:04:00.0: DVB: registering adapter 0
frontend 0 (LG Electronics LGDT3304 VSB/QAM Frontend)...
[ 5410.549081] DVB: registering new adapter (SAA716x dvb adapter)
[ 5410.665649] tda18271 0-0060: creating new instance
[ 5410.669264] Unknown device (0) detected @ 0-0060, device not supported.
[ 5410.669269] tda18271_attach: [0-0060|S] error -22 on line 1285
[ 5410.669272] tda18271 0-0060: destroying instance
[ 5410.704784] SAA716x Budget 0000:04:00.0: DVB: registering adapter 1
frontend 0 (LG Electronics LGDT3304 VSB/QAM Frontend)...

When I try to tune I get the following on all stations.

using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
>>> tune to: 57028615:8VSB
WARNING: >>> tuning failed!!!
>>> tune to: 57028615:8VSB (tuning failed)

Sometimes I also get 
WARNING: filter timeout pid
This happens mostly on frequencies I know have stations in my dfw area.

Any pointers would be much appreciated, especially how to find out which
tda18271 is master and how to setup 
the configuration struct's for ATSC , master, slave . 

Thanks /// Carl

/*when both tda18271 are configured with below struct they are both found */

/*if I remove .gate and .role comments it fails to detect the tda18271 on
the first i2c bus */
static struct tda18271_config averduet_tda_config_master = {
        .std_map           = &averduet_std_map,
        //.gate              = TDA18271_GATE_DIGITAL,
        //.role              = TDA18271_MASTER,
};

static struct tda18271_config averduet_tda_config_slave = {
        .std_map           = &averduet_std_map,
        .gate              = TDA18271_GATE_DIGITAL,
        .role              = TDA18271_SLAVE,
        .output_opt        = TDA18271_OUTPUT_LT_OFF,
        .rf_cal_on_startup = 1,
};

static struct lgdt3305_config averduet_lgdt3304_dev = {
        .i2c_addr           = 0x0e, /*0x0e, 0x59 these are the only two
possible values*/
        .demod_chip         = LGDT3304,
        .spectral_inversion = 1,
        .deny_i2c_rptr      = 0, /*1,*/
        .mpeg_mode          = LGDT3305_MPEG_PARALLEL,
        .tpclk_edge         = LGDT3305_TPCLK_FALLING_EDGE,
        .tpvalid_polarity   = LGDT3305_TP_VALID_HIGH,
        .vsb_if_khz         = 3250,
        .qam_if_khz         = 4000,
};




tridentsx@tridentsx-P5K-E:~/media_build/media$ lsmod
Module                  Size  Used by
tda18271               40860  2
lgdt3305               22788  2
saa716x_budget         18162  0
mb86a16                27023  1 saa716x_budget
saa716x_core           68492  1 saa716x_budget
stv090x                57159  1 saa716x_budget
dvb_core               90348  3 saa716x_core,saa716x_budget,lgdt3305
vesafb                 13500  1
snd_hda_codec_analog    75266  1
parport_pc             27504  0
ppdev                  12817  0
bnep                   17669  2
rfcomm                 37420  0
bluetooth             202069  10 bnep,rfcomm
snd_hda_intel          38307  2
coretemp               13131  0
binfmt_misc            17260  1
kvm_intel             126842  0
snd_hda_codec         117580  2 snd_hda_intel,snd_hda_codec_analog
snd_hwdep              13272  1 snd_hda_codec
kvm                   376505  1 kvm_intel
snd_pcm                80890  2 snd_hda_codec,snd_hda_intel
snd_page_alloc         14230  2 snd_pcm,snd_hda_intel
gpio_ich               13236  0
snd_seq_midi           13132  0
snd_seq_midi_event     14475  1 snd_seq_midi
snd_rawmidi            25114  1 snd_seq_midi
snd_seq                51280  2 snd_seq_midi_event,snd_seq_midi
nvidia               7108000  24
snd_seq_device         14137  3 snd_seq,snd_rawmidi,snd_seq_midi
snd_timer              24411  2 snd_pcm,snd_seq
microcode              18286  0
lpc_ich                16925  0
serio_raw              13031  0
snd                    56485  13
snd_hwdep,snd_timer,snd_pcm,snd_seq,snd_rawmidi,snd_hda_codec,snd_hda_intel,
snd_seq_device,snd_hda_codec_analog
asus_atk0110           17390  0
mac_hid                13037  0
soundcore              12600  1 snd
lp                     13299  0
parport                40753  3 lp,ppdev,parport_pc
pata_acpi              12886  0
firewire_ohci          35292  0
firewire_core          61718  1 firewire_ohci
crc_itu_t              12627  1 firewire_core
usb_storage            47684  0
pata_jmicron           12662  0
floppy                 55441  0
sky2                   52846  0
ahci                   25507  0
libahci                26108  1 ahci



-----Original Message-----
From: linux-media-owner@vger.kernel.org
[mailto:linux-media-owner@vger.kernel.org] On Behalf Of Steven Toth
Sent: Friday, June 28, 2013 10:23 AM
To: Carl-Fredrik Sundstrom
Cc: Devin Heitmueller; linux-media@vger.kernel.org
Subject: Re: lgdt3304

On Thu, Jun 27, 2013 at 11:00 PM, Carl-Fredrik Sundstrom
<cf@blueflowamericas.com> wrote:
>
> I am able to detect two lgdt3304 one on each i2c bus now. As you 
> suspected I had to set GPIO pin 17 for them to come alive.
>
> Now to my next question, how do I attach two front ends I have two 
> lgdt3304 and two TDA18271HD/C2 Is there a good driver I can look at 
> where they do that ?

The SAA7164 driver (amongst others) demonstrates how to expose multiple
tuners on a single card via multiple adapters, /dev/dvb/adapterX.

The cx88 driver demonstrates how to expose multiple tuners/demods via a
single transport bus, via a single dvb adapter.
/dev/dvb/adapter0/frontendX

- Steve

--
Steven Toth - Kernel Labs
http://www.kernellabs.com
--
To unsubscribe from this list: send the line "unsubscribe linux-media" in
the body of a message to majordomo@vger.kernel.org More majordomo info at
http://vger.kernel.org/majordomo-info.html

