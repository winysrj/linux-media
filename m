Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from rv-out-0506.google.com ([209.85.198.226])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <greblus@gmail.com>) id 1KiDH2-0007xJ-VU
	for linux-dvb@linuxtv.org; Tue, 23 Sep 2008 21:10:15 +0200
Received: by rv-out-0506.google.com with SMTP id b25so1993168rvf.41
	for <linux-dvb@linuxtv.org>; Tue, 23 Sep 2008 12:10:07 -0700 (PDT)
Message-ID: <912f87b30809231210w45e304d6rbd5ccfb964d36bba@mail.gmail.com>
Date: Tue, 23 Sep 2008 21:10:06 +0200
From: "=?ISO-8859-2?Q?Wiktor_Gr=EAbla?=" <greblus@gmail.com>
To: linux-dvb@linuxtv.org
MIME-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----=_Part_114845_21594638.1222197006805"
Subject: [linux-dvb] em28xx-audio: HVR-900 B3C0 - ID 2040:6502 Hauppauge
	(audio clicking)
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

------=_Part_114845_21594638.1222197006805
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hi.

After some diffing I've finally managed to get rid of "audio clicking"
problem which could be heard when using analog tv or composite input
of my HVR-900. Additionally, after Mauro's suggestion, I found it
necessary to change the audio amux value for composite input from 1 to
3.

Patch against linux-dvb hg repo attached. I hope it's trivial enough
to be applied quickly. I've been using my tuner for three days without
any sound issues so far.

Cheers,
W.

-- 
Talkers are no good doers.
http://greblus.net/djangoblog/

------=_Part_114845_21594638.1222197006805
Content-Type: text/x-diff;
 name=em28xx_audio_clicking_and_composite_amux_change.diff
Content-Transfer-Encoding: base64
X-Attachment-Id: f_flgwdl5c0
Content-Disposition: attachment;
 filename=em28xx_audio_clicking_and_composite_amux_change.diff

ZGlmZiAtdXIgdjRsLWR2Yi1vbGQvbGludXgvZHJpdmVycy9tZWRpYS92aWRlby9lbTI4eHgvZW0y
OHh4LWF1ZGlvLmMgdjRsLWR2Yi1uZXcvbGludXgvZHJpdmVycy9tZWRpYS92aWRlby9lbTI4eHgv
ZW0yOHh4LWF1ZGlvLmMKLS0tIHY0bC1kdmItb2xkL2xpbnV4L2RyaXZlcnMvbWVkaWEvdmlkZW8v
ZW0yOHh4L2VtMjh4eC1hdWRpby5jCTIwMDgtMDktMjEgMjE6MjY6MDQuMDAwMDAwMDAwICswMjAw
CisrKyB2NGwtZHZiLW5ldy9saW51eC9kcml2ZXJzL21lZGlhL3ZpZGVvL2VtMjh4eC9lbTI4eHgt
YXVkaW8uYwkyMDA4LTA5LTIxIDIxOjI2OjI0LjAwMDAwMDAwMCArMDIwMApAQCAtMTI3LDEwICsx
MjcsMTAgQEAKIAogCQkJaWYgKG9sZHB0ciArIGxlbmd0aCA+PSBydW50aW1lLT5idWZmZXJfc2l6
ZSkgewogCQkJCXVuc2lnbmVkIGludCBjbnQgPQotCQkJCSAgICBydW50aW1lLT5idWZmZXJfc2l6
ZSAtIG9sZHB0ciAtIDE7CisJCQkJICAgIHJ1bnRpbWUtPmJ1ZmZlcl9zaXplIC0gb2xkcHRyOwog
CQkJCW1lbWNweShydW50aW1lLT5kbWFfYXJlYSArIG9sZHB0ciAqIHN0cmlkZSwgY3AsCiAJCQkJ
ICAgICAgIGNudCAqIHN0cmlkZSk7Ci0JCQkJbWVtY3B5KHJ1bnRpbWUtPmRtYV9hcmVhLCBjcCAr
IGNudCwKKwkJCQltZW1jcHkocnVudGltZS0+ZG1hX2FyZWEsIGNwICsgY250ICogc3RyaWRlLAog
CQkJCSAgICAgICBsZW5ndGggKiBzdHJpZGUgLSBjbnQgKiBzdHJpZGUpOwogCQkJfSBlbHNlIHsK
IAkJCQltZW1jcHkocnVudGltZS0+ZG1hX2FyZWEgKyBvbGRwdHIgKiBzdHJpZGUsIGNwLApkaWZm
IC11ciB2NGwtZHZiLW9sZC9saW51eC9kcml2ZXJzL21lZGlhL3ZpZGVvL2VtMjh4eC9lbTI4eHgt
Y2FyZHMuYyB2NGwtZHZiLW5ldy9saW51eC9kcml2ZXJzL21lZGlhL3ZpZGVvL2VtMjh4eC9lbTI4
eHgtY2FyZHMuYwotLS0gdjRsLWR2Yi1vbGQvbGludXgvZHJpdmVycy9tZWRpYS92aWRlby9lbTI4
eHgvZW0yOHh4LWNhcmRzLmMJMjAwOC0wOS0yMSAyMToyNjowNC4wMDAwMDAwMDAgKzAyMDAKKysr
IHY0bC1kdmItbmV3L2xpbnV4L2RyaXZlcnMvbWVkaWEvdmlkZW8vZW0yOHh4L2VtMjh4eC1jYXJk
cy5jCTIwMDgtMDktMjEgMjE6MjY6MzEuMDAwMDAwMDAwICswMjAwCkBAIC01NzgsNyArNTc4LDcg
QEAKIAkJfSwgewogCQkJLnR5cGUgICAgID0gRU0yOFhYX1ZNVVhfQ09NUE9TSVRFMSwKIAkJCS52
bXV4ICAgICA9IFRWUDUxNTBfQ09NUE9TSVRFMSwKLQkJCS5hbXV4ICAgICA9IDEsCisJCQkuYW11
eCAgICAgPSAzLAogCQl9LCB7CiAJCQkudHlwZSAgICAgPSBFTTI4WFhfVk1VWF9TVklERU8sCiAJ
CQkudm11eCAgICAgPSBUVlA1MTUwX1NWSURFTywK
------=_Part_114845_21594638.1222197006805
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
------=_Part_114845_21594638.1222197006805--
