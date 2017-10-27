Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-oi0-f65.google.com ([209.85.218.65]:54430 "EHLO
        mail-oi0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751399AbdJ0BBo (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 26 Oct 2017 21:01:44 -0400
Date: Thu, 26 Oct 2017 20:01:42 -0500
From: Rob Herring <robh@kernel.org>
To: Dmitry Osipenko <digetx@gmail.com>
Cc: Thierry Reding <thierry.reding@gmail.com>,
        Jonathan Hunter <jonathanh@nvidia.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Vladimir Zapolskiy <vz@mleia.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        linux-media@vger.kernel.org, linux-tegra@vger.kernel.org,
        devel@driverdev.osuosl.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 2/5] media: dt: bindings: Add binding for NVIDIA Tegra
 Video Decoder Engine
Message-ID: <20171027010142.2glhx2djupxesnjp@rob-hp-laptop>
References: <cover.1508448293.git.digetx@gmail.com>
 <bf5b91666229f9e46ed8c73d6ca2e4b65f86b5ab.1508448293.git.digetx@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bf5b91666229f9e46ed8c73d6ca2e4b65f86b5ab.1508448293.git.digetx@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Oct 20, 2017 at 12:34:22AM +0300, Dmitry Osipenko wrote:
> Add binding documentation for the Video Decoder Engine which is found
> on NVIDIA Tegra20/30/114/124/132 SoC's.
> 
> Signed-off-by: Dmitry Osipenko <digetx@gmail.com>
> ---
>  .../devicetree/bindings/media/nvidia,tegra-vde.txt | 55 ++++++++++++++++++++++
>  1 file changed, 55 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/media/nvidia,tegra-vde.txt

Acked-by: Rob Herring <robh@kernel.org>
