Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f175.google.com ([209.85.212.175]:33030 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752572AbbH1RJ2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 28 Aug 2015 13:09:28 -0400
Received: by wiae7 with SMTP id e7so2816075wia.0
        for <linux-media@vger.kernel.org>; Fri, 28 Aug 2015 10:09:27 -0700 (PDT)
Date: Fri, 28 Aug 2015 18:09:24 +0100
From: Peter Griffin <peter.griffin@linaro.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	maxime.coquelin@st.com, srinivas.kandagatla@gmail.com,
	patrice.chotard@st.com, mchehab@osg.samsung.com,
	devicetree@vger.kernel.org, linux-media@vger.kernel.org
Subject: Re: [PATCH v2 3/5] [media] c8sectpfe: Remove select on undefined
 LIBELF_32
Message-ID: <20150828170924.GB18136@griffinp-ThinkPad-X1-Carbon-2nd>
References: <1440678575-21646-1-git-send-email-peter.griffin@linaro.org>
 <1440678575-21646-4-git-send-email-peter.griffin@linaro.org>
 <20150828065830.GE4796@x1>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150828065830.GE4796@x1>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Lee,

On Fri, 28 Aug 2015, Lee Jones wrote:

> On Thu, 27 Aug 2015, Peter Griffin wrote:
> 
> > LIBELF_32 is not defined in Kconfig, and is left over legacy
> > which is not required in the upstream driver, so remove it.
> > 
> > Signed-off-by: Peter Griffin <peter.griffin@linaro.org>
> > Suggested-by: Valentin Rothberg <valentinrothberg@gmail.com>
> 
> These are the wrong way round, they should be in chronological order.

Ok will fix in v3.

regards,

Peter.
