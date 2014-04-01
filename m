Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lb0-f179.google.com ([209.85.217.179]:48932 "EHLO
	mail-lb0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751061AbaDAAES (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 31 Mar 2014 20:04:18 -0400
Received: by mail-lb0-f179.google.com with SMTP id p9so6305990lbv.38
        for <linux-media@vger.kernel.org>; Mon, 31 Mar 2014 17:04:16 -0700 (PDT)
MIME-Version: 1.0
Date: Tue, 1 Apr 2014 10:04:16 +1000
Message-ID: <CAHLDD1NSe9nrWJ2nfXaeBngZ_=aVYU_hTvsFgWez-n2OtVCLGA@mail.gmail.com>
Subject: Lirc codec and starting "space" event
From: Austin Lund <austin.lund@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: multipart/mixed; boundary=14dae94edbd3b07f1c04f5efe815
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--14dae94edbd3b07f1c04f5efe815
Content-Type: text/plain; charset=UTF-8

Hi,

I've been having a problem with a GPIO ir device in an i.mx6 arm
system that I have (cubox-i).

It seems to all work ok, except the output on /dev/lirc0 is not quite
what lircd seems to expect.  Lircd wants a long space before the
starting pulse before processing any output. However, no long space is
sent when I check the output (doing "mode2" and a plain hexdump
/dev/lirc0).

This causes problems in detecting button presses on remotes.
Sometimes it works if you press the buttons quick enough, but after
waiting a while it doesn't work.

I have been looking at the code for a while now, and it seems that it
has something to do with the lirc codec ignoring reset events (just
returns 0).

I've made up this patch, but I'm travelling at the moment and haven't
had a chance to actually test it.

What I'm wondering is if this issue is known, and if my approach is
going down the right path.

The only alternative I could see is to change the way the gpio ir
driver handles events.  It seems to just call ir_raw_event_store_edge
which put a zeroed reset event into the queue.  I'm assuming there are
other users of these functions and that it's probably best not to
fiddle with that if possible.

Thanks.

PS Please CC me as I'm not subscribed.

--14dae94edbd3b07f1c04f5efe815
Content-Type: text/x-patch; charset=US-ASCII;
	name="0001-media-rc-Send-sync-space-information-on-the-lirc-dev.patch"
Content-Disposition: attachment;
	filename="0001-media-rc-Send-sync-space-information-on-the-lirc-dev.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_htgf87ry0

RnJvbSA0OWMwNDFlNmFiN2E5ZDVmY2JlODc4MTdkNWU4MTljMmFlZjZiM2FjIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBBdXN0aW4gTHVuZCA8YXVzdGluLmx1bmRAZ21haWwuY29tPgpE
YXRlOiBNb24sIDMxIE1hciAyMDE0IDE0OjUyOjQ3ICsxMDAwClN1YmplY3Q6IFtQQVRDSF0gbWVk
aWEvcmM6IFNlbmQgc3luYyBzcGFjZSBpbmZvcm1hdGlvbiBvbiB0aGUgbGlyYyBkZXZpY2UuCgpV
c2Vyc3BhY2UgZXhwZWN0cyB0byBzZWUgYSBsb25nIHNwYWNlIGJlZm9yZSB0aGUgZmlyc3QgcHVs
c2UgaXMgc2VudCBvbgp0aGUgbGlyYyBkZXZpY2UuICBDdXJyZW50bHksIGlmIGEgbG9uZyB0aW1l
IGhhcyBwYXNzZWQgYW5kIGEgbmV3IHBhY2tldAppcyBzdGFydGVkLCB0aGUgbGlyYyBjb2RlYyBq
dXN0IHJldHVybnMgYW5kIGRvZXNuJ3Qgc2VuZCBhbnl0aGluZy4gIFRoaXMKbWFrZXMgbGlyY2Qg
aWdub3JlIG1hbnkgcGVyZmVjdGx5IHZhbGlkIHNpZ25hbHMgdW5sZXNzIHRoZXkgYXJlIHNlbnQg
aW4KcXVpY2sgc3VjZXNzaW9uLiAgV2hlbiBhIHJlc2V0IGV2ZW50IGlzIGRlbGl2ZXJlZCwgd2Ug
Y2Fubm90IGtub3cKYW55dGhpbmcgYWJvdXQgdGhlIGR1cmF0aW9uIG9mIHRoZSBzcGFjZS4gIEJ1
dCBpdCBzaG91bGQgYmUgc2FmZSB0bwphc3N1bWUgaXQgaGFzIGJlZW4gYSBsb25nIHRpbWUgYW5k
IHdlIGp1c3Qgc2V0IHRoZSBkdXJhdGlvbiB0byBtYXhpbXVtLgotLS0KIGRyaXZlcnMvbWVkaWEv
cmMvaXItbGlyYy1jb2RlYy5jIHwgMTIgKysrKysrKysrLS0tCiAxIGZpbGUgY2hhbmdlZCwgOSBp
bnNlcnRpb25zKCspLCAzIGRlbGV0aW9ucygtKQoKZGlmZiAtLWdpdCBhL2RyaXZlcnMvbWVkaWEv
cmMvaXItbGlyYy1jb2RlYy5jIGIvZHJpdmVycy9tZWRpYS9yYy9pci1saXJjLWNvZGVjLmMKaW5k
ZXggZTQ1NjEyNi4uYTg5NWVkMCAxMDA2NDQKLS0tIGEvZHJpdmVycy9tZWRpYS9yYy9pci1saXJj
LWNvZGVjLmMKKysrIGIvZHJpdmVycy9tZWRpYS9yYy9pci1saXJjLWNvZGVjLmMKQEAgLTQyLDEx
ICs0MiwxNyBAQCBzdGF0aWMgaW50IGlyX2xpcmNfZGVjb2RlKHN0cnVjdCByY19kZXYgKmRldiwg
c3RydWN0IGlyX3Jhd19ldmVudCBldikKIAkJcmV0dXJuIC1FSU5WQUw7CiAKIAkvKiBQYWNrZXQg
c3RhcnQgKi8KLQlpZiAoZXYucmVzZXQpCi0JCXJldHVybiAwOworCWlmIChldi5yZXNldCkgewor
CQkvKiBVc2Vyc3BhY2UgZXhwZWN0cyBhIGxvbmcgc3BhY2UgZXZlbnQgYmVmb3JlIHRoZSBzdGFy
dCBvZgorCQkgKiB0aGUgc2lnbmFsIHRvIHVzZSBhcyBhIHN5bmMuICBUaGlzIG1heSBiZSBkb25l
IHdpdGggcmVwZWF0CisJCSAqIHBhY2tldHMgYW5kIG5vcm1hbCBzYW1wbGVzLiAgQnV0IGlmIGEg
cmVzZXQgaGFzIGJlZW4gc2VudAorCQkgKiB0aGVuIHdlIGFzc3VtZSB0aGF0IGEgbG9uZyB0aW1l
IGhhcyBwYXNzZWQsIHNvIHdlIHNlbmQgYQorCQkgKiBzcGFjZSB3aXRoIHRoZSBtYXhpbXVtIHRp
bWUgdmFsdWUuICovCisJCXNhbXBsZSA9IExJUkNfU1BBQ0UoTElSQ19WQUxVRV9NQVNLKTsKKwkJ
SVJfZHByaW50aygyLCAiZGVsaXZlcmluZyByZXNldCBzeW5jIHNwYWNlIHRvIGxpcmNfZGV2XG4i
KTsKIAogCS8qIENhcnJpZXIgcmVwb3J0cyAqLwotCWlmIChldi5jYXJyaWVyX3JlcG9ydCkgewor
CX0gZWxzZSBpZiAoZXYuY2Fycmllcl9yZXBvcnQpIHsKIAkJc2FtcGxlID0gTElSQ19GUkVRVUVO
Q1koZXYuY2Fycmllcik7CiAJCUlSX2RwcmludGsoMiwgImNhcnJpZXIgcmVwb3J0IChmcmVxOiAl
ZClcbiIsIHNhbXBsZSk7CiAKLS0gCjEuOS4xCgo=
--14dae94edbd3b07f1c04f5efe815--
