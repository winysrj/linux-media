Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f171.google.com ([209.85.212.171]:34046 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757917AbbFCSdc (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 3 Jun 2015 14:33:32 -0400
Message-ID: <556F4875.6010109@gmail.com>
Date: Wed, 03 Jun 2015 19:33:25 +0100
From: Malcolm Priestley <tvboxspy@gmail.com>
MIME-Version: 1.0
To: David Howells <dhowells@redhat.com>, crope@iki.fi
CC: linux-kernel@vger.kernel.org, linux-media@vger.kernel.org
Subject: Re: [PATCH] ts2020: Allow stats polling to be suppressed
References: <5564C269.2000003@gmail.com> <20150603113508.32135.28906.stgit@warthog.procyon.org.uk>
In-Reply-To: <20150603113508.32135.28906.stgit@warthog.procyon.org.uk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On 03/06/15 12:35, David Howells wrote:
> Statistics polling can not be done by lmedm04 driver's implementation of
> M88RS2000/TS2020 because I2C messages stop the device's demuxer, so allow
> polling for statistics to be suppressed in the ts2020 driver by setting
> dont_poll in the ts2020_config struct.

Hi David

As expected the lmedm04 driver needs this patch along with another patch 
to enable it for the driver which I will post shortly.

Otherwise everything is working fine on Antti's ts2020 branch

Regards


Malcolm

