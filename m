Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f173.google.com ([209.85.212.173]:38573 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932482AbbGVHjA (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 22 Jul 2015 03:39:00 -0400
Received: by wibxm9 with SMTP id xm9so88368630wib.1
        for <linux-media@vger.kernel.org>; Wed, 22 Jul 2015 00:38:59 -0700 (PDT)
Date: Wed, 22 Jul 2015 08:38:56 +0100
From: Peter Griffin <peter.griffin@linaro.org>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	srinivas.kandagatla@gmail.com, maxime.coquelin@st.com,
	patrice.chotard@st.com, mchehab@osg.samsung.com,
	lee.jones@linaro.org, hugues.fruchet@st.com,
	linux-media@vger.kernel.org, devicetree@vger.kernel.org
Subject: Re: [PATCH 11/12] [media] tsin: c8sectpfe: Add Kconfig and Makefile
 for the driver.
Message-ID: <20150722073856.GA32601@griffinp-ThinkPad-X1-Carbon-2nd>
References: <1435158670-7195-1-git-send-email-peter.griffin@linaro.org>
 <1435158670-7195-12-git-send-email-peter.griffin@linaro.org>
 <1435216998.4528.100.camel@tiscali.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1435216998.4528.100.camel@tiscali.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Paul,

Thanks for reviewing.

On Thu, 25 Jun 2015, Paul Bolle wrote:

> On Wed, 2015-06-24 at 16:11 +0100, Peter Griffin wrote:
> > --- /dev/null
> > +++ b/drivers/media/tsin/c8sectpfe/Makefile
> 
> > +c8sectpfe-y += c8sectpfe-core.o c8sectpfe-common.o c8sectpfe-dvb.o
> > +
> > +obj-$(CONFIG_DVB_C8SECTPFE) += c8sectpfe.o
> > +
> > +ifneq ($(CONFIG_DVB_C8SECTPFE),)
> > +	c8sectpfe-y += c8sectpfe-debugfs.o
> > +endif
> 
> Isn't the above equivalent to
>     c8sectpfe-y += c8sectpfe-core.o c8sectpfe-common.o c8sectpfe-dvb.o c8sectpfe-debugfs.o
> 
>     obj-$(CONFIG_DVB_C8SECTPFE) += c8sectpfe.o
> 
> Or am I missing something subtle here?

No I think I just messed up. Will fix in v2.

I suspect what happened  was I was starting to add a CONFIG_DVB_C8SECTPFE_DEBUGFS
Kconfig option, and then forgot ;)

In v2 I have added a "select DEBUG_FS" to Kconfig for the driver, and put it all on one
line. Also at the same time fixing some other Kconfig dependencies I noticed so
it now has 'select LIBELF_32' and 'select FW_LOADER'.

regards,

Peter.


