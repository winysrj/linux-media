Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:45532 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751191AbeACJKX (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 3 Jan 2018 04:10:23 -0500
Date: Wed, 3 Jan 2018 11:10:21 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Hugues FRUCHET <hugues.fruchet@st.com>
Cc: Steve Longerbeam <slongerbeam@gmail.com>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        Benjamin Gaignard <benjamin.gaignard@linaro.org>
Subject: Re: [PATCH v4 3/5] media: dt-bindings: ov5640: refine CSI-2 and add
 parallel interface
Message-ID: <20180103091021.x2yego3wmhsq6bfx@valkosipuli.retiisi.org.uk>
References: <1513763474-1174-1-git-send-email-hugues.fruchet@st.com>
 <1513763474-1174-4-git-send-email-hugues.fruchet@st.com>
 <20180102122046.iso43ungfndrjhlp@valkosipuli.retiisi.org.uk>
 <20180102122453.u4tb7cmy5ig76v7z@valkosipuli.retiisi.org.uk>
 <55be0bed-7964-fc94-58fb-d385b1adcc98@st.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <55be0bed-7964-fc94-58fb-d385b1adcc98@st.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Jan 03, 2018 at 08:47:09AM +0000, Hugues FRUCHET wrote:
> Hi Sakari,
> this is fine for me to drop those two lines so sync signals become 
> mandatory.
> Must I repost a v5 serie ?

Here's the diff:

diff --git a/Documentation/devicetree/bindings/media/i2c/ov5640.txt b/Documentation/devicetree/bindings/media/i2c/ov5640.txt
index e26a84646603..8e36da0d8406 100644
--- a/Documentation/devicetree/bindings/media/i2c/ov5640.txt
+++ b/Documentation/devicetree/bindings/media/i2c/ov5640.txt
@@ -31,8 +31,6 @@ Endpoint node required properties for parallel connection are:
 	     or <10> for 10 bits parallel bus
 - data-shift: shall be set to <2> for 8 bits parallel bus
 	      (lines 9:2 are used) or <0> for 10 bits parallel bus
-
-Endpoint node optional properties for parallel connection are:
 - hsync-active: active state of the HSYNC signal, 0/1 for LOW/HIGH respectively.
 - vsync-active: active state of the VSYNC signal, 0/1 for LOW/HIGH respectively.
 - pclk-sample: sample data on rising (1) or falling (0) edge of the pixel clock

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi
