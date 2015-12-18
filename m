Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f42.google.com ([74.125.82.42]:36960 "EHLO
	mail-wm0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932582AbbLRO3b (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 18 Dec 2015 09:29:31 -0500
Received: by mail-wm0-f42.google.com with SMTP id p187so66898335wmp.0
        for <linux-media@vger.kernel.org>; Fri, 18 Dec 2015 06:29:30 -0800 (PST)
From: Jemma Denson <jdenson@gmail.com>
To: mchehab@osg.samsung.com
Cc: linux-media@vger.kernel.org
Subject: Patches to dvbv5-zap
Date: Fri, 18 Dec 2015 14:28:22 +0000
Message-Id: <1450448906-17000-1-git-send-email-jdenson@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch series replaces the single patch sent earlier today. Essentially
it's to allow -t to be used at the same time as -x. We have a requirement
to show signal stats in a web interface and a lack of timeout would cause
issues when there's no signal.

The other patches are fixing bugs I noticed in adding this and then
simplifying the code slightly.

