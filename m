Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:58658 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752090Ab2BGRIg (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 7 Feb 2012 12:08:36 -0500
Received: by vbjk17 with SMTP id k17so4757110vbj.19
        for <linux-media@vger.kernel.org>; Tue, 07 Feb 2012 09:08:35 -0800 (PST)
MIME-Version: 1.0
Date: Tue, 7 Feb 2012 12:08:35 -0500
Message-ID: <CAOcJUbwqtvWy+O5guZBj7T2f61=8oe+gwqH6Fbifu1PVz+THzQ@mail.gmail.com>
Subject: pvrusb2: fix 7MHz & 8MHz DVB-T tuner support for HVR1900 rev D1F5
From: Michael Krufky <mkrufky@linuxtv.org>
To: Mike Isely <isely@pobox.com>
Cc: linux-media <linux-media@vger.kernel.org>,
	Communications nexus for pvrusb2 driver <pvrusb2@isely.net>,
	stable@kernel.org
Content-Type: multipart/mixed; boundary=f46d043d675b5acadf04b862d4f9
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--f46d043d675b5acadf04b862d4f9
Content-Type: text/plain; charset=ISO-8859-1

There are some new revisions of the HVR-1900 around whose DVB-T
support is broken without this small bug-fix.  Please merge asap -
this fix needs to go to stable kernels as well.  It applies cleanly
against *all* recent kernels.

The following changes since commit 805a6af8dba5dfdd35ec35dc52ec0122400b2610:

  Linux 3.2 (2012-01-04 15:55:44 -0800)

are available in the git repository at:
  git://linuxtv.org/mkrufky/hauppauge surrey

Michael Krufky (1):
      pvrusb2: fix 7MHz & 8MHz DVB-T tuner support for HVR1900 rev D1F5

 drivers/media/video/pvrusb2/pvrusb2-devattr.c |   10 ++++++++++
 1 files changed, 10 insertions(+), 0 deletions(-)

--f46d043d675b5acadf04b862d4f9
Content-Type: text/x-patch; charset=US-ASCII;
	name="0001-pvrusb2-fix-7MHz-8MHz-DVB-T-tuner-support-for-HVR190.patch"
Content-Disposition: attachment;
	filename="0001-pvrusb2-fix-7MHz-8MHz-DVB-T-tuner-support-for-HVR190.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_gyd6jt2o0

RnJvbSA3MjAyZTQ5NTgyNjExY2NkNzBlOTNkYjhiOGY3NWMwODExMDE1NDQ0IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBNaWNoYWVsIEtydWZreSA8bWtydWZreUBsaW51eHR2Lm9yZz4K
RGF0ZTogVHVlLCA3IEZlYiAyMDEyIDExOjI4OjMzIC0wNTAwClN1YmplY3Q6IFtQQVRDSF0gcHZy
dXNiMjogZml4IDdNSHogJiA4TUh6IERWQi1UIHR1bmVyIHN1cHBvcnQgZm9yIEhWUjE5MDAgcmV2
CiBEMUY1CgpUaGUgRDFGNSByZXZpc2lvbiBvZiB0aGUgV2luVFYgSFZSLTE5MDAgdXNlcyBhIHRk
YTE4MjcxYzIgdHVuZXIKaW5zdGVhZCBvZiBhIHRkYTE4MjcxYzEgdHVuZXIgYXMgdXNlZCBpbiBy
ZXZpc2lvbiBEMUU5LiBUbwphY2NvdW50IGZvciB0aGlzLCB3ZSBtdXN0IGhhcmRjb2RlIHRoZSBm
cm9udGVuZCBjb25maWd1cmF0aW9uCnRvIHVzZSB0aGUgc2FtZSBJRiBmcmVxdWVuY3kgY29uZmln
dXJhdGlvbiBmb3IgYm90aCByZXZpc2lvbnMKb2YgdGhlIGRldmljZS4KCjZNSHogRFZCLVQgaXMg
dW5hZmZlY3RlZCBieSB0aGlzIGlzc3VlLCBhcyB0aGUgcmVjb21tZW5kZWQKSUYgRnJlcXVlbmN5
IGNvbmZpZ3VyYXRpb24gZm9yIDZNSHogRFZCLVQgaXMgdGhlIHNhbWUgb24gYm90aApjMSBhbmQg
YzIgcmV2aXNpb25zIG9mIHRoZSB0ZGExODI3MSB0dW5lci4KClNpZ25lZC1vZmYtYnk6IE1pY2hh
ZWwgS3J1Zmt5IDxta3J1Zmt5QGxpbnV4dHYub3JnPgpDYzogTWlrZSBJc2VseSA8aXNlbHlAcG9i
b3guY29tPgpDYzogc3RhYmxlQGtlcm5lbC5vcmcKLS0tCiBkcml2ZXJzL21lZGlhL3ZpZGVvL3B2
cnVzYjIvcHZydXNiMi1kZXZhdHRyLmMgfCAgIDEwICsrKysrKysrKysKIDEgZmlsZXMgY2hhbmdl
ZCwgMTAgaW5zZXJ0aW9ucygrKSwgMCBkZWxldGlvbnMoLSkKCmRpZmYgLS1naXQgYS9kcml2ZXJz
L21lZGlhL3ZpZGVvL3B2cnVzYjIvcHZydXNiMi1kZXZhdHRyLmMgYi9kcml2ZXJzL21lZGlhL3Zp
ZGVvL3B2cnVzYjIvcHZydXNiMi1kZXZhdHRyLmMKaW5kZXggYzZkYThmNy4uZDhjODk4MiAxMDA2
NDQKLS0tIGEvZHJpdmVycy9tZWRpYS92aWRlby9wdnJ1c2IyL3B2cnVzYjItZGV2YXR0ci5jCisr
KyBiL2RyaXZlcnMvbWVkaWEvdmlkZW8vcHZydXNiMi9wdnJ1c2IyLWRldmF0dHIuYwpAQCAtMzIw
LDcgKzMyMCwxNyBAQCBzdGF0aWMgc3RydWN0IHRkYTgyOXhfY29uZmlnIHRkYTgyOXhfbm9fcHJv
YmUgPSB7CiAJLnByb2JlX3R1bmVyID0gVERBODI5WF9ET05UX1BST0JFLAogfTsKIAorc3RhdGlj
IHN0cnVjdCB0ZGExODI3MV9zdGRfbWFwIGhhdXBwYXVnZV90ZGExODI3MV9kdmJ0X3N0ZF9tYXAg
PSB7CisgICAgICAgIC5kdmJ0XzYgICA9IHsgLmlmX2ZyZXEgPSAzMzAwLCAuYWdjX21vZGUgPSAz
LCAuc3RkID0gNCwKKyAgICAgICAgICAgICAgICAgICAgICAuaWZfbHZsID0gMSwgLnJmYWdjX3Rv
cCA9IDB4MzcsIH0sCisgICAgICAgIC5kdmJ0XzcgICA9IHsgLmlmX2ZyZXEgPSAzODAwLCAuYWdj
X21vZGUgPSAzLCAuc3RkID0gNSwKKyAgICAgICAgICAgICAgICAgICAgICAuaWZfbHZsID0gMSwg
LnJmYWdjX3RvcCA9IDB4MzcsIH0sCisgICAgICAgIC5kdmJ0XzggICA9IHsgLmlmX2ZyZXEgPSA0
MzAwLCAuYWdjX21vZGUgPSAzLCAuc3RkID0gNiwKKyAgICAgICAgICAgICAgICAgICAgICAuaWZf
bHZsID0gMSwgLnJmYWdjX3RvcCA9IDB4MzcsIH0sCit9OworCiBzdGF0aWMgc3RydWN0IHRkYTE4
MjcxX2NvbmZpZyBoYXVwcGF1Z2VfdGRhMTgyNzFfZHZiX2NvbmZpZyA9IHsKKwkuc3RkX21hcCA9
ICZoYXVwcGF1Z2VfdGRhMTgyNzFfZHZidF9zdGRfbWFwLAogCS5nYXRlICAgID0gVERBMTgyNzFf
R0FURV9BTkFMT0csCiAJLm91dHB1dF9vcHQgPSBUREExODI3MV9PVVRQVVRfTFRfT0ZGLAogfTsK
LS0gCjEuNy41LjQKCg==
--f46d043d675b5acadf04b862d4f9--
