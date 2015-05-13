Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ie0-f176.google.com ([209.85.223.176]:35069 "EHLO
	mail-ie0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753574AbbEMJ0k (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 13 May 2015 05:26:40 -0400
Received: by iebpz10 with SMTP id pz10so26524465ieb.2
        for <linux-media@vger.kernel.org>; Wed, 13 May 2015 02:26:39 -0700 (PDT)
MIME-Version: 1.0
Date: Wed, 13 May 2015 10:26:39 +0100
Message-ID: <CAOwYNKbkLgeEdfuC9m3ytjKKwPqxob6JD0pDtrkJFGqbY_a8Ag@mail.gmail.com>
Subject: Disappearing dvb-usb stick IT9137FN (Kworld 499-2T)
From: Mike Martin <mike@redtux.org.uk>
To: linux-media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi

I have the above usb stick (dual frontend) which works fine for a
while then just vanishes.
ie: frontend just goes
 eg

ls /dev/dvb (I have a permanent DVB card as well)
/dev/dvb/adapter0
/dev/dvb/adapter1
/dev/dvb/adapter2

goes to

ls /dev/dvb (I have a permanent DVB card as well)
/dev/dvb/adapter0

To get it back I have plug/unplug several times (rebooting the box
seems to make no difference)

I am currently on fedora 21, but this seems to be a continual issue ,
through at least fedora 18 to date

I cant see anything obvious in dmesg or the logs

Any ideas
