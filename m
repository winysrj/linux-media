Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.academica.fi ([109.75.228.249]:52474 "EHLO
	smtp41.academica.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750992AbbF2JjK (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 29 Jun 2015 05:39:10 -0400
Message-ID: <55911239.4000709@iki.fi>
Date: Mon, 29 Jun 2015 12:39:05 +0300
From: Jouni Karvo <Jouni.Karvo@iki.fi>
MIME-Version: 1.0
To: =?UTF-8?B?VHljaG8gTMO8cnNlbg==?= <tycholursen@gmail.com>,
	linux-media@vger.kernel.org
Subject: Re: cx23885 risc op code error with DvbSKY T982
References: <55870014.90902@iki.fi> <5587D8A5.70905@iki.fi> <5587DB9F.4020008@gmail.com>
In-Reply-To: <5587DB9F.4020008@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

22.06.2015, 12:55, Tycho Lürsen kirjoitti:
> I've got a couple of T982 cards. Running Debian Jessie, with kernel 
> 4.1-rc8, I cannot reproduce your errors.
> Only difference might be:
> I synced the silabs drivers with upstream and used the patch from:

hi,

I tested with 4.1.0 (which produced the errors.  4.1.0 with media_build 
produced the errors.  I did not test that with the patch, as because of 
another kernel bug (in mdraid) I switched to 4.0.6.

With 4.0.6 this error does not seem to happen with neither card.

yours,
         Jouni
