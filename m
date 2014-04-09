Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-la0-f51.google.com ([209.85.215.51]:58888 "EHLO
	mail-la0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933717AbaDIVfH (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 9 Apr 2014 17:35:07 -0400
MIME-Version: 1.0
In-Reply-To: <1397079161-24144-2-git-send-email-crope@iki.fi>
References: <1397079161-24144-1-git-send-email-crope@iki.fi> <1397079161-24144-2-git-send-email-crope@iki.fi>
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Date: Wed, 9 Apr 2014 14:34:45 -0700
Message-ID: <CAB=NE6X-vqtn2Zk6+Xp6zYKnhKH3Cc3p3Zc712udsvmUYJJ3Lg@mail.gmail.com>
Subject: Re: [PATCHv2 1/2] rtl28xxu: do not hard depend on staging SDR module
To: Antti Palosaari <crope@iki.fi>
Cc: linux-media@vger.kernel.org,
	"backports@vger.kernel.org" <backports@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Apr 9, 2014 at 2:32 PM, Antti Palosaari <crope@iki.fi> wrote:
> +extern struct dvb_frontend *rtl2832_sdr_attach(struct dvb_frontend *fe,
> +       struct i2c_adapter *i2c, const struct rtl2832_config *cfg,
> +       struct v4l2_subdev *sd);

extern

  Luis
