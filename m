Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga06.intel.com ([134.134.136.31]:44632 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751082AbeC0H6Z (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 27 Mar 2018 03:58:25 -0400
From: Jani Nikula <jani.nikula@linux.intel.com>
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Hans Verkuil <hverkuil@xs4all.nl>
Cc: Maxime Ripard <maxime.ripard@bootlin.com>,
        Wolfram Sang <wsa@the-dreams.de>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        dri-devel@lists.freedesktop.org, linux-media@vger.kernel.org
Subject: Re: [PATCHv2 6/7] cec-pin-error-inj.rst: document CEC Pin Error Injection
In-Reply-To: <20180321124511.7e841256@vento.lan>
References: <20180305135139.95652-1-hverkuil@xs4all.nl> <20180305135139.95652-7-hverkuil@xs4all.nl> <20180321124511.7e841256@vento.lan>
Date: Tue, 27 Mar 2018 10:59:13 +0300
Message-ID: <87y3iedk4u.fsf@intel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, 21 Mar 2018, Mauro Carvalho Chehab <mchehab@s-opensource.com> wrote:
> Please notice that all debugfs/sysfs entries should *also* be
> documented at the standard way, e. g. by adding the corresponding
> documentation at Documentation/ABI.
>
> Please see Documentation/ABI/README.
>
> Additionally, there are a few minor nitpicks on this patch.
> See below.
>
> The remaining patches looked ok on my eyes.
>
> I'll wait for a v3 with the debugfs ABI documentation in order to merge
> it. Feel free to put it on a separate patch.

debugfs ABI? Sounds like an oxymoron to me.

BR,
Jani.

-- 
Jani Nikula, Intel Open Source Technology Center
