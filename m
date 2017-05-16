Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:40352 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1753010AbdEPVs1 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 16 May 2017 17:48:27 -0400
Date: Wed, 17 May 2017 00:48:17 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Ramiro Oliveira <Ramiro.Oliveira@synopsys.com>
Cc: linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
        devicetree@vger.kernel.org, CARLOS.PALMINHA@synopsys.com,
        Andrew-CT Chen <andrew-ct.chen@mediatek.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arnd Bergmann <arnd@arndb.de>, Benoit Parrot <bparrot@ti.com>,
        "David S. Miller" <davem@davemloft.net>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Hugues Fruchet <hugues.fruchet@st.com>,
        Jean-Christophe Trotin <jean-christophe.trotin@st.com>,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Minghsiu Tsai <minghsiu.tsai@mediatek.com>,
        Peter Griffin <peter.griffin@linaro.org>,
        Rick Chang <rick.chang@mediatek.com>,
        Rob Herring <robh+dt@kernel.org>,
        Simon Horman <simon.horman@netronome.com>,
        Songjun Wu <songjun.wu@microchip.com>,
        Tiffany Lin <tiffany.lin@mediatek.com>
Subject: Re: [PATCH 0/4] Support for Synopsys DW CSI-2 Host
Message-ID: <20170516214817.GP3227@valkosipuli.retiisi.org.uk>
References: <cover.1488885081.git.roliveir@synopsys.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1488885081.git.roliveir@synopsys.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Ramiro,

On Tue, Mar 07, 2017 at 02:37:47PM +0000, Ramiro Oliveira wrote:
> This patchset adds support for the DW CSI-2 Host and also for a video
> device associated with it. 
> 
> The first 2 patches are only for the DW CSI-2 Host and the last 2 are for
> the video device.
> 
> Although this patchset is named as v1 there were already two patchsets
> previous to this one, but with a different name: "Add support for the DW
> IP Prototyping Kits for MIPI CSI-2 Host".

Could you briefly describe the hardware and which IP blocks you have there?
Three devices to capture images from CSI-2 bus seems a lot.

-- 
Regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
