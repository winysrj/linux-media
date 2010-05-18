Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtpfb2-g21.free.fr ([212.27.42.10]:60760 "EHLO
	smtpfb2-g21.free.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756310Ab0EROIS (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 18 May 2010 10:08:18 -0400
Received: from smtp2-g21.free.fr (smtp2-g21.free.fr [212.27.42.2])
	by smtpfb2-g21.free.fr (Postfix) with ESMTP id 8A1FBCC0A70
	for <linux-media@vger.kernel.org>; Tue, 18 May 2010 16:08:14 +0200 (CEST)
Received: from smtp2-g21.free.fr (localhost [127.0.0.1])
	by smtp2-g21.free.fr (Postfix) with ESMTP id 32B544B0037
	for <linux-media@vger.kernel.org>; Tue, 18 May 2010 16:07:38 +0200 (CEST)
Received: from [192.168.1.252] (bog44-1-82-231-133-211.fbx.proxad.net [82.231.133.211])
	by smtp2-g21.free.fr (Postfix) with ESMTP
	for <linux-media@vger.kernel.org>; Tue, 18 May 2010 16:07:37 +0200 (CEST)
Message-ID: <4BF29E9D.9050907@free.fr>
Date: Tue, 18 May 2010 16:05:17 +0200
From: matpic <matpic@free.fr>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: new DVB-T initial tuning for fr-nantes
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

hello

As from today (18/05/2010) there is new frequency since analogic signal
is stopped and is now only numeric.


guard-interval has to be set to AUTO or scan find anything
 (1/32, 1/16, 1/8 ,1/4 doesn't work)


# Nantes - France
# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
T 538000000 8MHz 2/3 NONE QAM64 8k AUTO NONE
T 490000000 8MHz 2/3 NONE QAM64 8k AUTO NONE
T 546000000 8MHz 2/3 NONE QAM64 8k AUTO NONE
T 658000000 8MHz 2/3 NONE QAM64 8k AUTO NONE
T 682000000 8MHz 2/3 NONE QAM64 8k AUTO NONE
T 738000000 8MHz 2/3 NONE QAM64 8k AUTO NONE
#same frequency + offset 167000000 for some hardware DVB-T tuner
T 538167000 8MHz 2/3 NONE QAM64 8k AUTO NONE
T 546167000 8MHz 2/3 NONE QAM64 8k AUTO NONE
T 658167000 8MHz 2/3 NONE QAM64 8k AUTO NONE
T 682167000 8MHz 2/3 NONE QAM64 8k AUTO NONE
T 738167000 8MHz 2/3 NONE QAM64 8k AUTO NONE
