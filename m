Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-io0-f176.google.com ([209.85.223.176]:36425 "EHLO
	mail-io0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750895AbcANA3l (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 13 Jan 2016 19:29:41 -0500
MIME-Version: 1.0
Date: Wed, 13 Jan 2016 16:29:40 -0800
Message-ID: <CA+55aFzwgUD3FGHtNBcFeoysun_VebvoS5qygWSKz-tb2hsKGA@mail.gmail.com>
Subject: New device ID for Philips Spc880nc webcam
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Hans de Goede <hdegoede@redhat.com>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	klucznik <klucznik0@op.pl>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: multipart/mixed; boundary=001a113fd3e2e5c0df052940618a
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--001a113fd3e2e5c0df052940618a
Content-Type: text/plain; charset=UTF-8

Hans, Mauro,
 forwarding an email from Kikim with new USB ID's for the 880NC webcam.

Kikim, you really should send the patch as a single patch, and with
the appropriate sign-off. See Documentation/SubmittingPatches. Also,
please send to the right people: you can get that with

  ./scripts/get_maintainer.pl -f drivers/media/usb/pwc/pwc-if.c

(and you can also see them from this email).

               Linus

--
>From klucznik <klucznik0@op.pl>:on Wed, Jan 13, 2016 at 3:29 PM:
> Subject: driver patch Philips Spc880nc webcam
>
> Dear Linus Torvalds.
> I have a webcam Philips Spc880nc and a problem with the driver.
> I was looking for solutions to run on my system (PCLinuxOS) but I did not find.
> Did not want to modify my camera to SPC900NC - on the internet are the
> instructions - I wanted to keep the original.
> After a time I was able to activate the camera. Everything works - tested on a few kernel.
> So I send a kernel patches - might be able to join these patches to release a new kernel.
> Spc880nc would act then by all who have the cameras, not only for me.
> If you could cause to add the patches to the kernel it would be good for a everyone.
>
> Here is a link to my discussion at forum:
> http://www.pclinuxos.com/forum/index.php/topic,135688.0.html
>
> sorry for my english ;)  I greet ....... Kikim

--001a113fd3e2e5c0df052940618a
Content-Type: text/x-patch; charset=US-ASCII; name="kconfig.diff"
Content-Disposition: attachment; filename="kconfig.diff"
Content-Transfer-Encoding: base64
X-Attachment-Id: d7537c17dd7c0980_0.1

LS0tIC0JMjAxNi0wMS0xNCAwMDoxMTo1Mi40MjAxODIxMDUgKzAxMDANCisrKyAvdXNyL3NyYy9s
aW51eC00LjEuMTUtcGNsb3MxL2RyaXZlcnMvbWVkaWEvdXNiL3B3Yy9LY29uZmlnCTIwMTYtMDEt
MTQgMDA6MTE6NTAuMjQwMzM2OTgzICswMTAwDQpAQCAtOSw2ICs5LDcgQEANCiAJICAgKiBQaGls
aXBzIFBDVkM2NzUsIFBDVkM2ODAsIFBDVkM2OTANCiAJICAgKiBQaGlsaXBzIFBDVkM3MjAvNDAs
IFBDVkM3MzAsIFBDVkM3NDAsIFBDVkM3NTANCiAJICAgKiBQaGlsaXBzIFNQQzkwME5DDQorCSAg
ICogUGhpbGlwcyBTUEM4ODBOQw0KIAkgICAqIEFza2V5IFZDMDEwDQogCSAgICogTG9naXRlY2gg
UXVpY2tDYW0gUHJvIDMwMDAsIDQwMDAsICdab29tJywgJ05vdGVib29rIFBybycNCiAJICAgICBh
bmQgJ09yYml0Jy8nU3BoZXJlJw0KDQoNCg0KDQo=
--001a113fd3e2e5c0df052940618a
Content-Type: text/x-patch; charset=US-ASCII; name="pwc-if.c.diff"
Content-Disposition: attachment; filename="pwc-if.c.diff"
Content-Transfer-Encoding: base64
X-Attachment-Id: d7537c17dd7c0980_0.2

LS0tIC0JMjAxNi0wMS0xNCAwMDoxNDo1Ni40OTg5MjU0MjIgKzAxMDANCisrKyAvdXNyL3NyYy9s
aW51eC00LjEuMTUtcGNsb3MxL2RyaXZlcnMvbWVkaWEvdXNiL3B3Yy9wd2MtaWYuYwkyMDE2LTAx
LTE0IDAwOjE0OjUwLjM3NjAwODQxNSArMDEwMA0KQEAgLTkxLDYgKzkxLDcgQEANCiAJeyBVU0Jf
REVWSUNFKDB4MDQ3MSwgMHgwMzEyKSB9LA0KIAl7IFVTQl9ERVZJQ0UoMHgwNDcxLCAweDAzMTMp
IH0sIC8qIHRoZSAnbmV3JyA3MjBLICovDQogCXsgVVNCX0RFVklDRSgweDA0NzEsIDB4MDMyOSkg
fSwgLyogUGhpbGlwcyBTUEMgOTAwTkMgUEMgQ2FtZXJhICovDQorCXsgVVNCX0RFVklDRSgweDA0
NzEsIDB4MDMyQykgfSwgLyogUGhpbGlwcyBTUEMgODgwTkMgUEMgQ2FtZXJhICovDQogCXsgVVNC
X0RFVklDRSgweDA2OUEsIDB4MDAwMSkgfSwgLyogQXNrZXkgKi8NCiAJeyBVU0JfREVWSUNFKDB4
MDQ2RCwgMHgwOEIwKSB9LCAvKiBMb2dpdGVjaCBRdWlja0NhbSBQcm8gMzAwMCAqLw0KIAl7IFVT
Ql9ERVZJQ0UoMHgwNDZELCAweDA4QjEpIH0sIC8qIExvZ2l0ZWNoIFF1aWNrQ2FtIE5vdGVib29r
IFBybyAqLw0KQEAgLTgwMiw2ICs4MDMsMTEgQEANCiAJCQluYW1lID0gIlBoaWxpcHMgU1BDIDkw
ME5DIHdlYmNhbSI7DQogCQkJdHlwZV9pZCA9IDc0MDsNCiAJCQlicmVhazsNCisJCWNhc2UgMHgw
MzJDOg0KKwkJCVBXQ19JTkZPKCJQaGlsaXBzIFNQQyA4ODBOQyBVU0Igd2ViY2FtIGRldGVjdGVk
LlxuIik7DQorCQkJbmFtZSA9ICJQaGlsaXBzIFNQQyA4ODBOQyB3ZWJjYW0iOw0KKwkJCXR5cGVf
aWQgPSA3NDA7DQorCQkJYnJlYWs7DQogCQlkZWZhdWx0Og0KIAkJCXJldHVybiAtRU5PREVWOw0K
IAkJCWJyZWFrOw0KDQoNCg0KDQo=
--001a113fd3e2e5c0df052940618a--
