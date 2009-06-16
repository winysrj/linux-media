Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.233]:31590 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753437AbZFPMGI (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 16 Jun 2009 08:06:08 -0400
Subject: Re: [PATCHv7 7/9] FMTx: si4713: Add files to handle si4713 i2c
 device
From: Eero Nurkkala <ext-eero.nurkkala@nokia.com>
Reply-To: ext-eero.nurkkala@nokia.com
To: "Valentin Eduardo (Nokia-D/Helsinki)" <eduardo.valentin@nokia.com>
Cc: ext Hans Verkuil <hverkuil@xs4all.nl>,
	ext Mauro Carvalho Chehab <mchehab@infradead.org>,
	"Aaltonen Matti.J (Nokia-D/Tampere)" <matti.j.aaltonen@nokia.com>,
	ext Douglas Schilling Landgraf <dougsland@gmail.com>,
	Linux-Media <linux-media@vger.kernel.org>
In-Reply-To: <20090616115050.GE16092@esdhcp037198.research.nokia.com>
References: <1244827840-886-1-git-send-email-eduardo.valentin@nokia.com>
	 <200906141431.55725.hverkuil@xs4all.nl>
	 <20090616110609.GC16092@esdhcp037198.research.nokia.com>
	 <200906161322.13518.hverkuil@xs4all.nl>
	 <1245151808.3166.2.camel@eenurkka-desktop>
	 <20090616115050.GE16092@esdhcp037198.research.nokia.com>
Content-Type: text/plain
Date: Tue, 16 Jun 2009 15:05:37 +0300
Message-Id: <1245153937.3166.5.camel@eenurkka-desktop>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, 2009-06-16 at 13:50 +0200, Valentin Eduardo (Nokia-D/Helsinki) wrote:

> 
> Yes, sorry I've made some really bad phrasing. It is Strength. It is a
> feature to measure Received Signal Strength Indication (RSSI). As mentioned
> by Eero, it's not a good idea to transmit any on freq which the measurement is being done.
> 

It can't transmit any while this measuring is taking place - it's not a
good idea to transmit any, if the measurement has been taking place and
it is discovered that there's already a strong radio signal (on freq x).
So it can be used to find out a channel that's good for transmission =)

- Eero

