Return-path: <linux-media-owner@vger.kernel.org>
Received: from rouge.crans.org ([138.231.136.3]:52692 "EHLO rouge.crans.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759217AbZJGUFI (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 7 Oct 2009 16:05:08 -0400
Received: from localhost (localhost.crans.org [127.0.0.1])
	by rouge.crans.org (Postfix) with ESMTP id 9880483A0
	for <linux-media@vger.kernel.org>; Wed,  7 Oct 2009 21:37:06 +0200 (CEST)
Received: from rouge.crans.org ([10.231.136.3])
	by localhost (rouge.crans.org [10.231.136.3]) (amavisd-new, port 10024)
	with LMTP id GNS73OyYEJxx for <linux-media@vger.kernel.org>;
	Wed,  7 Oct 2009 21:37:06 +0200 (CEST)
Received: from [192.168.1.10] (64.pool85-50-72.dynamic.orange.es [85.50.72.64])
	(using SSLv3 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by rouge.crans.org (Postfix) with ESMTP id 0474A807D
	for <linux-media@vger.kernel.org>; Wed,  7 Oct 2009 21:37:05 +0200 (CEST)
Message-ID: <4ACCEDDF.7060306@crans.ens-cachan.fr>
Date: Wed, 07 Oct 2009 21:37:03 +0200
From: DUBOST Brice <dubost@crans.ens-cachan.fr>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: MuMuDVB 1.6
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello

I think this could interest some persons on this list

MuMuDVB 1.6 is out. MuMuDVB is a DVB streaming software with low memory
and CPU footprint.

The main goal of MuMuDVB is to split a full transponder over several
Mulitcast Group (each one correspondig to one channel/service)

MuMuDVB is able to stream in Multicast or in HTTP unicast. It supports
scrambled channels via CAM modules (using the libdvben50221), it is able
to find automatically the channels in the transponder. It is also able
to rewrite the PAT PID for better compatibility with set top boxes.

This version is the first to include the support for HTTP unicast and
improves the overall stability.

All ideas/comments are welcome (mumudvb at braice dot net)

MuMuDVB main site : http://mumudvb.braice.net

Regards

-- 
Brice

A: Yes.
>Q: Are you sure?
>>A: Because it reverses the logical flow of conversation.
>>>Q: Why is top posting annoying in email?
