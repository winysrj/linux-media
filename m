Return-path: <linux-media-owner@vger.kernel.org>
Received: from ni.piap.pl ([195.187.100.4]:52884 "EHLO ni.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755167AbbGCMOj (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 3 Jul 2015 08:14:39 -0400
Received: from t19.piap.pl (OSB1819.piap.pl [10.0.9.19])
	by ni.piap.pl (Postfix) with ESMTP id 57C8F4411F9
	for <linux-media@vger.kernel.org>; Fri,  3 Jul 2015 14:14:37 +0200 (CEST)
From: khalasa@piap.pl (Krzysztof =?utf-8?Q?Ha=C5=82asa?=)
To: linux-media <linux-media@vger.kernel.org>
Subject: Video driver for Techwell TW686[4589]-based cards.
Date: Fri, 03 Jul 2015 14:14:37 +0200
Message-ID: <m3bnftphea.fsf@t19.piap.pl>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I'll be attaching a driver for Techwell/Intersil TW686[4589]-based video
frame grabbers. It's currently tested only with v4.0 (the system I'm
using this on has problems with v4.1) but it should apply and work with
"current" kernels (there might be a trivial conflict in Kconfig and/or
Makefile).

Fire away.
-- 
Krzysztof Halasa

Industrial Research Institute for Automation and Measurements PIAP
Al. Jerozolimskie 202, 02-486 Warsaw, Poland
