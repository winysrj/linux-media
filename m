Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ed1-f68.google.com ([209.85.208.68]:39789 "EHLO
        mail-ed1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728314AbeJEP0u (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 5 Oct 2018 11:26:50 -0400
Subject: Re: [PATCH 0/4] Add MT7623 dts bindings documentation
To: robh+dt@kernel.org, mark.rutland@arm.com, joro@8bytes.org,
        arnd@arndb.de
Cc: rick.chang@mediatek.com, bin.liu@mediatek.com, mchehab@kernel.org,
        sboyd@codeaurora.org, sean.wang@mediatek.com,
        chen.zhong@mediatek.com, weiyi.lu@mediatek.com,
        ryder.lee@mediatek.com, yong.wu@mediatek.com,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        iommu@lists.linux-foundation.org, linux-media@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
References: <20181003090912.30501-1-matthias.bgg@gmail.com>
From: Matthias Brugger <matthias.bgg@gmail.com>
Message-ID: <add6ddc9-2eff-9413-de55-003acfeb2ffb@gmail.com>
Date: Fri, 5 Oct 2018 10:29:07 +0200
MIME-Version: 1.0
In-Reply-To: <20181003090912.30501-1-matthias.bgg@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On 03/10/2018 11:09, Matthias Brugger wrote:
> Mediateks MT7623 SoC shares most of its component with MT2701.
> This series adds devicetree documentation for all the devices.
> 
> It applies cleanly against linux next, so I don't expect any merge
> conflicts if this is taken by Arnd through the arm-soc tree for v4.20
> 
> 

For completeness, I merged the whole series to v4.19-next/dts32
