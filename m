Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.230]:51969 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752611AbZGYNaD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 25 Jul 2009 09:30:03 -0400
From: <ext-Eero.Nurkkala@nokia.com>
To: <hverkuil@xs4all.nl>, <eduardo.valentin@nokia.com>
CC: <mchehab@infradead.org>, <dougsland@gmail.com>,
	<matti.j.aaltonen@nokia.com>, <linux-media@vger.kernel.org>
Date: Sat, 25 Jul 2009 15:29:38 +0200
Subject: RE: [PATCHv10 6/8] FMTx: si4713: Add files to handle si4713 i2c
 device
Message-ID: <1FFEF31EBAA4F64B80D33027D4297760047DF3D655@NOK-EUMSG-02.mgdnok.nokia.com>
References: <1248453448-1668-1-git-send-email-eduardo.valentin@nokia.com>
 <1248453448-1668-6-git-send-email-eduardo.valentin@nokia.com>
 <1248453448-1668-7-git-send-email-eduardo.valentin@nokia.com>,<200907251520.53119.hverkuil@xs4all.nl>
In-Reply-To: <200907251520.53119.hverkuil@xs4all.nl>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>




> I'm surprised at these MAX string lengths. Looking at the RDS standard it
> seems that the max length for the PS_NAME is 8 and for RADIO_TEXT it is
> either 32 (2A group) or 64 (2B group). I don't know which group the si4713
> uses.
> 
> Can you clarify how this is used?
> 
> Regards,
> 
>         Hans

Well, PS_NAME can be 8 x n, but only 8 bytes are shown at once...
so it keeps 'scrolling', or changes periodically. There's even commercial
radio stations that do so.


- Eero