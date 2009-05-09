Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.tut.by ([195.137.160.40]:32941 "EHLO
	cluster-ldap.tutby.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753174AbZEIVHb (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 9 May 2009 17:07:31 -0400
From: "Igor M. Liplianin" <liplianin@tut.by>
To: linux-media@vger.kernel.org, "Jan D. Louw" <jd.louw@mweb.co.za>
Subject: zl10039 (ce5039) status
Date: Sun, 10 May 2009 00:07:20 +0300
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <200905100007.20983.liplianin@tut.by>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I have TeVii S630 USB device.
It uses ce6313(support is in mt312 driver) and ce5039 (support from Jan D. Louw 
http://www.linuxtv.org/pipermail/linux-dvb/2007-December/022569.html)

So, with little changes in order to accommodate ce6313 and ce5039, dw2102 driver works well for 
TeVii S630 card.

-- 
Igor M. Liplianin
Microsoft Windows Free Zone - Linux used for all Computing Tasks
