Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.gentoo.org ([140.211.166.183]:47506 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751745AbaGVFdf (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 22 Jul 2014 01:33:35 -0400
Received: from [192.168.178.22] (host-188-174-204-36.customer.m-online.net [188.174.204.36])
	(using TLSv1 with cipher ECDHE-RSA-AES128-SHA (128/128 bits))
	(No client certificate requested)
	(Authenticated sender: zzam)
	by smtp.gentoo.org (Postfix) with ESMTPSA id D31463400A0
	for <linux-media@vger.kernel.org>; Tue, 22 Jul 2014 05:33:33 +0000 (UTC)
Message-ID: <53CDF7A7.8080005@gentoo.org>
Date: Tue, 22 Jul 2014 07:33:27 +0200
From: Matthias Schwarzott <zzam@gentoo.org>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Different Devices identical hardware
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

I want to add support for Hauppauge WinTV 930C-HD and PCTV QuatroStick 521e.
The namess and USB-IDs are different, but the hardware is the same.

Should there be in this case one card entry in cx231xx driver or two?
Two would have the advantage that the correct name of the device could
be displayed, but some code related to the card entry would be duplicated.

Regards
Matthias
