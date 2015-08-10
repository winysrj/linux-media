Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud2.xs4all.net ([194.109.24.21]:49493 "EHLO
	lb1-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753842AbbHJJEf (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 10 Aug 2015 05:04:35 -0400
Message-ID: <55C86909.6030900@xs4all.nl>
Date: Mon, 10 Aug 2015 11:04:09 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Antti Palosaari <crope@iki.fi>, linux-media@vger.kernel.org
Subject: Re: [PATCHv3 09/13] hackrf: switch to single function which configures
 everything
References: <1438308650-2702-1-git-send-email-crope@iki.fi> <1438308650-2702-10-git-send-email-crope@iki.fi>
In-Reply-To: <1438308650-2702-10-git-send-email-crope@iki.fi>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 07/31/2015 04:10 AM, Antti Palosaari wrote:
> Implement single funtion, hackrf_set_params(), which handles all
> needed settings. Controls and other IOCTLs are just wrappers to that
> function. That way we can get easily better control what we could do
> on different device states - sleeping, receiving, transmitting.
> 
> Signed-off-by: Antti Palosaari <crope@iki.fi>

Acked-by: Hans Verkuil <hans.verkuil@cisco.com>

