Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f219.google.com ([209.85.218.219]:61507 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751089AbZIEUi7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 5 Sep 2009 16:38:59 -0400
Received: by bwz19 with SMTP id 19so901080bwz.37
        for <linux-media@vger.kernel.org>; Sat, 05 Sep 2009 13:39:01 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20090820001056.ar4ux62tx0coo0gs@webmail1.abo.fi>
References: <20090820001056.ar4ux62tx0coo0gs@webmail1.abo.fi>
Date: Sat, 5 Sep 2009 22:39:01 +0200
Message-ID: <bcb3ef430909051339n4d2abbdexba0af1b029a5fedd@mail.gmail.com>
Subject: Re: Terratec Cinergy C HD tuning problems
From: MartinG <gronslet@gmail.com>
To: dsjoblom@abo.fi
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Aug 19, 2009 at 11:10 PM, <dsjoblom@abo.fi> wrote:
> I'm having some problems with my Terratec Cinergy C PCI DVB-C card.
> ...
> /var/log/syslog (when tuning stops working):
>...
> kernel: [55168.360122] mantis_ack_wait (0): Slave RACK Fail !

Hi, I have the same problem:
Terratec Cinergy HD DVB-C PCI
Twinhan Technology Co. Ltd Mantis DTV PCI Bridge Controller [Ver 1.0] (rev 01)
VP-2040 PCI DVB-C device
TDA10023

MythTV chokes after a while because of the error described above.
Also, when I use w_scan, it is not able to scan (tune) for new
channels.

Similar problem is mentioned here:
http://thread.gmane.org/gmane.linux.drivers.dvb/47829

These are my bits:
s2-liplianin from http://mercurial.intuxication.org/hg/s2-liplianin (03 Jun)
kernel-2.6.29.6-217.2.16.fc11.x86_64

Any hints on how to get this working appreciated. Removing and
reinserting the mantis module doesn't seem to help for me.

-MartinG
