Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from dyn60-31.dsl.spy.dnainternet.fi ([83.102.60.31]
	helo=shogun.pilppa.org) by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <lamikr@pilppa.org>) id 1JyVqx-0006E9-42
	for linux-dvb@linuxtv.org; Tue, 20 May 2008 19:42:23 +0200
Date: Tue, 20 May 2008 20:42:12 +0300 (EEST)
From: Mika Laitio <lamikr@pilppa.org>
To: Alexander ter Haar <alexanderterhaar@gmail.com>
In-Reply-To: <d8ba26160805191256h16f5c760md6112dd9612f4bdd@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0805202001210.9493@shogun.pilppa.org>
References: <d8ba26160805191256h16f5c760md6112dd9612f4bdd@mail.gmail.com>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED;
	BOUNDARY="-1463809533-1213320911-1211305332=:9493"
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] v4l-dvb-hg conflict with zoran
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---1463809533-1213320911-1211305332=:9493
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed

> CC [M]  /var/tmp/portage/media-tv/v4l-dvb-hg-0.1-r2/work/v4l-dvb/v4l/zoran_device.o
> /var/tmp/portage/media-tv/v4l-dvb-hg-0.1-r2/work/v4l-dvb/v4l/zoran_procfs.c:
> In function 'zoran_proc_init':
> /var/tmp/portage/media-tv/v4l-dvb-hg-0.1-r2/work/v4l-dvb/v4l/zoran_procfs.c:208:
> error: implicit declaration of function 'proc_create_data'
> /var/tmp/portage/media-tv/v4l-dvb-hg-0.1-r2/work/v4l-dvb/v4l/zoran_procfs.c:208:
> warning: assignment makes pointer from integer without a cast
> make[2]: *** [/var/tmp/portage/media-tv/v4l-dvb-hg-0.1-r2/work/v4l-dvb/v4l/zoran_procfs.o]

I was tracking down the same build problem when I was building HG drivers 
yesterday against the Mandriva's 2.6.25 cooker kernel.

I think the error is due because 2.6.25 kernel does not yet have the 
definition of proc_create_data function in include/linux/proc_fs.h.
That is propably coming to 2.6.26 kernel as the latest Linux git contains 
that prototype.

So maybe a attached 1 line patch could be applied to v4l-dvb hg by 
somebody?

Mika
---1463809533-1213320911-1211305332=:9493
Content-Type: TEXT/PLAIN; charset=US-ASCII; name=zoran_proc_fs_build_fix_for_2625_kernel.patch
Content-Transfer-Encoding: BASE64
Content-ID: <Pine.LNX.4.64.0805202042120.9493@shogun.pilppa.org>
Content-Description: v4l-dvb zoran procfs build fix for 2.6.25 kernel
Content-Disposition: attachment; filename=zoran_proc_fs_build_fix_for_2625_kernel.patch

ZGlmZiAtTmF1ciB2NGwtZHZiX29sZC92NGwvY29tcGF0LmggdjRsLWR2Yi92
NGwvY29tcGF0LmgNCi0tLSB2NGwtZHZiX29sZC92NGwvY29tcGF0LmgJMjAw
OC0wNS0yMCAyMDoyNzoyMy4wMDAwMDAwMDAgKzAzMDANCisrKyB2NGwtZHZi
L3Y0bC9jb21wYXQuaAkyMDA4LTA1LTIwIDIwOjI2OjM3LjAwMDAwMDAwMCAr
MDMwMA0KQEAgLTUzNCw3ICs1MzQsNyBAQA0KICNkZWZpbmUgcHV0X3VuYWxp
Z25lZF9sZTE2KHIsIGEpCQkJCVwNCiAJcHV0X3VuYWxpZ25lZChjcHVfdG9f
bGUxNihyKSwgKCh1bnNpZ25lZCBzaG9ydCAqKShhKSkpDQogI2VuZGlmDQot
I2lmIExJTlVYX1ZFUlNJT05fQ09ERSA8IEtFUk5FTF9WRVJTSU9OKDIsIDYs
IDI1KQ0KKyNpZiBMSU5VWF9WRVJTSU9OX0NPREUgPCBLRVJORUxfVkVSU0lP
TigyLCA2LCAyNikNCiAjaWZkZWYgQ09ORklHX1BST0NfRlMNCiBzdGF0aWMg
aW5saW5lIHN0cnVjdCBwcm9jX2Rpcl9lbnRyeSAqcHJvY19jcmVhdGUoY29u
c3QgY2hhciAqYSwNCiAJbW9kZV90IGIsIHN0cnVjdCBwcm9jX2Rpcl9lbnRy
eSAqYywgY29uc3Qgc3RydWN0IGZpbGVfb3BlcmF0aW9ucyAqZCkNCg==

---1463809533-1213320911-1211305332=:9493
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
---1463809533-1213320911-1211305332=:9493--
