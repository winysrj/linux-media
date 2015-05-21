Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:46252 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753805AbbEULcX (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 21 May 2015 07:32:23 -0400
Date: Thu, 21 May 2015 14:32:13 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Jacek Anaszewski <j.anaszewski@samsung.com>
Cc: linux-leds@vger.kernel.org, linux-media@vger.kernel.org,
	kyungmin.park@samsung.com, pavel@ucw.cz, cooloney@gmail.com,
	rpurdie@rpsys.net, s.nawrocki@samsung.com,
	devicetree@vger.kernel.org, sre@kernel.org
Subject: Re: [PATCH v8 8/8] DT: samsung-fimc: Add examples for
 samsung,flash-led property
Message-ID: <20150521113213.GI8601@valkosipuli.retiisi.org.uk>
References: <1432131015-22397-1-git-send-email-j.anaszewski@samsung.com>
 <1432131015-22397-9-git-send-email-j.anaszewski@samsung.com>
 <20150520220018.GE8601@valkosipuli.retiisi.org.uk>
 <555DA119.9030904@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <555DA119.9030904@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Jacek,

On Thu, May 21, 2015 at 11:10:49AM +0200, Jacek Anaszewski wrote:
> Hi Sakari,
> 
> On 05/21/2015 12:00 AM, Sakari Ailus wrote:
> >Hi Jacek,
> >
> >On Wed, May 20, 2015 at 04:10:15PM +0200, Jacek Anaszewski wrote:
> >>This patch adds examples for samsung,flash-led property to the
> >>samsung-fimc.txt.
> >>
> >>Signed-off-by: Jacek Anaszewski <j.anaszewski@samsung.com>
> >>Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
> >>Cc: Sylwester Nawrocki <s.nawrocki@samsung.com>
> >>Cc: devicetree@vger.kernel.org
> >>---
> >>  .../devicetree/bindings/media/samsung-fimc.txt     |    4 ++++
> >>  1 file changed, 4 insertions(+)
> >>
> >>diff --git a/Documentation/devicetree/bindings/media/samsung-fimc.txt b/Documentation/devicetree/bindings/media/samsung-fimc.txt
> >>index 922d6f8..57edffa 100644
> >>--- a/Documentation/devicetree/bindings/media/samsung-fimc.txt
> >>+++ b/Documentation/devicetree/bindings/media/samsung-fimc.txt
> >>@@ -126,6 +126,8 @@ Example:
> >>  			clocks = <&camera 1>;
> >>  			clock-names = "mclk";
> >>
> >>+			samsung,flash-led = <&front_cam_flash>;
> >>+
> >>  			port {
> >>  				s5k6aa_ep: endpoint {
> >>  					remote-endpoint = <&fimc0_ep>;
> >>@@ -147,6 +149,8 @@ Example:
> >>  			clocks = <&camera 0>;
> >>  			clock-names = "mclk";
> >>
> >>+			samsung,flash-led = <&rear_cam_flash>;
> >>+
> >>  			port {
> >>  				s5c73m3_1: endpoint {
> >>  					data-lanes = <1 2 3 4>;
> >
> >Oops. I missed this property would have ended to the sensor's DT node. I
> >don't think we should have properties here that are parsed by another
> >driver --- let's discuss this tomorrow.
> 
> exynos4-is driver already parses sensor nodes (at least their 'port'
> sub-nodes).

If you read the code and the comment, it looks like something that should be
done better but hasn't been done yet. :-) That's something we should avoid.
Also, flash devices are by far more common than external ISPs I presume.

-- 
Regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
