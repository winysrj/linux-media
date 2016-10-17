Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vk0-f44.google.com ([209.85.213.44]:32912 "EHLO
        mail-vk0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755012AbcJQNtF (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 17 Oct 2016 09:49:05 -0400
Received: by mail-vk0-f44.google.com with SMTP id 83so152632736vkd.0
        for <linux-media@vger.kernel.org>; Mon, 17 Oct 2016 06:49:04 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAFrtWWmPqKkPSh1611hTRGpzr_KDEHxku47R1KsFgJNgPxbPnQ@mail.gmail.com>
References: <CAFrtWWmPqKkPSh1611hTRGpzr_KDEHxku47R1KsFgJNgPxbPnQ@mail.gmail.com>
From: Joacim J <jocke4u@gmail.com>
Date: Mon, 17 Oct 2016 15:48:49 +0200
Message-ID: <CAFrtWWnsk0zHrGhFqsGmJN+idXzwzVPxRkxLnd75qYgv8xMdOw@mail.gmail.com>
Subject: Re: Trying to get TBS5880 to work on Ubuntu with Hauppauge
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi

I have a fresh Ubuntu Server 16.04 install (for third time this
weekend) and trying to get my TBS5880 to work.

I have two "'Hauppauge Nova-T 500 Dual DVB-T" in the computer and
being recognized directly during install using:

root@frodo:~/tbs/linux-tbs-drivers# lsmod | grep dvb
dvb_usb_dib0700       147456  0
dib7000m               24576  1 dvb_usb_dib0700
dib0090                40960  1 dvb_usb_dib0700
dib0070                20480  1 dvb_usb_dib0700
dib3000mc              20480  3 dvb_usb_dib0700
dibx000_common         20480  3 dvb_usb_dib0700,dib3000mc,dib7000m
dvb_usb                24576  1 dvb_usb_dib0700
dvb_core              122880  1 dvb_usb
rc_core                28672  4 dvb_usb,dvb_usb_dib0700,rc_dib0700_rc5


When installing TBS5880 drivers as described it works fine:

# mv dvb-usb-tbsqbox-id5880.fw /lib/firmware/
# tar xjvf linux-tbs-drivers.tar.bz2
# cd linux-tbs-drivers
# ./v4l/tbs-x86_64.sh
# make && make install
# shutdown -r now

But afterwards, my Hauppauge cards are gone and no TBS either.
So the driver install doesn't work and also mess up Hauppauge cards.

What should I do?
How can I test with drivers without messing up the system?

/ Joacim
