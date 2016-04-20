Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ob0-f194.google.com ([209.85.214.194]:36816 "EHLO
	mail-ob0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751254AbcDTQYj (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 20 Apr 2016 12:24:39 -0400
MIME-Version: 1.0
In-Reply-To: <5714B330.9050801@xs4all.nl>
References: <1460650670-20849-1-git-send-email-ulrich.hecht+renesas@gmail.com>
	<1460650670-20849-7-git-send-email-ulrich.hecht+renesas@gmail.com>
	<5714B330.9050801@xs4all.nl>
Date: Wed, 20 Apr 2016 18:24:38 +0200
Message-ID: <CAO3366zOnq-LvRfCfRf-f=c9KhEvAWMxCGMJHxVjTG=Zwuyg1Q@mail.gmail.com>
Subject: Re: [PATCH v3 6/7] media: rcar-vin: initialize EDID data
From: Ulrich Hecht <ulrich.hecht+renesas@gmail.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: =?UTF-8?Q?Niklas_S=C3=B6derlund?= <niklas.soderlund@ragnatech.se>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	linux-renesas-soc@vger.kernel.org,
	Magnus Damm <magnus.damm@gmail.com>,
	Laurent <laurent.pinchart@ideasonboard.com>,
	ian.molton@codethink.co.uk, lars@metafoo.de,
	William Towle <william.towle@codethink.co.uk>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Apr 18, 2016 at 12:13 PM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> Where does this EDID come from? I'm just wondering if it has been
> adjusted for the capabilities of the adv.

It's from the cobalt driver, with only the vendor ID changed.

CU
Uli
