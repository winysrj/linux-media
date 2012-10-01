Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f172.google.com ([209.85.212.172]:60185 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750822Ab2JAHeE (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 1 Oct 2012 03:34:04 -0400
Received: by mail-wi0-f172.google.com with SMTP id hq12so2308320wib.1
        for <linux-media@vger.kernel.org>; Mon, 01 Oct 2012 00:34:02 -0700 (PDT)
From: Patrick Boettcher <pboettcher@kernellabs.com>
To: linux-media@vger.kernel.org
Subject: [media/usb] Trivial fix for 3.7 if not too late
Date: Mon,  1 Oct 2012 09:33:52 +0200
Message-Id: <1349076833-1864-1-git-send-email-pboettcher@kernellabs.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,


If it is not too late could you please incorporate the following patch to 3.7.

It fixed the autoloading of the technisat-ubs2-module when the device is actually detected.

- [PATCH] [media]: add MODULE_DEVICE_TABLE to technisat-usb2

best regards,

--
Patrick.
-
