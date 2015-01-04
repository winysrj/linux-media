Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtpfb1-g21.free.fr ([212.27.42.9]:34988 "EHLO
	smtpfb1-g21.free.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752563AbbADM1u (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 4 Jan 2015 07:27:50 -0500
Received: from smtp1-g21.free.fr (smtp1-g21.free.fr [212.27.42.1])
	by smtpfb1-g21.free.fr (Postfix) with ESMTP id A3B2777DB1B
	for <linux-media@vger.kernel.org>; Sun,  4 Jan 2015 13:27:46 +0100 (CET)
From: Romain Naour <romain.naour@openwide.fr>
To: linux-media@vger.kernel.org
Cc: Romain Naour <romain.naour@openwide.fr>
Subject: [PATCH 0/3] dvb-apps: Buildroot patches
Date: Sun,  4 Jan 2015 13:27:34 +0100
Message-Id: <1420374457-8633-1-git-send-email-romain.naour@openwide.fr>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This series contains several patches for dvb-apps to fixes
some cross-compilation/toolchain issues and add the ability
to disable static/shared libraries.

Arnout Vandecappelle (Essensium/Mind) (1):
  Fix generate-keynames.sh script for cross-compilation

Romain Naour (1):
  Make.rules: Handle static/shared only build

Simon Dawson (1):
  When building for avr32, the build fails as follows.

 Make.rules                                | 8 +++++++-
 util/av7110_loadkeys/generate-keynames.sh | 4 ++--
 util/scan/Makefile                        | 2 +-
 3 files changed, 10 insertions(+), 4 deletions(-)

-- 
1.9.3

