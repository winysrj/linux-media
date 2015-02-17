Return-path: <linux-media-owner@vger.kernel.org>
Received: from relaycp03.dominioabsoluto.net ([217.116.26.84]:35797 "EHLO
	relaycp03.dominioabsoluto.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932332AbbBQMrm (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 17 Feb 2015 07:47:42 -0500
From: "dCrypt" <dcrypt@telefonica.net>
To: <v4l@dharty.com>, <stoth@kernellabs.com>
Cc: <linux-media@vger.kernel.org>
References: <14641294.293916.1422889477503.JavaMail.defaultUser@defaultHost>	<1842309.294410.1422891194529.JavaMail.defaultUser@defaultHost> <CALzAhNXPne4_0vs80Y26Yia8=jYh8EqA0phJm31UzATdAvPvDg@mail.gmail.com> <8039614.312436.1422971964080.JavaMail.defaultUser@defaultHost> <54DD3986.3010707@dharty.com> <54E2BC31.7000809@dharty.com>
In-Reply-To: <54E2BC31.7000809@dharty.com>
Subject: RE: [BUG, workaround] HVR-2200/saa7164 problem with C7 power state
Date: Tue, 17 Feb 2015 13:47:39 +0100
Message-ID: <004501d04aaf$e9fe6540$bdfb2fc0$@net>
MIME-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----=_NextPart_000_0046_01D04AB8.4BC2CD40"
Content-Language: es
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is a multi-part message in MIME format.

------=_NextPart_000_0046_01D04AB8.4BC2CD40
Content-Type: text/plain;
	charset="utf-8"
Content-Transfer-Encoding: quoted-printable

Hi,

Forcing C-state to C6 doesn't help either. It's just the errors show up =
in the log later. Last reboot was the 12th of February, and I started =
getting errors this morning and VDR shutdown (five days working without =
issues). Find the log attached.

I am testing again with the next C-state bios option, C1, in order to =
check if the problem is related to the C-states or not.

Tested in Ubuntu 14.04 with 3.13.0-45-generic kernel, Asrock Q1900-M =
board.

BR=20

> -----Mensaje original-----
> De: linux-media-owner@vger.kernel.org [mailto:linux-media-
> owner@vger.kernel.org] En nombre de catchall
> Enviado el: martes, 17 de febrero de 2015 4:58
> Para: v4l@dharty.com; DCRYPT@telefonica.net; stoth@kernellabs.com
> CC: linux-media@vger.kernel.org
> Asunto: Re: [BUG, workaround] HVR-2200/saa7164 problem with C7 power
> state
>=20
> On 02/12/2015 03:38 PM, David Harty wrote:
> > I hadn't changed the PCI Express Configuration to Gen1 because per
> the
> > http://whirlpool.net.au/wiki/n54l_all_in_one page it didn't appear =
to
> > help reliably.  I've made that change now. I'll report to see if =
that
> > improves anything, perhaps both changes have to be made in
> conjunction.
>=20
> So the PCI Express change hasn't seemed to help either.  Any other
> ideas?
>=20
> David
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media"
> in the body of a message to majordomo@vger.kernel.org More majordomo
> info at  http://vger.kernel.org/majordomo-info.html

------=_NextPart_000_0046_01D04AB8.4BC2CD40
Content-Type: application/octet-stream;
	name="kern.log"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
	filename="kern.log"

Feb 17 11:14:09 homeserver kernel: [471556.235817] Event timed out=0A=
Feb 17 11:14:09 homeserver kernel: [471556.235857] =
saa7164_api_i2c_write() error, ret(2) =3D 0x32=0A=
Feb 17 11:14:09 homeserver kernel: [471556.235908] =
__tda18271_write_regs: [9-0060|M] ERROR: idx =3D 0x5, len =3D 1, =
i2c_transfer returned: -5=0A=
Feb 17 11:14:09 homeserver kernel: [471556.235984] =
tda18271c2_rf_tracking_filters_correction: [9-0060|M] error -5 on line =
266=0A=
Feb 17 11:14:09 homeserver kernel: [471556.236066] Event timed out=0A=
Feb 17 11:14:09 homeserver kernel: [471556.236129] =
saa7164_api_i2c_read() error, ret(2) =3D 0x32=0A=
Feb 17 11:14:09 homeserver kernel: [471556.236214] tda10048_readreg: =
readreg error (ret =3D=3D -5)=0A=
Feb 17 11:14:19 homeserver kernel: [471566.235822] Event timed out=0A=
Feb 17 11:14:19 homeserver kernel: [471566.235829] Event timed out=0A=
Feb 17 11:14:19 homeserver kernel: [471566.235834] =
saa7164_api_i2c_read() error, ret(1) =3D 0x32=0A=
Feb 17 11:14:19 homeserver kernel: [471566.235837] tda10048_readreg: =
readreg error (ret =3D=3D -5)=0A=
Feb 17 11:14:19 homeserver kernel: [471566.235971] =
saa7164_api_i2c_write() error, ret(1) =3D 0x32=0A=
Feb 17 11:14:19 homeserver kernel: [471566.236021] =
__tda18271_write_regs: [9-0060|M] ERROR: idx =3D 0x25, len =3D 1, =
i2c_transfer returned: -5=0A=
Feb 17 11:14:19 homeserver kernel: [471566.236099] =
tda18271_channel_configuration: [9-0060|M] error -5 on line 120=0A=
Feb 17 11:14:19 homeserver kernel: [471566.236159] tda18271_set_params: =
[9-0060|M] error -5 on line 985=0A=
Feb 17 11:14:23 homeserver kernel: [471570.267811] Event timed out=0A=
Feb 17 11:14:23 homeserver kernel: [471570.267849] =
saa7164_api_transition_port(portnr 1 unitid 0x22) error, ret =3D 0x32=0A=
Feb 17 11:14:23 homeserver kernel: [471570.267912] =
saa7164_dvb_pause_port() pause transition failed, ret =3D 0x32=0A=
Feb 17 11:14:29 homeserver kernel: [471576.235811] Event timed out=0A=
Feb 17 11:14:29 homeserver kernel: [471576.235851] =
saa7164_api_i2c_read() error, ret(1) =3D 0x32=0A=
Feb 17 11:14:29 homeserver kernel: [471576.235898] tda10048_readreg: =
readreg error (ret =3D=3D -5)=0A=
Feb 17 11:14:29 homeserver kernel: [471576.236036] Event timed out=0A=
Feb 17 11:14:29 homeserver kernel: [471576.236099] =
saa7164_api_i2c_write() error, ret(1) =3D 0x32=0A=
Feb 17 11:14:29 homeserver kernel: [471576.236184] tda10048_writereg: =
writereg error (ret =3D=3D -5)=0A=
Feb 17 11:14:33 homeserver kernel: [471580.267810] Event timed out=0A=
Feb 17 11:14:33 homeserver kernel: [471580.267847] =
saa7164_api_transition_port(portnr 1 unitid 0x22) error, ret =3D 0x32=0A=
Feb 17 11:14:33 homeserver kernel: [471580.267910] =
saa7164_dvb_acquire_port() acquire transition failed, ret =3D 0x32=0A=
Feb 17 11:14:39 homeserver kernel: [471586.235820] Event timed out=0A=
Feb 17 11:14:39 homeserver kernel: [471586.235860] =
saa7164_api_i2c_write() error, ret(1) =3D 0x32=0A=
Feb 17 11:14:39 homeserver kernel: [471586.235908] tda10048_writereg: =
writereg error (ret =3D=3D -5)=0A=
Feb 17 11:14:39 homeserver kernel: [471586.236023] Event timed out=0A=
Feb 17 11:14:39 homeserver kernel: [471586.236087] =
saa7164_api_i2c_write() error, ret(1) =3D 0x32=0A=
Feb 17 11:14:39 homeserver kernel: [471586.236176] =
__tda18271_write_regs: [10-0060|S] ERROR: idx =3D 0x5, len =3D 1, =
i2c_transfer returned: -5=0A=
Feb 17 11:14:39 homeserver kernel: [471586.236316] tda18271_init: =
[10-0060|S] error -5 on line 832=0A=
Feb 17 11:14:39 homeserver kernel: [471586.236404] tda18271_tune: =
[10-0060|S] error -5 on line 910=0A=
Feb 17 11:14:39 homeserver kernel: [471586.236492] tda18271_set_params: =
[10-0060|S] error -5 on line 985=0A=
Feb 17 11:14:43 homeserver kernel: [471590.267801] Event timed out=0A=
Feb 17 11:14:43 homeserver kernel: [471590.267838] =
saa7164_api_transition_port(portnr 1 unitid 0x22) error, ret =3D 0x32=0A=
Feb 17 11:14:43 homeserver kernel: [471590.267901] =
saa7164_dvb_stop_port() stop transition failed, ret =3D 0x32=0A=
Feb 17 11:14:49 homeserver kernel: [471596.235812] Event timed out=0A=
Feb 17 11:14:49 homeserver kernel: [471596.235875] =
saa7164_api_i2c_read() error, ret(1) =3D 0x32=0A=
Feb 17 11:14:49 homeserver kernel: [471596.235984] Event timed out=0A=
Feb 17 11:14:49 homeserver kernel: [471596.235994] tda10048_readreg: =
readreg error (ret =3D=3D -5)=0A=
Feb 17 11:14:49 homeserver kernel: [471596.236071] =
saa7164_api_i2c_write() error, ret(1) =3D 0x32=0A=
Feb 17 11:14:49 homeserver kernel: [471596.236118] tda10048_writereg: =
writereg error (ret =3D=3D -5)=0A=
Feb 17 11:14:59 homeserver kernel: [471606.235803] Event timed out=0A=
Feb 17 11:14:59 homeserver kernel: [471606.235837] =
saa7164_api_i2c_write() error, ret(1) =3D 0x32=0A=
Feb 17 11:14:59 homeserver kernel: [471606.235885] tda10048_writereg: =
writereg error (ret =3D=3D -5)=0A=
Feb 17 11:14:59 homeserver kernel: [471606.236048] Event timed out=0A=
Feb 17 11:14:59 homeserver kernel: [471606.236111] =
saa7164_api_i2c_write() error, ret(1) =3D 0x32=0A=
Feb 17 11:14:59 homeserver kernel: [471606.236197] tda10048_writereg: =
writereg error (ret =3D=3D -5)=0A=
Feb 17 11:15:09 homeserver kernel: [471616.235799] Event timed out=0A=
Feb 17 11:15:09 homeserver kernel: [471616.235862] =
saa7164_api_i2c_write() error, ret(1) =3D 0x32=0A=
Feb 17 11:15:09 homeserver kernel: [471616.235949] tda10048_writereg: =
writereg error (ret =3D=3D -5)=0A=
Feb 17 11:15:09 homeserver kernel: [471616.236101] Event timed out=0A=
Feb 17 11:15:09 homeserver kernel: [471616.236137] =
saa7164_api_i2c_read() error, ret(1) =3D 0x32=0A=
Feb 17 11:15:09 homeserver kernel: [471616.236185] tda10048_readreg: =
readreg error (ret =3D=3D -5)=0A=
Feb 17 11:15:19 homeserver kernel: [471626.235923] Event timed out=0A=
Feb 17 11:15:19 homeserver kernel: [471626.235987] =
saa7164_api_i2c_write() error, ret(1) =3D 0x32=0A=
Feb 17 11:15:19 homeserver kernel: [471626.236069] Event timed out=0A=
Feb 17 11:15:19 homeserver kernel: [471626.236075] =
saa7164_api_i2c_read() error, ret(1) =3D 0x32=0A=
Feb 17 11:15:19 homeserver kernel: [471626.236078] tda10048_readreg: =
readreg error (ret =3D=3D -5)=0A=
Feb 17 11:15:19 homeserver kernel: [471626.236277] tda10048_writereg: =
writereg error (ret =3D=3D -5)=0A=
Feb 17 11:15:29 homeserver kernel: [471636.235793] Event timed out=0A=
Feb 17 11:15:29 homeserver kernel: [471636.235856] =
saa7164_api_i2c_read() error, ret(1) =3D 0x32=0A=
Feb 17 11:15:29 homeserver kernel: [471636.235941] tda10048_readreg: =
readreg error (ret =3D=3D -5)=0A=
Feb 17 11:15:29 homeserver kernel: [471636.236036] Event timed out=0A=
Feb 17 11:15:29 homeserver kernel: [471636.236076] =
saa7164_api_i2c_read() error, ret(1) =3D 0x32=0A=
Feb 17 11:15:29 homeserver kernel: [471636.236123] tda10048_readreg: =
readreg error (ret =3D=3D -5)=0A=
Feb 17 11:15:39 homeserver kernel: [471646.235776] Event timed out=0A=
Feb 17 11:15:39 homeserver kernel: [471646.235939] Event timed out=0A=
Feb 17 11:15:39 homeserver kernel: [471646.235944] =
saa7164_api_i2c_read() error, ret(1) =3D 0x32=0A=
Feb 17 11:15:39 homeserver kernel: [471646.235947] tda10048_readreg: =
readreg error (ret =3D=3D -5)=0A=
Feb 17 11:15:39 homeserver kernel: [471646.245507] =
saa7164_api_i2c_write() error, ret(1) =3D 0x32=0A=
Feb 17 11:15:39 homeserver kernel: [471646.247897] tda10048_writereg: =
writereg error (ret =3D=3D -5)=0A=
Feb 17 11:15:49 homeserver kernel: [471656.235781] Event timed out=0A=
Feb 17 11:15:49 homeserver kernel: [471656.240039] =
saa7164_api_i2c_read() error, ret(1) =3D 0x32=0A=
Feb 17 11:15:49 homeserver kernel: [471656.244265] tda10048_readreg: =
readreg error (ret =3D=3D -5)=0A=
Feb 17 11:15:49 homeserver kernel: [471656.247942] Event timed out=0A=
Feb 17 11:15:49 homeserver kernel: [471656.247945] =
saa7164_api_i2c_write() error, ret(1) =3D 0x32=0A=
Feb 17 11:15:49 homeserver kernel: [471656.247951] =
__tda18271_write_regs: [9-0060|M] ERROR: idx =3D 0x5, len =3D 1, =
i2c_transfer returned: -5=0A=
Feb 17 11:15:49 homeserver kernel: [471656.247953] tda18271_init: =
[9-0060|M] error -5 on line 832=0A=
Feb 17 11:15:49 homeserver kernel: [471656.247955] tda18271_tune: =
[9-0060|M] error -5 on line 910=0A=
Feb 17 11:15:49 homeserver kernel: [471656.247957] tda18271_set_params: =
[9-0060|M] error -5 on line 985=0A=
Feb 17 11:15:59 homeserver kernel: [471666.247764] Event timed out=0A=
Feb 17 11:15:59 homeserver kernel: [471666.250115] =
saa7164_api_i2c_read() error, ret(1) =3D 0x32=0A=
Feb 17 11:15:59 homeserver kernel: [471666.252462] tda10048_readreg: =
readreg error (ret =3D=3D -5)=0A=
Feb 17 11:15:59 homeserver kernel: [471666.271854] Event timed out=0A=
Feb 17 11:15:59 homeserver kernel: [471666.276071] =
saa7164_api_i2c_write() error, ret(1) =3D 0x32=0A=
Feb 17 11:15:59 homeserver kernel: [471666.280238] tda10048_writereg: =
writereg error (ret =3D=3D -5)=0A=
Feb 17 11:16:09 homeserver kernel: [471676.251753] Event timed out=0A=
Feb 17 11:16:09 homeserver kernel: [471676.254045] =
saa7164_api_i2c_write() error, ret(1) =3D 0x32=0A=
Feb 17 11:16:09 homeserver kernel: [471676.256347] tda10048_writereg: =
writereg error (ret =3D=3D -5)=0A=
Feb 17 11:16:09 homeserver kernel: [471676.279874] Event timed out=0A=
Feb 17 11:16:09 homeserver kernel: [471676.284089] =
saa7164_api_i2c_write() error, ret(1) =3D 0x32=0A=
Feb 17 11:16:09 homeserver kernel: [471676.288283] =
__tda18271_write_regs: [10-0060|S] ERROR: idx =3D 0x5, len =3D 1, =
i2c_transfer returned: -5=0A=
Feb 17 11:16:09 homeserver kernel: [471676.292542] tda18271_init: =
[10-0060|S] error -5 on line 832=0A=
Feb 17 11:16:09 homeserver kernel: [471676.296821] tda18271_tune: =
[10-0060|S] error -5 on line 910=0A=
Feb 17 11:16:09 homeserver kernel: [471676.301035] tda18271_set_params: =
[10-0060|S] error -5 on line 985=0A=
Feb 17 11:16:19 homeserver kernel: [471686.255870] Event timed out=0A=
Feb 17 11:16:19 homeserver kernel: [471686.258174] =
saa7164_api_i2c_write() error, ret(1) =3D 0x32=0A=
Feb 17 11:16:19 homeserver kernel: [471686.260502] tda10048_writereg: =
writereg error (ret =3D=3D -5)=0A=
Feb 17 11:16:19 homeserver kernel: [471686.303789] Event timed out=0A=
Feb 17 11:16:19 homeserver kernel: [471686.308039] =
saa7164_api_i2c_read() error, ret(1) =3D 0x32=0A=
Feb 17 11:16:19 homeserver kernel: [471686.312217] tda10048_readreg: =
readreg error (ret =3D=3D -5)=0A=
Feb 17 11:16:24 homeserver kernel: [471691.483829] Event timed out=0A=
Feb 17 11:16:24 homeserver kernel: [471691.486115] =
saa7164_api_set_debug() error, ret =3D 0x32=0A=
Feb 17 11:16:29 homeserver kernel: [471696.259956] Event timed out=0A=
Feb 17 11:16:29 homeserver kernel: [471696.262215] =
saa7164_api_i2c_write() error, ret(1) =3D 0x32=0A=
Feb 17 11:16:29 homeserver kernel: [471696.264513] tda10048_writereg: =
writereg error (ret =3D=3D -5)=0A=
Feb 17 11:16:29 homeserver kernel: [471696.315925] Event timed out=0A=
Feb 17 11:16:29 homeserver kernel: [471696.318175] =
saa7164_api_i2c_write() error, ret(1) =3D 0x32=0A=
Feb 17 11:16:29 homeserver kernel: [471696.320437] tda10048_writereg: =
writereg error (ret =3D=3D -5)=0A=
Feb 17 11:16:34 homeserver kernel: [471701.487834] Event timed out=0A=
Feb 17 11:16:34 homeserver kernel: [471701.490072] =
saa7164_api_set_debug() error, ret =3D 0x32=0A=
Feb 17 11:16:34 homeserver kernel: [471701.492327] Histogram named irq =
intervals (ms, count, last_update_jiffy)=0A=
Feb 17 11:16:34 homeserver kernel: [471701.494625] Total: 0=0A=
Feb 17 11:16:34 homeserver kernel: [471701.496870] Histogram named =
deferred intervals (ms, count, last_update_jiffy)=0A=
Feb 17 11:16:34 homeserver kernel: [471701.499269] Total: 0=0A=
Feb 17 11:16:34 homeserver kernel: [471701.501573] Histogram named irq =
to deferred intervals (ms, count, last_update_jiffy)=0A=
Feb 17 11:16:34 homeserver kernel: [471701.503933] Total: 0=0A=
Feb 17 11:16:34 homeserver kernel: [471701.506244] Histogram named =
encoder/vbi read() intervals (ms, count, last_update_jiffy)=0A=
Feb 17 11:16:34 homeserver kernel: [471701.508634] Total: 0=0A=
Feb 17 11:16:34 homeserver kernel: [471701.510984] Histogram named =
encoder/vbi poll() intervals (ms, count, last_update_jiffy)=0A=
Feb 17 11:16:34 homeserver kernel: [471701.513424] Total: 0=0A=
Feb 17 11:16:34 homeserver kernel: [471701.515815] Histogram named =
encoder/vbi read() intervals (ms, count, last_update_jiffy)=0A=
Feb 17 11:16:34 homeserver kernel: [471701.518263] Total: 0=0A=
Feb 17 11:16:34 homeserver kernel: [471701.520692] Histogram named =
encoder/vbi poll() intervals (ms, count, last_update_jiffy)=0A=
Feb 17 11:16:34 homeserver kernel: [471701.523185] Total: 0=0A=
Feb 17 11:16:39 homeserver kernel: [471706.263865] Event timed out=0A=
Feb 17 11:16:39 homeserver kernel: [471706.266334] =
saa7164_api_i2c_read() error, ret(1) =3D 0x32=0A=
Feb 17 11:16:39 homeserver kernel: [471706.268824] tda10048_readreg: =
readreg error (ret =3D=3D -5)=0A=
Feb 17 11:16:39 homeserver kernel: [471706.320055] Event timed out=0A=
Feb 17 11:16:39 homeserver kernel: [471706.322537] =
saa7164_api_i2c_write() error, ret(1) =3D 0x32=0A=
Feb 17 11:16:39 homeserver kernel: [471706.325042] tda10048_writereg: =
writereg error (ret =3D=3D -5)=0A=
Feb 17 11:16:49 homeserver kernel: [471716.267740] Event timed out=0A=
Feb 17 11:16:49 homeserver kernel: [471716.270225] =
saa7164_api_i2c_write() error, ret(1) =3D 0x32=0A=
Feb 17 11:16:49 homeserver kernel: [471716.272728] tda10048_writereg: =
writereg error (ret =3D=3D -5)=0A=
Feb 17 11:16:49 homeserver kernel: [471716.323740] Event timed out=0A=
Feb 17 11:16:49 homeserver kernel: [471716.326216] =
saa7164_api_i2c_write() error, ret(1) =3D 0x32=0A=
Feb 17 11:16:49 homeserver kernel: [471716.328728] tda10048_writereg: =
writereg error (ret =3D=3D -5)=0A=
Feb 17 11:16:59 homeserver kernel: [471726.271965] Event timed out=0A=
Feb 17 11:16:59 homeserver kernel: [471726.274450] =
saa7164_api_i2c_write() error, ret(1) =3D 0x32=0A=
Feb 17 11:16:59 homeserver kernel: [471726.276967] =
__tda18271_write_regs: [9-0060|M] ERROR: idx =3D 0x5, len =3D 1, =
i2c_transfer returned: -5=0A=
Feb 17 11:16:59 homeserver kernel: [471726.279550] =
tda18271_toggle_output: [9-0060|M] error -5 on line 48=0A=
Feb 17 11:16:59 homeserver kernel: [471726.327837] Event timed out=0A=
Feb 17 11:16:59 homeserver kernel: [471726.330422] =
saa7164_api_i2c_read() error, ret(1) =3D 0x32=0A=
Feb 17 11:16:59 homeserver kernel: [471726.333024] tda10048_readreg: =
readreg error (ret =3D=3D -5)=0A=
Feb 17 11:17:09 homeserver kernel: [471736.280053] Event timed out=0A=
Feb 17 11:17:09 homeserver kernel: [471736.282637] =
saa7164_api_i2c_read() error, ret(1) =3D 0x32=0A=
Feb 17 11:17:09 homeserver kernel: [471736.285246] tda10048_readreg: =
readreg error (ret =3D=3D -5)=0A=
Feb 17 11:17:09 homeserver kernel: [471736.332018] Event timed out=0A=
Feb 17 11:17:09 homeserver kernel: [471736.334596] =
saa7164_api_i2c_write() error, ret(1) =3D 0x32=0A=
Feb 17 11:17:09 homeserver kernel: [471736.337174] tda10048_writereg: =
writereg error (ret =3D=3D -5)=0A=
Feb 17 11:17:19 homeserver kernel: [471746.287882] Event timed out=0A=
Feb 17 11:17:19 homeserver kernel: [471746.290425] =
saa7164_api_i2c_write() error, ret(1) =3D 0x32=0A=
Feb 17 11:17:19 homeserver kernel: [471746.293014] tda10048_writereg: =
writereg error (ret =3D=3D -5)=0A=
Feb 17 11:17:19 homeserver kernel: [471746.293252] tda18271 9-0060: =
destroying instance=0A=
Feb 17 11:17:19 homeserver kernel: [471746.335890] Event timed out=0A=
Feb 17 11:17:19 homeserver kernel: [471746.338461] =
saa7164_api_i2c_write() error, ret(1) =3D 0x32=0A=
Feb 17 11:17:19 homeserver kernel: [471746.341048] =
__tda18271_write_regs: [10-0060|S] ERROR: idx =3D 0x5, len =3D 1, =
i2c_transfer returned: -5=0A=
Feb 17 11:17:19 homeserver kernel: [471746.343676] =
tda18271_toggle_output: [10-0060|S] error -5 on line 48=0A=
Feb 17 11:17:29 homeserver kernel: [471756.343850] Event timed out=0A=
Feb 17 11:17:29 homeserver kernel: [471756.346480] =
saa7164_api_i2c_read() error, ret(1) =3D 0x32=0A=
Feb 17 11:17:29 homeserver kernel: [471756.349130] tda10048_readreg: =
readreg error (ret =3D=3D -5)=0A=
Feb 17 11:17:39 homeserver kernel: [471766.351897] Event timed out=0A=
Feb 17 11:17:39 homeserver kernel: [471766.354517] =
saa7164_api_i2c_write() error, ret(1) =3D 0x32=0A=
Feb 17 11:17:39 homeserver kernel: [471766.357161] tda10048_writereg: =
writereg error (ret =3D=3D -5)=0A=
Feb 17 11:17:39 homeserver kernel: [471766.357415] tda18271 10-0060: =
destroying instance=0A=
Feb 17 11:17:41 homeserver kernel: [471768.413025] saa7164 driver loaded=0A=
Feb 17 11:17:41 homeserver kernel: [471768.414245] CORE saa7164[0]: =
subsystem: 0070:8940, board: Hauppauge WinTV-HVR2200 =
[card=3D9,autodetected]=0A=
Feb 17 11:17:41 homeserver kernel: [471768.414254] saa7164[0]/0: found =
at 0000:03:00.0, rev: 129, irq: 18, latency: 0, mmio: 0xd0800000=0A=
Feb 17 11:17:51 homeserver kernel: [471778.411713] Event timed out=0A=
Feb 17 11:17:51 homeserver kernel: [471778.414337] =
saa7164_api_get_fw_version() error, ret =3D 0x32=0A=
Feb 17 11:17:51 homeserver kernel: [471778.416974] Failed to communicate =
with the firmware=0A=
Feb 17 11:18:01 homeserver kernel: [471788.419722] Event timed out=0A=
Feb 17 11:18:01 homeserver kernel: [471788.422315] =
saa7164_api_modify_gpio() error, ret =3D 0x32=0A=
Feb 17 11:18:11 homeserver kernel: [471798.423837] Event timed out=0A=
Feb 17 11:18:11 homeserver kernel: [471798.426423] =
saa7164_api_modify_gpio() error, ret =3D 0x32=0A=
Feb 17 11:18:21 homeserver kernel: [471808.451824] Event timed out=0A=
Feb 17 11:18:21 homeserver kernel: [471808.454405] =
saa7164_api_modify_gpio() error, ret =3D 0x32=0A=
Feb 17 11:18:31 homeserver kernel: [471818.455810] Event timed out=0A=
Feb 17 11:18:31 homeserver kernel: [471818.458395] =
saa7164_api_modify_gpio() error, ret =3D 0x32=0A=
Feb 17 11:18:41 homeserver kernel: [471828.459796] Event timed out=0A=
Feb 17 11:18:41 homeserver kernel: [471828.462394] =
saa7164_api_i2c_read() error, ret(1) =3D 0x32=0A=
Feb 17 11:18:51 homeserver kernel: [471838.463845] Event timed out=0A=
Feb 17 11:18:51 homeserver kernel: [471838.466424] =
saa7164_api_enum_subdevs() error, ret =3D 0x32=0A=
Feb 17 11:18:51 homeserver kernel: [471838.469031] saa7164_cmd_send() =
Invalid param=0A=
Feb 17 11:18:51 homeserver kernel: [471838.471607] =
saa7164_api_enum_subdevs() error, ret =3D 0x9=0A=
Feb 17 11:19:01 homeserver kernel: [471848.471838] Event timed out=0A=
Feb 17 11:19:01 homeserver kernel: [471848.474402] =
saa7164_api_i2c_read() error, ret(1) =3D 0x32=0A=
Feb 17 11:19:01 homeserver kernel: [471848.476982] tda10048_readreg: =
readreg error (ret =3D=3D -5)=0A=
Feb 17 11:19:01 homeserver kernel: [471848.479545] =
saa7164_dvb_register() Frontend initialization failed=0A=
Feb 17 11:19:01 homeserver kernel: [471848.482103] saa7164_initdev() =
Failed to register dvb adapters on porta=0A=
Feb 17 11:19:11 homeserver kernel: [471858.483869] Event timed out=0A=
Feb 17 11:19:11 homeserver kernel: [471858.486385] =
saa7164_api_i2c_read() error, ret(1) =3D 0x32=0A=
Feb 17 11:19:11 homeserver kernel: [471858.488909] tda10048_readreg: =
readreg error (ret =3D=3D -5)=0A=
Feb 17 11:19:11 homeserver kernel: [471858.491410] =
saa7164_dvb_register() Frontend initialization failed=0A=
Feb 17 11:19:11 homeserver kernel: [471858.493898] saa7164_initdev() =
Failed to register dvb adapters on portb=0A=
Feb 17 11:19:11 homeserver kernel: [471858.496375] =
saa7164_encoder_register() failed (errno =3D -19), NO PCI configuration=0A=
Feb 17 11:19:11 homeserver kernel: [471858.498840] saa7164_initdev() =
Failed to register mpeg encoder=0A=
Feb 17 11:19:11 homeserver kernel: [471858.501290] =
saa7164_encoder_register() failed (errno =3D -19), NO PCI configuration=0A=
Feb 17 11:19:11 homeserver kernel: [471858.503743] saa7164_initdev() =
Failed to register mpeg encoder=0A=
Feb 17 11:19:11 homeserver kernel: [471858.506167] =
saa7164_vbi_register() failed (errno =3D -19), NO PCI configuration=0A=
Feb 17 11:19:11 homeserver kernel: [471858.508594] saa7164_initdev() =
Failed to register vbi device=0A=
Feb 17 11:19:11 homeserver kernel: [471858.511030] =
saa7164_vbi_register() failed (errno =3D -19), NO PCI configuration=0A=
Feb 17 11:19:11 homeserver kernel: [471858.513496] saa7164_initdev() =
Failed to register vbi device=0A=
Feb 17 11:19:21 homeserver kernel: [471868.515857] Event timed out=0A=
Feb 17 11:19:21 homeserver kernel: [471868.518312] =
saa7164_api_set_debug() error, ret =3D 0x32=0A=
Feb 17 11:19:31 homeserver kernel: [471878.519667] Event timed out=0A=
Feb 17 11:19:31 homeserver kernel: [471878.522106] =
saa7164_api_set_debug() error, ret =3D 0x32=0A=
Feb 17 13:36:11 homeserver kernel: [480077.860590] usb 1-2.1: new =
low-speed USB device number 4 using xhci_hcd=0A=
Feb 17 13:36:11 homeserver kernel: [480077.880771] usb 1-2.1: New USB =
device found, idVendor=3D046a, idProduct=3D0001=0A=
Feb 17 13:36:11 homeserver kernel: [480077.880776] usb 1-2.1: New USB =
device strings: Mfr=3D0, Product=3D0, SerialNumber=3D0=0A=
Feb 17 13:36:11 homeserver kernel: [480077.880991] usb 1-2.1: ep 0x81 - =
rounding interval to 64 microframes, ep desc says 96 microframes=0A=
Feb 17 13:36:11 homeserver kernel: [480077.906136] hidraw: raw HID =
events driver (C) Jiri Kosina=0A=
Feb 17 13:36:11 homeserver kernel: [480077.916072] usbcore: registered =
new interface driver usbhid=0A=
Feb 17 13:36:11 homeserver kernel: [480077.916078] usbhid: USB HID core =
driver=0A=
Feb 17 13:36:11 homeserver kernel: [480077.924254] input: HID 046a:0001 =
as /devices/pci0000:00/0000:00:14.0/usb1/1-2/1-2.1/1-2.1:1.0/input/input7=0A=
Feb 17 13:36:11 homeserver kernel: [480077.924480] hid-generic =
0003:046A:0001.0001: input,hidraw0: USB HID v1.00 Keyboard [HID =
046a:0001] on usb-0000:00:14.0-2.1/input0=0A=

------=_NextPart_000_0046_01D04AB8.4BC2CD40--

