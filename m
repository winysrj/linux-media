Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vw0-f192.google.com ([209.85.212.192]:37340 "EHLO
	mail-vw0-f192.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752545AbZJAVOd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 1 Oct 2009 17:14:33 -0400
Received: by vws30 with SMTP id 30so296017vws.21
        for <linux-media@vger.kernel.org>; Thu, 01 Oct 2009 14:14:37 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <37219a840910011227r155d4bc1kc98935e3a52a4a17@mail.gmail.com>
References: <c85228170910011138w6d3fa3adibbb25d275baa824f@mail.gmail.com>
	 <37219a840910011227r155d4bc1kc98935e3a52a4a17@mail.gmail.com>
Date: Thu, 1 Oct 2009 18:14:36 -0300
Message-ID: <c85228170910011414n29837812y28010ef0d97b7bf1@mail.gmail.com>
Subject: Re: How to make my device work with linux?
From: Wellington Terumi Uemura <wellingtonuemura@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I was looking around to find that there is a driver for that Fujitsu
MB86A16 inside the "Linux Mantis Driver" project, Fujitsu MB86A16
DVB-S/DSS DC Receiver driver made by Manu Abraham
http://www.verbraak.org/wiki/index.php/Linux_Mantis_driver.

I've done a few tests with usbsnoop and other tools but USB sniffer
doesn't see any valid command, jut a bunch of bytes that makes no
sense:
http://www.isely.net/pvrusb2/firmware.html#FX2

I will try my luck compiling that Fujitsu driver, but my best guess is
that without a proper I/O from that FX2 it will end up with nothing at
all.

Thank you.

> For a first step, I'd recommend to read up on using USB sniffers to
> capture the windows driver traffic.  The drivers for the FX2 parts
> tend to be relatively easy to sniff.  We already have a linux driver
> for the TDA18271, I *think* there is a driver available for that
> Fujitsu demod but it's not in the v4l-dvb master repository.
[snip]
