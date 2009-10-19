Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:13351 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751176AbZJSMfl (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 19 Oct 2009 08:35:41 -0400
Received: from eu_spt2 (mailout1.w1.samsung.com [210.118.77.11])
 by mailout1.w1.samsung.com
 (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTP id <0KRR001WCH6U4H@mailout1.w1.samsung.com> for
 linux-media@vger.kernel.org; Mon, 19 Oct 2009 13:25:42 +0100 (BST)
Received: from linux.samsung.com ([106.116.38.10])
 by spt2.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0KRR00CCRH6U6S@spt2.w1.samsung.com> for
 linux-media@vger.kernel.org; Mon, 19 Oct 2009 13:25:42 +0100 (BST)
Date: Mon, 19 Oct 2009 14:24:01 +0200
From: Tomasz Fujak <t.fujak@samsung.com>
Subject: RE: [RFC] Video events, version 2.1
In-reply-to: <4AD877A0.3080004@maxwell.research.nokia.com>
To: 'Sakari Ailus' <sakari.ailus@maxwell.research.nokia.com>,
	linux-media@vger.kernel.org
Cc: 'Laurent Pinchart' <laurent.pinchart@ideasonboard.com>,
	'Hans Verkuil' <hverkuil@xs4all.nl>,
	"'Zutshi Vimarsh (Nokia-D-MSW/Helsinki)'" <vimarsh.zutshi@nokia.com>,
	'Ivan Ivanov' <iivanov@mm-sol.com>,
	'Cohen David Abraham' <david.cohen@nokia.com>,
	'Guru Raj' <gururaj.nagendra@intel.com>, mkrufky@hauppauge.com,
	dheitmueller@kernellabs.org
Message-id: <004301ca50b7$0a02e6c0$1e08b440$%fujak@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-language: pl
Content-transfer-encoding: 7BIT
References: <4AD877A0.3080004@maxwell.research.nokia.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

The event count may be useful for the reason Laurent mentioned. In case we
don't have dequeue multiple (DQEVENT_MULTIPLE?) a flag should be enough,
saying if there are any events immediately available. That'd be just one bit
we could mash into the 'type' field.

On the other hand I can imagine an event type that come swarming once a
client registers to them (i.e.: VSYNC). In such a case they may overflow a
queue and discard potentially useful events (i.e.: a cable detached from the
output). We could do one of the following:
 - nothing (let the above happen if the application is not fast enough to
retrieve events),
 - suggest using separate event feed for periodic events,
 - compress periodic events (provide 'compressed' flag, and stamp the event
with the timestamp of the last of the kind) - thus at most one of a periodic
event type would reside in the queue,
 - let the client define the window size,
 - define event priorities (low, normal, high) and discard overflowing
events starting with the lowest priorities. I.e.: low for VSYNC, normal for
picture decoding error and high for cable attach

Third, the event subscription scheme. What does a subscription call mean:
"Add these new events to what I already collect" or "Discard whatever I have
subscribed for and now give me this"?
In the latter use, there are just 27 event types available; can't tell if
that's enough till we try to enumerate the event types we currently have.
I've just seen a few of them (DVB, UVC, ACPI), but I think the list would
grow once people start using the v4l2 events. How big is it going to be?
 
Best regards
-- 
Tomasz Fujak


