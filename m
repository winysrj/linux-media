Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail7.sea5.speakeasy.net ([69.17.117.9]:36823 "EHLO
	mail7.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754924AbZFLTb2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 12 Jun 2009 15:31:28 -0400
Date: Fri, 12 Jun 2009 12:31:29 -0700 (PDT)
From: Trent Piepho <xyzzy@speakeasy.org>
To: Randy Dunlap <randy.dunlap@oracle.com>
cc: Stephen Rothwell <sfr@canb.auug.org.au>,
	linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	linux-media@vger.kernel.org
Subject: Re: [PATCH -next] v4l: expose function outside of ifdef/endif block
In-Reply-To: <4A32A2CE.40002@oracle.com>
Message-ID: <Pine.LNX.4.58.0906121220520.32713@shell2.speakeasy.net>
References: <20090612185601.be53b034.sfr@canb.auug.org.au> <4A32A2CE.40002@oracle.com>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="289735540-2083449865-1244835089=:32713"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.
  Send mail to mime@docserver.cac.washington.edu for more info.

--289735540-2083449865-1244835089=:32713
Content-Type: TEXT/PLAIN; charset=US-ASCII

On Fri, 12 Jun 2009, Randy Dunlap wrote:
> From: Randy Dunlap <randy.dunlap@oracle.com>
>
> Move v4l_bound_align_image() outside of an #ifdef CONFIG_I2C block
> so that it is always built.  Fixes a build error:

clamp_align() should be moved as well, since it's only used by
v4l_bound_align_image().  I'm attaching an alternate version that fixes
this.  Labeled the endif too.

>  drivers/media/video/v4l2-common.c |    3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
>
> --- linux-next-20090612.orig/drivers/media/video/v4l2-common.c
> +++ linux-next-20090612/drivers/media/video/v4l2-common.c
> @@ -915,6 +915,7 @@ const unsigned short *v4l2_i2c_tuner_add
>  	return NULL;
>  }
>  EXPORT_SYMBOL_GPL(v4l2_i2c_tuner_addrs);
> +#endif
>
>  /* Clamp x to be between min and max, aligned to a multiple of 2^align.  min
>   * and max don't have to be aligned, but there must be at least one valid
> @@ -986,5 +987,3 @@ void v4l_bound_align_image(u32 *w, unsig
>  	}
>  }
>  EXPORT_SYMBOL_GPL(v4l_bound_align_image);
> -
> -#endif
--289735540-2083449865-1244835089=:32713
Content-Type: TEXT/PLAIN; charset=US-ASCII; name="tmp.patch"
Content-Transfer-Encoding: BASE64
Content-ID: <Pine.LNX.4.58.0906121231290.32713@shell2.speakeasy.net>
Content-Description: 
Content-Disposition: attachment; filename="tmp.patch"

IyBIRyBjaGFuZ2VzZXQgcGF0Y2gNCiMgVXNlciBUcmVudCBQaWVwaG8gPHh5
enp5QHNwZWFrZWFzeS5vcmc+DQojIERhdGUgMTI0NDgzNDk1OCAyNTIwMA0K
IyBOb2RlIElEIDIzYmQ2NTE2ZWFmY2MwNmZmYjU5MDA3M2U3NDRjN2UxNzM4
MmFlZjkNCiMgUGFyZW50ICAwMWZkNGUzYmQxYzBmYjUyY2IxNWFjYmQyMmNh
N2Y0ODU3MTcwZTZlDQp2NGwyOiBNb3ZlIGJvdW5kaW5nIGNvZGUgb3V0c2lk
ZSBJMkMgaWZkZWYgYmxvY2sNCg0KRnJvbTogVHJlbnQgUGllcGhvIDx4eXp6
eUBzcGVha2Vhc3kub3JnPg0KDQpNb3ZlIHY0bF9ib3VuZF9hbGlnbl9pbWFn
ZSgpIGFuZCBjbGFtcF9hbGlnbigpIG91dHNpZGUgb2YgYW4gaWZkZWYgYmxv
Y2sNCmZvciBJMkMgcmVsYXRlZCBjb2RlLiAgQ2FuIGNhdXNlIGFuIHVuZGVm
aW5lZCByZWZlcmVuY2UgdG8NCmB2NGxfYm91bmRfYWxpZ25faW1hZ2UnIGlm
IEkyQyBpc24ndCBlbmFibGVkLg0KDQpQcmlvcml0eTogaGlnaA0KDQpTaWdu
ZWQtb2ZmLWJ5OiBUcmVudCBQaWVwaG8gPHh5enp5QHNwZWFrZWFzeS5vcmc+
DQpSZXBvcnRlZC1ieTogUmFuZHkgRHVubGFwIDxyYW5keS5kdW5sYXBAb3Jh
Y2xlLmNvbT4NCg0KZGlmZiAtciAwMWZkNGUzYmQxYzAgLXIgMjNiZDY1MTZl
YWZjIGxpbnV4L2RyaXZlcnMvbWVkaWEvdmlkZW8vdjRsMi1jb21tb24uYw0K
LS0tIGEvbGludXgvZHJpdmVycy9tZWRpYS92aWRlby92NGwyLWNvbW1vbi5j
CVRodSBKdW4gMTEgMTU6MzE6MjIgMjAwOSAtMDcwMA0KKysrIGIvbGludXgv
ZHJpdmVycy9tZWRpYS92aWRlby92NGwyLWNvbW1vbi5jCUZyaSBKdW4gMTIg
MTI6Mjk6MTggMjAwOSAtMDcwMA0KQEAgLTk5Nyw2ICs5OTcsOCBAQCBjb25z
dCB1bnNpZ25lZCBzaG9ydCAqdjRsMl9pMmNfdHVuZXJfYWRkDQogfQ0KIEVY
UE9SVF9TWU1CT0xfR1BMKHY0bDJfaTJjX3R1bmVyX2FkZHJzKTsNCiANCisj
ZW5kaWYgLyogZGVmaW5lZChDT05GSUdfSTJDKSAqLw0KKw0KIC8qIENsYW1w
IHggdG8gYmUgYmV0d2VlbiBtaW4gYW5kIG1heCwgYWxpZ25lZCB0byBhIG11
bHRpcGxlIG9mIDJeYWxpZ24uICBtaW4NCiAgKiBhbmQgbWF4IGRvbid0IGhh
dmUgdG8gYmUgYWxpZ25lZCwgYnV0IHRoZXJlIG11c3QgYmUgYXQgbGVhc3Qg
b25lIHZhbGlkDQogICogdmFsdWUuICBFLmcuLCBtaW49MTcsbWF4PTMxLGFs
aWduPTQgaXMgbm90IGFsbG93ZWQgYXMgdGhlcmUgYXJlIG5vIG11bHRpcGxl
cw0KQEAgLTEwNjcsNSArMTA2OSwzIEBAIHZvaWQgdjRsX2JvdW5kX2FsaWdu
X2ltYWdlKHUzMiAqdywgdW5zaWcNCiAJfQ0KIH0NCiBFWFBPUlRfU1lNQk9M
X0dQTCh2NGxfYm91bmRfYWxpZ25faW1hZ2UpOw0KLQ0KLSNlbmRpZg0K

--289735540-2083449865-1244835089=:32713--
