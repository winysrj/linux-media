Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud3.xs4all.net ([194.109.24.30]:34059 "EHLO
        lb3-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1754135AbdCTKtD (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 20 Mar 2017 06:49:03 -0400
Subject: Re: DRM Atomic property for color-space conversion
To: =?UTF-8?B?VmlsbGUgU3lyasOkbMOk?= <ville.syrjala@linux.intel.com>,
        Brian Starkey <brian.starkey@arm.com>
References: <20170131155541.GF11506@e106950-lin.cambridge.arm.com>
 <20170316140725.GF31595@intel.com>
 <0cff6bab-7593-d3d2-f3b5-71dc21669dab@intel.com>
 <20170316143059.GG31595@intel.com>
 <20170316143721.GN6268@e110455-lin.cambridge.arm.com>
 <f806a38d-f52c-0cf2-bee6-582f1a35d312@intel.com>
 <20170316155501.GA25006@e106950-lin.cambridge.arm.com>
 <fc590903-a88e-d2c2-968f-26d59963caba@intel.com>
 <20170316173656.GI31595@intel.com>
 <20170317103313.GA2090@e106950-lin.cambridge.arm.com>
 <20170317140951.GT31595@intel.com>
Cc: "Sharma, Shashank" <shashank.sharma@intel.com>,
        Local user for Liviu Dudau <liviu.dudau@arm.com>,
        dri-devel@lists.freedesktop.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, mihail.atanassov@arm.com,
        "Cyr, Aric" <Aric.Cyr@amd.com>,
        "Wentland, Harry" <Harry.Wentland@amd.com>,
        Alex Deucher <alexdeucher@gmail.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <e30ee10b-d846-d2f0-65ae-1b556ff636bc@xs4all.nl>
Date: Mon, 20 Mar 2017 11:48:49 +0100
MIME-Version: 1.0
In-Reply-To: <20170317140951.GT31595@intel.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 03/17/2017 03:09 PM, Ville Syrjälä wrote:
> On Fri, Mar 17, 2017 at 10:33:15AM +0000, Brian Starkey wrote:
>> For not-programmable hardware, would a second "DEGAMMA_FIXED" property
>> make sense, which is an enum type exposing what curves are supported?
>> (with analogous GAMMA_FIXED as well)
> 
> Hmm. I suppose we could make it a bit more explicit like that.
> Not sure how we'd specify those though. Just BT.709, BT.2020, etc. and
> perhaps just something like 'Gamma 2.2' if it's a pure gamma curve?
> Someone who is more familiar with the subject could probably propose
> a better naming scheme.

Just as a reference, this is how V4L2 describes colorspace information:

https://www.linuxtv.org/downloads/v4l-dvb-apis-new/uapi/v4l/colorspaces.html

Sections 2.4-2.6 are all about that.

Note: pure gamma functions (i.e. Gamma 2.2) are not defined since we do not
support hardware that needs that. Should that be needed in the future, then
we would add that to the xfer_func defines.

Regards,

	Hans
