Return-path: <linux-media-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:40577 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751268Ab3IJN2o (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 10 Sep 2013 09:28:44 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gldv-linux-media@m.gmane.org>)
	id 1VJNzl-00082B-0J
	for linux-media@vger.kernel.org; Tue, 10 Sep 2013 15:28:41 +0200
Received: from exchange.muehlbauer.de ([194.25.158.132])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Tue, 10 Sep 2013 15:28:41 +0200
Received: from Bassai_Dai by exchange.muehlbauer.de with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Tue, 10 Sep 2013 15:28:41 +0200
To: linux-media@vger.kernel.org
From: Tom <Bassai_Dai@gmx.net>
Subject: kconfig syntax error
Date: Tue, 10 Sep 2013 13:28:21 +0000 (UTC)
Message-ID: <loom.20130910T135911-353@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

I cloned the linux kernel from git://linuxtv.org/pinchartl/media.git and
tried to configure the kernel, but I got the following problem:

arch/arm/Kconfig:98: syntax error
arch/arm/Kconfig:97: unknown option "With"
arch/arm/Kconfig:98: unknown option "DMA"
arch/arm/Kconfig:99: unknown option "specified"
arch/arm/Kconfig:100: unknown option "by"
arch/arm/Kconfig:130: syntax error
arch/arm/Kconfig:129: unknown option "The"
arch/arm/Kconfig:130: unknown option "bus"
arch/arm/Kconfig:131: unknown option "the"
arch/arm/Kconfig:132: unknown option "1995"
arch/arm/Kconfig:135: syntax error
 .
 .
 .
and so on. Does anyone know what I am missing? Is my crosscompiler too old?

Regrads, Tom



