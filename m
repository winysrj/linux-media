Return-path: <linux-media-owner@vger.kernel.org>
Received: from lo.gmane.org ([80.91.229.12]:51944 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752190AbZLZVMm (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 26 Dec 2009 16:12:42 -0500
Received: from list by lo.gmane.org with local (Exim 4.50)
	id 1NOdwE-00013V-JC
	for linux-media@vger.kernel.org; Sat, 26 Dec 2009 22:12:38 +0100
Received: from cpc4-dals10-0-0-cust795.hari.cable.virginmedia.com ([92.234.3.28])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Sat, 26 Dec 2009 22:12:38 +0100
Received: from mariofutire by cpc4-dals10-0-0-cust795.hari.cable.virginmedia.com with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Sat, 26 Dec 2009 22:12:38 +0100
To: linux-media@vger.kernel.org
From: Andrea <mariofutire@googlemail.com>
Subject: Error using PWC on a PS3
Date: Sat, 26 Dec 2009 21:12:15 +0000
Message-ID: <hh5u7f$km0$1@ger.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

I've tried to attach my Logitech, Inc. QuickCam Pro 4000 to a PS3 running Fedora 12.

I get this error in dmesg

pwc: Failed to set video mode QSIF@10 fps; return code = -110

Everything works well on a standard x86 laptop running Fedora 11.

Anybody has an idea why a different architecture could affect pwc?
I don't know, problems with little/big endian?

