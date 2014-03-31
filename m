Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ve0-f172.google.com ([209.85.128.172]:44972 "EHLO
	mail-ve0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752640AbaCaRSA (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 31 Mar 2014 13:18:00 -0400
MIME-Version: 1.0
In-Reply-To: <53391E67.2000306@xs4all.nl>
References: <53242AC7.9080301@xs4all.nl>
	<53391E67.2000306@xs4all.nl>
Date: Mon, 31 Mar 2014 10:17:59 -0700
Message-ID: <CA+55aFzs_O780hEowt9vg69-Kxfwzn5j1eL2F2Tzw4C56koeRg@mail.gmail.com>
Subject: Re: sparse and anonymous unions
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Hans Verkuil <hverkuil@xs4all.nl>, Chris Li <sparse@chrisli.org>
Cc: Sparse Mailing-list <linux-sparse@vger.kernel.org>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: multipart/mixed; boundary=047d7bb04396b4185c04f5ea3b3f
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--047d7bb04396b4185c04f5ea3b3f
Content-Type: text/plain; charset=UTF-8

On Mon, Mar 31, 2014 at 12:51 AM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
>
> Here is a simple test case for this problem:
>
> ====== anon-union.c ======
> struct s {
>         union {
>                 int val;
>         };
> };
>
> static struct s foo = { .val = 5, };

Ok, this fixes the warning, but we seem to still mess up the actual
initializer. It looks like some later phase gets the offset wrong, so
when we lay things out in memory, we'll put things at offset zero
(which is right for your test-case, but not if there was something
before that anonymous union).

Regardless, that only matters for real code generation, not for using
sparse as a semantic checker, so this patch is correct and is an
improvement.

Chris, mind applying this one too? It removes more lines than it adds
while fixing things, by removing the helper function that isn't good
at anoymous unions, and using another one that does this all right..

                  Linus

--047d7bb04396b4185c04f5ea3b3f
Content-Type: text/plain; charset=US-ASCII; name="patch.diff"
Content-Disposition: attachment; filename="patch.diff"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_htg0pfhk0

IGV2YWx1YXRlLmMgfCAxNCArKy0tLS0tLS0tLS0tLQogMSBmaWxlIGNoYW5nZWQsIDIgaW5zZXJ0
aW9ucygrKSwgMTIgZGVsZXRpb25zKC0pCgpkaWZmIC0tZ2l0IGEvZXZhbHVhdGUuYyBiL2V2YWx1
YXRlLmMKaW5kZXggOGE1M2IzZTg4NGUwLi41YWRmYzFlM2ZmMjYgMTAwNjQ0Ci0tLSBhL2V2YWx1
YXRlLmMKKysrIGIvZXZhbHVhdGUuYwpAQCAtMjE3MSwxNyArMjE3MSw2IEBAIHN0YXRpYyBpbnQg
ZXZhbHVhdGVfYXJndW1lbnRzKHN0cnVjdCBzeW1ib2wgKmYsIHN0cnVjdCBzeW1ib2wgKmZuLCBz
dHJ1Y3QgZXhwcmVzCiAJcmV0dXJuIDE7CiB9CiAKLXN0YXRpYyBzdHJ1Y3Qgc3ltYm9sICpmaW5k
X3N0cnVjdF9pZGVudChzdHJ1Y3Qgc3ltYm9sICpjdHlwZSwgc3RydWN0IGlkZW50ICppZGVudCkK
LXsKLQlzdHJ1Y3Qgc3ltYm9sICpzeW07Ci0KLQlGT1JfRUFDSF9QVFIoY3R5cGUtPnN5bWJvbF9s
aXN0LCBzeW0pIHsKLQkJaWYgKHN5bS0+aWRlbnQgPT0gaWRlbnQpCi0JCQlyZXR1cm4gc3ltOwot
CX0gRU5EX0ZPUl9FQUNIX1BUUihzeW0pOwotCXJldHVybiBOVUxMOwotfQotCiBzdGF0aWMgdm9p
ZCBjb252ZXJ0X2luZGV4KHN0cnVjdCBleHByZXNzaW9uICplKQogewogCXN0cnVjdCBleHByZXNz
aW9uICpjaGlsZCA9IGUtPmlkeF9leHByZXNzaW9uOwpAQCAtMjI5MCwxMSArMjI3OSwxMiBAQCBz
dGF0aWMgc3RydWN0IGV4cHJlc3Npb24gKmNoZWNrX2Rlc2lnbmF0b3JzKHN0cnVjdCBleHByZXNz
aW9uICplLAogCQkJfQogCQkJZSA9IGUtPmlkeF9leHByZXNzaW9uOwogCQl9IGVsc2UgaWYgKGUt
PnR5cGUgPT0gRVhQUl9JREVOVElGSUVSKSB7CisJCQlpbnQgb2Zmc2V0ID0gMDsKIAkJCWlmIChj
dHlwZS0+dHlwZSAhPSBTWU1fU1RSVUNUICYmIGN0eXBlLT50eXBlICE9IFNZTV9VTklPTikgewog
CQkJCWVyciA9ICJmaWVsZCBuYW1lIG5vdCBpbiBzdHJ1Y3Qgb3IgdW5pb24iOwogCQkJCWJyZWFr
OwogCQkJfQotCQkJY3R5cGUgPSBmaW5kX3N0cnVjdF9pZGVudChjdHlwZSwgZS0+ZXhwcl9pZGVu
dCk7CisJCQljdHlwZSA9IGZpbmRfaWRlbnRpZmllcihlLT5leHByX2lkZW50LCBjdHlwZS0+c3lt
Ym9sX2xpc3QsICZvZmZzZXQpOwogCQkJaWYgKCFjdHlwZSkgewogCQkJCWVyciA9ICJ1bmtub3du
IGZpZWxkIG5hbWUgaW4iOwogCQkJCWJyZWFrOwo=
--047d7bb04396b4185c04f5ea3b3f--
