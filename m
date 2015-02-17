Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:33094 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754742AbbBQNx2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 17 Feb 2015 08:53:28 -0500
From: David Howells <dhowells@redhat.com>
In-Reply-To: <28064.1424180750@warthog.procyon.org.uk>
References: <28064.1424180750@warthog.procyon.org.uk> <20150217095705.6b317321@recife.lan> <20150216153307.19963.61947.stgit@warthog.procyon.org.uk>
Cc: dhowells@redhat.com,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	mkrufky@linuxtv.org, linux-media@vger.kernel.org
Subject: Re: [PATCH] cxusb: Use enum to represent table offsets rather than hard-coding numbers
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <7663.1424181168.1@warthog.procyon.org.uk>
Content-Transfer-Encoding: 8BIT
Date: Tue, 17 Feb 2015 13:52:48 +0000
Message-ID: <7664.1424181168@warthog.procyon.org.uk>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

David Howells <dhowells@redhat.com> wrote:

> That should really be:
> 
> 	[VID_MEDION_MD95700] = {USB_VID_MEDION,	USB_PID_MEDION_MD95700},
> 
> since the index number is the model, not the vendor, which brings me to:
> 
> 	[DVICO_BLUEBIRD_DVB_T_NANO_2_NFW_WARM] = {USB_VID_DVICO, USB_PID_DVICO_BLUEBIRD_DVB_T_NANO_2_NFW_WARM},
> 
> which would be excessively long.

In fact, they're both wrong, since there needs to be a USB_DEVICE() wrapper.

David
