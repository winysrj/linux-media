Return-path: <linux-media-owner@vger.kernel.org>
Received: from dell.nexicom.net ([216.168.96.13]:37391 "EHLO smtp.nexicom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753316Ab2HZWjy (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 26 Aug 2012 18:39:54 -0400
Received: from mail.lockie.ca (dyn-dsl-mb-216-168-121-163.nexicom.net [216.168.121.163])
	by smtp.nexicom.net (8.13.6/8.13.4) with ESMTP id q7QMdqVI007311
	for <linux-media@vger.kernel.org>; Sun, 26 Aug 2012 18:39:53 -0400
Received: from [192.168.1.102] (69-196-139-35.dsl.teksavvy.com [69.196.139.35])
	(using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mail.lockie.ca (Postfix) with ESMTPSA id 6EEB01E006F
	for <linux-media@vger.kernel.org>; Sun, 26 Aug 2012 18:39:52 -0400 (EDT)
Message-ID: <503AA5B7.60704@lockie.ca>
Date: Sun, 26 Aug 2012 18:39:51 -0400
From: James <bjlockie@lockie.ca>
MIME-Version: 1.0
To: linux-media Mailing List <linux-media@vger.kernel.org>
Subject: patch idea
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


If the driver is built into kernel it causes a timeout because it relies on udev which is not initialized yet (that is the theory).
Regardless, the timeout is not needed except to load the firmware to provide analog reception.
I doubt anyone who compiles it in the kernel needs the firmware.

I think the following should make it into the kernel source:

drivers/media/video/cx25840/cx25840-core.c

#ifdef MODULE
        cx25840_loadfw(state->c);
#endif
