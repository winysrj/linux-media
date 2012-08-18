Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wg0-f44.google.com ([74.125.82.44]:61081 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751006Ab2HROTM (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 18 Aug 2012 10:19:12 -0400
Received: by wgbdr13 with SMTP id dr13so4140439wgb.1
        for <linux-media@vger.kernel.org>; Sat, 18 Aug 2012 07:19:10 -0700 (PDT)
Message-ID: <502FA46E.3050500@googlemail.com>
Date: Sat, 18 Aug 2012 16:19:26 +0200
From: =?ISO-8859-15?Q?Frank_Sch=E4fer?= <fschaefer.oss@googlemail.com>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: How to add new chip ids to v4l2-chip-ident.h ?
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

I would like to know how to add new chip ids to v4l2-chip-ident.h. Ist
there a kind of policy for choosing numbers ?
Which numbers would be approriate for the em25xx/em26xx/em27xx/em28xx
chips ?
Unfortunately 2700 is already used by V4L2_IDENT_VP27SMPX...

Regards,
Frank Schäfer


