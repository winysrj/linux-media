Return-path: <linux-media-owner@vger.kernel.org>
Received: from 99-34-136-231.lightspeed.bcvloh.sbcglobal.net ([99.34.136.231]:48163
	"EHLO desource.dyndns.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756410Ab0EERhR (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 5 May 2010 13:37:17 -0400
Received: from root by desource.dyndns.org with local (Exim 4.71)
	(envelope-from <root@desource.dyndns.org>)
	id 1O9i2Q-0005mW-DD
	for linux-media@vger.kernel.org; Wed, 05 May 2010 13:05:34 -0400
From: David Ellingsworth <david@identd.dyndns.org>
To: linux-media@vger.kernel.org
Subject: [PATCH/RFC 0/7] dsbr100: driver cleanup
Date: Wed,  5 May 2010 13:05:23 -0400
Message-Id: <1273079130-21999-1-git-send-email-david@identd.dyndns.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch series addresses several issues in the dsbr100 driver.
This series is based on the v4l-dvb master git branch and has been
compile tested only. It should be tested before applying.

The following patches are included in this series:
   [PATCH/RFC 1/7] dsbr100: implement proper locking
   [PATCH/RFC 2/7] dsbr100: fix potential use after free
   [PATCH/RFC 3/7] dsbr100: only change frequency upon success
   [PATCH/RFC 4/7] dsbr100: remove disconnected indicator
   [PATCH/RFC 5/7] dsbr100: properly initialize the radio
   [PATCH/RFC 6/7] dsbr100: cleanup usb probe routine
   [PATCH/RFC 7/7] dsbr100: simplify access to radio device

Regards,

David Ellingsworth
