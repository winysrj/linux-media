Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
MIME-Version: 1.0
In-Reply-To: <51821.47198.qm@web56805.mail.re3.yahoo.com>
References: <878323.51314.qm@web56803.mail.re3.yahoo.com>
	<49C3A5E4.9010908@linuxtv.org>
	<412bdbff0903200725k699a2b40xdfa69e9113239c0d@mail.gmail.com>
	<51821.47198.qm@web56805.mail.re3.yahoo.com>
Date: Sun, 22 Mar 2009 20:01:23 -0400
Message-ID: <412bdbff0903221701v49c3370ai7c877281b2953ff5@mail.gmail.com>
From: Devin Heitmueller <devin.heitmueller@gmail.com>
To: ZhanMa <zhan@digilinksoftware.com>
Cc: linux-dvb <linux-dvb@linuxtv.org>
Subject: Re: [linux-dvb] Linux driver for Hauppauge WinTV-HVR 950Q
Reply-To: linux-media@vger.kernel.org
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

On Sun, Mar 22, 2009 at 1:59 PM, ZhanMa <zhan@digilinksoftware.com> wrote:
> Hi Steven and Devin,
>
> Please ignore the last email, I just used 'dvbscan', and found it can load
> the xc5000 firmware, so I think that it will load the firmware at certain
> conditions.
>
> While, when run 'dvbscan', I got "Unable to query frontend status":
>
> #./dvbscan /usr/share/dvb/atsc/us-ATSC-center-frequencies-8VSB
> xc5000: xc5000_init()
> =A0xc5000_init() , call xc_load_fw_and_init_tuner()
> =A0[xc_load_fw_and_init_tuner]
> xc5000: xc5000_is_firmware_loaded() returns False id =3D 0x2000
> =A0[xc_load_fw_and_init_tuner] call xc5000_fwupload
> xc5000: waiting for firmware upload (dvb-fe-xc5000-1.1.fw)...
> xc5000: firmware read 12332 bytes.
> xc5000: firmware upload
> xc5000: xc5000_TunerReset()
> au0828_tuner_callback()
> =A0[xc_load_fw_and_init_tuner] call xc_initialize
> xc5000: xc_initialize()
> xc5000: *** ADC envelope (0-1023) =3D 49183
> xc5000: *** Frequency error =3D 896234 Hz
> xc5000: *** Lock status (0-Wait, 1-Locked, 2-No-signal) =3D 32831
> xc5000: *** HW: V0e.01, FW: V02.0f
> xc5000: *** Horizontal sync frequency =3D 16106 Hz
> xc5000: *** Frame lines =3D 49215
> xc5000: *** Quality (0:<8dB, 7:>56dB) =3D 32831
> xc5000: xc5000_set_params() frequency=3D177028615 (Hz)
> xc5000: xc5000_set_params() VSB modulation
> xc5000: xc5000_set_params() frequency=3D175278615 (compensated)
> xc5000: xc_SetSignalSource(0) Source =3D ANTENNA
> xc5000: xc_SetTVStandard(0x8002,0x00c0)
> xc5000: xc_SetTVStandard() Standard =3D DTV6
> xc5000: xc_set_IF_frequency(freq_khz =3D 6000) freq_code =3D 0x1800
> xc5000: xc_tune_channel(175278615)
> xc5000: xc_set_RF_frequency(175278615)
> xc5000: *** ADC envelope (0-1023) =3D 49279
> xc5000: *** Frequency error =3D 896234 Hz
> xc5000: *** Lock status (0-Wait, 1-Locked, 2-No-signal) =3D 32831
> xc5000: *** HW: V0f.01, FW: V02.0f
> xc5000: *** Horizontal sync frequency =3D 15862 Hz
> xc5000: *** Frame lines =3D 49279
> xc5000: *** Quality (0:<8dB, 7:>56dB) =3D 32831
> Unable to query frontend status
> xc5000: xc5000_sleep()
>
>
> Actually, before, I tried the dvbscan on my laptop with Fedora Core 8, li=
nux
> kernel 2.6.25, and v4l-dvb is dated about March 18, but I got the same
> problem.
>
> Jason

Hello Jason,

Step 1:  Please update to the latest version of the v4l-dvb code.  I
don't want to be in a situation where I am debugging old code, and
this will make it easier to send you patches to get more debugging
info.

Step 2:  Please use pastebin to include the full dmesg output.  Users
often send what they believe is relevant, and this often does not
include critical information.  This also allows me to get some context
as to what else is going on in the system.

Step 3: Please try using the "scan" tool as opposed to the "dvbscan"
tool.  I know that scan works as expected and want to rule out some
sort of application issue.  Also be sure to provide the exact command
line that you ran.

Are you trying to scan for digital channels over the air, or are you
trying to scan for digital cable?  And do you know that you can
actually receive channels in your location (have you tried it with the
same antenna in the same location under Windows?)

In older versions of the code, the firmware gets loaded on the first
use, as opposed to when the driver gets started up (this behavior
changed on Mar 18th).  Also bear in mind that it takes ten to twelve
seconds to load the firmware (this is a known issue with the i2c bus
that I am actively debugging).

Devin

-- =

Devin J. Heitmueller
http://www.devinheitmueller.com
AIM: devinheitmueller

_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
