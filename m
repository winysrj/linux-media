Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-oi0-f67.google.com ([209.85.218.67]:35110 "EHLO
	mail-oi0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751432AbcDTQYc (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 20 Apr 2016 12:24:32 -0400
MIME-Version: 1.0
In-Reply-To: <5714B143.50902@xs4all.nl>
References: <1460650670-20849-1-git-send-email-ulrich.hecht+renesas@gmail.com>
	<1460650670-20849-6-git-send-email-ulrich.hecht+renesas@gmail.com>
	<5714B143.50902@xs4all.nl>
Date: Wed, 20 Apr 2016 18:24:31 +0200
Message-ID: <CAO3366wQ=CFx2XKNHBYCaN7TXs=unW77SucwMOVi7PCDPyZvkQ@mail.gmail.com>
Subject: Re: [PATCH v3 5/7] media: rcar-vin: add DV timings support
From: Ulrich Hecht <ulrich.hecht+renesas@gmail.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: hans.verkuil@cisco.com,
	=?UTF-8?Q?Niklas_S=C3=B6derlund?= <niklas.soderlund@ragnatech.se>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	linux-renesas-soc@vger.kernel.org,
	Magnus Damm <magnus.damm@gmail.com>,
	Laurent <laurent.pinchart@ideasonboard.com>,
	ian.molton@codethink.co.uk, lars@metafoo.de,
	William Towle <william.towle@codethink.co.uk>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Apr 18, 2016 at 12:04 PM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> Hi Ulrich,
>
> This isn't right: this just overwrites the adv7180 input with an HDMI input.
>
> I assume the intention is to have support for both adv7180 and HDMI input and
> to use VIDIOC_S_INPUT to select between the two.

I'm not quite sure what you mean.  The inputs are always hardwired to
one specific decoder, no switching possible.

CU
Uli
