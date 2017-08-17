Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud7.xs4all.net ([194.109.24.31]:47118 "EHLO
        lb3-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751851AbdHQHFR (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 17 Aug 2017 03:05:17 -0400
Subject: Re: [PATCH v7] media: platform: Renesas IMR driver
To: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        linux-media@vger.kernel.org, devicetree@vger.kernel.org
Cc: linux-renesas-soc@vger.kernel.org,
        Konstantin Kozhevnikov
        <Konstantin.Kozhevnikov@cogentembedded.com>,
        Rob Herring <robh@kernel.org>
References: <20170804180402.795437602@cogentembedded.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <146c6915-b0c1-5cba-ce67-630c1ddc4b19@xs4all.nl>
Date: Thu, 17 Aug 2017 09:05:11 +0200
MIME-Version: 1.0
In-Reply-To: <20170804180402.795437602@cogentembedded.com>
Content-Type: text/plain; charset=iso-8859-15
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sergei,

A few high level comments (I'll look at the patch itself later):

- There is no MAINTAINERS entry, please add one.
- Don't attach the patch, post it inline (ideally with 'git send-email')
- Split up the patch into 4 separate patches: bindings, doc changes,
  driver and MAINTAINERS patch. This will make it easier to review.
- Please give the v4l2-compliance output in the cover letter of the v8
  patch series. I can't merge this driver without being certain there
  are no compliance issues.
- You also have IMR-LSX3 and IMR-LX3 patches, why not add them to the
  patch series? I can review the set as a single unit. Up to you, though.

Regards,

	Hans
