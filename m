Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:38344 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752538Ab2DCKUP (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 3 Apr 2012 06:20:15 -0400
Message-ID: <4F7ACEDE.2040604@iki.fi>
Date: Tue, 03 Apr 2012 13:20:14 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Michael_B=FCsch?= <m@bues.ch>
CC: linux-media <linux-media@vger.kernel.org>
Subject: Re: [PATCH] fc0011: use usleep_range()
References: <20120403110845.629c1c82@milhouse>
In-Reply-To: <20120403110845.629c1c82@milhouse>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 03.04.2012 12:08, Michael Büsch wrote:
> Use usleep_range() instead of msleep() to improve power saving opportunities.
>
> Signed-off-by: Michael Buesch<m@bues.ch>

Applied thanks!
http://git.linuxtv.org/anttip/media_tree.git/shortlog/refs/heads/af9035_experimental

regards
Antti
-- 
http://palosaari.fi/
