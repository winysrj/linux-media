Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx30.mail.ru ([194.67.23.238]:2325 "EHLO mx30.mail.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752057AbZAYRjy (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 25 Jan 2009 12:39:54 -0500
Date: Sun, 25 Jan 2009 20:48:32 +0300
From: Goga777 <goga777@bk.ru>
To: linux-dvb@linuxtv.org
Cc: linux-media@vger.kernel.org
Subject: Re: [linux-dvb] How to use scan-s2?
Message-ID: <20090125204832.2dc19f6e@bk.ru>
In-Reply-To: <497C7669.5090408@makhutov.org>
References: <497C3F0F.1040107@makhutov.org>
	<497C359C.5090308@okg-computer.de>
	<497C7669.5090408@makhutov.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

> I have run the scan using a TeVii S650. Now I have run then same using
> my SkyStar HD and I got 1467 services.
> 
> So there is something not working using the TeVii S650...

have you any duplicates channels in channels list after of scan with tevii ?
could you have a look on debug logs of cx24116 during of scan ? have you any messages like these 

unsupported rolloff selected (3) 

Goga
