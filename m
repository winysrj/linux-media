Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ew0-f219.google.com ([209.85.219.219]:45753 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753361Ab0AUQXl (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 21 Jan 2010 11:23:41 -0500
Received: by ewy19 with SMTP id 19so162917ewy.1
        for <linux-media@vger.kernel.org>; Thu, 21 Jan 2010 08:23:40 -0800 (PST)
MIME-Version: 1.0
Date: Thu, 21 Jan 2010 16:23:39 +0000
Message-ID: <fa2628e11001210823g7f41573enafccbdaa8ebc948f@mail.gmail.com>
Subject: updated dvb-t/uk-StocklandHill scan file
From: =?UTF-8?B?U3RldmVuIEPDtHTDqQ==?= <steven.cote@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I have an updated scan file for uk-StocklandHill for the new settings
after the digital switch over.

# UK, Stockland Hill
# http://www.ukfree.tv/txdetail.php?a=ST222014
T 514167000 8MHz 2/3 1/2 QAM64 8k 1/32 NONE     # PSB1
T 490167000 8MHz 2/3 1/2 QAM64 8k 1/32 NONE     # PSB2
#T 538167000 8MHz 2/3 1/2 QAM64 8k 1/32 NONE     # PSB3 (DVB-T2)
T 505833000 8MHz 2/3 1/2 QAM64 8k 1/32 NONE     # COM4
T 481833000 8MHz 2/3 1/2 QAM64 8k 1/32 NONE     # COM5
T 529833000 8MHz 2/3 1/2 QAM64 8k 1/32 NONE     # COM6


I've commented out the line for PSB3, since it's not actually
activated yet and when it is, it'll be carrying a DVB-T2 signal. So
even once it's up and running, there's nothing out there that supports
it as far as I'm aware.

There are a couple other transmitters in the south-west that have
switched over as well so I'll bug some people on the Devon/Cornwall
LUG mailing list to see if I can gather up the rest of them.
