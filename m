Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from py-out-1112.google.com ([64.233.166.182])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <christophpfister@gmail.com>) id 1JfMeg-0007Co-C4
	for linux-dvb@linuxtv.org; Fri, 28 Mar 2008 23:02:35 +0100
Received: by py-out-1112.google.com with SMTP id a29so518279pyi.0
	for <linux-dvb@linuxtv.org>; Fri, 28 Mar 2008 15:02:28 -0700 (PDT)
Message-ID: <19a3b7a80803281502p619d2162rf36581871deac680@mail.gmail.com>
Date: Fri, 28 Mar 2008 23:02:27 +0100
From: "Christoph Pfister" <christophpfister@gmail.com>
To: "Arthur Konovalov" <kasjas@hot.ee>
In-Reply-To: <47ED538C.4090302@hot.ee>
MIME-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----=_Part_11266_33248372.1206741748095"
References: <200803212024.17198.christophpfister@gmail.com>
	<200803281535.57209.christophpfister@gmail.com>
	<47ED0962.20701@hot.ee>
	<200803281816.10525.christophpfister@gmail.com>
	<47ED538C.4090302@hot.ee>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] CI/CAM fixes for knc1 dvb-s cards
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

------=_Part_11266_33248372.1206741748095
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

2008/3/28, Arthur Konovalov <kasjas@hot.ee>:
> Christoph Pfister wrote:
>  > Am Freitag 28 M=E4rz 2008 schrieb Arthur Konovalov:
>  > Try removing the following three lines from
>  > linux/drivers/media/dvb/dvb-core/dvb_ca_en50221.c and see whether it w=
orks:
>  >
>  > 989                           /* clear down an old CI slot if necessar=
y */
>  > 990                           if (ca->slot_info[slot].slot_state !=3D =
DVB_CA_SLOTSTATE_NONE)
>  > 991                                   dvb_ca_en50221_slot_shutdown(ca,=
 slot);
>
>  Done.
>
>  > If it doesn't work load budget-core with module param debug=3D255 and =
dvb-core
>  > with module param cam_debug=3D1 (likely you need to unload them first)=
; please
>  > paste dmesg in any case.
>
>  I haven't xine GUI at moment, but regarding to logs I suspect that it
>  doesn't works...

Hmm.
Can you please try the attached patch (still with the modification
described above ^^) and send dmesg?

>  Attached files are:
>  dmesg_load_modules - dmesg after modules load.
>  dmesg_start_vdr - dmesg after vdr start.
>  syslog - syslog after vdr start.
>
>  I noticed some suspicious rows in logs:
>
>  budget_av: saa7113_init(): saa7113 not found on KNC card

That's no problem.

>  DVB: TDA10021(0): _tda10021_writereg, writereg error (reg =3D=3D 0x01, v=
al
>  =3D=3D 0x6a, ret =3D=3D -121)

That's also present in your original log ...

>  I hope it helps and wish quick solution :) .
>
>  Regards,
>
> Arthur

Christoph

------=_Part_11266_33248372.1206741748095
Content-Type: text/plain; name=patch.diff
Content-Transfer-Encoding: base64
X-Attachment-Id: f_fedasff3
Content-Disposition: attachment; filename=patch.diff

ZGlmZiAtciAwNzc2ZTQ4MDE5OTEgbGludXgvZHJpdmVycy9tZWRpYS9kdmIvdHRwY2kvYnVkZ2V0
LWF2LmMKLS0tIGEvbGludXgvZHJpdmVycy9tZWRpYS9kdmIvdHRwY2kvYnVkZ2V0LWF2LmMJRnJp
IE1hciAyOCAxNDo1Mjo0NCAyMDA4IC0wMzAwCisrKyBiL2xpbnV4L2RyaXZlcnMvbWVkaWEvZHZi
L3R0cGNpL2J1ZGdldC1hdi5jCUZyaSBNYXIgMjggMjI6NDA6MjIgMjAwOCArMDEwMApAQCAtMjQx
LDYgKzI0MSw4IEBAIHN0YXRpYyBpbnQgY2lpbnRmX3Nsb3Rfc2h1dGRvd24oc3RydWN0IGQKIAog
CWlmIChzbG90ICE9IDApCiAJCXJldHVybiAtRUlOVkFMOworCisJV0FSTl9PTigxKTsKIAogCWRw
cmludGsoMSwgImNpaW50Zl9zbG90X3NodXRkb3duXG4iKTsKIAo=
------=_Part_11266_33248372.1206741748095
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
------=_Part_11266_33248372.1206741748095--
