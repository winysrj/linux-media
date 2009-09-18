Return-path: <linux-media-owner@vger.kernel.org>
Received: from web28511.mail.ukl.yahoo.com ([87.248.110.190]:42210 "HELO
	web28511.mail.ukl.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1757521AbZIRSof convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 18 Sep 2009 14:44:35 -0400
Message-ID: <195772.10046.qm@web28511.mail.ukl.yahoo.com>
Date: Fri, 18 Sep 2009 11:37:56 -0700 (PDT)
From: Edward Sheldrake <ejs1920@yahoo.co.uk>
Subject: Leadtek/Terratec usb id mixup in hg 12889
To: linux-media@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

With latest hg (12994), my "Leadtek Winfast DTV Dongle (STK7700P based)" (0413:6f01) gets detected as a "Terratec Cinergy T USB XXS (HD)".

I think "&dib0700_usb_id_table[34]" (the leadtek) got moved by mistake, but "&dib0700_usb_id_table[33]" (a terratec) should have been moved instead (in changeset 12889).

hg 12889: http://linuxtv.org/hg/v4l-dvb/rev/cec94ceb4f54


Send instant messages to your online friends http://uk.messenger.yahoo.com 
