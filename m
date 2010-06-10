Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp1.goneo.de ([82.100.220.80]:22281 "EHLO smtp1.goneo.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759123Ab0FJRyG (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 10 Jun 2010 13:54:06 -0400
Received: from smtp1.goneo.de (localhost [127.0.0.1])
	by scan.goneo.de (Postfix) with ESMTP id 2BD4C3A3896
	for <linux-media@vger.kernel.org>; Thu, 10 Jun 2010 19:47:10 +0200 (CEST)
Received: from smtp1.goneo.de ([127.0.0.1])
	by smtp1.goneo.de (smtp1.goneo.de [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id bVUQEgQU2B5E for <linux-media@vger.kernel.org>;
	Thu, 10 Jun 2010 19:46:57 +0200 (CEST)
Received: from mctrus1.localnet (99.a2c-250-229.astra2connect.com [92.250.229.99])
	by smtp1.goneo.de (Postfix) with ESMTPSA id B4B053A390C
	for <linux-media@vger.kernel.org>; Thu, 10 Jun 2010 19:46:55 +0200 (CEST)
From: Tobias Trus <trus@elnrode.de>
To: linux-media@vger.kernel.org
Subject: No frontend0 for Technotrend Budget 3200
Date: Thu, 10 Jun 2010 19:46:43 +0200
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201006101946.43691.trus@elnrode.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

I've got a Technotrend Budget 3200 installed in my Kubuntu Lucid (10.04) 
machine. It worked fine out of the box. Because I want to watch a broadcast and 
record another one at the same time I bought another DVB-Card. This time I 
bought a Technisat Skystar HD2 because with the TT Budget I've problems 
getting a lock on some channels.

To getting the Technisat SkyStar HD2 work I compiled and installed the actual 
v4l-dvb-drivers using hg clone http://linuxtv.org/hg/v4l-dvb.

Now the Technisat worked fine but the frontend0-entry for the Technotrend is 
missing. Does anybody know how to fix it?

best regards
Tobias
