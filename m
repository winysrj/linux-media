Return-path: <linux-media-owner@vger.kernel.org>
Received: from lo.gmane.org ([80.91.229.12]:45355 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751308Ab0BPM1f (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 16 Feb 2010 07:27:35 -0500
Received: from list by lo.gmane.org with local (Exim 4.69)
	(envelope-from <gldv-linux-media@m.gmane.org>)
	id 1NhMWb-0000ZW-1k
	for linux-media@vger.kernel.org; Tue, 16 Feb 2010 13:27:33 +0100
Received: from 80-218-69-65.dclient.hispeed.ch ([80.218.69.65])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Tue, 16 Feb 2010 13:27:33 +0100
Received: from auslands-kv by 80-218-69-65.dclient.hispeed.ch with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Tue, 16 Feb 2010 13:27:33 +0100
To: linux-media@vger.kernel.org
From: Michael <auslands-kv@gmx.de>
Subject: Re: tw68: Congratulations :-) and possible vsync problem :-(
Date: Tue, 16 Feb 2010 13:27:15 +0100
Message-ID: <hle2v2$kll$1@ger.gmane.org>
References: <hldpqq$nfn$1@ger.gmane.org> <hldrkq$t7v$1@ger.gmane.org> <hldtno$41u$1@ger.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7Bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Here is some more info:

I loaded the module with option core_debug=15.

When I run with low CPU load (vx driver), I get the following log lines:

[10261.346087] tw6804[0]: tw68_buffer_queue: queuing buffer cd7bb3c0
[10261.346087] tw6804[0]: tw68_buffer_queue: [cd7bb3c0/0] first active
[10261.346087] tw6804[0]: tw68_buffer_queue: queuing buffer cc91b260
[10261.346087] tw6804[0]: tw68_buffer_queue: [cc91b260/1] appended to active
[10261.393852] tw6804[0]: tw68_wakeup: [cd7bb3c0/0] field_count=293
[10261.397831] tw6804[0]: tw68_buffer_queue: queuing buffer cd7bb3c0
[10261.397831] tw6804[0]: tw68_buffer_queue: [cd7bb3c0/0] appended to active
[10261.433849] tw6804[0]: tw68_wakeup: [cc91b260/1] field_count=294
[10261.437823] tw6804[0]: tw68_buffer_queue: queuing buffer cc91b260
[10261.437823] tw6804[0]: tw68_buffer_queue: [cc91b260/1] appended to active
[10261.473839] tw6804[0]: tw68_wakeup: [cd7bb3c0/0] field_count=295
[10261.477415] tw6804[0]: tw68_buffer_queue: queuing buffer cd7bb3c0
[10261.477415] tw6804[0]: tw68_buffer_queue: [cd7bb3c0/0] appended to active
[10261.511590] tw6804[0]: tw68_wakeup: [cc91b260/1] field_count=296
[10261.518421] tw6804[0]: tw68_buffer_queue: queuing buffer cc91b260
[10261.518421] tw6804[0]: tw68_buffer_queue: [cc91b260/1] appended to active
[10261.552610] tw6804[0]: tw68_wakeup: [cd7bb3c0/0] field_count=297
[10261.577131] tw6804[0]: tw68_buffer_queue: queuing buffer cd7bb3c0
[10261.577158] tw6804[0]: tw68_buffer_queue: [cd7bb3c0/0] appended to active
[10261.593610] tw6804[0]: tw68_wakeup: [cc91b260/1] field_count=298
[10261.599735] tw6804[0]: tw68_buffer_queue: queuing buffer cc91b260
[10261.599759] tw6804[0]: tw68_buffer_queue: [cc91b260/1] appended to active
[10261.633812] tw6804[0]: tw68_wakeup: [cd7bb3c0/0] field_count=299
[10261.637784] tw6804[0]: tw68_buffer_queue: queuing buffer cd7bb3c0
[10261.637784] tw6804[0]: tw68_buffer_queue: [cd7bb3c0/0] appended to active
[10261.673804] tw6804[0]: tw68_wakeup: [cc91b260/1] field_count=300
[10261.677776] tw6804[0]: tw68_buffer_queue: queuing buffer cc91b260
[10261.677776] tw6804[0]: tw68_buffer_queue: [cc91b260/1] appended to active

Very regular, just one "first active".

With high CPU load (x11 driver) I get:

[10066.494080] tw6804[0]: tw68_buffer_queue: queuing buffer cd7bb3c0
[10066.494080] tw6804[0]: tw68_buffer_queue: [cd7bb3c0/0] first active
[10066.548758] tw6804[0]: tw68_buffer_queue: queuing buffer cd7bb600
[10066.548758] tw6804[0]: tw68_buffer_queue: [cd7bb600/1] appended to active
[10066.552054] tw6804[0]: tw68_wakeup: [cd7bb3c0/0] field_count=173
[10066.589772] tw6804[0]: tw68_wakeup: [cd7bb600/1] field_count=174
[10066.596604] tw6804[0]: tw68_buffer_queue: queuing buffer cd7bb3c0
[10066.596604] tw6804[0]: tw68_buffer_queue: [cd7bb3c0/0] first active
[10066.630773] tw6804[0]: tw68_wakeup: [cd7bb3c0/0] field_count=175
[10066.658108] tw6804[0]: tw68_buffer_queue: queuing buffer cd7bb600
[10066.658108] tw6804[0]: tw68_buffer_queue: [cd7bb600/1] first active
[10066.712033] tw6804[0]: tw68_wakeup: [cd7bb600/1] field_count=176
[10066.726463] tw6804[0]: tw68_buffer_queue: queuing buffer cd7bb3c0
[10066.726463] tw6804[0]: tw68_buffer_queue: [cd7bb3c0/0] first active
[10066.752027] tw6804[0]: tw68_wakeup: [cd7bb3c0/0] field_count=177
[10066.781142] tw6804[0]: tw68_buffer_queue: queuing buffer cd7bb600
[10066.781142] tw6804[0]: tw68_buffer_queue: [cd7bb600/1] first active
[10066.832009] tw6804[0]: tw68_wakeup: [cd7bb600/1] field_count=178
[10066.835821] tw6804[0]: tw68_buffer_queue: queuing buffer cd7bb3c0
[10066.835821] tw6804[0]: tw68_buffer_queue: [cd7bb3c0/0] first active
[10066.869996] tw6804[0]: tw68_wakeup: [cd7bb3c0/0] field_count=179
[10066.890493] tw6804[0]: tw68_buffer_queue: queuing buffer cd7bb600
[10066.890493] tw6804[0]: tw68_buffer_queue: [cd7bb600/1] first active
[10066.911006] tw6804[0]: tw68_wakeup: [cd7bb600/1] field_count=180
[10066.945177] tw6804[0]: tw68_buffer_queue: queuing buffer cd7bb3c0
[10066.945177] tw6804[0]: tw68_buffer_queue: [cd7bb3c0/0] first active
[10066.991979] tw6804[0]: tw68_wakeup: [cd7bb3c0/0] field_count=181
[10066.999859] tw6804[0]: tw68_buffer_queue: queuing buffer cd7bb600
[10066.999859] tw6804[0]: tw68_buffer_queue: [cd7bb600/1] first active
[10067.031973] tw6804[0]: tw68_wakeup: [cd7bb600/1] field_count=182
[10067.061365] tw6804[0]: tw68_buffer_queue: queuing buffer cd7bb3c0
[10067.061365] tw6804[0]: tw68_buffer_queue: [cd7bb3c0/0] first active
[10067.109211] tw6804[0]: tw68_buffer_queue: queuing buffer cd7bb600
[10067.109211] tw6804[0]: tw68_buffer_queue: [cd7bb600/1] appended to active
[10067.109211] tw6804[0]: tw68_wakeup: [cd7bb3c0/0] field_count=183
[10067.150229] tw6804[0]: tw68_wakeup: [cd7bb600/1] field_count=184
[10067.170720] tw6804[0]: tw68_buffer_queue: queuing buffer cd7bb3c0

Strongly irregular, many "first active", sometimes two "field counts" after 
each other.

Hope this helps.

Michael

