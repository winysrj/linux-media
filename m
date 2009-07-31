Return-path: <linux-media-owner@vger.kernel.org>
Received: from fmmailgate01.web.de ([217.72.192.221]:56957 "EHLO
	fmmailgate01.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751003AbZGaIj6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 31 Jul 2009 04:39:58 -0400
Received: from smtp05.web.de (fmsmtp05.dlan.cinetic.de [172.20.4.166])
	by fmmailgate01.web.de (Postfix) with ESMTP id 478AE10F0C207
	for <linux-media@vger.kernel.org>; Fri, 31 Jul 2009 10:39:58 +0200 (CEST)
Received: from [217.228.167.87] (helo=[172.16.99.2])
	by smtp05.web.de with asmtp (TLSv1:AES256-SHA:256)
	(WEB.DE 4.110 #277)
	id 1MWneg-0007Um-00
	for linux-media@vger.kernel.org; Fri, 31 Jul 2009 10:39:58 +0200
Message-ID: <4A72ADDB.9010209@magic.ms>
Date: Fri, 31 Jul 2009 10:39:55 +0200
From: emagick@magic.ms
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: Re: Cinergy T2 stopped working with kernel 2.6.30
References: <4A61FD76.8010409@magic.ms>
In-Reply-To: <4A61FD76.8010409@magic.ms>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I've added dummy 32-bit variables to dvb_frontend_swzigzag_autotune() to change the
frame size. Here are the results for mythweb (can tune/cannot tune):

#variables     i486       i586
  0             ok         failure
  1             failure    ok
  2             ok         ok
  3             failure    failure
  4             failure    ok
  5             ok         ok
  6             ok         ok
  7             ok         ok
  8             ok         failure
  9             failure    ok
10             ok         ok
11             ok         failure
12             failure    ok
13             ok         ok
14             ok         ok
15             ok         ok
16             ok         ok
17             ok         ok
18             ok         failure
19             ok         failure
20             failure    ok

There's a pattern with some exceptions. Could be an alignment-related problem.

Anyone listening?

