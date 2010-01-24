Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:51991 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753388Ab0AXXzn (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 24 Jan 2010 18:55:43 -0500
Message-ID: <4B5CDDF9.5000003@iki.fi>
Date: Mon, 25 Jan 2010 01:55:37 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Jiri Slaby <jslaby@suse.cz>
CC: linux-kernel@vger.kernel.org, jirislaby@gmail.com,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	linux-media@vger.kernel.org
Subject: Re: [PATCH 4/4] media: dvb/af9015, add hashes support
References: <4B4F6BE5.2040102@iki.fi> <1264173055-14787-4-git-send-email-jslaby@suse.cz>
In-Reply-To: <1264173055-14787-4-git-send-email-jslaby@suse.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 01/22/2010 05:10 PM, Jiri Slaby wrote:
> So as a final patch, add support for hash and one hash entry
> for MSI digi vox mini II:
> iManufacturer 1 Afatech
> iProduct      2 DVB-T 2
> iSerial       3 010101010600001
>
> It is now handled with proper IR and key map tables.
>
> Signed-off-by: Jiri Slaby<jslaby@suse.cz>
> Cc: Antti Palosaari<crope@iki.fi>
> Cc: Mauro Carvalho Chehab<mchehab@redhat.com>
> Cc: linux-media@vger.kernel.org
>
> Signed-off-by: Jiri Slaby<jslaby@suse.cz>
> ---
>   drivers/media/dvb/dvb-usb/af9015.c |   14 ++++++++++++--
>   1 files changed, 12 insertions(+), 2 deletions(-)

Acked-by: Antti Palosaari <crope@iki.fi>
-- 
http://palosaari.fi/
