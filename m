Return-path: <linux-media-owner@vger.kernel.org>
Received: from claranet-outbound-smtp00.uk.clara.net ([195.8.89.33]:41775 "EHLO
	claranet-outbound-smtp00.uk.clara.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754821AbZICKVs (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 3 Sep 2009 06:21:48 -0400
Message-ID: <4A9F98BA.3010001@onelan.com>
Date: Thu, 03 Sep 2009 11:21:46 +0100
From: Simon Farnsworth <simon.farnsworth@onelan.com>
MIME-Version: 1.0
To: Hans de Goede <j.w.r.degoede@hhs.nl>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: libv4l2 and the Hauppauge HVR1600 (cx18 driver) not working well
 together
References: <4A9E9E08.7090104@onelan.com> <4A9EAF07.3040303@hhs.nl> <4A9F89AD.7030106@onelan.com> <4A9F9006.6020203@hhs.nl>
In-Reply-To: <4A9F9006.6020203@hhs.nl>
Content-Type: multipart/mixed;
 boundary="------------010705080202000803020101"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is a multi-part message in MIME format.
--------------010705080202000803020101
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hans de Goede wrote:
> Ok,
> 
> That was even easier then I thought it would be. Attached is a patch
> (against libv4l-0.6.1), which implements 1) and 3) from above.
> 
I applied it to a clone of your HG repository, and had to make a minor
change to get it to compile. I've attached the updated patch.

It looks like the read() from the card isn't reading entire frames ata a
time - I'm using a piece of test gear that I have to return in a couple
of hours to send colourbars to it, and I'm seeing bad colour, and the
picture moving across the screen. I'll try and chase this, see whether
there's something obviously wrong.

The repository I went against was http://linuxtv.org/hg/~hgoede/libv4l/
identified as:
$ hg identify
c51a90c0f62f+ tip

-- 
Simon Farnsworth


--------------010705080202000803020101
Content-Type: text/plain;
 name="diff"
Content-Transfer-Encoding: base64
Content-Disposition: inline;
 filename="diff"

ZGlmZiAtciBjNTFhOTBjMGY2MmYgdjRsMi1hcHBzL2xpYnY0bC9saWJ2NGwyL2xpYnY0bDIu
YwotLS0gYS92NGwyLWFwcHMvbGlidjRsL2xpYnY0bDIvbGlidjRsMi5jCVR1ZSBTZXAgMDEg
MTA6MDM6MjcgMjAwOSArMDIwMAorKysgYi92NGwyLWFwcHMvbGlidjRsL2xpYnY0bDIvbGli
djRsMi5jCVRodSBTZXAgMDMgMTE6MTc6MDUgMjAwOSArMDEwMApAQCAtNTI2LDEwICs1MjYs
OSBAQAogICAgIHJldHVybiAtMTsKICAgfQogCi0gIC8qIHdlIG9ubHkgYWRkIGZ1bmN0aW9u
YWxpdHkgZm9yIHZpZGVvIGNhcHR1cmUgZGV2aWNlcywgYW5kIHdlIGRvIG5vdAotICAgICBo
YW5kbGUgZGV2aWNlcyB3aGljaCBkb24ndCBkbyBtbWFwICovCisgIC8qIHdlIG9ubHkgYWRk
IGZ1bmN0aW9uYWxpdHkgZm9yIHZpZGVvIGNhcHR1cmUgZGV2aWNlcyAqLwogICBpZiAoIShj
YXAuY2FwYWJpbGl0aWVzICYgVjRMMl9DQVBfVklERU9fQ0FQVFVSRSkgfHwKLSAgICAgICEo
Y2FwLmNhcGFiaWxpdGllcyAmIFY0TDJfQ0FQX1NUUkVBTUlORykpCisgICAgICAhKGNhcC5j
YXBhYmlsaXRpZXMgJiAoVjRMMl9DQVBfU1RSRUFNSU5HfFY0TDJfQ0FQX1JFQURXUklURSkp
KQogICAgIHJldHVybiBmZDsKIAogICAvKiBHZXQgY3VycmVudCBjYW0gZm9ybWF0ICovCkBA
IC01NjQsNiArNTYzLDggQEAKICAgZGV2aWNlc1tpbmRleF0uZmxhZ3MgPSB2NGwyX2ZsYWdz
OwogICBpZiAoY2FwLmNhcGFiaWxpdGllcyAmIFY0TDJfQ0FQX1JFQURXUklURSkKICAgICBk
ZXZpY2VzW2luZGV4XS5mbGFncyB8PSBWNEwyX1NVUFBPUlRTX1JFQUQ7CisgIGlmICghKGNh
cC5jYXBhYmlsaXRpZXMgJiBWNEwyX0NBUF9TVFJFQU1JTkcpKQorICAgIGRldmljZXNbaW5k
ZXhdLmZsYWdzIHw9IFY0TDJfVVNFX1JFQURfRk9SX1JFQUQ7CiAgIGlmICghc3RyY21wKChj
aGFyICopY2FwLmRyaXZlciwgInV2Y3ZpZGVvIikpCiAgICAgZGV2aWNlc1tpbmRleF0uZmxh
Z3MgfD0gVjRMMl9JU19VVkM7CiAgIGRldmljZXNbaW5kZXhdLm9wZW5fY291bnQgPSAxOwpA
QCAtNTcxLDcgKzU3Miw3IEBACiAgIGRldmljZXNbaW5kZXhdLmRlc3RfZm10ID0gZm10Owog
CiAgIC8qIFdoZW4gYSB1c2VyIGRvZXMgYSB0cnlfZm10IHdpdGggdGhlIGN1cnJlbnQgZGVz
dF9mbXQgYW5kIHRoZSBkZXN0X2ZtdAotICAgICBpcyBhIHN1cHBvcnRlZCBvbmUgd2Ugd2ls
bCBhbGlnbiB0aGUgcmVzdWx1dGlvbiAoc2VlIHRyeV9mbXQgZm9yIHdoeSkuCisgICAgIGlz
IGEgc3VwcG9ydGVkIG9uZSB3ZSB3aWxsIGFsaWduIHRoZSByZXNvbHV0aW9uIChzZWUgdHJ5
X2ZtdCBmb3Igd2h5KS4KICAgICAgRG8gdGhlIHNhbWUgaGVyZSBub3csIHNvIHRoYXQgYSB0
cnlfZm10IG9uIHRoZSByZXN1bHQgb2YgYSBnZXRfZm10IGRvbmUKICAgICAgaW1tZWRpYXRl
bHkgYWZ0ZXIgb3BlbiBsZWF2ZXMgdGhlIGZtdCB1bmNoYW5nZWQuICovCiAgIGlmICh2NGxj
b252ZXJ0X3N1cHBvcnRlZF9kc3RfZm9ybWF0KAo=
--------------010705080202000803020101--
