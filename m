Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yw0-f194.google.com ([209.85.161.194]:36421 "EHLO
        mail-yw0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754076AbdGNOsq (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 14 Jul 2017 10:48:46 -0400
Date: Fri, 14 Jul 2017 09:48:43 -0500
From: Rob Herring <robh@kernel.org>
To: Jose Abreu <Jose.Abreu@synopsys.com>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        Carlos Palminha <CARLOS.PALMINHA@synopsys.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Sylwester Nawrocki <snawrocki@kernel.org>,
        devicetree@vger.kernel.org
Subject: Re: [PATCH v8 2/5] dt-bindings: media: Document Synopsys Designware
 HDMI RX
Message-ID: <20170714144843.ckwyvpo3h54t7acl@rob-hp-laptop>
References: <cover.1499701281.git.joabreu@synopsys.com>
 <36ad6ab0cf3051efeb02508141e08efd56761018.1499701282.git.joabreu@synopsys.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <36ad6ab0cf3051efeb02508141e08efd56761018.1499701282.git.joabreu@synopsys.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Jul 10, 2017 at 04:46:52PM +0100, Jose Abreu wrote:
> Document the bindings for the Synopsys Designware HDMI RX.
> 
> Signed-off-by: Jose Abreu <joabreu@synopsys.com>
> Cc: Carlos Palminha <palminha@synopsys.com>
> Cc: Rob Herring <robh+dt@kernel.org>
> Cc: Mark Rutland <mark.rutland@arm.com>
> Cc: Mauro Carvalho Chehab <mchehab@kernel.org>
> Cc: Hans Verkuil <hans.verkuil@cisco.com>
> Cc: Sylwester Nawrocki <snawrocki@kernel.org>
> Cc: devicetree@vger.kernel.org
> 
> Changes from v7:
> 	- Remove SoC specific bindings (Rob)
> Changes from v6:
> 	- Document which properties are required/optional (Sylwester)
> 	- Drop compatible string for SoC (Sylwester)
> 	- Reword edid-phandle property (Sylwester)
> 	- Typo fixes (Sylwester)
> Changes from v4:
> 	- Use "cfg" instead of "cfg-clk" (Rob)
> 	- Change node names (Rob)
> Changes from v3:
> 	- Document the new DT bindings suggested by Sylwester
> Changes from v2:
> 	- Document edid-phandle property
> ---
>  .../devicetree/bindings/media/snps,dw-hdmi-rx.txt  | 58 ++++++++++++++++++++++
>  1 file changed, 58 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/media/snps,dw-hdmi-rx.txt

Acked-by: Rob Herring <robh@kernel.org>
