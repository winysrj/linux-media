Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:47976 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726926AbeIAPIj (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 1 Sep 2018 11:08:39 -0400
Date: Sat, 1 Sep 2018 13:56:59 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Hugues FRUCHET <hugues.fruchet@st.com>
Cc: Steve Longerbeam <slongerbeam@gmail.com>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        Benjamin Gaignard <benjamin.gaignard@linaro.org>,
        Maxime Ripard <maxime.ripard@bootlin.com>,
        Jacopo Mondi <jacopo@jmondi.org>
Subject: Re: [PATCH v2] media: ov5640: do not change mode if format or frame
 interval is unchanged
Message-ID: <20180901105659.k77ksktpwq7n6do5@valkosipuli.retiisi.org.uk>
References: <1534152111-16837-1-git-send-email-hugues.fruchet@st.com>
 <c5b3d6cd-862b-56a0-a81b-29cece658953@st.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c5b3d6cd-862b-56a0-a81b-29cece658953@st.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Aug 16, 2018 at 09:56:13AM +0000, Hugues FRUCHET wrote:
> Hi all,
> 
> Please ignore this v2, the v1 was merged.
> I've just pushed a new patch which fixes the regression observed, see:
> https://www.mail-archive.com/linux-media@vger.kernel.org/msg134413.html
> 
> Sorry for inconvenience.

No worries; thanks for the fix!

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi
