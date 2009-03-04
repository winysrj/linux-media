Return-path: <linux-media-owner@vger.kernel.org>
Received: from ryu.zarb.org ([212.85.158.22]:45580 "EHLO ryu.zarb.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756160AbZCDTxO (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 4 Mar 2009 14:53:14 -0500
Subject: Re: [hg:v4l-dvb] Add ids for Yuan PD378S DVB adapter
From: Pascal Terjan <pterjan@mandriva.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Arnaud Patard <apatard@mandriva.com>
In-Reply-To: <E1LevhK-0006y8-4V@www.linuxtv.org>
References: <E1LevhK-0006y8-4V@www.linuxtv.org>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Wed, 04 Mar 2009 20:53:07 +0100
Message-Id: <1236196387.3606.2.camel@plop>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Le mercredi 04 mars 2009 à 19:20 +0100, Patch from Pascal Terjan a
écrit :
> The patch number 10825 was added via Mauro Carvalho Chehab <mchehab@redhat.com>
> to http://linuxtv.org/hg/v4l-dvb master development tree.

The merge seems wrong:

> +/* 45 */{ USB_DEVICE(USB_VID_YUAN,      USB_PID_YUAN_PD378S) },

> +				{ &dib0700_usb_id_table[44], NULL },

Should be 45

