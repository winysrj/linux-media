Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-io0-f176.google.com ([209.85.223.176]:36317 "EHLO
        mail-io0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932750AbeAHTvG (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 8 Jan 2018 14:51:06 -0500
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.44L0.1801081354450.1908-100000@iolanthe.rowland.org>
References: <CA+55aFx90oOU-3R8pCeM0ESTDYhmugD5znA9LrGj1zhazWBtcg@mail.gmail.com>
 <Pine.LNX.4.44L0.1801081354450.1908-100000@iolanthe.rowland.org>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 8 Jan 2018 11:51:04 -0800
Message-ID: <CA+55aFwuAojr7vAfiRO-2je-wDs7pu+avQZNhX_k9NN=D7_zVQ@mail.gmail.com>
Subject: Re: dvb usb issues since kernel 4.9
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Ingo Molnar <mingo@kernel.org>,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Josef Griebichler <griebichler.josef@gmx.at>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        USB list <linux-usb@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Rik van Riel <riel@redhat.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Hannes Frederic Sowa <hannes@redhat.com>,
        Jesper Dangaard Brouer <jbrouer@redhat.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        LMML <linux-media@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        David Miller <davem@davemloft.net>
Content-Type: multipart/mixed; boundary="001a114491985d43a20562491e47"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--001a114491985d43a20562491e47
Content-Type: text/plain; charset="UTF-8"

On Mon, Jan 8, 2018 at 11:15 AM, Alan Stern <stern@rowland.harvard.edu> wrote:
>
> Both dwc2_hsotg and ehci-hcd use the tasklets embedded in the
> giveback_urb_bh member of struct usb_hcd.  See usb_hcd_giveback_urb()
> in drivers/usb/core/hcd.c; the calls are
>
>         else if (high_prio_bh)
>                 tasklet_hi_schedule(&bh->bh);
>         else
>                 tasklet_schedule(&bh->bh);
>
> As it turns out, high_prio_bh gets set for interrupt and isochronous
> URBs but not for bulk and control URBs.  The DVB driver in question
> uses bulk transfers.

Ok, so we could try out something like the appended?

NOTE! I have not tested this at all. It LooksObvious(tm), but...

                    Linus

--001a114491985d43a20562491e47
Content-Type: text/plain; charset="US-ASCII"; name="patch.diff"
Content-Disposition: attachment; filename="patch.diff"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_jc6mgxpr0

IGtlcm5lbC9zb2Z0aXJxLmMgfCAxMiArKysrKysrKy0tLS0KIDEgZmlsZSBjaGFuZ2VkLCA4IGlu
c2VydGlvbnMoKyksIDQgZGVsZXRpb25zKC0pCgpkaWZmIC0tZ2l0IGEva2VybmVsL3NvZnRpcnEu
YyBiL2tlcm5lbC9zb2Z0aXJxLmMKaW5kZXggMmY1ZTg3ZjFiYWUyLi45N2IwODA5NTZmZWEgMTAw
NjQ0Ci0tLSBhL2tlcm5lbC9zb2Z0aXJxLmMKKysrIGIva2VybmVsL3NvZnRpcnEuYwpAQCAtNzks
MTIgKzc5LDE2IEBAIHN0YXRpYyB2b2lkIHdha2V1cF9zb2Z0aXJxZCh2b2lkKQogCiAvKgogICog
SWYga3NvZnRpcnFkIGlzIHNjaGVkdWxlZCwgd2UgZG8gbm90IHdhbnQgdG8gcHJvY2VzcyBwZW5k
aW5nIHNvZnRpcnFzCi0gKiByaWdodCBub3cuIExldCBrc29mdGlycWQgaGFuZGxlIHRoaXMgYXQg
aXRzIG93biByYXRlLCB0byBnZXQgZmFpcm5lc3MuCisgKiByaWdodCBub3cuIExldCBrc29mdGly
cWQgaGFuZGxlIHRoaXMgYXQgaXRzIG93biByYXRlLCB0byBnZXQgZmFpcm5lc3MsCisgKiB1bmxl
c3Mgd2UncmUgZG9pbmcgc29tZSBvZiB0aGUgc3luY2hyb25vdXMgc29mdGlycXMuCiAgKi8KLXN0
YXRpYyBib29sIGtzb2Z0aXJxZF9ydW5uaW5nKHZvaWQpCisjZGVmaW5lIFNPRlRJUlFfTk9XX01B
U0sgKCgxIDw8IEhJX1NPRlRJUlEpIHwgKDEgPDwgVEFTS0xFVF9TT0ZUSVJRKSkKK3N0YXRpYyBi
b29sIGtzb2Z0aXJxZF9ydW5uaW5nKHVuc2lnbmVkIGxvbmcgcGVuZGluZykKIHsKIAlzdHJ1Y3Qg
dGFza19zdHJ1Y3QgKnRzayA9IF9fdGhpc19jcHVfcmVhZChrc29mdGlycWQpOwogCisJaWYgKHBl
bmRpbmcgJiBTT0ZUSVJRX05PV19NQVNLKQorCQlyZXR1cm4gZmFsc2U7CiAJcmV0dXJuIHRzayAm
JiAodHNrLT5zdGF0ZSA9PSBUQVNLX1JVTk5JTkcpOwogfQogCkBAIC0zMjUsNyArMzI5LDcgQEAg
YXNtbGlua2FnZSBfX3Zpc2libGUgdm9pZCBkb19zb2Z0aXJxKHZvaWQpCiAKIAlwZW5kaW5nID0g
bG9jYWxfc29mdGlycV9wZW5kaW5nKCk7CiAKLQlpZiAocGVuZGluZyAmJiAha3NvZnRpcnFkX3J1
bm5pbmcoKSkKKwlpZiAocGVuZGluZyAmJiAha3NvZnRpcnFkX3J1bm5pbmcocGVuZGluZykpCiAJ
CWRvX3NvZnRpcnFfb3duX3N0YWNrKCk7CiAKIAlsb2NhbF9pcnFfcmVzdG9yZShmbGFncyk7CkBA
IC0zNTIsNyArMzU2LDcgQEAgdm9pZCBpcnFfZW50ZXIodm9pZCkKIAogc3RhdGljIGlubGluZSB2
b2lkIGludm9rZV9zb2Z0aXJxKHZvaWQpCiB7Ci0JaWYgKGtzb2Z0aXJxZF9ydW5uaW5nKCkpCisJ
aWYgKGtzb2Z0aXJxZF9ydW5uaW5nKGxvY2FsX3NvZnRpcnFfcGVuZGluZygpKSkKIAkJcmV0dXJu
OwogCiAJaWYgKCFmb3JjZV9pcnF0aHJlYWRzKSB7Cg==
--001a114491985d43a20562491e47--
