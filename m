Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail0.scram.de ([78.47.204.202]:36437 "EHLO mail.scram.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752570AbZAQKh2 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 17 Jan 2009 05:37:28 -0500
Message-ID: <4971B4F6.1020407@scram.de>
Date: Sat, 17 Jan 2009 11:37:42 +0100
From: Jochen Friedrich <jochen@scram.de>
MIME-Version: 1.0
To: Antti Palosaari <crope@iki.fi>
CC: Detlef Rohde <rohde.d@t-online.de>,
	Roberto Ragusa <mail@robertoragusa.it>,
	linux-media@vger.kernel.org
Subject: Re: MC44S803 frontend (it works)
References: <4936FF66.3020109@robertoragusa.it> <494C0002.1060204@scram.de> <49623372.90403@robertoragusa.it> <4965327A.5000605@t-online.de> <496CD4C8.50004@t-online.de> <496E2C6B.3050607@scram.de> <496E2FB5.4080406@scram.de> <4971367E.90504@iki.fi> <4971AE26.9070901@t-online.de> <4971B278.8010804@iki.fi>
In-Reply-To: <4971B278.8010804@iki.fi>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Antti,

> I did some more changes, could you test again:

This version works OK for me :-). The old version also worked, but was very insensitive (i only received one
transponder instead of 6, i guess this GPIO must switch on some RF-amplifyer or so).

Thanks,
Jochen
