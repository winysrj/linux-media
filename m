Return-path: <linux-media-owner@vger.kernel.org>
Received: from hqemgate16.nvidia.com ([216.228.121.65]:4069 "EHLO
	hqemgate16.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752366AbbIWB0C (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 22 Sep 2015 21:26:02 -0400
Subject: Re: [PATCH 2/3] ARM64: add tegra-vi support in T210 device-tree
To: Thierry Reding <treding@nvidia.com>
References: <1442861755-22743-1-git-send-email-pengw@nvidia.com>
 <1442861755-22743-3-git-send-email-pengw@nvidia.com>
 <20150922121730.GC1417@ulmo.nvidia.com>
CC: <hansverk@cisco.com>, <linux-media@vger.kernel.org>,
	<ebrower@nvidia.com>, <jbang@nvidia.com>, <swarren@nvidia.com>,
	<davidw@nvidia.com>, <gfitzer@nvidia.com>, <bmurthyv@nvidia.com>,
	<linux-tegra@vger.kernel.org>
From: Bryan Wu <pengw@nvidia.com>
Message-ID: <5601FFA8.3050401@nvidia.com>
Date: Tue, 22 Sep 2015 18:26:00 -0700
MIME-Version: 1.0
In-Reply-To: <20150922121730.GC1417@ulmo.nvidia.com>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 09/22/2015 05:17 AM, Thierry Reding wrote:
> Hi Bryan,
>
> This patchset really needs to be Cc'ed to linux-tegra@vger.kernel.org,
> it's becoming impossible to track it otherwise.

My bad, I copied and pasted old git send-email command line.

> On Mon, Sep 21, 2015 at 11:55:54AM -0700, Bryan Wu wrote:
> [...]
>> diff --git a/arch/arm64/boot/dts/nvidia/tegra210.dtsi b/arch/arm64/boot/dts/nvidia/tegra210.dtsi
>> index 1168bcd..3f6501f 100644
>> --- a/arch/arm64/boot/dts/nvidia/tegra210.dtsi
>> +++ b/arch/arm64/boot/dts/nvidia/tegra210.dtsi
>> @@ -109,9 +109,181 @@
>>   
>>   		vi@0,54080000 {
>>   			compatible = "nvidia,tegra210-vi";
>> -			reg = <0x0 0x54080000 0x0 0x00040000>;
>> +			reg = <0x0 0x54080000 0x0 0x800>;
> This now no longer matches the address map in the TRM.

That's because we split out the CSI parts from VI.

>>   			interrupts = <GIC_SPI 69 IRQ_TYPE_LEVEL_HIGH>;
>>   			status = "disabled";
>> +			clocks = <&tegra_car TEGRA210_CLK_VI>,
>> +				 <&tegra_car TEGRA210_CLK_CSI>,
>> +				 <&tegra_car TEGRA210_CLK_PLL_C>;
>> +			clock-names = "vi", "csi", "parent";
>> +			resets = <&tegra_car 20>;
>> +			reset-names = "vi";
>> +
>> +			power-domains = <&pmc TEGRA_POWERGATE_VENC>;
> As an aside, this will currently prevent the driver from probing because
> the generic power domain code will return -EPROBE_DEFER if this property
> is encountered but the corresponding driver (for the PMC) hasn't
> registered any power domains yet. So until the PMC driver changes have
> been merged we can't add these power-domains properties.
>
> That's not something for you to worry about, though. I'll make sure to
> strip this out if it happens to get merged before the PMC driver changes
> and add it back it afterwards.

OK, need I strip this out and provide a separated patch which waiting 
for the PMC changes merged?

>> +
>> +			iommus = <&mc TEGRA_SWGROUP_VI>;
>> +
>> +			ports {
>> +				#address-cells = <1>;
>> +				#size-cells = <0>;
>> +
>> +				port@0 {
>> +					reg = <0>;
>> +
>> +					vi_in0: endpoint {
>> +						remote-endpoint = <&csi_out0>;
>> +					};
>> +				};
>> +				port@1 {
>> +					reg = <1>;
>> +
>> +					vi_in1: endpoint {
>> +						remote-endpoint = <&csi_out1>;
>> +					};
>> +				};
>> +				port@2 {
>> +					reg = <2>;
>> +
>> +					vi_in2: endpoint {
>> +						remote-endpoint = <&csi_out2>;
>> +					};
>> +				};
>> +				port@3 {
>> +					reg = <3>;
>> +
>> +					vi_in3: endpoint {
>> +						remote-endpoint = <&csi_out3>;
>> +					};
>> +				};
>> +				port@4 {
>> +					reg = <4>;
>> +
>> +					vi_in4: endpoint {
>> +						remote-endpoint = <&csi_out4>;
>> +					};
>> +				};
>> +				port@5 {
>> +					reg = <5>;
>> +
>> +					vi_in5: endpoint {
>> +						remote-endpoint = <&csi_out5>;
>> +					};
>> +				};
>> +
>> +			};
>> +		};
>> +
>> +		csi@0,54080838 {
> I think this and its siblings should be children of the vi node. They
> are within the same memory aperture according to the TRM and the fact
> that the VI needs to reference the "CSI" clock indicates that the
> coupling is tighter than this current DT layout makes it out to be.
>
>> +			compatible = "nvidia,tegra210-csi";
>> +			reg = <0x0 0x54080838 0x0 0x700>;
> Some of the internal register documentation indicates that the register
> range actually starts at an offset of 0x800, it just so happens that we
> don't use any of the registers from 0x800 to 0x837. So I think this
> needs to be adapted.
Right, in the driver we don't use those registers from 0x800 to 0x837.

>> +			clocks = <&tegra_car TEGRA210_CLK_CILAB>;
>> +			clock-names = "cil";
>> +
>> +			ports {
>> +				#address-cells = <1>;
>> +				#size-cells = <0>;
>> +
>> +				port@0 {
>> +					reg = <0>;
>> +					#address-cells = <1>;
>> +					#size-cells = <0>;
>> +					csi_in0: endpoint@0 {
>> +						reg = <0x0>;
>> +					};
>> +					csi_out0: endpoint@1 {
>> +						reg = <0x1>;
>> +						remote-endpoint = <&vi_in0>;
>> +					};
>> +				};
>> +				port@1 {
>> +					reg = <1>;
>> +					#address-cells = <1>;
>> +					#size-cells = <0>;
>> +					csi_in1: endpoint@0 {
>> +						reg = <0>;
>> +					};
>> +					csi_out1: endpoint@1 {
>> +						reg = <1>;
>> +						remote-endpoint = <&vi_in1>;
>> +					};
>> +				};
>> +			};
> This, and the ports subnode of the vi node, is *a lot* of lines to
> describe what's effectively a hard-coded association. Nothing in here
> can be configured, so I doubt that it is necessary to describe the VI
> to this extent in DT.
It actually can be changed but it's not very common.

Like CSIA -> PPB and CSIB->PPA.

> It's quite difficult to judge because we don't have an actual use-case
> yet where real sensors need to be hooked up. Do we have some internal
> boards that we can use to prototype this from a DT point of view? What
> we'd need is just something that has any sensor connected to one of the
> CSI ports so we can see what we really need to fully describe such a
> setup.

It's doable we remove these hard configuration in DT and setup those 
media links in hard code of driver.
I'm just not sure we might have some changeable connection between VI 
and CSI in the future Tegra chips.

I'm working on adding the real sensor to this driver, device tree 
binding is quite standard as in our DT video-devices.txt binding file.

csi_in0 has a remote-endpoint = <&sensor1>;
sensor1 has a remote-endpoint = <&csi_in0>;

> I'm reluctant to apply something like this, or the corresponding
> binding, without at least having attempted to describe a real user.
>
> Thierry

I understand your concern let's find a good way  to solve this problem.

Since it's kind of fixed connections between VI and CSI, I can put those 
media links setup hard coded in the driver.

Thanks,
-Bryan

