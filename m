Return-path: <linux-media-owner@vger.kernel.org>
Received: from znsun1.ifh.de ([141.34.1.16]:45838 "EHLO znsun1.ifh.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752413AbZISKtn (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 19 Sep 2009 06:49:43 -0400
Date: Sat, 19 Sep 2009 12:49:39 +0200 (CEST)
From: Patrick Boettcher <pboettcher@kernellabs.com>
To: Edward Sheldrake <ejs1920@yahoo.co.uk>
cc: linux-media@vger.kernel.org
Subject: Re: Leadtek/Terratec usb id mixup in hg 12889
In-Reply-To: <195772.10046.qm@web28511.mail.ukl.yahoo.com>
Message-ID: <alpine.LRH.1.10.0909191249110.9214@pub5.ifh.de>
References: <195772.10046.qm@web28511.mail.ukl.yahoo.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, 18 Sep 2009, Edward Sheldrake wrote:

> With latest hg (12994), my "Leadtek Winfast DTV Dongle (STK7700P based)" (0413:6f01) gets detected as a "Terratec Cinergy T USB XXS (HD)".
>
> I think "&dib0700_usb_id_table[34]" (the leadtek) got moved by mistake, but "&dib0700_usb_id_table[33]" (a terratec) should have been moved instead (in changeset 12889).
>
> hg 12889: http://linuxtv.org/hg/v4l-dvb/rev/cec94ceb4f54

Argl!

Very well spotted.

Can you please check if this patch fixes it correctly?

http://www.kernellabs.com/hg/~pboettcher/v4l-dvb/

Thanks,
--

Patrick Boettcher - Kernel Labs
http://www.kernellabs.com/
