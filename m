Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mognix.dark-green.com ([88.116.226.179])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <gimli@dark-green.com>) id 1LBqoH-0005tl-9X
	for linux-dvb@linuxtv.org; Sun, 14 Dec 2008 14:15:03 +0100
Received: from webmail.dark-green.com
	(83-64-96-243.bad-voeslau.xdsl-line.inode.at [83.64.96.243])
	by mognix.dark-green.com (Postfix) with ESMTP id 84DE45AC09A
	for <linux-dvb@linuxtv.org>; Sun, 14 Dec 2008 14:15:29 +0100 (CET)
Message-ID: <52355.62.178.208.71.1229260499.squirrel@webmail.dark-green.com>
In-Reply-To: <200812141302.47851@orion.escape-edv.de>
References: <4943A606.5060502@cadsoft.de>
	<200812141302.47851@orion.escape-edv.de>
Date: Sun, 14 Dec 2008 14:14:59 +0100 (CET)
From: "gimli" <gimli@dark-green.com>
To: linux-dvb@linuxtv.org
MIME-Version: 1.0
Content-Type: multipart/mixed;boundary="----=_20081214141459_67866"
Subject: [linux-dvb] Terratec Cinergy S2 PCI HD S2API ( Liplianin's tree )
	fixes
Reply-To: gimli@dark-green.com
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

------=_20081214141459_67866
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

Hi,

attached there are 2 patches. One which corrects MANTIS_VP_1041_DVB_S2 an=
d
the second one solves the following bug :

 memory: 0xdffff000, mmio: 0xffffc2000035a000
found a VP-1041 PCI DSS/DVB-S/DVB-S2 device on (01:06.0),
    Mantis Rev 1 [153b:1179], irq: 16, latency: 64
    memory: 0xdffff000, mmio: 0xffffc2000035a000
    MAC Address=3D[00:08:ca:1c:d5:e6]
mantis_alloc_buffers (0): DMA=3D0x6d810000 cpu=3D0xffff88006d810000 size=3D=
65536
mantis_alloc_buffers (0): RISC=3D0x6e8fa000 cpu=3D0xffff88006e8fa000 size=
=3D1000
DVB: registering new adapter (Mantis dvb adapter)
stb0899_attach: Attaching STB0899
mantis_frontend_init (0): found STB0899 DVB-S/DVB-S2 frontend @0x68
stb6100_attach: Attaching STB6100
DVB: registering adapter 0 frontend 0 (STB0899 Multistandard)...
mantis_ca_init (0): Registering EN50221 device
mantis_ca_init (0): Registered EN50221 device
BUG: unable to handle kernel NULL pointer dereference at 0000000000000000
IP: [<ffffffff80231ca0>] 0xffffffff80231ca0
PGD 6d805067 PUD 6d8f1067 PMD 0
Oops: 0000 [1] PREEMPT SMP
CPU 1
Modules linked in: mantis(+) lnbp21 mb86a16 stb6100 tda10021 tda10023
stb0899 stv0299 dvb_core autofs4 container pci_slot sbs video output
battery sbshc af_packet ac it87 hwmon_vid powernow_k8 cpufreq_userspace
cpufreq_powersave cpufreq_ondemand freq_table arc4 ecb snd_hda_intel
snd_pcm_oss snd_mixer_oss snd_pcm snd_page_alloc snd_hwdep snd_seq_dummy
snd_seq_oss zd1211rw psmouse snd_seq_midi snd_rawmidi evdev serio_raw
mac80211 k8temp snd_seq_midi_event shpchp usbhid snd_seq pci_hotplug
cfg80211 hid snd_timer snd_seq_device i2c_core snd soundcore wmi
parport_pc parport button ohci1394 ieee1394 forcedeth ehci_hcd ohci_hcd
usbcore thermal processor fan
Pid: 9, comm: events/1 Not tainted 2.6.27 #1
RIP: 0010:[<ffffffff80231ca0>]  [<ffffffff80231ca0>] 0xffffffff80231ca0
RSP: 0018:ffff88006fbbfe20  EFLAGS: 00010082
RAX: 0000000000000000 RBX: ffff88006d31c058 RCX: 0000000000000000
RDX: 0000000000000001 RSI: 0000000000000003 RDI: ffff88006d31c058
RBP: ffff88006fbbfe50 R08: ffffffffffffffe8 R09: ffff88000102ce00
R10: 0000004a93e37af4 R11: ffffffff804e8fa7 R12: 0000000000000001
R13: 0000000000000001 R14: ffff88006d31c060 R15: 0000000000000000
FS:  00007f8874a416e0(0000) GS:ffff88006f802780(0000) knlGS:0000000000000=
000
CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
CR2: 0000000000000000 CR3: 000000006e8d5000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process events/1 (pid: 9, threadinfo ffff88006fbbe000, task ffff88006fb73=
600)
Stack:  0000000300000000 ffff88006d31c058 0000000000000000 00000000000000=
01
 0000000000000286 0000000000000003 ffff88006fbbfe90 ffffffff802324ce
 ffff88006f802908 ffff88006d31c038 ffff88006d31c030 ffffffffa0262fc3
Call Trace:
 [<ffffffff802324ce>] 0xffffffff802324ce
 [<ffffffffa0262fc3>] ? 0xffffffffa0262fc3
 [<ffffffff8024ab06>] 0xffffffff8024ab06
 [<ffffffff8024ac82>] ? 0xffffffff8024ac82
 [<ffffffff8024e082>] ? 0xffffffff8024e082
 [<ffffffff8024ab92>] ? 0xffffffff8024ab92
 [<ffffffff8024dd3f>] ? 0xffffffff8024dd3f
 [<ffffffff802397ba>] ? 0xffffffff802397ba
 [<ffffffff802125e9>] ? 0xffffffff802125e9
 [<ffffffff8024dcf8>] ? 0xffffffff8024dcf8
 [<ffffffff802125df>] ? 0xffffffff802125df


Code: c9 c3 55 48 89 e5 41 57 4d 89 c7 41 56 4c 8d 77 08
<3>mantis_hif_init (0): Adapter(0) Initializing Mantis Host Interface
41 55 41 54 41 89 d4 53 48 83 ec 08 89 75 d4 89 4d d0 48 8b 47 08 4c 8d 4=
0
e8 <49> 8b 40 18 48 8d 58 e8 eb 2d 45 8b 28 4c 89 f9 8b 55 d0 8b 75
RIP  [<ffffffff80231ca0>] 0xffffffff80231ca0
 RSP <ffff88006fbbfe20>
CR2: 0000000000000000
---[ end trace e8c4dfd3500996f1 ]---
note: events/1[9] exited with preempt_count 1

Both patches are taken from Manu Abraham's multiproto mantis tree and jus=
t
aplied to Igor Liplianin's S2API tree.

mfg

Edgar (gimli) Hucek

------=_20081214141459_67866
Content-Type: application/octet-stream; name="s2-liplianin_cinergy.patch"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="s2-liplianin_cinergy.patch"

ZGlmZiAtdU5yIHMyLWxpcGxpYW5pbi9saW51eC9kcml2ZXJzL21lZGlhL2R2Yi9tYW50aXMvbWFu
dGlzX3ZwMTA0MS5oIHMyLWxpcGxpYW5pbi5jaW5lcmd5L2xpbnV4L2RyaXZlcnMvbWVkaWEvZHZi
L21hbnRpcy9tYW50aXNfdnAxMDQxLmgKLS0tIHMyLWxpcGxpYW5pbi9saW51eC9kcml2ZXJzL21l
ZGlhL2R2Yi9tYW50aXMvbWFudGlzX3ZwMTA0MS5oCTIwMDgtMTItMTMgMTg6MTk6MzguMDAwMDAw
MDAwICswMTAwCisrKyBzMi1saXBsaWFuaW4uY2luZXJneS9saW51eC9kcml2ZXJzL21lZGlhL2R2
Yi9tYW50aXMvbWFudGlzX3ZwMTA0MS5oCTIwMDgtMTItMTMgMTg6MjM6MTAuMDAwMDAwMDAwICsw
MTAwCkBAIC0yNyw3ICsyNyw3IEBACiAjaW5jbHVkZSAic3RiNjEwMC5oIgogI2luY2x1ZGUgImxu
YnAyMS5oIgogCi0jZGVmaW5lIE1BTlRJU19WUF8xMDQxX0RWQl9TMgkweDAwMzEKKyNkZWZpbmUg
TUFOVElTX1ZQXzEwNDFfRFZCX1MyCTB4MTE3OQogI2RlZmluZSBURUNITklTQVRfU0tZU1RBUl9I
RDJfMQkweDAwMDEKIC8vIFN1YnN5c3RlbTogRGV2aWNlIDFhZTQ6MDAwMwogI2RlZmluZSBURUNI
TklTQVRfU0tZU1RBUl9IRDJfMiAweDAwMDMK
------=_20081214141459_67866
Content-Type: application/octet-stream;
      name="s2-liplianin_cinergy_mutex.patch"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="s2-liplianin_cinergy_mutex.patch"

LS0tIHMyLWxpcGxpYW5pbi9saW51eC9kcml2ZXJzL21lZGlhL2R2Yi9tYW50aXMvbWFudGlzX2Nh
LmMJMjAwOC0xMi0xMyAxODoxOTozOC4wMDAwMDAwMDAgKzAxMDAKKysrIG1hbnRpcy9saW51eC9k
cml2ZXJzL21lZGlhL2R2Yi9tYW50aXMvbWFudGlzX2NhLmMJMjAwOC0xMi0xNCAxMzo0MzowMS4w
MDAwMDAwMDAgKzAxMDAKQEAgLTE2MCw2ICsxNjAsMTIgQEAKIAljYS0+ZW41MDIyMS5wb2xsX3Ns
b3Rfc3RhdHVzCT0gbWFudGlzX3Nsb3Rfc3RhdHVzOwogCWNhLT5lbjUwMjIxLmRhdGEJCT0gY2E7
CiAKKwltdXRleF9pbml0KCZjYS0+Y2FfbG9jayk7CisKKwlpbml0X3dhaXRxdWV1ZV9oZWFkKCZj
YS0+aGlmX2RhdGFfd3EpOworCWluaXRfd2FpdHF1ZXVlX2hlYWQoJmNhLT5oaWZfb3Bkb25lX3dx
KTsKKwlpbml0X3dhaXRxdWV1ZV9oZWFkKCZjYS0+aGlmX3dyaXRlX3dxKTsKKwogCWRwcmludGso
dmVyYm9zZSwgTUFOVElTX0VSUk9SLCAxLCAiUmVnaXN0ZXJpbmcgRU41MDIyMSBkZXZpY2UiKTsK
IAlpZiAoKHJlc3VsdCA9IGR2Yl9jYV9lbjUwMjIxX2luaXQoZHZiX2FkYXB0ZXIsICZjYS0+ZW41
MDIyMSwgY2FfZmxhZ3MsIDEpKSAhPSAwKSB7CiAJCWRwcmludGsodmVyYm9zZSwgTUFOVElTX0VS
Uk9SLCAxLCAiRU41MDIyMTogSW5pdGlhbGl6YXRpb24gZmFpbGVkIik7Ci0tLSBzMi1saXBsaWFu
aW4vbGludXgvZHJpdmVycy9tZWRpYS9kdmIvbWFudGlzL21hbnRpc19oaWYuYwkyMDA4LTEyLTEz
IDE4OjE5OjM4LjAwMDAwMDAwMCArMDEwMAorKysgbWFudGlzL2xpbnV4L2RyaXZlcnMvbWVkaWEv
ZHZiL21hbnRpcy9tYW50aXNfaGlmLmMJMjAwOC0xMi0xNCAxMzo0MzowMS4wMDAwMDAwMDAgKzAx
MDAKQEAgLTc1LDYgKzkyLDcgQEAKIAl1MzIgaGlmX2FkZHIgPSAwLCBkYXRhLCBjb3VudCA9IDQ7
CiAKIAlkcHJpbnRrKHZlcmJvc2UsIE1BTlRJU19ERUJVRywgMSwgIkFkYXB0ZXIoJWQpIFNsb3Qo
MCk6IFJlcXVlc3QgSElGIE1lbSBSZWFkIiwgbWFudGlzLT5udW0pOworCW11dGV4X2xvY2soJmNh
LT5jYV9sb2NrKTsKIAloaWZfYWRkciAmPSB+TUFOVElTX0dQSUZfUENNQ0lBUkVHOwogCWhpZl9h
ZGRyICY9IH5NQU5USVNfR1BJRl9QQ01DSUFJT007CiAJaGlmX2FkZHIgfD0gIE1BTlRJU19ISUZf
U1RBVFVTOwpAQCAtODcsOSArMTA1LDExIEBACiAKIAlpZiAobWFudGlzX2hpZl9zYnVmX29wZG9u
ZV93YWl0KGNhKSAhPSAwKSB7CiAJCWRwcmludGsodmVyYm9zZSwgTUFOVElTX0VSUk9SLCAxLCAi
QWRhcHRlciglZCkgU2xvdCgwKTogR1BJRiBTbWFydCBCdWZmZXIgb3BlcmF0aW9uIGZhaWxlZCIs
IG1hbnRpcy0+bnVtKTsKKwkJbXV0ZXhfdW5sb2NrKCZjYS0+Y2FfbG9jayk7CiAJCXJldHVybiAt
RVJFTU9URUlPOwogCX0KIAlkYXRhID0gbW1yZWFkKE1BTlRJU19HUElGX0RJTik7CisJbXV0ZXhf
dW5sb2NrKCZjYS0+Y2FfbG9jayk7CiAJZHByaW50ayh2ZXJib3NlLCBNQU5USVNfREVCVUcsIDEs
ICJNZW0gUmVhZDogMHglMDJ4IiwgZGF0YSk7CiAJcmV0dXJuIChkYXRhID4+IDI0KSAmIDB4ZmY7
CiB9CkBAIC0xMDEsNiArMTIxLDcgQEAKIAl1MzIgaGlmX2FkZHIgPSAwOwogCiAJZHByaW50ayh2
ZXJib3NlLCBNQU5USVNfREVCVUcsIDEsICJBZGFwdGVyKCVkKSBTbG90KDApOiBSZXF1ZXN0IEhJ
RiBNZW0gV3JpdGUiLCBtYW50aXMtPm51bSk7CisJbXV0ZXhfbG9jaygmY2EtPmNhX2xvY2spOwog
CWhpZl9hZGRyICY9IH5NQU5USVNfR1BJRl9ISUZSRFdSTjsKIAloaWZfYWRkciAmPSB+TUFOVElT
X0dQSUZfUENNQ0lBUkVHOwogCWhpZl9hZGRyICY9IH5NQU5USVNfR1BJRl9QQ01DSUFJT007CkBA
IC0xMTMsOSArMTM0LDExIEBACiAKIAlpZiAobWFudGlzX2hpZl93cml0ZV93YWl0KGNhKSAhPSAw
KSB7CiAJCWRwcmludGsodmVyYm9zZSwgTUFOVElTX0VSUk9SLCAxLCAiQWRhcHRlciglZCkgU2xv
dCgwKTogSElGIFNtYXJ0IEJ1ZmZlciBvcGVyYXRpb24gZmFpbGVkIiwgbWFudGlzLT5udW0pOwor
CQltdXRleF91bmxvY2soJmNhLT5jYV9sb2NrKTsKIAkJcmV0dXJuIC1FUkVNT1RFSU87CiAJfQog
CWRwcmludGsodmVyYm9zZSwgTUFOVElTX0RFQlVHLCAxLCAiTWVtIFdyaXRlOiAoMHglMDJ4IHRv
IDB4JTAyeCkiLCBkYXRhLCBhZGRyKTsKKwltdXRleF91bmxvY2soJmNhLT5jYV9sb2NrKTsKIAog
CXJldHVybiAwOwogfQpAQCAtMTI2LDYgKzE0OSw3IEBACiAJdTMyIGRhdGEsIGhpZl9hZGRyID0g
MDsKIAogCWRwcmludGsodmVyYm9zZSwgTUFOVElTX0RFQlVHLCAxLCAiQWRhcHRlciglZCkgU2xv
dCgwKTogUmVxdWVzdCBISUYgSS9PIFJlYWQiLCBtYW50aXMtPm51bSk7CisJbXV0ZXhfbG9jaygm
Y2EtPmNhX2xvY2spOwogCWhpZl9hZGRyICY9IH5NQU5USVNfR1BJRl9QQ01DSUFSRUc7CiAJaGlm
X2FkZHIgfD0gIE1BTlRJU19HUElGX1BDTUNJQUlPTTsKIAloaWZfYWRkciB8PSAgTUFOVElTX0hJ
Rl9TVEFUVVM7CkBAIC0xMzgsMTEgKzE2MiwxMyBAQAogCiAJaWYgKG1hbnRpc19oaWZfc2J1Zl9v
cGRvbmVfd2FpdChjYSkgIT0gMCkgewogCQlkcHJpbnRrKHZlcmJvc2UsIE1BTlRJU19FUlJPUiwg
MSwgIkFkYXB0ZXIoJWQpIFNsb3QoMCk6IEhJRiBTbWFydCBCdWZmZXIgb3BlcmF0aW9uIGZhaWxl
ZCIsIG1hbnRpcy0+bnVtKTsKKwkJbXV0ZXhfdW5sb2NrKCZjYS0+Y2FfbG9jayk7CiAJCXJldHVy
biAtRVJFTU9URUlPOwogCX0KIAlkYXRhID0gbW1yZWFkKE1BTlRJU19HUElGX0RJTik7CiAJZHBy
aW50ayh2ZXJib3NlLCBNQU5USVNfREVCVUcsIDEsICJJL08gUmVhZDogMHglMDJ4IiwgZGF0YSk7
CiAJdWRlbGF5KDUwKTsKKwltdXRleF91bmxvY2soJmNhLT5jYV9sb2NrKTsKIAogCXJldHVybiAo
dTgpIGRhdGE7CiB9CkBAIC0xNTMsNiArMTc5LDcgQEAKIAl1MzIgaGlmX2FkZHIgPSAwOwogCiAJ
ZHByaW50ayh2ZXJib3NlLCBNQU5USVNfREVCVUcsIDEsICJBZGFwdGVyKCVkKSBTbG90KDApOiBS
ZXF1ZXN0IEhJRiBJL08gV3JpdGUiLCBtYW50aXMtPm51bSk7CisJbXV0ZXhfbG9jaygmY2EtPmNh
X2xvY2spOwogCWhpZl9hZGRyICY9IH5NQU5USVNfR1BJRl9QQ01DSUFSRUc7CiAJaGlmX2FkZHIg
Jj0gfk1BTlRJU19HUElGX0hJRlJEV1JOOwogCWhpZl9hZGRyIHw9ICBNQU5USVNfR1BJRl9QQ01D
SUFJT007CkBAIC0xNjQsOSArMTkxLDExIEBACiAJCiAJaWYgKG1hbnRpc19oaWZfd3JpdGVfd2Fp
dChjYSkgIT0gMCkgewogCQlkcHJpbnRrKHZlcmJvc2UsIE1BTlRJU19FUlJPUiwgMSwgIkFkYXB0
ZXIoJWQpIFNsb3QoMCk6IEhJRiBTbWFydCBCdWZmZXIgb3BlcmF0aW9uIGZhaWxlZCIsIG1hbnRp
cy0+bnVtKTsKKwkJbXV0ZXhfdW5sb2NrKCZjYS0+Y2FfbG9jayk7CiAJCXJldHVybiAtRVJFTU9U
RUlPOwogCX0KIAlkcHJpbnRrKHZlcmJvc2UsIE1BTlRJU19ERUJVRywgMSwgIkkvTyBXcml0ZTog
KDB4JTAyeCB0byAweCUwMngpIiwgZGF0YSwgYWRkcik7CisJbXV0ZXhfdW5sb2NrKCZjYS0+Y2Ff
bG9jayk7CiAJdWRlbGF5KDUwKTsKIAogCXJldHVybiAwOwpAQCAtMTgwLDEwICsyMDksOCBAQAog
CiAJc2xvdFswXS5zbGF2ZV9jZmcgPSAweDcwNzczMDI4OwogCWRwcmludGsodmVyYm9zZSwgTUFO
VElTX0VSUk9SLCAxLCAiQWRhcHRlciglZCkgSW5pdGlhbGl6aW5nIE1hbnRpcyBIb3N0IEludGVy
ZmFjZSIsIG1hbnRpcy0+bnVtKTsKLQlpbml0X3dhaXRxdWV1ZV9oZWFkKCZjYS0+aGlmX2RhdGFf
d3EpOwotCWluaXRfd2FpdHF1ZXVlX2hlYWQoJmNhLT5oaWZfb3Bkb25lX3dxKTsKLQlpbml0X3dh
aXRxdWV1ZV9oZWFkKCZjYS0+aGlmX3dyaXRlX3dxKTsKIAorCW11dGV4X2xvY2soJmNhLT5jYV9s
b2NrKTsKIAlpcnFjZmcgPSBtbXJlYWQoTUFOVElTX0dQSUZfSVJRQ0ZHKTsKIAlpcnFjZmcgPSBN
QU5USVNfTUFTS19CUlJEWQl8CiAJCSBNQU5USVNfTUFTS19XUkFDSwl8CkBAIC0xOTMsNiArMjIw
LDcgQEAKIAkJIE1BTlRJU19NQVNLX09WRkxXOwogCiAJbW13cml0ZShpcnFjZmcsIE1BTlRJU19H
UElGX0lSUUNGRyk7CisJbXV0ZXhfdW5sb2NrKCZjYS0+Y2FfbG9jayk7CiAKIAlyZXR1cm4gMDsK
IH0KQEAgLTIwMyw3ICsyMzEsOSBAQAogCXUzMiBpcnFjZmc7CiAKIAlkcHJpbnRrKHZlcmJvc2Us
IE1BTlRJU19FUlJPUiwgMSwgIkFkYXB0ZXIoJWQpIEV4aXRpbmcgTWFudGlzIEhvc3QgSW50ZXJm
YWNlIiwgbWFudGlzLT5udW0pOworCW11dGV4X2xvY2soJmNhLT5jYV9sb2NrKTsKIAlpcnFjZmcg
PSBtbXJlYWQoTUFOVElTX0dQSUZfSVJRQ0ZHKTsKIAlpcnFjZmcgJj0gfk1BTlRJU19NQVNLX0JS
UkRZOwogCW1td3JpdGUoaXJxY2ZnLCBNQU5USVNfR1BJRl9JUlFDRkcpOworCW11dGV4X3VubG9j
aygmY2EtPmNhX2xvY2spOwogfQotLS0gczItbGlwbGlhbmluL2xpbnV4L2RyaXZlcnMvbWVkaWEv
ZHZiL21hbnRpcy9tYW50aXNfbGluay5oCTIwMDgtMTItMTMgMTg6MTk6MzguMDAwMDAwMDAwICsw
MTAwCisrKyBtYW50aXMvbGludXgvZHJpdmVycy9tZWRpYS9kdmIvbWFudGlzL21hbnRpc19saW5r
LmgJMjAwOC0xMi0xNCAxMzo0MzowMS4wMDAwMDAwMDAgKzAxMDAKQEAgLTIxLDYgKzIxLDcgQEAK
ICNpZm5kZWYgX19NQU5USVNfTElOS19ICiAjZGVmaW5lIF9fTUFOVElTX0xJTktfSAogCisjaW5j
bHVkZSA8bGludXgvbXV0ZXguaD4KICNpbmNsdWRlIDxsaW51eC93b3JrcXVldWUuaD4KICNpbmNs
dWRlICJkdmJfY2FfZW41MDIyMS5oIgogCkBAIC02MSw2ICs2Miw3IEBACiAJdm9pZAkJCQkqY2Ff
cHJpdjsKIAogCXN0cnVjdCBkdmJfY2FfZW41MDIyMQkJZW41MDIyMTsKKwlzdHJ1Y3QgbXV0ZXgJ
CQljYV9sb2NrOwogfTsKIAogLyogQ0EgKi8K
------=_20081214141459_67866
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
------=_20081214141459_67866--
