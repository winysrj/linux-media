Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vc0-f178.google.com ([209.85.220.178]:53667 "EHLO
	mail-vc0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754383Ab3FBRD4 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 2 Jun 2013 13:03:56 -0400
Received: by mail-vc0-f178.google.com with SMTP id id13so2117515vcb.37
        for <linux-media@vger.kernel.org>; Sun, 02 Jun 2013 10:03:56 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <C73E570AC040D442A4DD326F39F0F00E2AE21490DA@SAPHIR.xi-lite.lan>
References: <1411209.JetyNPSOgp@dibcom294>
	<20130427112833.203d7fbb@redhat.com>
	<C73E570AC040D442A4DD326F39F0F00E2AE21490DA@SAPHIR.xi-lite.lan>
Date: Sun, 2 Jun 2013 13:03:55 -0400
Message-ID: <CAOcJUbyRKFoVAGnUwABVRY3WrF0+VF6q=H2MGBzF7s2TRjq05A@mail.gmail.com>
Subject: Re: [GIT PULL FOR 3.10] DiBxxxx: fixes and improvements
From: Michael Krufky <mkrufky@linuxtv.org>
To: Olivier GRENIE <olivier.grenie@parrot.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	Patrick BOETTCHER <patrick.boettcher@parrot.com>,
	Patrick Boettcher <pboettcher@kernellabs.com>
Content-Type: multipart/mixed; boundary=089e0129508856604104de2ed5d2
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--089e0129508856604104de2ed5d2
Content-Type: text/plain; charset=ISO-8859-1

Olivier,

I have regenerated your patch against the most recent codebase, as
your patch no longer applies.  (There were changes merged on the 29th
of April that broke it.)

The new patch is attached, but I am reluctant to merge it, as I do not
have any description of the patch, and it lacks a sign-off.

Please test this patch and confirm that it produces the desired
effect, then resubmit with a short description and your sign-off.

Best regards,

Mike Krufky

On Sat, May 4, 2013 at 12:05 AM, Olivier GRENIE
<olivier.grenie@parrot.com> wrote:
> Hello Mauro,
> can you apply the attached patch. This patch correct the proposed patch by Patrick for the dib807x. Sorry to not have seen it before.
>
> regards,
> Olivier
>
> ________________________________________
> From: Mauro Carvalho Chehab [mchehab@redhat.com]
> Sent: Saturday, April 27, 2013 4:28 PM
> To: Patrick Boettcher
> Cc: linux-media@vger.kernel.org; Olivier GRENIE; Patrick BOETTCHER
> Subject: Re: [GIT PULL FOR 3.10] DiBxxxx: fixes and improvements
>
> Hi Patrick,
>
> Em Mon, 22 Apr 2013 10:12:34 +0200
> Patrick Boettcher <pboettcher@kernellabs.com> escreveu:
>
>> Hi Mauro,
>>
>> These patches contains some fixes and changes for the DiBcom demods and
>> SIPs.
>>
>> Please merge for 3.10 if possible.
>>
>>
>> The following changes since commit 60d509fa6a9c4653a86ad830e4c4b30360b23f0e:
>>
>>   Linux 3.9-rc8 (2013-04-21 14:38:45 -0700)
>>
>> are available in the git repository at:
>>
>>   git://git.linuxtv.org/pb/media_tree.git/ master
>
> Hmm... I suspect that there's something wrong with those changes.
>
> Testing it with a dib8076 usb stick seems that the code is worse than
> before, as it is now harder to get a lock here.
>
> With the previous code:
>
> INFO     Scanning frequency #1 725142857
> Carrier(0x03) Signal= 67.46% C/N= 0.00% UCB= 0 postBER= 0
> Viterbi(0x05) Signal= 67.08% C/N= 0.00% UCB= 0 postBER= 2097151
> Viterbi(0x07) Signal= 67.54% C/N= 0.25% UCB= 165 postBER= 0
> Sync   (0x0f) Signal= 67.06% C/N= 0.23% UCB= 151 postBER= 0
> Lock   (0x1f) Signal= 67.58% C/N= 0.24% UCB= 160 postBER= 338688
> Service #0 (60320) BAND HD channel 57.1.0
> Service #1 (60345) BAND 1SEG channel 57.1.1
>
> With the new code:
>
> INFO     Scanning frequency #1 725142857
>        (0x00) Signal= 68.80% C/N= 0.00% UCB= 0 postBER= 0
> RF     (0x01) Signal= 68.78% C/N= 0.00% UCB= 0 postBER= 0
> RF     (0x01) Signal= 68.69% C/N= 0.00% UCB= 0 postBER= 0
> RF     (0x01) Signal= 69.82% C/N= 0.00% UCB= 0 postBER= 0
> RF     (0x01) Signal= 69.29% C/N= 0.00% UCB= 0 postBER= 0
> RF     (0x01) Signal= 69.27% C/N= 0.00% UCB= 0 postBER= 0
> RF     (0x01) Signal= 69.28% C/N= 0.00% UCB= 0 postBER= 0
> RF     (0x01) Signal= 69.27% C/N= 0.00% UCB= 0 postBER= 0
> RF     (0x01) Signal= 68.55% C/N= 0.00% UCB= 0 postBER= 0
> RF     (0x01) Signal= 68.50% C/N= 0.00% UCB= 0 postBER= 0
> RF     (0x01) Signal= 68.43% C/N= 0.00% UCB= 0 postBER= 0
> RF     (0x01) Signal= 68.65% C/N= 0.00% UCB= 0 postBER= 0
> RF     (0x01) Signal= 69.75% C/N= 0.00% UCB= 0 postBER= 0
> RF     (0x01) Signal= 69.29% C/N= 0.00% UCB= 0 postBER= 0
> RF     (0x01) Signal= 69.28% C/N= 0.00% UCB= 0 postBER= 0
> RF     (0x01) Signal= 69.25% C/N= 0.00% UCB= 0 postBER= 0
> RF     (0x01) Signal= 68.43% C/N= 0.00% UCB= 0 postBER= 0
> RF     (0x01) Signal= 68.46% C/N= 0.00% UCB= 0 postBER= 0
> RF     (0x01) Signal= 68.43% C/N= 0.00% UCB= 0 postBER= 0
> RF     (0x01) Signal= 68.90% C/N= 0.00% UCB= 0 postBER= 0
> RF     (0x01) Signal= 69.50% C/N= 0.00% UCB= 0 postBER= 0
> RF     (0x01) Signal= 69.28% C/N= 0.00% UCB= 0 postBER= 0
> RF     (0x01) Signal= 69.22% C/N= 0.00% UCB= 0 postBER= 0
> RF     (0x01) Signal= 69.22% C/N= 0.00% UCB= 0 postBER= 0
> RF     (0x01) Signal= 68.43% C/N= 0.00% UCB= 0 postBER= 0
> RF     (0x01) Signal= 68.41% C/N= 0.00% UCB= 0 postBER= 0
> RF     (0x01) Signal= 68.41% C/N= 0.00% UCB= 0 postBER= 0
> RF     (0x01) Signal= 68.96% C/N= 0.00% UCB= 0 postBER= 0
> RF     (0x01) Signal= 69.42% C/N= 0.00% UCB= 0 postBER= 0
> RF     (0x01) Signal= 69.24% C/N= 0.00% UCB= 0 postBER= 0
> RF     (0x01) Signal= 69.22% C/N= 0.00% UCB= 0 postBER= 0
> RF     (0x01) Signal= 69.25% C/N= 0.00% UCB= 0 postBER= 0
>
> So, it seems that the changes broke something.
>
> Regards,
> Mauro

--089e0129508856604104de2ed5d2
Content-Type: application/octet-stream; name="2013-05-04-040550.patch"
Content-Disposition: attachment; filename="2013-05-04-040550.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_hhghaj7g1

ZGlmZiAtLWdpdCBhL2RyaXZlcnMvbWVkaWEvZHZiLWZyb250ZW5kcy9kaWI4MDAwLmMgYi9kcml2
ZXJzL21lZGlhL2R2Yi1mcm9udGVuZHMvZGliODAwMC5jCmluZGV4IDkwNTM2MTQuLjQ4N2MyNTMg
MTAwNjQ0Ci0tLSBhL2RyaXZlcnMvbWVkaWEvZHZiLWZyb250ZW5kcy9kaWI4MDAwLmMKKysrIGIv
ZHJpdmVycy9tZWRpYS9kdmItZnJvbnRlbmRzL2RpYjgwMDAuYwpAQCAtMjQ0NSw3ICsyNDQ1LDgg
QEAgc3RhdGljIGludCBkaWI4MDAwX2F1dG9zZWFyY2hfc3RhcnQoc3RydWN0IGR2Yl9mcm9udGVu
ZCAqZmUpCiAJaWYgKHN0YXRlLT5yZXZpc2lvbiA9PSAweDgwOTApCiAJCWludGVybmFsID0gZGli
ODAwMF9yZWFkMzIoc3RhdGUsIDIzKSAvIDEwMDA7CiAKLQlpZiAoc3RhdGUtPmF1dG9zZWFyY2hf
c3RhdGUgPT0gQVNfU0VBUkNISU5HX0ZGVCkgeworCWlmICgoc3RhdGUtPnJldmlzaW9uID49IDB4
ODAwMikgJiYKKwkgICAgKHN0YXRlLT5hdXRvc2VhcmNoX3N0YXRlID09IEFTX1NFQVJDSElOR19G
RlQpKSB7CiAJCWRpYjgwMDBfd3JpdGVfd29yZChzdGF0ZSwgIDM3LCAweDAwNjUpOyAvKiBQX2N0
cmxfcGhhX29mZl9tYXggZGVmYXVsdCB2YWx1ZXMgKi8KIAkJZGliODAwMF93cml0ZV93b3JkKHN0
YXRlLCAxMTYsIDB4MDAwMCk7IC8qIFBfYW5hX2dhaW4gdG8gMCAqLwogCkBAIC0yNDgxLDcgKzI0
ODIsOCBAQCBzdGF0aWMgaW50IGRpYjgwMDBfYXV0b3NlYXJjaF9zdGFydChzdHJ1Y3QgZHZiX2Zy
b250ZW5kICpmZSkKIAkJZGliODAwMF93cml0ZV93b3JkKHN0YXRlLCA3NzAsIChkaWI4MDAwX3Jl
YWRfd29yZChzdGF0ZSwgNzcwKSAmIDB4ZGZmZikgfCAoMSA8PCAxMykpOyAvKiBQX3Jlc3RhcnRf
Y2NnID0gMSAqLwogCQlkaWI4MDAwX3dyaXRlX3dvcmQoc3RhdGUsIDc3MCwgKGRpYjgwMDBfcmVh
ZF93b3JkKHN0YXRlLCA3NzApICYgMHhkZmZmKSB8ICgwIDw8IDEzKSk7IC8qIFBfcmVzdGFydF9j
Y2cgPSAwICovCiAJCWRpYjgwMDBfd3JpdGVfd29yZChzdGF0ZSwgMCwgKGRpYjgwMDBfcmVhZF93
b3JkKHN0YXRlLCAwKSAmIDB4N2ZmKSB8ICgwIDw8IDE1KSB8ICgxIDw8IDEzKSk7IC8qIFBfcmVz
dGFydF9zZWFyY2ggPSAwOyAqLwotCX0gZWxzZSBpZiAoc3RhdGUtPmF1dG9zZWFyY2hfc3RhdGUg
PT0gQVNfU0VBUkNISU5HX0dVQVJEKSB7CisJfSBlbHNlIGlmICgoc3RhdGUtPnJldmlzaW9uID49
IDB4ODAwMikgJiYKKwkJICAgKHN0YXRlLT5hdXRvc2VhcmNoX3N0YXRlID09IEFTX1NFQVJDSElO
R19HVUFSRCkpIHsKIAkJYy0+dHJhbnNtaXNzaW9uX21vZGUgPSBUUkFOU01JU1NJT05fTU9ERV84
SzsKIAkJYy0+Z3VhcmRfaW50ZXJ2YWwgPSBHVUFSRF9JTlRFUlZBTF8xXzg7CiAJCWMtPmludmVy
c2lvbiA9IDA7CkBAIC0yNTgzLDcgKzI1ODUsOCBAQCBzdGF0aWMgaW50IGRpYjgwMDBfYXV0b3Nl
YXJjaF9pcnEoc3RydWN0IGR2Yl9mcm9udGVuZCAqZmUpCiAJc3RydWN0IGRpYjgwMDBfc3RhdGUg
KnN0YXRlID0gZmUtPmRlbW9kdWxhdG9yX3ByaXY7CiAJdTE2IGlycV9wZW5kaW5nID0gZGliODAw
MF9yZWFkX3dvcmQoc3RhdGUsIDEyODQpOwogCi0JaWYgKHN0YXRlLT5hdXRvc2VhcmNoX3N0YXRl
ID09IEFTX1NFQVJDSElOR19GRlQpIHsKKwlpZiAoKHN0YXRlLT5yZXZpc2lvbiA+PSAweDgwMDIp
ICYmCisJICAgIChzdGF0ZS0+YXV0b3NlYXJjaF9zdGF0ZSA9PSBBU19TRUFSQ0hJTkdfRkZUKSkg
ewogCQlpZiAoaXJxX3BlbmRpbmcgJiAweDEpIHsKIAkJCWRwcmludGsoImRpYjgwMDBfYXV0b3Nl
YXJjaF9pcnE6IG1heCBjb3JyZWxhdGlvbiByZXN1bHQgYXZhaWxhYmxlIik7CiAJCQlyZXR1cm4g
MzsK
--089e0129508856604104de2ed5d2--
