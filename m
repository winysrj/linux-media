Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m2QJer6m013335
	for <video4linux-list@redhat.com>; Wed, 26 Mar 2008 15:40:53 -0400
Received: from cinke.fazekas.hu (cinke.fazekas.hu [195.199.244.225])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m2QJeg4i022130
	for <video4linux-list@redhat.com>; Wed, 26 Mar 2008 15:40:43 -0400
Date: Wed, 26 Mar 2008 20:40:31 +0100 (CET)
From: Balint Marton <cus@fazekas.hu>
To: Peter =?ISO-8859-1?Q?V=E1gner?= <peter.v@datagate.sk>
In-Reply-To: <1206553154.7076.4.camel@vb>
Message-ID: <Pine.LNX.4.64.0803262037560.9392@cinke.fazekas.hu>
References: <patchbomb.1206497254@bluegene.athome>
	<47E9F4F4.2050503@datagate.sk>
	<Pine.LNX.4.64.0803261520340.14189@cinke.fazekas.hu>
	<1206553154.7076.4.camel@vb>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-943463948-482507265-1206560345=:9392"
Content-ID: <Pine.LNX.4.64.0803262039470.9392@cinke.fazekas.hu>
Cc: video4linux-list@redhat.com
Subject: Re: [PATCH 0 of 3] cx88: fix oops on rmmod and implement stereo
 detection
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---943463948-482507265-1206560345=:9392
Content-Type: TEXT/PLAIN; CHARSET=US-ASCII
Content-ID: <Pine.LNX.4.64.0803262039471.9392@cinke.fazekas.hu>

> I am just wondering might there be a way to fix also this
> issue? Sometimes it works even at startup of the player but more
> frequently it does not.
Try the attached patch. It disables the audio thread completely.

Regards,
  Marton
---943463948-482507265-1206560345=:9392
Content-Type: TEXT/X-PATCH; CHARSET=US-ASCII;
	NAME=cx88-disable-audio-thread.patch
Content-Transfer-Encoding: BASE64
Content-ID: <Pine.LNX.4.64.0803262039050.9392@cinke.fazekas.hu>
Content-Description: 
Content-Disposition: ATTACHMENT; FILENAME=cx88-disable-audio-thread.patch

ZGlmZiAtciAxZmFiZTliMTlmMGMgbGludXgvZHJpdmVycy9tZWRpYS92aWRl
by9jeDg4L2N4ODgtdmlkZW8uYw0KLS0tIGEvbGludXgvZHJpdmVycy9tZWRp
YS92aWRlby9jeDg4L2N4ODgtdmlkZW8uYwlXZWQgTWFyIDI2IDAwOjUwOjE4
IDIwMDggKzAxMDANCisrKyBiL2xpbnV4L2RyaXZlcnMvbWVkaWEvdmlkZW8v
Y3g4OC9jeDg4LXZpZGVvLmMJV2VkIE1hciAyNiAyMDoyOTo1MiAyMDA4ICsw
MTAwDQpAQCAtMjE4MSw2ICsyMTgxLDcgQEAgc3RhdGljIGludCBfX2Rldmlu
aXQgY3g4ODAwX2luaXRkZXYoc3RydQ0KIAljeDg4X3ZpZGVvX211eChjb3Jl
LDApOw0KIAltdXRleF91bmxvY2soJmNvcmUtPmxvY2spOw0KIA0KKyNpZiAw
DQogCS8qIHN0YXJ0IHR2YXVkaW8gdGhyZWFkICovDQogI2lmIExJTlVYX1ZF
UlNJT05fQ09ERSA+PSBLRVJORUxfVkVSU0lPTigyLDUsMCkNCiAJaWYgKGNv
cmUtPmJvYXJkLnR1bmVyX3R5cGUgIT0gVFVORVJfQUJTRU5UKSB7DQpAQCAt
MjE5OCw2ICsyMTk5LDcgQEAgc3RhdGljIGludCBfX2RldmluaXQgY3g4ODAw
X2luaXRkZXYoc3RydQ0KIA0KIAljb3JlLT5rdGhyZWFkID0gTlVMTDsNCiAj
ZW5kaWYNCisjZW5kaWYNCiAJcmV0dXJuIDA7DQogDQogZmFpbF91bnJlZzoN
Cg==

---943463948-482507265-1206560345=:9392
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
---943463948-482507265-1206560345=:9392--
