Return-path: <linux-media-owner@vger.kernel.org>
Received: from dns1.tnr.at ([62.99.154.7]:35079 "EHLO mail.tnr.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752102AbZKRHxa (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 18 Nov 2009 02:53:30 -0500
Received: from devenv1 (chello084115150029.3.graz.surfer.at [84.115.150.29])
	by mail.tnr.at (Postfix) with ESMTP id BC4B0C10310
	for <linux-media@vger.kernel.org>; Wed, 18 Nov 2009 08:45:03 +0100 (CET)
Date: Wed, 18 Nov 2009 08:45:16 +0100
From: Andreas Feuersinger <andreas.feuersinger@spintower.eu>
To: linux-media@vger.kernel.org
Subject: Driver for NXP SAA7154
Message-ID: <20091118084516.375817ff@devenv1>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Hi,

I wonder if there is work in progress for a Linux driver supporting
the NXP SAA7154 Multistandard video decoder with comb filter, component
input and RGB output chip. The chip provides some improvements of the
SAA7119 chip which is (partially?) supported by the kernel right now.
(I'm not so sure about that)

I work for a very small startup company developing an arm based embedded
system and would very much be interested in the development of that
driver.

We would especially be interested in 

* De-interlacing for progressive displays

NXP Product page:
http://www.nxp.com/#/pip/pip=[pip=SAA7154E_SAA7154H]|pp=[t=pip,i=SAA7154E_SAA7154H]
Datasheet:
http://www.nxp.com/documents/data_sheet/SAA7154E_SAA7154H.pdf

Any help appreciated!

Thanks,
Andreas
