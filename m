Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:39346 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756033AbZALShc (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 12 Jan 2009 13:37:32 -0500
Message-ID: <496B8DE7.2070500@iki.fi>
Date: Mon, 12 Jan 2009 20:37:27 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Lindsay Mathieson <lindsay.mathieson@gmail.com>
CC: linux-dvb@linuxtv.org, linux-media@vger.kernel.org
Subject: Re: [linux-dvb] af9015
References: <200901122023.43128.lindsay.mathieson@gmail.com>
In-Reply-To: <200901122023.43128.lindsay.mathieson@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Lindsay Mathieson wrote:
> I see the trunk now supports the DigitalNow TinyTwin (af9015), but only 
> for one tuner. Is it possible to enable the second tuner or are there 
> still issues with that?

Yes it is possible to enable second tuner by module param, modprobe 
dvb-usb-af9015 dual_mode=1. But I just tested and looks like no picture 
at all from 2nd tuner. I have no idea when it was gone totally broken... 
Anyhow, on single mode it should work 100% well.

regards
Antti
-- 
http://palosaari.fi/
