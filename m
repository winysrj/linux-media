Return-path: <linux-media-owner@vger.kernel.org>
Received: from us01smtprelay-2.synopsys.com ([198.182.60.111]:55827 "EHLO
        smtprelay.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752710AbdKMSds (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 13 Nov 2017 13:33:48 -0500
Subject: Re: [PATCH 08/10] video/hdmi: Reject illegal picture aspect ratios
To: Ville Syrjala <ville.syrjala@linux.intel.com>,
        <dri-devel@lists.freedesktop.org>
References: <20171113170427.4150-1-ville.syrjala@linux.intel.com>
 <20171113170427.4150-9-ville.syrjala@linux.intel.com>
CC: <intel-gfx@lists.freedesktop.org>,
        Shashank Sharma <shashank.sharma@intel.com>,
        "Lin, Jia" <lin.a.jia@intel.com>,
        "Akashdeep Sharma" <akashdeep.sharma@intel.com>,
        Jim Bride <jim.bride@linux.intel.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Emil Velikov <emil.l.velikov@gmail.com>,
        Thierry Reding <thierry.reding@gmail.com>,
        "Hans Verkuil" <hans.verkuil@cisco.com>,
        <linux-media@vger.kernel.org>
From: Jose Abreu <Jose.Abreu@synopsys.com>
Message-ID: <4d500922-8ac7-c448-9838-806abae31a53@synopsys.com>
Date: Mon, 13 Nov 2017 18:33:43 +0000
MIME-Version: 1.0
In-Reply-To: <20171113170427.4150-9-ville.syrjala@linux.intel.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On 13-11-2017 17:04, Ville Syrjala wrote:
> From: Ville Syrjälä <ville.syrjala@linux.intel.com>
>
> AVI infoframe can only carry none, 4:3, or 16:9 picture aspect
> ratios. Return an error if the user asked for something different.
>
> Cc: Shashank Sharma <shashank.sharma@intel.com>
> Cc: "Lin, Jia" <lin.a.jia@intel.com>
> Cc: Akashdeep Sharma <akashdeep.sharma@intel.com>
> Cc: Jim Bride <jim.bride@linux.intel.com>
> Cc: Jose Abreu <Jose.Abreu@synopsys.com>
> Cc: Daniel Vetter <daniel.vetter@ffwll.ch>
> Cc: Emil Velikov <emil.l.velikov@gmail.com>
> Cc: Thierry Reding <thierry.reding@gmail.com>
> Cc: Hans Verkuil <hans.verkuil@cisco.com>
> Cc: linux-media@vger.kernel.org
> Signed-off-by: Ville Syrjälä <ville.syrjala@linux.intel.com>

Reviewed-by: Jose Abreu <joabreu@synopsys.com>

Best Regards,
Jose Miguel Abreu
