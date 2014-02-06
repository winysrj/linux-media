Return-path: <linux-media-owner@vger.kernel.org>
Received: from slow1-d.mail.gandi.net ([217.70.178.86]:37806 "EHLO
	slow1-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932130AbaBFIZh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 6 Feb 2014 03:25:37 -0500
Received: from relay6-d.mail.gandi.net (relay6-d.mail.gandi.net [217.70.183.198])
	by slow1-d.mail.gandi.net (Postfix) with ESMTP id 0E5FE47B8AE
	for <linux-media@vger.kernel.org>; Thu,  6 Feb 2014 09:25:36 +0100 (CET)
Received: from mfilter20-d.gandi.net (mfilter20-d.gandi.net [217.70.178.148])
	by relay6-d.mail.gandi.net (Postfix) with ESMTP id 3610BFB89B
	for <linux-media@vger.kernel.org>; Thu,  6 Feb 2014 09:25:23 +0100 (CET)
Received: from relay6-d.mail.gandi.net ([217.70.183.198])
	by mfilter20-d.gandi.net (mfilter20-d.gandi.net [10.0.15.180]) (amavisd-new, port 10024)
	with ESMTP id kmXOk-1y-Uzs for <linux-media@vger.kernel.org>;
	Thu,  6 Feb 2014 09:25:21 +0100 (CET)
Received: from mail.sardemff7.net (128-79-238-221.hfc.dyn.abo.bbox.fr [128.79.238.221])
	(Authenticated sender: sardemff7@sardemff7.net)
	by relay6-d.mail.gandi.net (Postfix) with ESMTPA id 88C8BFB8A4
	for <linux-media@vger.kernel.org>; Thu,  6 Feb 2014 09:25:21 +0100 (CET)
Received: from lizzy.sardemff7.net (unknown [87.89.29.250])
	by mail.sardemff7.net (Postfix) with ESMTPSA id D7F99265E9AF
	for <linux-media@vger.kernel.org>; Thu,  6 Feb 2014 08:25:19 +0000 (UTC)
Message-ID: <52F346EA.4070100@sardemff7.net>
Date: Thu, 06 Feb 2014 09:25:14 +0100
From: Quentin Glidic <sardemff7+linuxtv@sardemff7.net>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: dvb-apps build failure
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

When building dvb-apps from the Mercurial repository, you hit the 
following error:
install: cannot stat 'atsc/*': No such file or directory

In the latest changeset 
(http://linuxtv.org/hg/dvb-apps/rev/d40083fff895) scan files were 
deleted from the repository but not their install rule.

Could someone please remove the bottom part of util/scan/Makefile (from 
line 31, 
http://linuxtv.org/hg/dvb-apps/file/d40083fff895/util/scan/Makefile#l31) 
to fix this issue?

Thanks,

-- 

Quentin “Sardem FF7” Glidic
