Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lj1-f195.google.com ([209.85.208.195]:42496 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728437AbeGPJTi (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 16 Jul 2018 05:19:38 -0400
Received: by mail-lj1-f195.google.com with SMTP id x12-v6so3571478ljj.9
        for <linux-media@vger.kernel.org>; Mon, 16 Jul 2018 01:53:14 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20180711160713.GA29354@rob-hp-laptop>
References: <1530797585-8555-1-git-send-email-todor.tomov@linaro.org>
 <1530797585-8555-9-git-send-email-todor.tomov@linaro.org> <20180711160713.GA29354@rob-hp-laptop>
From: Todor Tomov <todor.tomov@linaro.org>
Date: Mon, 16 Jul 2018 11:53:13 +0300
Message-ID: <CAA3CUABj_udpu1yAGGd070_uLNYLbTYEHb_sbHLheUErkPnYtQ@mail.gmail.com>
Subject: Re: [PATCH v2 08/34] media: camss: Unify the clock names
To: Rob Herring <robh@kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Mark Rutland <mark.rutland@arm.com>, devicetree@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Rob,

Thank you for review.

On 11 July 2018 at 19:07, Rob Herring <robh@kernel.org> wrote:
> On Thu, Jul 05, 2018 at 04:32:39PM +0300, Todor Tomov wrote:
>> Unify the clock names - use names closer to the clock
>> definitions.
>
> Why? You can't just change names. You are breaking an ABI.

Main reason is that this change allows more logical names and
handling in the driver when support for 8996 is added.
To clarify by example:
- we used to have "camss_vfe_vfe" in 8916;
- now we will have "vfe0" in 8916 and "vfe0" and "vfe1" in 8996.

To achieve this I have changed the names to match more closely
the definitions in the clock driver, which are based on the
documentation. Yes, I should have done this the first time...

I have used to update the dt and kernel code together. Yes, the
change breaks the ABI but does this cause difficulties in practice?

>
>>
>> CC: Rob Herring <robh+dt@kernel.org>
>> CC: Mark Rutland <mark.rutland@arm.com>
>> CC: devicetree@vger.kernel.org
>> Signed-off-by: Todor Tomov <todor.tomov@linaro.org>
>> ---
>>  .../devicetree/bindings/media/qcom,camss.txt       | 24 +++++++++++-----------
>
> Bindings should be a separate patch.

I can do that in the next version.

Best regards,
Todor

>
>>  drivers/media/platform/qcom/camss/camss.c          | 20 ++++++++----------
>>  2 files changed, 20 insertions(+), 24 deletions(-)
>>
>> diff --git a/Documentation/devicetree/bindings/media/qcom,camss.txt b/Documentation/devicetree/bindings/media/qcom,camss.txt
>> index cadeceb..032e8ed 100644
>> --- a/Documentation/devicetree/bindings/media/qcom,camss.txt
>> +++ b/Documentation/devicetree/bindings/media/qcom,camss.txt
>> @@ -53,7 +53,7 @@ Qualcomm Camera Subsystem
>>       Usage: required
>>       Value type: <stringlist>
>>       Definition: Should contain the following entries:
>> -                - "camss_top_ahb"
>> +                - "top_ahb"
>>                  - "ispif_ahb"
>>                  - "csiphy0_timer"
>>                  - "csiphy1_timer"
>> @@ -67,11 +67,11 @@ Qualcomm Camera Subsystem
>>                  - "csi1_phy"
>>                  - "csi1_pix"
>>                  - "csi1_rdi"
>> -                - "camss_ahb"
>> -                - "camss_vfe_vfe"
>> -                - "camss_csi_vfe"
>> -                - "iface"
>> -                - "bus"
>> +                - "ahb"
>> +                - "vfe0"
>> +                - "csi_vfe0"
>> +                - "vfe_ahb"
>> +                - "vfe_axi"
>>  - vdda-supply:
>>       Usage: required
>>       Value type: <phandle>
>> @@ -161,7 +161,7 @@ Qualcomm Camera Subsystem
>>                       <&gcc GCC_CAMSS_CSI_VFE0_CLK>,
>>                       <&gcc GCC_CAMSS_VFE_AHB_CLK>,
>>                       <&gcc GCC_CAMSS_VFE_AXI_CLK>;
>> -                clock-names = "camss_top_ahb",
>> +                clock-names = "top_ahb",
>>                          "ispif_ahb",
>>                          "csiphy0_timer",
>>                          "csiphy1_timer",
>> @@ -175,11 +175,11 @@ Qualcomm Camera Subsystem
>>                          "csi1_phy",
>>                          "csi1_pix",
>>                          "csi1_rdi",
>> -                        "camss_ahb",
>> -                        "camss_vfe_vfe",
>> -                        "camss_csi_vfe",
>> -                        "iface",
>> -                        "bus";
>> +                        "ahb",
>> +                        "vfe0",
>> +                        "csi_vfe0",
>> +                        "vfe_ahb",
>> +                        "vfe_axi";
>>               vdda-supply = <&pm8916_l2>;
>>               iommus = <&apps_iommu 3>;
>>               ports {
>> diff --git a/drivers/media/platform/qcom/camss/camss.c b/drivers/media/platform/qcom/camss/camss.c
>> index abf6184..0b663e0 100644
>> --- a/drivers/media/platform/qcom/camss/camss.c
>> +++ b/drivers/media/platform/qcom/camss/camss.c
>> @@ -32,8 +32,7 @@ static const struct resources csiphy_res[] = {
>>       /* CSIPHY0 */
>>       {
>>               .regulator = { NULL },
>> -             .clock = { "camss_top_ahb", "ispif_ahb",
>> -                        "camss_ahb", "csiphy0_timer" },
>> +             .clock = { "top_ahb", "ispif_ahb", "ahb", "csiphy0_timer" },
>>               .clock_rate = { { 0 },
>>                               { 0 },
>>                               { 0 },
>> @@ -45,8 +44,7 @@ static const struct resources csiphy_res[] = {
>>       /* CSIPHY1 */
>>       {
>>               .regulator = { NULL },
>> -             .clock = { "camss_top_ahb", "ispif_ahb",
>> -                        "camss_ahb", "csiphy1_timer" },
>> +             .clock = { "top_ahb", "ispif_ahb", "ahb", "csiphy1_timer" },
>>               .clock_rate = { { 0 },
>>                               { 0 },
>>                               { 0 },
>> @@ -60,8 +58,7 @@ static const struct resources csid_res[] = {
>>       /* CSID0 */
>>       {
>>               .regulator = { "vdda" },
>> -             .clock = { "camss_top_ahb", "ispif_ahb",
>> -                        "csi0_ahb", "camss_ahb",
>> +             .clock = { "top_ahb", "ispif_ahb", "csi0_ahb", "ahb",
>>                          "csi0", "csi0_phy", "csi0_pix", "csi0_rdi" },
>>               .clock_rate = { { 0 },
>>                               { 0 },
>> @@ -78,8 +75,7 @@ static const struct resources csid_res[] = {
>>       /* CSID1 */
>>       {
>>               .regulator = { "vdda" },
>> -             .clock = { "camss_top_ahb", "ispif_ahb",
>> -                        "csi1_ahb", "camss_ahb",
>> +             .clock = { "top_ahb", "ispif_ahb", "csi1_ahb", "ahb",
>>                          "csi1", "csi1_phy", "csi1_pix", "csi1_rdi" },
>>               .clock_rate = { { 0 },
>>                               { 0 },
>> @@ -96,10 +92,10 @@ static const struct resources csid_res[] = {
>>
>>  static const struct resources_ispif ispif_res = {
>>       /* ISPIF */
>> -     .clock = { "camss_top_ahb", "camss_ahb", "ispif_ahb",
>> +     .clock = { "top_ahb", "ahb", "ispif_ahb",
>>                  "csi0", "csi0_pix", "csi0_rdi",
>>                  "csi1", "csi1_pix", "csi1_rdi" },
>> -     .clock_for_reset = { "camss_vfe_vfe", "camss_csi_vfe" },
>> +     .clock_for_reset = { "vfe0", "csi_vfe0" },
>>       .reg = { "ispif", "csi_clk_mux" },
>>       .interrupt = "ispif"
>>
>> @@ -108,8 +104,8 @@ static const struct resources_ispif ispif_res = {
>>  static const struct resources vfe_res = {
>>       /* VFE0 */
>>       .regulator = { NULL },
>> -     .clock = { "camss_top_ahb", "camss_vfe_vfe", "camss_csi_vfe",
>> -                "iface", "bus", "camss_ahb" },
>> +     .clock = { "top_ahb", "vfe0", "csi_vfe0",
>> +                "vfe_ahb", "vfe_axi", "ahb" },
>>       .clock_rate = { { 0 },
>>                       { 50000000, 80000000, 100000000, 160000000,
>>                         177780000, 200000000, 266670000, 320000000,
>> --
>> 2.7.4
>>
