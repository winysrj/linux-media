Return-path: <linux-media-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.25]:56160 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761451AbZCCWMi (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 3 Mar 2009 17:12:38 -0500
Received: by ey-out-2122.google.com with SMTP id 25so649008eya.37
        for <linux-media@vger.kernel.org>; Tue, 03 Mar 2009 14:12:34 -0800 (PST)
Message-ID: <49ADAB54.5020004@gmail.com>
Date: Tue, 03 Mar 2009 23:12:36 +0100
From: Roel Kluin <roel.kluin@gmail.com>
MIME-Version: 1.0
To: mchehab@redhat.com
CC: linux-media@vger.kernel.org
Subject: V4L/DVB: dvb_dmx_swfilter_section_copy_dump() assignment or addition?
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

vi drivers/media/dvb/dvb-core/dvb_demux.c +214

and note:

static int dvb_dmx_swfilter_section_copy_dump(struct dvb_demux_feed *feed,
                                              const u8 *buf, u8 len)
{
	...
        if (sec->tsfeedp + len > DMX_MAX_SECFEED_SIZE) {
		...
                len = DMX_MAX_SECFEED_SIZE - sec->tsfeedp;
		    ^------------shouldn't this be '+='?
        }

	if (len <= 0)
                return 0;

Also note: len cannot be less than 0 since it's an u8.
