Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.bredband2.com ([83.219.192.166]:33705 "EHLO
	smtp.bredband2.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932711AbaLBUvq (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 2 Dec 2014 15:51:46 -0500
Message-ID: <547E2656.2020009@southpole.se>
Date: Tue, 02 Dec 2014 21:51:34 +0100
From: Benjamin Larsson <benjamin@southpole.se>
MIME-Version: 1.0
To: Antti Palosaari <crope@iki.fi>, linux-media@vger.kernel.org
Subject: Re: [PATCH 1/3] rtl2832: convert driver to I2C binding
References: <1417530683-5063-1-git-send-email-crope@iki.fi>
In-Reply-To: <1417530683-5063-1-git-send-email-crope@iki.fi>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 12/02/2014 03:31 PM, Antti Palosaari wrote:
> Convert that driver to I2C driver model.
> Legacy DVB binding is left also for later removal...
>
> Signed-off-by: Antti Palosaari <crope@iki.fi>

Works fine. Thanks for the quick fix.

Tested-by: Benjamin Larsson <benjamin@southpole.se>

MvH
Benjamin Larsson
