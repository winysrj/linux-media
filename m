Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vb0-f44.google.com ([209.85.212.44]:50893 "EHLO
	mail-vb0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751402Ab3G2FwH (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 29 Jul 2013 01:52:07 -0400
MIME-Version: 1.0
In-Reply-To: <1374604777-15523-5-git-send-email-s.nawrocki@samsung.com>
References: <1374604777-15523-1-git-send-email-s.nawrocki@samsung.com>
	<1374604777-15523-5-git-send-email-s.nawrocki@samsung.com>
Date: Mon, 29 Jul 2013 11:22:06 +0530
Message-ID: <CALt3h79AVS_bY4b0beo+zK2JMSnp5qnmNQWM0+_CqSV7dMCeGw@mail.gmail.com>
Subject: Re: [REVIEW PATCH 4/6] exynos4-is: Add clock provider for the
 external clocks
From: Arun Kumar K <arunkk.samsung@gmail.com>
To: Sylwester Nawrocki <s.nawrocki@samsung.com>
Cc: LMML <linux-media@vger.kernel.org>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	linux-samsung-soc <linux-samsung-soc@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sylwester,

On Wed, Jul 24, 2013 at 12:09 AM, Sylwester Nawrocki
<s.nawrocki@samsung.com> wrote:
> This patch adds clock provider to expose the sclk_cam0/1 clocks
> for image sensor subdevs.
>
> Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> ---
>  .../devicetree/bindings/media/samsung-fimc.txt     |   17 +++-
>  drivers/media/platform/exynos4-is/media-dev.c      |   92 ++++++++++++++++++++
>  drivers/media/platform/exynos4-is/media-dev.h      |   19 +++-
>  3 files changed, 125 insertions(+), 3 deletions(-)
>
> diff --git a/Documentation/devicetree/bindings/media/samsung-fimc.txt b/Documentation/devicetree/bindings/media/samsung-fimc.txt
> index 96312f6..04a2b87 100644
> --- a/Documentation/devicetree/bindings/media/samsung-fimc.txt
> +++ b/Documentation/devicetree/bindings/media/samsung-fimc.txt
> @@ -91,6 +91,15 @@ Optional properties
>  - samsung,camclk-out : specifies clock output for remote sensor,
>                        0 - CAM_A_CLKOUT, 1 - CAM_B_CLKOUT;
>
> +'clock-controller' node (optional)
> +----------------------------------
> +
> +The purpose of this node is to define a clock provider for external image
> +sensors and link any of the CAM_?_CLKOUT clock outputs with related external
> +clock consumer device. Properties specific to this node are described in
> +../clock/clock-bindings.txt.
> +
> +
>  Image sensor nodes
>  ------------------
>
> @@ -114,7 +123,7 @@ Example:
>                         vddio-supply = <...>;
>
>                         clock-frequency = <24000000>;
> -                       clocks = <...>;
> +                       clocks = <&camclk 1>;
>                         clock-names = "mclk";
>
>                         port {
> @@ -135,7 +144,7 @@ Example:
>                         vddio-supply = <...>;
>
>                         clock-frequency = <24000000>;
> -                       clocks = <...>;
> +                       clocks = <&camclk 0>;
>                         clock-names = "mclk";
>
>                         port {
> @@ -156,6 +165,10 @@ Example:
>                 pinctrl-names = "default";
>                 pinctrl-0 = <&cam_port_a_clk_active>;
>
> +               camclk: clock-controller {
> +                      #clock-cells = 1;

Isn't it
                          #clock-cells = <1>;
?

> +               };
> +


Regards
Arun
