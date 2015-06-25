Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud6.xs4all.net ([194.109.24.31]:43039 "EHLO
	lb3-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750983AbbFYHX0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 25 Jun 2015 03:23:26 -0400
Message-ID: <1435216998.4528.100.camel@tiscali.nl>
Subject: Re: [PATCH 11/12] [media] tsin: c8sectpfe: Add Kconfig and Makefile
 for the driver.
From: Paul Bolle <pebolle@tiscali.nl>
To: Peter Griffin <peter.griffin@linaro.org>,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	srinivas.kandagatla@gmail.com, maxime.coquelin@st.com,
	patrice.chotard@st.com, mchehab@osg.samsung.com
Cc: lee.jones@linaro.org, hugues.fruchet@st.com,
	linux-media@vger.kernel.org, devicetree@vger.kernel.org
Date: Thu, 25 Jun 2015 09:23:18 +0200
In-Reply-To: <1435158670-7195-12-git-send-email-peter.griffin@linaro.org>
References: <1435158670-7195-1-git-send-email-peter.griffin@linaro.org>
	 <1435158670-7195-12-git-send-email-peter.griffin@linaro.org>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, 2015-06-24 at 16:11 +0100, Peter Griffin wrote:
> --- /dev/null
> +++ b/drivers/media/tsin/c8sectpfe/Makefile

> +c8sectpfe-y += c8sectpfe-core.o c8sectpfe-common.o c8sectpfe-dvb.o
> +
> +obj-$(CONFIG_DVB_C8SECTPFE) += c8sectpfe.o
> +
> +ifneq ($(CONFIG_DVB_C8SECTPFE),)
> +	c8sectpfe-y += c8sectpfe-debugfs.o
> +endif

Isn't the above equivalent to
    c8sectpfe-y += c8sectpfe-core.o c8sectpfe-common.o c8sectpfe-dvb.o c8sectpfe-debugfs.o

    obj-$(CONFIG_DVB_C8SECTPFE) += c8sectpfe.o

Or am I missing something subtle here?


Paul Bolle
