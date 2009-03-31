Return-path: <linux-media-owner@vger.kernel.org>
Received: from mta3.srv.hcvlny.cv.net ([167.206.4.198]:61114 "EHLO
	mta3.srv.hcvlny.cv.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751962AbZCaOaI (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 31 Mar 2009 10:30:08 -0400
Received: from steven-toths-macbook-pro.local
 (ool-45721e5a.dyn.optonline.net [69.114.30.90]) by mta3.srv.hcvlny.cv.net
 (Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
 with ESMTP id <0KHD00CB3KA2OK40@mta3.srv.hcvlny.cv.net> for
 linux-media@vger.kernel.org; Tue, 31 Mar 2009 10:30:05 -0400 (EDT)
Date: Tue, 31 Mar 2009 10:30:02 -0400
From: Steven Toth <stoth@linuxtv.org>
Subject: Re: XC5000 DVB-T/DMB-TH support
In-reply-to: <15ed362e0903302039g6d9575cnca5d9b62b566db72@mail.gmail.com>
To: David Wong <davidtlwong@gmail.com>
Cc: Devin Heitmueller <devin.heitmueller@gmail.com>,
	linux-media@vger.kernel.org
Message-id: <49D228EA.3090302@linuxtv.org>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8; format=flowed
Content-transfer-encoding: 7BIT
References: <15ed362e0903301947rf0de73eo8edbd8cbcd5b5abd@mail.gmail.com>
 <412bdbff0903301957i77c36f10hcb9e9cb919124057@mail.gmail.com>
 <15ed362e0903302039g6d9575cnca5d9b62b566db72@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hmm.

> 		priv->freq_hz = params->frequency - 1750000;

Prior to reading this I would of sworn blind that we'd witnessed the XC5000 
working on DVB-T devices, it's been a while and now I'm doubting that belief.

- Steve
