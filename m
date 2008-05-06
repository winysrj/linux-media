Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from ctb-mesg-1-1.saix.net ([196.25.240.79])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <jd.louw@mweb.co.za>) id 1JtV5Z-0004Gn-PP
	for linux-dvb@linuxtv.org; Tue, 06 May 2008 23:52:47 +0200
From: "Jan D. Louw" <jd.louw@mweb.co.za>
To: Aliaksey Kandratsenka <alkondratenko@gmail.com>
Date: Tue, 6 May 2008 23:52:13 +0200
References: <1209985450.3659.1.camel@alk.gsn>
In-Reply-To: <1209985450.3659.1.camel@alk.gsn>
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_NMNIIpJTXhBqw9H"
Message-Id: <200805062352.13231.jd.louw@mweb.co.za>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Compro S350
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

--Boundary-00=_NMNIIpJTXhBqw9H
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Monday 05 May 2008 13:04:10 Aliaksey Kandratsenka wrote:
> Hi.
>
> I've recently obtained Compro S350. It's my first DVB card so don't
> laugh at be too loudly if I'm doing something very wrong.
>
> I've tried original driver without success. I had to change PCI ID of
> card to 7133 (from 7130). Driver loads OK, but tuning to known frequency
> does not work. Turning logging on for zl10039 and zl10313 does not
> reveal any unusual errors (10039 shows expected error during chip
> reset).
>
> alk:/usr/src/linux-2.6.25.1cpro# szap -c /video/channels.conf -n 9
> reading channels from file '/video/channels.conf'
> zapping to 9 '=D0=98=D0=BD=D1=84=D0=BE=D0=BA=D0=B0=D0=BD=D0=B0=D0=BB;HTB+=
':
> sat 0, frequency =3D 12322 MHz V, symbolrate 27500000, vpid =3D 0x0148, a=
pid
> =3D 0x019e
> using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
> status 00 | signal 0105 | snr fffe | ber 00000000 | unc 00000000 |
> status 00 | signal 0104 | snr fffd | ber 00000000 | unc 00000000 |
> status 00 | signal 0104 | snr fffe | ber 00000000 | unc 00000000 |
> status 00 | signal 0104 | snr fffe | ber 00000000 | unc 00000000 |
> status 00 | signal 0104 | snr fffe | ber 00000000 | unc 00000000 |
> status 00 | signal 0103 | snr fffe | ber 00000000 | unc 00000000 |
>
> I can confirm that card uses CE6313 chip (i've found it on board). I
> wasn't able to find CE503{7/9} chip on board, but all register values
> seem plausible.
>
> I've also tried recently commited mt312 based code, by simply replacing
> call to zl10313_attach to vp310_mt312_attach and trying both values of
> voltage_inverted config option with similar results.
>
> I'd like to help with this driver, but I wasn't able to find normal
> CE6313 (aka zl10313) specs. All datasheet I found (one from intel, other
> from Zarlink) do not have registers description.
>
> It's also possible that problem lies elsewhere. Maybe some GPIO pins
> need to be tweaked. There's dedicated compro chip on this card and I
> have no idea what it may do.

Hi Aliaksey,

I tested on a Compro S300 with a ZL10313 and ZL10039 (under the tin can). Y=
our=20
S350 is advertised as having PCI wakeup features that the S300 lack. On my=
=20
S300 board IC U13 was left unpopulated, which is probably related to the=20
wakeup feature.

The Compro branded IC (U9) you mentioned is a remote control decoder micro=
=20
with a parallel interface to the PCI controller. My PCI controller is a=20
SAA7130HL. You said you had to change your PCI ID to 7133, which probably=20
means you've got a SAA7133 (with added audio decoding features but more or=
=20
less pin compatible I think).

If both the ZL10313 and ZL10039 drivers attached successfully it means they=
=20
respond correctly to the initial register probes. The Intel chips are=20
probably exact copies of the Zarlinks, so they should work unmodified.

I used a combination of the MT312 and incomplete ZL10313 datasheets to writ=
e=20
the driver. The additional register settings I gathered from watching I2C=20
traffic of Compro's Fedora Xen kernel driver available on their website. Th=
e=20
patched driver from zzam also has the missing register names and settings.

I'm attaching the pin mappings I used, gathered with the trusty multimeter =
&=20
magnifying glass method. I never recorded the tuner pin mappings, but SLEEP=
=20
wasn't connected if I remember correctly.

I used this to determine the SAA7130 GPIO settings. At the moment only GPIO=
15=20
is configured for output, connected to the RESET line of the demodulator. I=
=20
think you are correct to suspect the GPIO settings. One clue would be to=20
watch your card's initial GPIO settings at boot. Mine looks like this:

saa7130[0]: board init: gpio is 843f00


--Boundary-00=_NMNIIpJTXhBqw9H
Content-Type: application/vnd.oasis.opendocument.spreadsheet;
  name="demod.ods"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
	filename="demod.ods"

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
AN8BAADWKAAAAAA=

--Boundary-00=_NMNIIpJTXhBqw9H
Content-Type: application/vnd.oasis.opendocument.spreadsheet;
  name="processor.ods"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
	filename="processor.ods"

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

--Boundary-00=_NMNIIpJTXhBqw9H
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--Boundary-00=_NMNIIpJTXhBqw9H--
