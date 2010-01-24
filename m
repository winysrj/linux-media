Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:42594 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750784Ab0AXXyy (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 24 Jan 2010 18:54:54 -0500
Message-ID: <4B5CDDC7.2090600@iki.fi>
Date: Mon, 25 Jan 2010 01:54:47 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Jiri Slaby <jslaby@suse.cz>
CC: linux-kernel@vger.kernel.org, jirislaby@gmail.com,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	linux-media@vger.kernel.org
Subject: Re: [PATCH 3/4] media: dvb/af9015, refactor remote setting
References: <4B4F6BE5.2040102@iki.fi> <1264173055-14787-3-git-send-email-jslaby@suse.cz>
In-Reply-To: <1264173055-14787-3-git-send-email-jslaby@suse.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 01/22/2010 05:10 PM, Jiri Slaby wrote:
> Add af9015_setup structure to hold (right now only remote) setup
> of distinct receivers.
>
> Add af9015_setup_match for matching ids against tables.
>
> This is for easier matching different kind of ids against tables
> to obtain setups. Currently module parameters and usb vendor ids
> are switched into and matched against tables. Hashes will follow.
>
> Signed-off-by: Jiri Slaby<jslaby@suse.cz>
> Cc: Antti Palosaari<crope@iki.fi>
> Cc: Mauro Carvalho Chehab<mchehab@redhat.com>
> Cc: linux-media@vger.kernel.org
> ---
>   drivers/media/dvb/dvb-usb/af9015.c |  222 ++++++++++++++---------------------
>   1 files changed, 89 insertions(+), 133 deletions(-)

Acked-by: Antti Palosaari <crope@iki.fi>
-- 
http://palosaari.fi/
