Return-path: <linux-media-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:48206 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751247AbbJDJaI (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 4 Oct 2015 05:30:08 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gldv-linux-media@m.gmane.org>)
	id 1ZifcL-00046k-Gz
	for linux-media@vger.kernel.org; Sun, 04 Oct 2015 11:30:05 +0200
Received: from 92.243.181.209 ([92.243.181.209])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Sun, 04 Oct 2015 11:30:05 +0200
Received: from matwey.kornilov by 92.243.181.209 with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Sun, 04 Oct 2015 11:30:05 +0200
To: linux-media@vger.kernel.org
From: "Matwey V. Kornilov" <matwey.kornilov@gmail.com>
Subject: v4l2 api: supported resolution negotiation
Date: Sun, 4 Oct 2015 12:23:08 +0300
Message-ID: <muqr5s$f1j$2@ger.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

I learned from V2L2 API how to detect all supported formats using
VIDIOC_ENUM_FMT.
When I perform VIDIOC_S_FMT I don't know how to fill fmt.pix.width and
fmt.pix.height, since I know only format.
How should I negotiate device resolution? Could you point me?

