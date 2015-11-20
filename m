Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:42121 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751586AbbKTMwU (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 20 Nov 2015 07:52:20 -0500
Subject: Re: PID filter testing
To: Benjamin Larsson <benjamin@southpole.se>,
	linux-media@vger.kernel.org
References: <564EFD40.8050504@southpole.se>
From: Antti Palosaari <crope@iki.fi>
Message-ID: <564F1777.7020903@iki.fi>
Date: Fri, 20 Nov 2015 14:52:07 +0200
MIME-Version: 1.0
In-Reply-To: <564EFD40.8050504@southpole.se>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 11/20/2015 01:00 PM, Benjamin Larsson wrote:
> Hi, what tools can I use to test pid filter support in the drivers ?

dvbtraffic shows all the pids from tuned stream, but IIRC it does not 
work with dvbv5-zap as it opens device blocked mode. dvbv5-zap has 
itself quite similar mode than dvbtraffic, it is --monitor.

To configure custom pids you need to patch tuning file, but usually 
there is already enough pids to test as full scan usually returns tens 
of tv channels (>~100 pids).

Antti

-- 
http://palosaari.fi/
