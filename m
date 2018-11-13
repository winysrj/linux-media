Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtprelay2.synopsys.com ([198.182.60.111]:54504 "EHLO
        smtprelay.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731399AbeKMT7L (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 13 Nov 2018 14:59:11 -0500
Subject: Re: [V3, 3/4] Documentation: dt-bindings: media: Document bindings
 for DW MIPI CSI-2 Host
To: Rob Herring <robh@kernel.org>,
        Luis Oliveira <luis.oliveira@synopsys.com>
CC: <linux-media@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <joao.pinto@synopsys.com>, <festevam@gmail.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Neil Armstrong <narmstrong@baylibre.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        "Keiichi Watanabe" <keiichiw@chromium.org>,
        Kate Stewart <kstewart@linuxfoundation.org>,
        Todor Tomov <todor.tomov@linaro.org>,
        <devicetree@vger.kernel.org>
References: <1539953556-35762-1-git-send-email-lolivei@synopsys.com>
 <1539953556-35762-4-git-send-email-lolivei@synopsys.com>
 <20181024174158.GB2902@bogus>
From: Luis de Oliveira <luis.oliveira@synopsys.com>
Message-ID: <7b0355cb-e000-619d-48ab-08cf6424fd8d@synopsys.com>
Date: Tue, 13 Nov 2018 10:00:50 +0000
MIME-Version: 1.0
In-Reply-To: <20181024174158.GB2902@bogus>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On 24-Oct-18 18:41, Rob Herring wrote:
> On Fri, Oct 19, 2018 at 02:52:25PM +0200, Luis Oliveira wrote:
>> Add bindings for Synopsys DesignWare MIPI CSI-2 host.
> 
> Also, drop "Documentation: " from the subject. All bindings are 
> documentation and the preferred prefix is 'dt-bindings: <binding dir>: '.
> 
>>

Ok, thank you again.

>> Signed-off-by: Luis Oliveira <lolivei@synopsys.com>
>> ---
>> Changelog
>> v2-V3
>> - removed IPI settings
>>
>>  .../devicetree/bindings/media/snps,dw-csi-plat.txt | 52 ++++++++++++++++++++++
>>  1 file changed, 52 insertions(+)
>>  create mode 100644 Documentation/devicetree/bindings/media/snps,dw-csi-plat.txt
