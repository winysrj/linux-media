Return-path: <linux-media-owner@vger.kernel.org>
Received: from nm25-vm1.access.bullet.mail.bf1.yahoo.com ([216.109.115.192]:58913
        "EHLO nm25-vm1.access.bullet.mail.bf1.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751037AbdFABwL (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 31 May 2017 21:52:11 -0400
From: Ron Moreland <ronmoreland@att.net>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Subject: Error trying to build the latest V4L on a BeagleBone Black
Message-Id: <60ED3B7A-D17A-4720-A286-4DD1A36F47E0@att.net>
Date: Wed, 31 May 2017 18:52:07 -0700
To: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Mime-Version: 1.0 (Mac OS X Mail 9.3 \(3124\))
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

=E2=80=99m trying to build the latest V4L on a BeagleBone Black ( BBB ):
lsb_release -a ->
No LSB modules are available.
Distributor ID: Debian
Description:    Debian GNU/Linux 8.8 (jessie)
Release:        8.8
Codename:       jessie

name -mrs ->  Linux 4.4.54-ti-r93 armv7l

error:

./scripts/make_kconfig.pl /lib/modules/4.4.54-ti-r93/build =
/lib/modules/4.4.54-ti-r93/build 1
Preparing to compile for kernel version 4.4.54
File not found: /lib/modules/4.4.54-ti-r93/build/.config at =
./scripts/make_kconfig.pl line 33, <IN> line 4.
Makefile:383: recipe for target 'allyesconfig' failed
make[1]: *** [allyesconfig] Error 2
make[1]: Leaving directory '/home/ron/media_build/v4l'
Makefile:26: recipe for target 'allyesconfig' failed
make: *** [allyesconfig] Error 2
can't select all drivers at ./build line 501.=
