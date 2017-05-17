Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:35930
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751524AbdEQLsG (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 17 May 2017 07:48:06 -0400
Date: Wed, 17 May 2017 08:47:53 -0300
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: Ramiro Oliveira <Ramiro.Oliveira@synopsys.com>,
        linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
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
Message-ID: <20170517084753.6092e7e7@vento.lan>
In-Reply-To: <20170516214817.GP3227@valkosipuli.retiisi.org.uk>
References: <cover.1488885081.git.roliveir@synopsys.com>
        <20170516214817.GP3227@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Wed, 17 May 2017 00:48:17 +0300
Sakari Ailus <sakari.ailus@iki.fi> escreveu:

> Hi Ramiro,
> 
> On Tue, Mar 07, 2017 at 02:37:47PM +0000, Ramiro Oliveira wrote:
> > This patchset adds support for the DW CSI-2 Host and also for a video
> > device associated with it. 
> > 
> > The first 2 patches are only for the DW CSI-2 Host and the last 2 are for
> > the video device.
> > 
> > Although this patchset is named as v1 there were already two patchsets
> > previous to this one, but with a different name: "Add support for the DW
> > IP Prototyping Kits for MIPI CSI-2 Host".  
> 
> Could you briefly describe the hardware and which IP blocks you have there?
> Three devices to capture images from CSI-2 bus seems a lot.

Just a quick notice here... calling the driver as "dwc" sounds confusing,
we have already a "dwc2" and a "dwc3" driver (and an OOT "otg-dwc" driver
at RPi tree).

Ok, those are USB drivers, but, as we had some patches for it (or due
to it) at linux-media, I would prefer if you could use some other name
here, to avoid confusion :-)

Thanks,
Mauro
