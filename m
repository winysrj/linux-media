Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.openmailbox.org ([62.4.1.34]:39247 "EHLO
	mail.openmailbox.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932146AbbBBSCo (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 2 Feb 2015 13:02:44 -0500
Received: from localhost (localhost [127.0.0.1])
	by mail.openmailbox.org (Postfix) with ESMTP id 0D1CC2E01C0
	for <linux-media@vger.kernel.org>; Mon,  2 Feb 2015 18:55:31 +0100 (CET)
Received: from mail.openmailbox.org ([62.4.1.34])
	by localhost (mail.openmailbox.org [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id K7xeU7Y8Dfej for <linux-media@vger.kernel.org>;
	Mon,  2 Feb 2015 18:55:29 +0100 (CET)
Message-ID: <54CFBA0E.205@openmailbox.org>
Date: Mon, 02 Feb 2015 17:55:26 +0000
From: Kyle Dominguez <kpd@openmailbox.org>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: libv4l
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

When trying to build libv4l, it fails because I don't have the 
dependencies for v4l1. Is it possibe to make libv4l without having 
videodev.h? I only want the v4l2 parts, to which I have videodev2.h.

Thanks,

kpd
