Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f176.google.com ([209.85.128.176]:33856 "EHLO
        mail-wr0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932689AbdE0Bja (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 26 May 2017 21:39:30 -0400
Received: by mail-wr0-f176.google.com with SMTP id j27so9748663wre.1
        for <linux-media@vger.kernel.org>; Fri, 26 May 2017 18:39:29 -0700 (PDT)
MIME-Version: 1.0
From: Vincent McIntyre <vincent.mcintyre@gmail.com>
Date: Sat, 27 May 2017 11:39:27 +1000
Message-ID: <CAEsFdVM2h=pf4vf9Y_2dSSJeAzoj2bFCe5UCOWt9btZy6Pd14g@mail.gmail.com>
Subject: [regression] Build failure on ubuntu 16.04 LTS
To: linux-media@vger.kernel.org
Content-Type: multipart/mixed; boundary="f403045f4e8a522abe055077860b"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--f403045f4e8a522abe055077860b
Content-Type: text/plain; charset="UTF-8"

$ cat /etc/lsb-release
DISTRIB_ID=Ubuntu
DISTRIB_RELEASE=16.04
DISTRIB_CODENAME=xenial
DISTRIB_DESCRIPTION="Ubuntu 16.04.2 LTS"

$ uname -a
Linux testbox 4.8.0-53-generic #56~16.04.1-Ubuntu SMP Tue May 16
01:18:56 UTC 2017 x86_64 x86_64 x86_64 GNU/Linux

$ git remote -v
origin  git://linuxtv.org/media_build.git (fetch)
origin  git://linuxtv.org/media_build.git (push)

$ git log -1
commit c8dfc17d6d049d79497c78737625f6ea3b08c456
Author: Hans Verkuil <hans.verkuil@cisco.com>
Date:   Mon May 22 09:11:11 2017 +0200

    Don't build atomisp crap

    Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>

The attached log file has the failure. This build was done with a
fresh git clone.  I did a quick grep of the tree and the only place I
find cec_devnode_register is in the module that fails to build,
cec-core.c.

Any advice welcome.
Vince

--f403045f4e8a522abe055077860b
Content-Type: text/x-log; charset="US-ASCII"; name="build.log"
Content-Disposition: attachment; filename="build.log"
Content-Transfer-Encoding: base64
X-Attachment-Id: file0

KioqKioqKioqKioqKioqKioqCiogU3RhcnQgYnVpbGRpbmcgKgoqKioqKioqKioqKioqKioqKioK
bWFrZSAtQyAvaG9tZS9tZS9naXQvY2xvbmVzL21lZGlhX2J1aWxkL3Y0bCBhbGx5ZXNjb25maWcK
bWFrZVsxXTogRW50ZXJpbmcgZGlyZWN0b3J5ICcvaG9tZS9tZS9naXQvY2xvbmVzL21lZGlhX2J1
aWxkL3Y0bCcKTm8gdmVyc2lvbiB5ZXQsIHVzaW5nIDQuOC4wLTUzLWdlbmVyaWMKbWFrZVsyXTog
RW50ZXJpbmcgZGlyZWN0b3J5ICcvaG9tZS9tZS9naXQvY2xvbmVzL21lZGlhX2J1aWxkL2xpbnV4
JwpTeW5jaW5nIHdpdGggZGlyIC4uL21lZGlhLwpBcHBseWluZyBwYXRjaGVzIGZvciBrZXJuZWwg
NC44LjAtNTMtZ2VuZXJpYwpwYXRjaCAtcyAtZiAtTiAtcDEgLWkgLi4vYmFja3BvcnRzL2FwaV92
ZXJzaW9uLnBhdGNoCnBhdGNoIC1zIC1mIC1OIC1wMSAtaSAuLi9iYWNrcG9ydHMvcHJfZm10LnBh
dGNoCnBhdGNoIC1zIC1mIC1OIC1wMSAtaSAuLi9iYWNrcG9ydHMvZGVidWcucGF0Y2gKcGF0Y2gg
LXMgLWYgLU4gLXAxIC1pIC4uL2JhY2twb3J0cy9kcngzOXh4ai5wYXRjaApwYXRjaCAtcyAtZiAt
TiAtcDEgLWkgLi4vYmFja3BvcnRzL3Y0LjEwX3NjaGVkX3NpZ25hbC5wYXRjaApwYXRjaCAtcyAt
ZiAtTiAtcDEgLWkgLi4vYmFja3BvcnRzL3Y0LjEwX2ZhdWx0X3BhZ2UucGF0Y2gKcGF0Y2ggLXMg
LWYgLU4gLXAxIC1pIC4uL2JhY2twb3J0cy92NC4xMF9yZWZjb3VudC5wYXRjaApwYXRjaCAtcyAt
ZiAtTiAtcDEgLWkgLi4vYmFja3BvcnRzL3Y0LjlfbW1fYWRkcmVzcy5wYXRjaApwYXRjaCAtcyAt
ZiAtTiAtcDEgLWkgLi4vYmFja3BvcnRzL3Y0LjlfZHZiX25ldF9tYXhfbXR1LnBhdGNoCnBhdGNo
IC1zIC1mIC1OIC1wMSAtaSAuLi9iYWNrcG9ydHMvdjQuOV9rdGltZV9jbGVhbnVwcy5wYXRjaApw
YXRjaCAtcyAtZiAtTiAtcDEgLWkgLi4vYmFja3BvcnRzL3Y0LjhfdXNlcl9wYWdlc19mbGFnLnBh
dGNoClBhdGNoZWQgZHJpdmVycy9tZWRpYS9kdmItY29yZS9kdmJkZXYuYwpQYXRjaGVkIGRyaXZl
cnMvbWVkaWEvdjRsMi1jb3JlL3Y0bDItZGV2LmMKUGF0Y2hlZCBkcml2ZXJzL21lZGlhL3JjL3Jj
LW1haW4uYwpTeW5jaW5nIHdpdGggZGlyIC4uL21lZGlhLwptYWtlWzJdOiBMZWF2aW5nIGRpcmVj
dG9yeSAnL2hvbWUvbWUvZ2l0L2Nsb25lcy9tZWRpYV9idWlsZC9saW51eCcKLi9zY3JpcHRzL21h
a2Vfa2NvbmZpZy5wbCAvbGliL21vZHVsZXMvNC44LjAtNTMtZ2VuZXJpYy9idWlsZCAvbGliL21v
ZHVsZXMvNC44LjAtNTMtZ2VuZXJpYy9idWlsZCAxClByZXBhcmluZyB0byBjb21waWxlIGZvciBr
ZXJuZWwgdmVyc2lvbiA0LjguMAoKKioqV0FSTklORzoqKiogWW91IGRvIG5vdCBoYXZlIHRoZSBm
dWxsIGtlcm5lbCBzb3VyY2VzIGluc3RhbGxlZC4KVGhpcyBkb2VzIG5vdCBwcmV2ZW50IHlvdSBm
cm9tIGJ1aWxkaW5nIHRoZSB2NGwtZHZiIHRyZWUgaWYgeW91IGhhdmUgdGhlCmtlcm5lbCBoZWFk
ZXJzLCBidXQgdGhlIGZ1bGwga2VybmVsIHNvdXJjZSBtYXkgYmUgcmVxdWlyZWQgaW4gb3JkZXIg
dG8gdXNlCm1ha2UgbWVudWNvbmZpZyAvIHhjb25maWcgLyBxY29uZmlnLgoKSWYgeW91IGFyZSBl
eHBlcmllbmNpbmcgcHJvYmxlbXMgYnVpbGRpbmcgdGhlIHY0bC1kdmIgdHJlZSwgcGxlYXNlIHRy
eQpidWlsZGluZyBhZ2FpbnN0IGEgdmFuaWxsYSBrZXJuZWwgYmVmb3JlIHJlcG9ydGluZyBhIGJ1
Zy4KClZhbmlsbGEga2VybmVscyBhcmUgYXZhaWxhYmxlIGF0IGh0dHA6Ly9rZXJuZWwub3JnLgpP
biBtb3N0IGRpc3Ryb3MsIHRoaXMgd2lsbCBjb21waWxlIGEgbmV3bHkgZG93bmxvYWRlZCBrZXJu
ZWw6CgpjcCAvYm9vdC9jb25maWctYHVuYW1lIC1yYCA8eW91ciBrZXJuZWwgZGlyPi8uY29uZmln
CmNkIDx5b3VyIGtlcm5lbCBkaXI+Cm1ha2UgYWxsIG1vZHVsZXNfaW5zdGFsbCBpbnN0YWxsCgpQ
bGVhc2Ugc2VlIHlvdXIgZGlzdHJvJ3Mgd2ViIHNpdGUgZm9yIGluc3RydWN0aW9ucyB0byBidWls
ZCBhIG5ldyBrZXJuZWwuCgpXQVJOSU5HOiBUaGlzIGlzIHRoZSBWNEwvRFZCIGJhY2twb3J0IHRy
ZWUsIHdpdGggZXhwZXJpbWVudGFsIGRyaXZlcnMKICAgICAgICAgYmFja3BvcnRlZCB0byBydW4g
b24gbGVnYWN5IGtlcm5lbHMgZnJvbSB0aGUgZGV2ZWxvcG1lbnQgdHJlZSBhdDoKICAgICAgICAg
ICAgICAgIGh0dHA6Ly9naXQubGludXh0di5vcmcvbWVkaWEtdHJlZS5naXQuCiAgICAgICAgIEl0
IGlzIGdlbmVyYWxseSBzYWZlIHRvIHVzZSBpdCBmb3IgdGVzdGluZyBhIG5ldyBkcml2ZXIgb3IK
ICAgICAgICAgZmVhdHVyZSwgYnV0IGl0cyB1c2FnZSBvbiBwcm9kdWN0aW9uIGVudmlyb25tZW50
cyBpcyByaXNreS4KICAgICAgICAgRG9uJ3QgdXNlIGl0IGluIHByb2R1Y3Rpb24uIFlvdSd2ZSBi
ZWVuIHdhcm5lZC4KSU5URUxfQVRPTUlTUDogUmVxdWlyZXMgYXQgbGVhc3Qga2VybmVsIDkuMjU1
LjI1NQpDcmVhdGVkIGRlZmF1bHQgKGFsbCB5ZXMpIC5jb25maWcgZmlsZQouL3NjcmlwdHMvZml4
X2tjb25maWcucGwKbWFrZVsxXTogTGVhdmluZyBkaXJlY3RvcnkgJy9ob21lL21lL2dpdC9jbG9u
ZXMvbWVkaWFfYnVpbGQvdjRsJwptYWtlIC1DIC9ob21lL21lL2dpdC9jbG9uZXMvbWVkaWFfYnVp
bGQvdjRsIAptYWtlWzFdOiBFbnRlcmluZyBkaXJlY3RvcnkgJy9ob21lL21lL2dpdC9jbG9uZXMv
bWVkaWFfYnVpbGQvdjRsJwpzY3JpcHRzL21ha2VfbWFrZWZpbGUucGwKQ2FuJ3QgaGFuZGxlIGlu
Y2x1ZGVzISBJbiAuLi9saW51eC9kcml2ZXJzL3N0YWdpbmcvbWVkaWEvYXRvbWlzcC9wY2kvYXRv
bWlzcDIvY3NzMjQwMC9NYWtlZmlsZSBhdCBzY3JpcHRzL21ha2VfbWFrZWZpbGUucGwgbGluZSAx
MDksIDxHRU4xNTI+IGxpbmUgNC4KLi9zY3JpcHRzL21ha2VfbXljb25maWcucGwKcGVybCBzY3Jp
cHRzL21ha2VfY29uZmlnX2NvbXBhdC5wbCAvbGliL21vZHVsZXMvNC44LjAtNTMtZ2VuZXJpYy9i
dWlsZCAuLy5teWNvbmZpZyAuL2NvbmZpZy1jb21wYXQuaApjcmVhdGluZyBzeW1ib2xpYyBsaW5r
cy4uLgptYWtlIC1DIGZpcm13YXJlIHByZXAKbWFrZVsyXTogRW50ZXJpbmcgZGlyZWN0b3J5ICcv
aG9tZS9tZS9naXQvY2xvbmVzL21lZGlhX2J1aWxkL3Y0bC9maXJtd2FyZScKbWFrZVsyXTogTGVh
dmluZyBkaXJlY3RvcnkgJy9ob21lL21lL2dpdC9jbG9uZXMvbWVkaWFfYnVpbGQvdjRsL2Zpcm13
YXJlJwptYWtlIC1DIGZpcm13YXJlCm1ha2VbMl06IEVudGVyaW5nIGRpcmVjdG9yeSAnL2hvbWUv
bWUvZ2l0L2Nsb25lcy9tZWRpYV9idWlsZC92NGwvZmlybXdhcmUnCiAgQ0MgIGloZXgyZncKR2Vu
ZXJhdGluZyB2aWNhbS9maXJtd2FyZS5mdwpHZW5lcmF0aW5nIHR0dXNiLWJ1ZGdldC9kc3Bib290
Y29kZS5iaW4KR2VuZXJhdGluZyBjcGlhMi9zdHYwNjcyX3ZwNC5iaW4KR2VuZXJhdGluZyBhdjcx
MTAvYm9vdGNvZGUuYmluCm1ha2VbMl06IExlYXZpbmcgZGlyZWN0b3J5ICcvaG9tZS9tZS9naXQv
Y2xvbmVzL21lZGlhX2J1aWxkL3Y0bC9maXJtd2FyZScKS2VybmVsIGJ1aWxkIGRpcmVjdG9yeSBp
cyAvbGliL21vZHVsZXMvNC44LjAtNTMtZ2VuZXJpYy9idWlsZAptYWtlIC1DIC4uL2xpbnV4IGFw
cGx5X3BhdGNoZXMKbWFrZVsyXTogRW50ZXJpbmcgZGlyZWN0b3J5ICcvaG9tZS9tZS9naXQvY2xv
bmVzL21lZGlhX2J1aWxkL2xpbnV4JwpTeW5jaW5nIHdpdGggZGlyIC4uL21lZGlhLwpQYXRjaGVz
IGZvciA0LjguMC01My1nZW5lcmljIGFscmVhZHkgYXBwbGllZC4KbWFrZVsyXTogTGVhdmluZyBk
aXJlY3RvcnkgJy9ob21lL21lL2dpdC9jbG9uZXMvbWVkaWFfYnVpbGQvbGludXgnCm1ha2UgLUMg
L2xpYi9tb2R1bGVzLzQuOC4wLTUzLWdlbmVyaWMvYnVpbGQgU1VCRElSUz0vaG9tZS9tZS9naXQv
Y2xvbmVzL21lZGlhX2J1aWxkL3Y0bCAgbW9kdWxlcwptYWtlWzJdOiBFbnRlcmluZyBkaXJlY3Rv
cnkgJy91c3Ivc3JjL2xpbnV4LWhlYWRlcnMtNC44LjAtNTMtZ2VuZXJpYycKICBDQyBbTV0gIC9o
b21lL21lL2dpdC9jbG9uZXMvbWVkaWFfYnVpbGQvdjRsL2NlYy1jb3JlLm8KL2hvbWUvbWUvZ2l0
L2Nsb25lcy9tZWRpYV9idWlsZC92NGwvY2VjLWNvcmUuYzogSW4gZnVuY3Rpb24gJ2NlY19kZXZu
b2RlX3JlZ2lzdGVyJzoKL2hvbWUvbWUvZ2l0L2Nsb25lcy9tZWRpYV9idWlsZC92NGwvY2VjLWNv
cmUuYzoxNDI6ODogZXJyb3I6IGltcGxpY2l0IGRlY2xhcmF0aW9uIG9mIGZ1bmN0aW9uICdjZGV2
X2RldmljZV9hZGQnIFstV2Vycm9yPWltcGxpY2l0LWZ1bmN0aW9uLWRlY2xhcmF0aW9uXQogIHJl
dCA9IGNkZXZfZGV2aWNlX2FkZCgmZGV2bm9kZS0+Y2RldiwgJmRldm5vZGUtPmRldik7CiAgICAg
ICAgXgovaG9tZS9tZS9naXQvY2xvbmVzL21lZGlhX2J1aWxkL3Y0bC9jZWMtY29yZS5jOiBJbiBm
dW5jdGlvbiAnY2VjX2Rldm5vZGVfdW5yZWdpc3Rlcic6Ci9ob21lL21lL2dpdC9jbG9uZXMvbWVk
aWFfYnVpbGQvdjRsL2NlYy1jb3JlLmM6MTg2OjI6IGVycm9yOiBpbXBsaWNpdCBkZWNsYXJhdGlv
biBvZiBmdW5jdGlvbiAnY2Rldl9kZXZpY2VfZGVsJyBbLVdlcnJvcj1pbXBsaWNpdC1mdW5jdGlv
bi1kZWNsYXJhdGlvbl0KICBjZGV2X2RldmljZV9kZWwoJmRldm5vZGUtPmNkZXYsICZkZXZub2Rl
LT5kZXYpOwogIF4KY2MxOiBzb21lIHdhcm5pbmdzIGJlaW5nIHRyZWF0ZWQgYXMgZXJyb3JzCnNj
cmlwdHMvTWFrZWZpbGUuYnVpbGQ6Mjg5OiByZWNpcGUgZm9yIHRhcmdldCAnL2hvbWUvbWUvZ2l0
L2Nsb25lcy9tZWRpYV9idWlsZC92NGwvY2VjLWNvcmUubycgZmFpbGVkCm1ha2VbM106ICoqKiBb
L2hvbWUvbWUvZ2l0L2Nsb25lcy9tZWRpYV9idWlsZC92NGwvY2VjLWNvcmUub10gRXJyb3IgMQpN
YWtlZmlsZToxNDkxOiByZWNpcGUgZm9yIHRhcmdldCAnX21vZHVsZV8vaG9tZS9tZS9naXQvY2xv
bmVzL21lZGlhX2J1aWxkL3Y0bCcgZmFpbGVkCm1ha2VbMl06ICoqKiBbX21vZHVsZV8vaG9tZS9t
ZS9naXQvY2xvbmVzL21lZGlhX2J1aWxkL3Y0bF0gRXJyb3IgMgptYWtlWzJdOiBMZWF2aW5nIGRp
cmVjdG9yeSAnL3Vzci9zcmMvbGludXgtaGVhZGVycy00LjguMC01My1nZW5lcmljJwpNYWtlZmls
ZTo1MTogcmVjaXBlIGZvciB0YXJnZXQgJ2RlZmF1bHQnIGZhaWxlZAptYWtlWzFdOiAqKiogW2Rl
ZmF1bHRdIEVycm9yIDIKbWFrZVsxXTogTGVhdmluZyBkaXJlY3RvcnkgJy9ob21lL21lL2dpdC9j
bG9uZXMvbWVkaWFfYnVpbGQvdjRsJwpNYWtlZmlsZToyNjogcmVjaXBlIGZvciB0YXJnZXQgJ2Fs
bCcgZmFpbGVkCm1ha2U6ICoqKiBbYWxsXSBFcnJvciAyCmJ1aWxkIGZhaWxlZCBhdCAuL2J1aWxk
IGxpbmUgNTAyLgo=
--f403045f4e8a522abe055077860b--
