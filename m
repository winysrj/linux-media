Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:59886 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751781AbbBLALv (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 11 Feb 2015 19:11:51 -0500
Message-ID: <54DBEFC4.7080208@iki.fi>
Date: Thu, 12 Feb 2015 02:11:48 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: =?UTF-8?B?UmFmYWVsIExvdXJlbsOnbyBkZSBMaW1hIENoZWhhYg==?=
	<chehabrafael@gmail.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH RFC] dvb-usb-v2: add support for the media controller
 at USB driver
References: <1423699484-8733-1-git-send-email-chehabrafael@gmail.com>
In-Reply-To: <1423699484-8733-1-git-send-email-chehabrafael@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Moikka!

On 02/12/2015 02:04 AM, Rafael Lourenço de Lima Chehab wrote:
> Create a struct media_device and add it to the dvb adapter.
>
> Please notice that the tuner is not mapped yet by the dvb core.
>
> Signed-off-by: Rafael Lourenço de Lima Chehab <chehabrafael@gmail.com>
> ---
>   drivers/media/usb/dvb-usb-v2/dvb_usb.h      |  5 +++
>   drivers/media/usb/dvb-usb-v2/dvb_usb_core.c | 61 +++++++++++++++++++++++++++++
>   2 files changed, 66 insertions(+)

I am not against that patch, but I don't simply understand media 
controller concept enough detailed level. So it is all up to Mauro.

regards
Antti

-- 
http://palosaari.fi/
