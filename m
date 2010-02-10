Return-path: <linux-media-owner@vger.kernel.org>
Received: from tichy.grunau.be ([85.131.189.73]:58943 "EHLO tichy.grunau.be"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756328Ab0BJSkF (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 10 Feb 2010 13:40:05 -0500
Received: from localhost (p5DDC401F.dip0.t-ipconnect.de [93.220.64.31])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by tichy.grunau.be (Postfix) with ESMTPSA id C18E09005C
	for <linux-media@vger.kernel.org>; Wed, 10 Feb 2010 19:34:19 +0100 (CET)
Date: Wed, 10 Feb 2010 19:35:54 +0100
From: Janne Grunau <j@jannau.net>
To: linux-media@vger.kernel.org
Subject: [PATCH 0 of 7] Implement -p in all zap programs
Message-ID: <20100210183554.GK8026@aniel.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

this patch series implements -p (record PAT and PMT) for [act]zap
and a couple of related cleanups.

Janne

 b/util/szap/util.c |  126 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 b/util/szap/util.h |   24 ++++++++++
 util/szap/Makefile |    2
 util/szap/azap.c   |   72 ++++++++++++++++--------------
 util/szap/czap.c   |   91 ++++++++++++++++++++++----------------
 util/szap/szap.c   |   97 ++--------------------------------------
 util/szap/tzap.c   |   73 +++++++++++++++++-------------
 7 files changed, 291 insertions(+), 194 deletions(-)

