Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from fmmailgate05.web.de ([217.72.192.243])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <reach.blystak@web.de>) id 1Jnzcv-0006b8-Hs
	for linux-dvb@linuxtv.org; Mon, 21 Apr 2008 19:16:25 +0200
Received: from web.de
	by fmmailgate05.web.de (Postfix) with SMTP id 3F37A4F0333F
	for <linux-dvb@linuxtv.org>; Mon, 21 Apr 2008 19:15:52 +0200 (CEST)
Message-ID: <6355212.1208798152212.JavaMail.fmail@fmcert02.dlan.cinetic.de>
MIME-Version: 1.0
Date: Mon, 21 Apr 2008 19:15:50 +0200
From: Dominik Blystak <reach.blystak@web.de>
To: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Nova-HD-S2
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============0672982502=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--===============0672982502==
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg="md5";
	boundary="----=_Part_33327_32049443.1208798152209"

------=_Part_33327_32049443.1208798152209
Content-Type: text/plain; charset=iso-8859-15
Content-Transfer-Encoding: quoted-printable

Hi Charles,

I got the Nova-HD-S2 "running" the way you describe with ubuntu kernel vers=
ion 2.6.22. The errors you get indicate a problem with the kernel - you may=
 try 2.6.22.=20
If you get this stuff built don't expect too much. Tuning with szap and wat=
ching with mplayer works but I'm getting the following recurring kernel bug=
 when trying to scan for channels (e.g. with mythtv or kaffeine):

