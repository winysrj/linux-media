Return-path: <mchehab@pedra>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:42357 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752060Ab1AHBCz (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 7 Jan 2011 20:02:55 -0500
Received: by gyb11 with SMTP id 11so6772151gyb.19
        for <linux-media@vger.kernel.org>; Fri, 07 Jan 2011 17:02:54 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <201101072206.30323.hverkuil@xs4all.nl>
References: <201101072053.37211@orion.escape-edv.de>
	<AANLkTinj2NcOcVUPifsNcvbs=Mivwe89+hg8XLsCJnQ7@mail.gmail.com>
	<201101072206.30323.hverkuil@xs4all.nl>
Date: Sat, 8 Jan 2011 12:02:54 +1100
Message-ID: <AANLkTik0-n-KBrTQa4kjahLXyqLagMp+A77zcV3hVAx5@mail.gmail.com>
Subject: Re: Debug code in HG repositories
From: Vincent McIntyre <vincent.mcintyre@gmail.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Devin Heitmueller <dheitmueller@kernellabs.com>,
	linux-media@vger.kernel.org
Content-Type: multipart/mixed; boundary=0015174c3bc277657c04994b4b20
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

--0015174c3bc277657c04994b4b20
Content-Type: text/plain; charset=ISO-8859-1

On 1/8/11, Hans Verkuil <hverkuil@xs4all.nl> wrote:

> Have you tried Mauro's media_build tree? I had to use it today to test a
> driver from git on a 2.6.35 kernel. Works quite nicely. Perhaps we should
> promote this more. I could add backwards compatibility builds to my daily
> build script that uses this in order to check for which kernel versions
> this compiles if there is sufficient interest.
>

As an end-user I would be interested in seeing this added, since it
will allow faster detection of breakage in the older versions. For
instance building against 2.6.32 fails like this:

  CC [M]  /home/vjm/git/clones/linuxtv.org/new_build/v4l/hdpvr-i2c.o
/home/vjm/git/clones/linuxtv.org/new_build/v4l/hdpvr-i2c.c: In
function 'hdpvr_new_i2c_ir':
/home/vjm/git/clones/linuxtv.org/new_build/v4l/hdpvr-i2c.c:62: error:
too many arguments to function 'i2c_new_probed_device'
make[4]: *** [/home/vjm/git/clones/linuxtv.org/new_build/v4l/hdpvr-i2c.o]
Error 1
make[3]: *** [_module_/home/vjm/git/clones/linuxtv.org/new_build/v4l] Error 2
make[3]: Leaving directory `/usr/src/linux-headers-2.6.32-26-ec297b-generic'
make[2]: *** [default] Error 2
make[2]: Leaving directory `/home/vjm/git/clones/linuxtv.org/new_build/v4l'
make[1]: *** [all] Error 2
make[1]: Leaving directory `/home/vjm/git/clones/linuxtv.org/new_build'
make: *** [default] Error 2

It's unclear that adding this would cause a lot of extra work; the
patches that need to be applied are quite few - a tribute to the
design work!

For what it's worth, I've attached the shell script I use to pull
updates and do a new build.
Doing the initial setup is well explained by the
linuxtv.org/media_tree.git page,
but this script may be of use to end users wanting to track development.

Cheers
Vince

--0015174c3bc277657c04994b4b20
Content-Type: application/x-sh; name="update-and-build.sh"
Content-Disposition: attachment; filename="update-and-build.sh"
Content-Transfer-Encoding: base64
X-Attachment-Id: file0

IyEvYmluL3NoCiMKIyBidWlsZCBsYXRlc3QgdjRsIG1vZHVsZXMuCiMgQXV0aG9yOiB2aW5jZW50
Lm1jaW50eXJlQGdtYWlsLmNvbQojIExpY2Vuc2U6IEdQTDIrCiMKIyBDb25maWcgLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLQojTG9jYXRpb24gb2YgbGludXgtbWVkaWEgYW5kIG5ld19idWlsZCBjbG9uZXMKVE9QPS9o
b21lL21lL2dpdC9jbG9uZXMvbGludXh0di5vcmcKVkVSQk9TRT0xCgojIEludGVybmFsIGNvbmZp
ZyAtLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tCkRFQlVHPTAKSU5TVEFMTD0wCgojIE1haW4gLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tCkxPR0ZJTEU9
YnVpbGQuYGRhdGUgKyVZJW0lZFQlSCVNJVNgLmxvZwplY2hvICJMb2dnaW5nIHRvICckTE9HRklM
RSciCmVjaG8gIlRoZSBidWlsZCBjb3VsZCB0YWtlIHNvbWUgdGltZS4uLiIKZWNobyAiVXNlICd0
YWlsIC1mICRMT0dGSUxFJyB0byBmb2xsb3cgcHJvZ3Jlc3MiCmV4ZWMgMT4gJExPR0ZJTEUgMj4m
MQplY2hvICIKVGhpcyBpcyAnJDAnCmNhbGxlZCBvbiBgZGF0ZWAKZnJvbSBgcHdkYAp3aXRoIGFy
Z3VtZW50cyAnJEAnCiIKCndoaWxlIHRlc3QgJCMgLWd0ICAwCmRvCiAgICBjYXNlICQxIGluCiAg
ICAgIC1baUldKikgSU5TVEFMTD0xOyBlY2hvICJNb2R1bGVzIHdpbGwgYmUgSU5TVEFMTGVkIgog
ICAgICA7OwogICAgICAtW2REXSopIERFQlVHPTE7IGVjaG8gIkRFQlVHIG9uIgogICAgICA7Owog
ICAgICAtW3ZWXSopIFZFUkJPU0U9MTsgZWNobyAiVkVSQk9TRSBvbiIKICAgICAgOzsKICAgIGVz
YWMKZG9uZQoKdGVzdCAiMSIgPSAiJERFQlVHIiAmJiBzZXQgLXgKY2QgIiRUT1AiIHx8IGV4aXQg
MQoKZWNobyB1cGRhdGUgdGhlIHY0bCB0cmVlIGZpcnN0CmNkIHY0bC1kdmIKaWYgdGVzdCAiMSIg
PSAiJFZFUkJPU0UiIDsgdGhlbgogICAgZWNobyAiTm93IGluIGBwd2RgIgogICAgIyBsaXN0IGFs
bCBicmFuY2hlcwogICAgZ2l0IGJyYW5jaCAtYQogICAgIyBsaXN0IHJlbW90ZXMKICAgIGdpdCBy
ZW1vdGUgLXYgc2hvdwpmaQpnaXQgY2hlY2tvdXQgbWVkaWEtbWFzdGVyCmdpdCByZXNldCAtLWhh
cmQKZ2l0IGNsZWFuIC1mIC1kCmdpdCBwdWxsIC4gcmVtb3Rlcy9saW51eHR2L3N0YWdpbmcvZm9y
X3YyLjYuMzgKIyBzaG93IGxhc3QgbG9nIGVudHJ5CnRlc3QgIjEiID0gIiRWRVJCT1NFIiAmJiBn
aXQgbG9nIC0xCgplY2hvICIiCmVjaG8gIk5vdyB1cGRhdGUgdGhlIG5ld19idWlsZCIKY2QgLi4v
bmV3X2J1aWxkCmlmIHRlc3QgIjEiID0gIiRWRVJCT1NFIiA7IHRoZW4KICAgIGVjaG8gIk5vdyBp
biBgcHdkYCIKICAgIGdpdCBicmFuY2ggLWEKICAgIGdpdCByZW1vdGUgLXYgc2hvdwpmaQpnaXQg
Y2hlY2tvdXQgbWFzdGVyCmdpdCByZXNldCAtLWhhcmQKZ2l0IGNsZWFuIC1mIC1kCmdpdCBwdWxs
IC11CiMgc2hvdyBsYXN0IGxvZyBlbnRyeQp0ZXN0ICIxIiA9ICIkVkVSQk9TRSIgJiYgZ2l0IGxv
ZyAtMQpjZCBsaW51eAoKZWNobyAiIgplY2hvICJDbGVhbiB1cCIKbWFrZSBjbGVhbjsgbWFrZSBk
aXN0Y2xlYW4KCmVjaG8gIiIKZWNobyAiU3RhcnQgYnVpbGQiCm1ha2UgdGFyIERJUj0vaG9tZS92
am0vZ2l0L2Nsb25lcy9saW51eHR2Lm9yZy92NGwtZHZiCm1ha2UgdW50YXIKCiMgY2FsbCBtYWtl
IHRvIGNyZWF0ZSB2NGwvLmNvbmZpZ3VyZQptYWtlCiN2aSAuLi92NGwvLmNvbmZpZyAjdHVybiBv
ZmYgRklSRURUVgpzZWQgLWkgLWUgJ3MvQ09ORklHX0RWQl9GSVJFRFRWPW0vQ09ORklHX0RWQl9G
SVJFRFRWPW4vJyAuLi92NGwvLmNvbmZpZwoKbWFrZQoKaWYgdGVzdCAiMSIgPSAiJElOU1RBTEwi
IDsgdGhlbgogICAgbWFrZSBpbnN0YWxsCmVsc2UKICAgIGVjaG8gIiBTSU1VTEFUSU5HIG1vZHVs
ZSBpbnN0YWxsIgogICAgbWFrZSAtbiBpbnN0YWxsCmZpCgpleGl0Cg==
--0015174c3bc277657c04994b4b20--
