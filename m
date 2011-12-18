Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:35789 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751371Ab1LRJtO (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 18 Dec 2011 04:49:14 -0500
Date: Sun, 18 Dec 2011 03:48:59 -0600
From: Jonathan Nieder <jrnieder@gmail.com>
To: David Fries <david@fries.net>
Cc: video4linux-list@redhat.com,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Istvan Varga <istvan_v@mailbox.hu>,
	linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
	Darron Broad <darron@kewl.org>,
	Steven Toth <stoth@kernellabs.com>
Subject: Re: [PATCH] cx88-dvb avoid dangling core->gate_ctrl pointer
Message-ID: <20111218094859.GA8243@elie.hsd1.il.comcast.net>
References: <20111215055920.GA3948@spacedout.fries.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111215055920.GA3948@spacedout.fries.net>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi David,

David Fries wrote:

> DVB: registering new adapter (cx88[0])
> DVB: registering adapter 0 frontend 0 (Oren OR51132 VSB/QAM Frontend)...
> cx88[0]: videobuf_dvb_register_frontend failed (errno = -12)
> cx88[0]/2: dvb_register failed (err = -12)
> cx88[0]/2: cx8802 probe failed, err = -12

Is CONFIG_DVB_NET enabled?  If not, does reverting fcc8e7d8c0e2
(dvb_net: Simplify the code if DVB NET is not defined, 2011-06-01)
help?

Thanks,
Jonathan
