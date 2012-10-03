Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-oa0-f46.google.com ([209.85.219.46]:50539 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755369Ab2JCVS1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 3 Oct 2012 17:18:27 -0400
Received: by oagh16 with SMTP id h16so7947561oag.19
        for <linux-media@vger.kernel.org>; Wed, 03 Oct 2012 14:18:26 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20121003210532.GA10941@kroah.com>
References: <CA+55aFyzXFNq7O+M9EmiRLJ=cDJziipf=BLM8GGAG70j_QTciQ@mail.gmail.com>
 <20121002221239.GA30990@kroah.com> <20121002222333.GA32207@kroah.com>
 <CA+55aFwNEm9fCE+U_c7XWT33gP8rxothHBkSsnDbBm8aXoB+nA@mail.gmail.com>
 <506C562E.5090909@redhat.com> <CA+55aFweE2BgGjGkxLPkmHeV=Omc4RsuU6Kc6SLZHgJPsqDpeA@mail.gmail.com>
 <20121003170907.GA23473@ZenIV.linux.org.uk> <CA+55aFw0pB99ztq5YUS56db-ijdxzevA=mvY3ce5O_yujVFOcA@mail.gmail.com>
 <20121003195059.GA13541@kroah.com> <CA+55aFwjyABgr-nmsDb-184nQF7KfA8+5kbuBNwyQBHs671qQg@mail.gmail.com>
 <20121003210532.GA10941@kroah.com>
From: Kay Sievers <kay@vrfy.org>
Date: Wed, 3 Oct 2012 23:18:06 +0200
Message-ID: <CAPXgP13h+7+WoZ2jVjroLWU495wDPwzbhefX8ziuQMznKBWyLQ@mail.gmail.com>
Subject: Re: udev breakages - was: Re: Need of an ".async_probe()" type of
 callback at driver's core - Was: Re: [PATCH] [media] drxk: change it to use request_firmware_nowait()
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
	Al Viro <viro@zeniv.linux.org.uk>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Ming Lei <ming.lei@canonical.com>,
	Lennart Poettering <lennart@poettering.net>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Kay Sievers <kay@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Michael Krufky <mkrufky@linuxtv.org>,
	Ivan Kalvachev <ikalvachev@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Oct 3, 2012 at 11:05 PM, Greg KH <gregkh@linuxfoundation.org> wrote:

> As for the firmware path, maybe we should
> change that to be modified by userspace (much like /sbin/hotplug was) in
> a proc file so that distros can override the location if they need to.

If that's needed, a CONFIG_FIRMWARE_PATH= with the array of locations
would probably be sufficient.

Like udev's defaults here:
  http://cgit.freedesktop.org/systemd/systemd/tree/configure.ac#n550

Kay
