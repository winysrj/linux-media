Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtpout27.attiva.biz ([85.37.16.28]:1757 "EHLO
	smtpout27.attiva.biz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755548AbZJZKpm (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 26 Oct 2009 06:45:42 -0400
Message-ID: <4AE57DD5.8030706@veneto.com>
Date: Mon, 26 Oct 2009 11:45:41 +0100
From: Massimo Del Fedele <max@veneto.com>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: Hint request for driver change
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

I'm trying to support the analog part of Pinnacle PCTV310e, which is an
ULI M9207 based card; by now I added the support for the digital side
patching the M920x driver; in order to add the analog part the driver
should be almost completely rewritten, and it'll take more source files,
so it should have a separate folder.
Shall I make a new driver (with different name, as m920x-new) or simply
remove old one and add the new ?

Ciao

Max

