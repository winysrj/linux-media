Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-la0-f47.google.com ([209.85.215.47]:47770 "EHLO
	mail-la0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933143AbaDISY6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 9 Apr 2014 14:24:58 -0400
MIME-Version: 1.0
In-Reply-To: <1397060069-12757-1-git-send-email-crope@iki.fi>
References: <1397060069-12757-1-git-send-email-crope@iki.fi>
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Date: Wed, 9 Apr 2014 11:24:36 -0700
Message-ID: <CAB=NE6W-X9cvN8mKsoeF5=_FA9X54AYxB41TZawEE3JhB=o7bw@mail.gmail.com>
Subject: Re: [PATCH] rtl28xxu: do not hard depend on staging SDR module
To: Antti Palosaari <crope@iki.fi>, Joe Perches <joe@perches.com>
Cc: linux-media@vger.kernel.org,
	"backports@vger.kernel.org" <backports@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Apr 9, 2014 at 9:14 AM, Antti Palosaari <crope@iki.fi> wrote:
> +extern struct dvb_frontend *rtl2832_sdr_attach(struct dvb_frontend *fe,
> +       struct i2c_adapter *i2c, const struct rtl2832_config *cfg,
> +       struct v4l2_subdev *sd);


Thanks for the patch! Joe has been going on a crusade to remove
externs as they are not needed, if we can avoid adding new ones
that'll prevent another followp cleanup patch.

  Luis
