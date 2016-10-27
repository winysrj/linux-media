Return-path: <linux-media-owner@vger.kernel.org>
Received: from foss.arm.com ([217.140.101.70]:37782 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1034073AbcJ0OZh (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 27 Oct 2016 10:25:37 -0400
Date: Thu, 27 Oct 2016 09:28:44 +0100
From: Brian Starkey <brian.starkey@arm.com>
To: Gustavo Padovan <gustavo@padovan.org>,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        linux-media@vger.kernel.org
Subject: Re: [RFC PATCH v2 7/9] drm: atomic: factor out common out-fence
 operations
Message-ID: <20161027082844.GA10281@e106950-lin.cambridge.arm.com>
References: <1477472108-27222-1-git-send-email-brian.starkey@arm.com>
 <1477472108-27222-8-git-send-email-brian.starkey@arm.com>
 <20161026214514.GI12629@joana>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20161026214514.GI12629@joana>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Oct 26, 2016 at 07:45:14PM -0200, Gustavo Padovan wrote:
>
>%p should be kept for your internal debug only. Make sure to remove
>anything that exposes kernel address when sending patches.
>
>Gustavo
>

Noted, thanks!

-Brian
