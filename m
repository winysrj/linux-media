Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.19]:65356 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756085AbaIDWul (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 4 Sep 2014 18:50:41 -0400
Received: from minime.bse ([24.134.147.13]) by mail.gmx.com (mrgmx001) with
 ESMTPSA (Nemesis) id 0MHXXo-1XOYrb0d5w-003LcF for
 <linux-media@vger.kernel.org>; Fri, 05 Sep 2014 00:50:39 +0200
Date: Fri, 5 Sep 2014 00:50:38 +0200
From: Daniel =?iso-8859-1?Q?Gl=F6ckner?= <daniel-gl@gmx.net>
To: Antti Palosaari <crope@iki.fi>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH 3/3] af9035: remove I2C client differently
Message-ID: <20140904225038.GA27825@minime.bse>
References: <1409867023-8362-1-git-send-email-crope@iki.fi>
 <1409867023-8362-3-git-send-email-crope@iki.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1409867023-8362-3-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Sep 05, 2014 at 12:43:43AM +0300, Antti Palosaari wrote:
> +	switch (state->af9033_config[adap->id].tuner) {
> +	case AF9033_TUNER_IT9135_38:
> +	case AF9033_TUNER_IT9135_51:
> +	case AF9033_TUNER_IT9135_52:
> +	case AF9033_TUNER_IT9135_60:
> +	case AF9033_TUNER_IT9135_61:
> +	case AF9033_TUNER_IT9135_62:
> +		demod2 = 2;
> +	default:
> +		demod2 = 1;
> +	}

Missing break?
