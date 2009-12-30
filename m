Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx-mail.opticon.hu ([85.90.160.75]:48452 "EHLO
	mx-mail.opticon.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751468AbZL3USq (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 30 Dec 2009 15:18:46 -0500
Subject: AverMedia A577 (cx23385, xc3028, af9013)
From: =?ISO-8859-1?Q?Nov=E1k?= Levente <lnovak@dragon.unideb.hu>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 30 Dec 2009 21:12:02 +0100
Message-ID: <1262203922.13686.36.camel@szisz-laptop>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

Now that DVB-T is finally available in my town, I would like to ask for
help to make my AverMedia HybridExpress (A577) work under Linux.

This is the information I have gathered so far:

Main chips are the following (see
http://www.ixbt.com/monitor/aver-hybrid-express.shtml for pictures, the
page is in Russian though):

cx23885 (PCIe A/V decoder)
xc3028  (hybrid tuner)
af9013  (demod)

all of these individual chips are already supported under Linux, only
the "glue" is missing between them, I think.

I've also got an A885VCap.inf file (which is some 3164 lines long,
that's why I don't attach it here except if requested), along with other
files (a885vcap.cat, A885VCap.sys, cpnotify.ax, cxtvrate.dll, but also
merlinC.rom and cx416enc.rom) from the Windows driver pack. I don't know
if all of these are really needed, especially cx416enc.rom, since this
card is not supposed to have a hardware A/V encoder.

I would like to ask for help, what is the next step I should take in
order to make this card work?

Levente