[  129.340000] BUG: unable to handle kernel paging request at virtual addre=
ss f9ffffff
[  129.340000]  printing eip:
[  129.340000] c0108ddb
[  129.340000] *pde =3D 1feec067
[  129.340000] *pte =3D 00000000
[  129.340000] Oops: 0000 [#1]
[  129.340000] SMP=20
[  129.340000] Modules linked in: af_packet ipv6 container ac button dock s=
bs video battery sbp2 lp isl6421 cx24116 snd_seq_dummy snd_seq_oss snd_seq_=
midi cx88_dvb cx88_vp3054_i2c videobuf_dvb dvb_core snd_rawmidi snd_hda_int=
el tuner tea5767 tda8290 tda18271 cx88_alsa snd_pcm_oss tda827x tuner_xc202=
8 xc5000 snd_mixer_oss snd_pcm tda9887 tuner_simple tuner_types mt20xx tea5=
761 snd_seq_midi_event fglrx(P) cx8802 cx8800 cx88xx snd_seq snd_timer comp=
at_ioctl32 v4l2_common snd_seq_device videodev parport_pc parport v4l1_comp=
at ir_common lirc_imon lirc_dev snd i2c_algo_bit tveeprom soundcore videobu=
f_dma_sg videobuf_core btcx_risc pcspkr snd_page_alloc i2c_piix4 k8temp i2c=
_core shpchp pci_hotplug ati_agp agpgart evdev ext3 jbd mbcache sg sr_mod c=
drom sd_mod ata_generic usbhid hid floppy ehci_hcd atiixp ide_core r8169 oh=
ci1394 ieee1394 ahci libata scsi_mod ohci_hcd usbcore thermal processor fan=
 fuse apparmor commoncap
[  129.340000] CPU:    1
[  129.340000] EIP:    0060:[<c0108ddb>]    Tainted: P       VLI
[  129.340000] EFLAGS: 00010286   (2.6.22-14-generic #1)
[  129.340000] EIP is at dma_free_coherent+0x2b/0x60
[  129.340000] eax: 00000000   ebx: f6585000   ecx: f6585000   edx: 0000000=
0
[  129.340000] esi: f9ffffff   edi: f6469d2c   ebp: 00000282   esp: f65a7f5=
c
[  129.340000] ds: 007b   es: 007b   fs: 00d8  gs: 0000  ss: 0068
[  129.340000] Process cx88[0] dvb (pid: 7661, ti=3Df65a6000 task=3Df774cf9=
0 task.ti=3Df65a6000)
[  129.340000] Stack: ffffffff 36585000 f89a14e0 36585000 f89e43cb f6469cc0=
 f6469cc0 f6469d48=20
[  129.340000]        f7889918 f8ab9cb6 00000000 f7889918 00000020 f8a0b508=
 00000000 f7889918=20
[  129.340000]        f668b600 f7889918 f8a0b63b f7889918 f7889910 f8a0b6df=
 f668b624 f8a66465=20
[  129.340000] Call Trace:
[  129.340000]  [<f89a14e0>] btcx_riscmem_free+0x40/0x90 [btcx_risc]
[  129.340000]  [<f89e43cb>] videobuf_dma_unmap+0x2b/0x60 [videobuf_dma_sg]
[  129.340000]  [<f8ab9cb6>] cx88_free_buffer+0x46/0x60 [cx88xx]
[  129.340000]  [<f8a0b508>] videobuf_queue_cancel+0x88/0xb0 [videobuf_core=
]
[  129.340000]  [<f8a0b63b>] __videobuf_read_stop+0xb/0x60 [videobuf_core]
[  129.340000]  [<f8a0b6df>] videobuf_read_stop+0xf/0x20 [videobuf_core]
[  129.340000]  [<f8a66465>] videobuf_dvb_thread+0xf5/0x160 [videobuf_dvb]
[  129.340000]  [<f8a66370>] videobuf_dvb_thread+0x0/0x160 [videobuf_dvb]
[  129.340000]  [<c013bb12>] kthread+0x42/0x70
[  129.340000]  [<c013bad0>] kthread+0x0/0x70
[  129.340000]  [<c0105487>] kernel_thread_helper+0x7/0x10
[  129.340000]  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D
[  129.340000] Code: 56 31 f6 85 c0 53 89 cb 74 06 8b b0 40 01 00 00 8d 42 =
ff ba ff ff ff ff c1 e8 0b 90 8d 74 26 00 83 c2 01 d1 e8 75 f9 85 f6 74 06 =
<8b> 0e 39 cb 73 09 89 d8 5b 5e e9 a6 a4 05 00 8b 46 08 c1 e0 0c=20
[  129.340000] EIP: [<c0108ddb>] dma_free_coherent+0x2b/0x60 SS:ESP 0068:f6=
5a7f5c

I've also tried other revs where the patch seemed to work and the multiprot=
o driver but AFAIK there are no multiproto-aware apps around, beside a few =
hacks. I tried the VDR 1.5.14 which should work with multiproto but I only =
got some "unsupported operation" messages from ioctl().

I hope the whole beef around the hvr-4000 development gets settled soon bec=
ause the current situation is really annoying!

with best regards,
Dominik
_______________________________________________________________
Schon geh=F6rt? Der neue WEB.DE MultiMessenger kann`s mit allen:=20
http://www.produkte.web.de/messenger/?did=3D3016


------=_Part_33327_32049443.1208798152209
Content-Type: application/pkcs7-signature; name=smime.p7s; smime-type=signed-data
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

MIAGCSqGSIb3DQEHAqCAMIACAQExDjAMBggqhkiG9w0CBQUAMIAGCSqGSIb3DQEHAQAAoIID8zCC
A+8wggLXoAMCAQICBAQ0TWMwDQYJKoZIhvcNAQEEBQAwgaAxCzAJBgNVBAYTAkRFMRIwEAYDVQQK
EwlXRUIuREUgQUcxFTATBgNVBAsTDFRydXN0IENlbnRlcjEaMBgGA1UEBxMRRC03NjIyNyBLYXJs
c3J1aGUxLTArBgNVBAMTJFdFQi5ERSBUcnVzdENlbnRlciBFTWFpbC1aZXJ0aWZpa2F0ZTEbMBkG
CSqGSIb3DQEJARYMdHJ1c3RAd2ViLmRlMB4XDTA3MDYyOTExMjc0OFoXDTA4MDYyODExMjc0OFow
ZDEKMAgGA1UEBhMBRDEXMBUGA1UEBwwORnJhbmtmdXJ0L01haW4xGDAWBgNVBAMTD0RvbWluaWsg
Qmx5c3RhazEjMCEGCSqGSIb3DQEJARYUcmVhY2guYmx5c3Rha0B3ZWIuZGUwgZ8wDQYJKoZIhvcN
AQEBBQADgY0AMIGJAoGBAKWD/hBa0bzceV/FxRfALXSYXdCXrnxamQZOrSjZUFaWEmwT9F7NuX/W
Oy3JyjsLHzsWsWuCKqm+sj0d/BJjFBACBpNP3dmG0MZPUxq/cf/6a+t8NMYGh7JxK9edcd0NtzUW
jRGDGLTEOqJprHpg15Xe3r5+QC26NLsTfrmrSibRAgMBAAGjge8wgewwHQYDVR0OBBYEFDdHViYr
mE6EeajCA4nl/cyZAlFiMB8GA1UdIwQYMBaAFFpkzNcIjXxhAsbLkgPXwrr53rzUMAwGA1UdEwEB
/wQCMAAwEQYJYIZIAYb4QgEBBAQDAgSwMCMGCWCGSAGG+EIBAgQWFhRodHRwczovL3RydXN0Lndl
Yi5kZTAaBglghkgBhvhCAQgEDRYLL0hpbGZlL0FHQi8wFgYJYIZIAYb4QgEDBAkWBy9ydi8/cz0w
FgYJYIZIAYb4QgEHBAkWBy9ybi8/cz0wGAYJYIZIAYb4QgEEBAsWCS9ydkNBLz9zPTANBgkqhkiG
9w0BAQQFAAOCAQEAjpPNOhbSpulqc1eRzg6B2R9H5vmLpsiAiDOiGbTL256AZjsK3uY0LhT7EMxW
1W0o3y4rON8v38pVSiT6BTLnpLlcI8IvLwTS22GnArL2hefWeH+hm29Ez0DyMCR4Iuga8sM8i0Os
WutBTi7vJfcuaHUNFDyLlwmdM2RvueqsvhBF9Dv4yPQVQxDZLfWam45nvCkOG+15/hWSUFQSyjfg
3bMFE5E/jNGQHz6AxZbN2qh/Z7I6ib4T30NvZ7TBoi6bao3W6KH2E5EyUA+YQQ5a4060d+x2aKes
8YU0Y4gE2bqQyhKcSlPI70T8inaxNUPAwDy8kga3qlPs42GBud97RjGCArowggK2AgEBMIGpMIGg
MQswCQYDVQQGEwJERTESMBAGA1UEChMJV0VCLkRFIEFHMRUwEwYDVQQLEwxUcnVzdCBDZW50ZXIx
GjAYBgNVBAcTEUQtNzYyMjcgS2FybHNydWhlMS0wKwYDVQQDEyRXRUIuREUgVHJ1c3RDZW50ZXIg
RU1haWwtWmVydGlmaWthdGUxGzAZBgkqhkiG9w0BCQEWDHRydXN0QHdlYi5kZQIEBDRNYzAMBggq
hkiG9w0CBQUAoIIBYzAYBgkqhkiG9w0BCQMxCwYJKoZIhvcNAQcBMBwGCSqGSIb3DQEJBTEPFw0w
ODA0MjExNzE1NTJaMB8GCSqGSIb3DQEJBDESBBBwM0PiiOVtAFOyFjILe6TcMEkGCSqGSIb3DQEJ
DzE8MDowCgYIKoZIhvcNAwcwDgYIKoZIhvcNAwICAgCAMA0GCCqGSIb3DQMCAgFAMA0GCCqGSIb3
DQMCAgEoMIG8BgsqhkiG9w0BCRACCzGBrKCBqTCBoDELMAkGA1UEBhMCREUxEjAQBgNVBAoTCVdF
Qi5ERSBBRzEVMBMGA1UECxMMVHJ1c3QgQ2VudGVyMRowGAYDVQQHExFELTc2MjI3IEthcmxzcnVo
ZTEtMCsGA1UEAxMkV0VCLkRFIFRydXN0Q2VudGVyIEVNYWlsLVplcnRpZmlrYXRlMRswGQYJKoZI
hvcNAQkBFgx0cnVzdEB3ZWIuZGUCBAQ0TWMwDQYJKoZIhvcNAQEBBQAEgYB9kc12fM9nhv5O/+at
kyyVPZ7W81koygTs0kGMC71cxNkQm1vb9hkModWwWEyNu9PA6buF/sj2kHW2fJkT83gCm9Pch8J9
eAlYK+VWeCvdXPzCVFp7Cc23KcnpT1atHVKbfj1S1yiCbwjZHrBwCnVvSGXcyM514KWyRCeYCa6q
SQAAAAAAAA==
------=_Part_33327_32049443.1208798152209--


--===============0672982502==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============0672982502==--
