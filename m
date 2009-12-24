Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-out.m-online.net ([212.18.0.10]:37383 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752191AbZLXWmO (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 24 Dec 2009 17:42:14 -0500
Received: from mail01.m-online.net (mail.m-online.net [192.168.3.149])
	by mail-out.m-online.net (Postfix) with ESMTP id 66F051C00207
	for <linux-media@vger.kernel.org>; Thu, 24 Dec 2009 23:42:12 +0100 (CET)
Received: from localhost (dynscan2.mnet-online.de [192.168.1.215])
	by mail.m-online.net (Postfix) with ESMTP id B0BA390310
	for <linux-media@vger.kernel.org>; Thu, 24 Dec 2009 23:42:12 +0100 (CET)
Received: from mail.mnet-online.de ([192.168.3.149])
	by localhost (dynscan2.mnet-online.de [192.168.1.215]) (amavisd-new, port 10024)
	with ESMTP id DMi03CDRTZFp for <linux-media@vger.kernel.org>;
	Thu, 24 Dec 2009 23:42:11 +0100 (CET)
Received: from [192.168.1.5] (ppp-88-217-19-215.dynamic.mnet-online.de [88.217.19.215])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mail.mnet-online.de (Postfix) with ESMTP
	for <linux-media@vger.kernel.org>; Thu, 24 Dec 2009 23:42:11 +0100 (CET)
Message-ID: <4B33EE3E.5060201@a-city.de>
Date: Thu, 24 Dec 2009 23:42:06 +0100
From: TAXI <taxi@a-city.de>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: Feature Request: virtual /dev/videoX for low budget DVB cards
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

What about a virtual /dev/videoX for low budget DVB cards?
The idea behind is to provide a device set with every type of card (low
budget, full featured) so that for example tvtime works with every type
of card.

The virtual device could be made by the following way:
kernel driver (low budget, DVB-Decoded) -> kernel/userspace linker ->
userspace decoder -> kernel/userspace linker -> kernel-driver (low
budget, DVB-Encoded)

I'm not a developer so (maybe) that's just a stupid idea.
