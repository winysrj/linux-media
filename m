Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx2.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m8C7WVcF019666
	for <video4linux-list@redhat.com>; Fri, 12 Sep 2008 03:32:31 -0400
Received: from an-out-0708.google.com (an-out-0708.google.com [209.85.132.249])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m8C7UXCl024499
	for <video4linux-list@redhat.com>; Fri, 12 Sep 2008 03:30:33 -0400
Received: by an-out-0708.google.com with SMTP id d31so98509and.124
	for <video4linux-list@redhat.com>; Fri, 12 Sep 2008 00:30:33 -0700 (PDT)
Message-ID: <3192d3cd0809120030u781d25cfm49afefb40f01d060@mail.gmail.com>
Date: Fri, 12 Sep 2008 07:30:33 +0000
From: "Christian Gmeiner" <christian.gmeiner@gmail.com>
To: "Linux and Kernel Video" <video4linux-list@redhat.com>
In-Reply-To: <3192d3cd0809120003q11367eb1if685b033b4f4d070@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----=_Part_131054_5876490.1221204633392"
References: <3192d3cd0809120003q11367eb1if685b033b4f4d070@mail.gmail.com>
Subject: Re: [PATCH] Clean up adv7175 driver
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

------=_Part_131054_5876490.1221204633392
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Upps... missed patch file.

2008/9/12 Christian Gmeiner <christian.gmeiner@gmail.com>:
> This patch removes some not needed includes and also removes some not supported
> variables from struct adv7175.
>
> Signed-off-by: Christian Gmeiner <christian.gmeiner@gmail.com>
>
> --
> Christian Gmeiner, B.Sc.
>



-- 
Christian Gmeiner, B.Sc.

------=_Part_131054_5876490.1221204633392
Content-Type: application/octet-stream; name=adv7175_cleanup.patch
Content-Transfer-Encoding: base64
X-Attachment-Id: f_fl0luxb90
Content-Disposition: attachment; filename=adv7175_cleanup.patch

ZGlmZiAtciBlNWNhNDUzNGI1NDMgbGludXgvZHJpdmVycy9tZWRpYS92aWRlby9hZHY3MTc1LmMK
LS0tIGEvbGludXgvZHJpdmVycy9tZWRpYS92aWRlby9hZHY3MTc1LmMJVHVlIFNlcCAwOSAwODoy
OTo1NiAyMDA4IC0wNzAwCisrKyBiL2xpbnV4L2RyaXZlcnMvbWVkaWEvdmlkZW8vYWR2NzE3NS5j
CUZyaSBTZXAgMTIgMDg6NTg6MDYgMjAwOCArMDAwMApAQCAtMjQsMjMgKzI0LDcgQEAKICAqIEZv
dW5kYXRpb24sIEluYy4sIDY3NSBNYXNzIEF2ZSwgQ2FtYnJpZGdlLCBNQSAwMjEzOSwgVVNBLgog
ICovCiAKLSNpbmNsdWRlIDxsaW51eC9tb2R1bGUuaD4KLSNpbmNsdWRlIDxsaW51eC9pbml0Lmg+
Ci0jaW5jbHVkZSA8bGludXgvZGVsYXkuaD4KLSNpbmNsdWRlIDxsaW51eC9lcnJuby5oPgotI2lu
Y2x1ZGUgPGxpbnV4L2ZzLmg+Ci0jaW5jbHVkZSA8bGludXgva2VybmVsLmg+Ci0jaW5jbHVkZSA8
bGludXgvbWFqb3IuaD4KLSNpbmNsdWRlIDxsaW51eC9zbGFiLmg+Ci0jaW5jbHVkZSA8bGludXgv
bW0uaD4KLSNpbmNsdWRlIDxsaW51eC9zaWduYWwuaD4KLSNpbmNsdWRlIDxsaW51eC90eXBlcy5o
PgogI2luY2x1ZGUgPGxpbnV4L2kyYy5oPgotI2luY2x1ZGUgPGFzbS9pby5oPgotI2luY2x1ZGUg
PGFzbS9wZ3RhYmxlLmg+Ci0jaW5jbHVkZSA8YXNtL3BhZ2UuaD4KLSNpbmNsdWRlIDxhc20vdWFj
Y2Vzcy5oPgotCiAjaW5jbHVkZSA8bGludXgvdmlkZW9kZXYuaD4KICNpbmNsdWRlIDxsaW51eC92
aWRlb19lbmNvZGVyLmg+CiAjaW5jbHVkZSAiY29tcGF0LmgiCkBAIC02OSwxMCArNTMsNiBAQAog
CWludCBub3JtOwogCWludCBpbnB1dDsKIAlpbnQgZW5hYmxlOwotCWludCBicmlnaHQ7Ci0JaW50
IGNvbnRyYXN0OwotCWludCBodWU7Ci0JaW50IHNhdDsKIH07CiAKICNkZWZpbmUgICBJMkNfQURW
NzE3NSAgICAgICAgMHhkNAo=
------=_Part_131054_5876490.1221204633392
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
------=_Part_131054_5876490.1221204633392--
