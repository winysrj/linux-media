Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f172.google.com ([209.85.212.172]:38551 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755643Ab2KHSCT (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 8 Nov 2012 13:02:19 -0500
Received: by mail-wi0-f172.google.com with SMTP id hm6so342201wib.1
        for <linux-media@vger.kernel.org>; Thu, 08 Nov 2012 10:02:18 -0800 (PST)
MIME-Version: 1.0
Date: Thu, 8 Nov 2012 21:32:18 +0330
Message-ID: <CADV=gjEKsYOu-G9-Tf7NO0iKaRYvmLKQ9wdgabH_96w4KYv51g@mail.gmail.com>
Subject: more than 6 Tevii S464 DVB-S2 card in linux 3.6.5.
From: "Ali H.M. Hoseini" <alihmh@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

I have 8 Tevii S464 DVB-S2 cards installed in my industrial PC with
Ubuntu 10.04.4 with kernel 3.6.5.

The system loads cx88_dvb for this card, but only recognizes six of
cards, and make device files for them under /dev/dvb. (adapters 0 to
5).
dmesg is silent about other cards, but lspci -vv clearly shows 8 cards
are exist on system.
If I install another cards, like TechnoTrend S2-1600, the adapter
numbers increase, which clearly shows 6 adapters is limit for Tevii
S464 module.

I'm used to install 18 skystar2 v2.8 in this system, without any problem.

What is the problem, and how could I recompile kernel to overcome it.

regards.
A. Hoseini.
