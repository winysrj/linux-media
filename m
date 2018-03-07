Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:63256 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751087AbeCGKQq (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 7 Mar 2018 05:16:46 -0500
Date: Wed, 7 Mar 2018 07:16:40 -0300
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Fabio Estevam <festevam@gmail.com>
Cc: Hugues Fruchet <hugues.fruchet@st.com>,
        Steve Longerbeam <slongerbeam@gmail.com>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media <linux-media@vger.kernel.org>,
        Benjamin Gaignard <benjamin.gaignard@linaro.org>,
        Maxime Ripard <maxime.ripard@bootlin.com>
Subject: Re: [PATCH] media: dvbdev: fix building on ia64
Message-ID: <20180307071640.03b5ec00@vento.lan>
In-Reply-To: <CAOMZO5C5jSxwKMV0hZpA1emFW9ha8GN4XsTsdTfgPU4eJ44Ctw@mail.gmail.com>
References: <1520355879-20291-1-git-send-email-hugues.fruchet@st.com>
        <20180307081302.h47mjhlkeq72shw7@valkosipuli.retiisi.org.uk>
        <CAOMZO5C5jSxwKMV0hZpA1emFW9ha8GN4XsTsdTfgPU4eJ44Ctw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Wed, 7 Mar 2018 06:47:14 -0300
Fabio Estevam <festevam@gmail.com> escreveu:

> Hi Mauro,
> 
> On Wed, Mar 7, 2018 at 6:14 AM, Mauro Carvalho Chehab
> <mchehab@s-opensource.com> wrote:
> > Not sure why, but, on ia64, with Linaro's gcc 7.3 compiler,
> > using #ifdef (CONFIG_I2C) is not OK.  
> 
> Looking at the kbuild report the failure happens when CONFIG_I2C=m.
> 
> IS_ENABLED() macro takes care of both built-in and module as it will expand to:
> 
> #if defined(CONFIG_I2C) || defined(CONFIG_I2C_MODULE)

Ah, true! Yeah, I forgot that for tri-state vars, it should test for
_MODULE variant.

> 
> and that's the reason why IS_ENABLE() fixes the build problem.

Thanks for reminding me.

Regards,
Mauro
